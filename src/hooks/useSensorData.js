import { useState, useEffect, useCallback, useRef } from 'react';
import { supabase } from '../supabaseClient';
import { useNotification } from './useNotification';
import { processDataByRange } from '../utils/dataUtils';

// Configuración fuera del componente para que no se recree
const CROP_THRESHOLDS = {
  temperature: { min: 10, max: 35, label: "Temperatura", unit: "°C" },
  humidity: { min: 40, max: 80, label: "Humedad Aire", unit: "%" },
  soil_moisture: { min: 20, max: 90, label: "Humedad Suelo", unit: "%" },
  ph: { min: 5.5, max: 7.5, label: "pH", unit: "" },
  solar_radiation: { min: 100, max: 1200, label: "Radiación", unit: "W/m²" }
};

export const useSensorData = (timeRange, selectedDate, showDetail = false, isGrouped = false) => {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(true);
  const lastAnalyzedIdRef = useRef(null);
  const { addNotification, deleteNotification } = useNotification();

  // Lógica de Alertas
  const analyzeCropHealth = (latestReading) => {
    if (!latestReading || lastAnalyzedIdRef.current === latestReading.id) return;
    lastAnalyzedIdRef.current = latestReading.id;

    const diffInMinutes = (new Date() - new Date(latestReading.timestamp)) / 1000 / 60;
    if (diffInMinutes > 5) return;

    Object.keys(CROP_THRESHOLDS).forEach(key => {
      const value = latestReading[key];
      const config = CROP_THRESHOLDS[key];
      if (value != null) {
        const alertId = `alert-${key}`;
        if (value < config.min || value > config.max) {
          console.warn(`⚠️ ALERTA: ${config.label} (${value})`);
          addNotification({
            id: alertId,
            type: 'error',
            title: `⚠️ Alerta de ${config.label}`,
            message: `Lectura ACTUAL (${value.toFixed(1)}${config.unit}) fuera de rango.`,
            sensor: key
          });
        } else {
          deleteNotification(alertId);
        }
      }
    });
  };

  const fetchData = useCallback(async () => {
    let from = new Date();
    let to = new Date();

    if (timeRange === 'custom') {
      from = new Date(selectedDate);
      from.setHours(0, 0, 0, 0);
      to = new Date(selectedDate);
      to.setHours(23, 59, 59, 999);
    } else if (timeRange === 'month') {
      from = new Date(selectedDate.getFullYear(), selectedDate.getMonth(), 1);
      to = new Date(selectedDate.getFullYear(), selectedDate.getMonth() + 1, 0);
      to.setHours(23, 59, 59, 999);
    } else {
      const hoursBack = timeRange === '24h' ? 24 : timeRange === '7d' ? 168 : 720;
      from = new Date();
      from.setHours(from.getHours() - hoursBack);
    }

    console.log('📅 Fetching data from', from.toISOString(), 'to', to.toISOString());

    // Obtener mapeo de sensor_id -> category
    const { data: sensors, error: sensorsError } = await supabase
      .from('sensors')
      .select(`
        id,
        serial_number,
        sensor_types!inner(category)
      `);

    const sensorCategoryMap = {};
    if (!sensorsError && sensors) {
      sensors.forEach(s => {
        sensorCategoryMap[s.id] = {
          category: s.sensor_types?.category || 'unknown',
          serial_number: s.serial_number
        };
      });
    }

    // Fetch sensor readings
    const { data: supabaseData, error } = await supabase
      .from('sensor_readings')
      .select('id, timestamp, data, sensor_id')
      .gte('timestamp', from.toISOString())
      .lte('timestamp', to.toISOString())
      .order('timestamp', { ascending: true });

    console.log(`📊 Fetched ${supabaseData?.length || 0} readings`);

    if (!error && supabaseData) {
      const rawData = supabaseData.map(d => {
        const sensorJson = d.data || {};
        const sensorInfo = sensorCategoryMap[d.sensor_id] || {};
        const category = sensorInfo.category || 'unknown';
        const serialNum = sensorInfo.serial_number || d.sensor_id;

        return {
          id: d.id,
          timestamp: d.timestamp,
          sensor_id: serialNum,
          sensor_category: category,
          temperature: sensorJson.temperature ?? sensorJson.soil_temperature,
          humidity: sensorJson.humidity,
          soil_moisture: sensorJson.soil_humidity ?? sensorJson.soil_moisture,
          solar_radiation: sensorJson.solar_radiation,
          ph: sensorJson.ph,
          nitrogen: sensorJson.nitrogen,
          potassium: sensorJson.potassium,
          phosphorus: sensorJson.phosphorus,
          conductivity: sensorJson.conductivity,
          soil_temperature: sensorJson.soil_temperature,
          pm10: sensorJson.pm10,
          pm25: sensorJson.pm25 ?? sensorJson.pm2_5,
          noise: sensorJson.noise,
          rainfall: sensorJson.rainfall ?? sensorJson.rain,
          wind_speed: sensorJson.wind_speed,
        };
      });

      console.log('🔄 Processing', rawData.length, 'data points');

      // Procesar datos con la nueva función
      const chartReadyData = processDataByRange(rawData, timeRange, showDetail, isGrouped);
      console.log('✅ Processed data:', chartReadyData.length, 'points, sensors:', chartReadyData.allSensors);

      setData(chartReadyData);
      setLoading(false);

      // Analizar solo si estamos viendo datos recientes
      const isHistory = timeRange === 'custom' && selectedDate.toDateString() !== new Date().toDateString();
      if (rawData.length > 0 && !isHistory) {
        analyzeCropHealth(rawData[rawData.length - 1]);
      }
    } else if (error) {
      console.error('❌ Error fetching data:', error);
    }
  }, [timeRange, selectedDate, showDetail, isGrouped, addNotification, deleteNotification]);

  useEffect(() => {
    fetchData();
    const channel = supabase.channel('realtime-sensors')
      .on('postgres_changes', { event: 'INSERT', schema: 'public', table: 'sensor_readings' }, () => {
        console.log("⚡ [HOOK] Dato nuevo detectado");
        fetchData();
      })
      .subscribe();
    return () => { supabase.removeChannel(channel); };
  }, [fetchData]);

  // Helper para obtener último valor
  const getLatestValid = (key) => {
    if (data.length === 0) return null;
    const last = data[data.length - 1];

    if (isGrouped && data.allSensors) {
      // Promediar el ultimo bucket
      let sum = 0, count = 0;
      data.allSensors.forEach(sId => {
        const val = last[`${key}_${sId}`];
        if (val != null) { sum += val; count++; }
      });
      return count > 0 ? (sum / count) : null;
    }

    // Modo normal
    for (let i = data.length - 1; i >= 0; i--) {
      if (data[i][key] != null) return data[i][key];
    }
    return null;
  };

  return { data, loading, getLatestValid };
};