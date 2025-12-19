import React, { useState, useEffect, useCallback, useRef } from 'react';
import { supabase } from '../supabaseClient';
import {
  Thermometer, Droplets, Wind, Sun, Activity,
  Play, Square, BarChart2, Filter, CloudRain, Zap, Volume2
} from 'lucide-react';

// Componentes
import ChartCard from '../components/ChartCard';
import DateSelector from '../components/DateSelector';
import MetricCard from '../components/MetricCard';
import { Switch } from '@headlessui/react';

// Hooks y Utils
import { useNotification } from '../hooks/useNotification';
import { processDataByRange } from '../utils/dataUtils';

// Configuración de Umbrales y Estilos
const CROP_THRESHOLDS = {
  temperature: { min: 10, max: 35, label: "Temperatura", unit: "°C", color: "#ef4444", icon: Thermometer },
  humidity: { min: 40, max: 80, label: "Humedad Aire", unit: "%", color: "#3b82f6", icon: Droplets },
  soil_moisture: { min: 20, max: 90, label: "Humedad Suelo", unit: "%", color: "#10b981", icon: Wind },
  ph: { min: 5.5, max: 7.5, label: "pH", unit: "", color: "#8b5cf6", icon: Activity },
  solar_radiation: { min: 100, max: 1200, label: "Radiación", unit: "W/m²", color: "#f59e0b", icon: Sun },

  // Nuevas Métricas (Station)
  nitrogen: { min: 0, max: 1000, label: "Nitrógeno", unit: "mg/kg", color: "#84cc16", icon: Activity },
  potassium: { min: 0, max: 1000, label: "Potasio", unit: "mg/kg", color: "#be185d", icon: Activity },
  phosphorus: { min: 0, max: 1000, label: "Fósforo", unit: "mg/kg", color: "#fbbf24", icon: Activity },
  conductivity: { min: 0, max: 5000, label: "Conductividad", unit: "µS/cm", color: "#0ea5e9", icon: Zap },
  soil_temperature: { min: 0, max: 60, label: "Temp. Suelo", unit: "°C", color: "#f97316", icon: Thermometer },
  pm10: { min: 0, max: 100, label: "PM10", unit: "µg/m³", color: "#64748b", icon: CloudRain },
  pm25: { min: 0, max: 100, label: "PM2.5", unit: "µg/m³", color: "#475569", icon: CloudRain },
  noise: { min: 0, max: 120, label: "Ruido", unit: "dB", color: "#d946ef", icon: Volume2 },
  rainfall: { min: 0, max: 500, label: "Lluvia", unit: "mm", color: "#06b6d4", icon: CloudRain },
  wind_speed: { min: 0, max: 100, label: "Velocidad Viento", unit: "m/s", color: "#14b8a6", icon: Wind },
};

// Mapeo de métricas a categorías de sensores compatibles
const METRIC_CATEGORIES = {
  temperature: ['soil', 'meteorological'], // Suelo (soil_temp) + Atmosférico (air temp)
  humidity: ['meteorological'], // Solo atmosférico (air humidity)
  soil_moisture: ['soil'], // Solo suelo
  solar_radiation: ['solar'], // Solo solar
  ph: ['soil'],
  nitrogen: ['soil'],
  potassium: ['soil'],
  phosphorus: ['soil'],
  conductivity: ['soil'],
  soil_temperature: ['soil'],
  pm10: ['meteorological'],
  pm25: ['meteorological'],
  noise: ['meteorological'],
  rainfall: ['meteorological'],
  wind_speed: ['meteorological'],
};

// Emojis para categorías
const CATEGORY_ICONS = {
  soil: '🌱',
  solar: '☀️',
  meteorological: '🌤️',
  unknown: '❓'
};

const CATEGORY_LABELS = {
  soil: 'Suelo',
  solar: 'Solar',
  meteorological: 'Atmosférico',
  unknown: 'Desconocido'
};

const DashboardView = () => {
  const [data, setData] = useState([]);

  // Estados de Filtros
  const [timeRange, setTimeRange] = useState('custom'); // 'custom' (Diario) o 'month'
  const [selectedDate, setSelectedDate] = useState(new Date());
  const [isGrouped, setIsGrouped] = useState(false);
  const [selectedParameter, setSelectedParameter] = useState('all');

  const [showDetail, setShowDetail] = useState(false);
  const [loading, setLoading] = useState(true);
  const [isSimulating, setIsSimulating] = useState(false);

  const lastAnalyzedIdRef = useRef(null);
  const { addNotification, deleteNotification } = useNotification();

  // --- MANEJADORES ---
  const handleDateSelect = (date) => {
    setSelectedDate(date);
  };

  const toggleSimulation = () => setIsSimulating(!isSimulating);

  const handleTimeRangeSelect = (range) => {
    setTimeRange(range);
    if (range !== 'month' && range !== 'custom') setSelectedDate(new Date());
  };

  // --- SIMULACIÓN ---
  useEffect(() => {
    let intervalId;
    if (isSimulating) {
      const insertFakeData = async () => {
        try {
          // Generar datos para 5 sensores simulados
          const sensors = [
            { id: 'sim-1', serial_number: 'SENSOR-001' },
            { id: 'sim-2', serial_number: 'SENSOR-002' },
            { id: 'sim-3', serial_number: 'SENSOR-003' },
            { id: 'sim-4', serial_number: 'SENSOR-004' },
            { id: 'sim-5', serial_number: 'SENSOR-005' },
          ];

          const payloads = sensors.map(sensor => ({
            sensor_id: sensor.id,
            sensor_serial_number: sensor.serial_number,
            timestamp: new Date().toISOString(),
            raspberry_pi_id: 'CLIENT-SIMULATOR',
            quality_score: 100,
            data: {
              temperature: parseFloat((Math.random() * (30 - 15) + 15).toFixed(1)), // 15-30°C
              humidity: parseFloat((Math.random() * (80 - 40) + 40).toFixed(1)),
              soil_humidity: parseFloat((Math.random() * (90 - 20) + 20).toFixed(1)),
              soil_moisture: parseFloat((Math.random() * (90 - 20) + 20).toFixed(1)),
              ph: parseFloat((Math.random() * (8 - 5) + 5).toFixed(2)),
              solar_radiation: parseFloat((Math.random() * 1000).toFixed(0)),
              // Nuevos datos simulados
              nitrogen: parseFloat((Math.random() * 200).toFixed(0)),
              potassium: parseFloat((Math.random() * 200).toFixed(0)),
              phosphorus: parseFloat((Math.random() * 200).toFixed(0)),
              conductivity: parseFloat((Math.random() * 2000).toFixed(0)),
              soil_temperature: parseFloat((Math.random() * (25 - 10) + 10).toFixed(1)),
              pm10: parseFloat((Math.random() * 50).toFixed(1)),
              pm25: parseFloat((Math.random() * 30).toFixed(1)),
              noise: parseFloat((Math.random() * 90).toFixed(1)),
              rainfall: Math.random() > 0.8 ? parseFloat((Math.random() * 10).toFixed(1)) : 0,
              wind_speed: parseFloat((Math.random() * 20).toFixed(1))
            }
          }));

          const { error } = await supabase.from('sensor_readings').insert(payloads);
          if (error) console.error("❌ Error insertando:", error.message);

        } catch (err) { console.error(err); }
      };

      insertFakeData();
      intervalId = setInterval(insertFakeData, 5000); // 5 segundos
      addNotification({ id: 'sim-start', type: 'info', title: 'Simulación Multi-Sensor', message: 'Generando datos extendidos...' });
    } else {
      deleteNotification('sim-start');
    }
    return () => clearInterval(intervalId);
  }, [isSimulating, addNotification, deleteNotification]);

  // --- ANÁLISIS DE ALERTAS ---
  const analyzeCropHealth = (latestReading) => {
    if (!latestReading) return;
    if (lastAnalyzedIdRef.current === latestReading.id) return;
    lastAnalyzedIdRef.current = latestReading.id;

    const diffInMinutes = (new Date() - new Date(latestReading.timestamp)) / 1000 / 60;
    if (diffInMinutes > 5) return;

    Object.keys(CROP_THRESHOLDS).forEach(key => {
      // Solo alertar sobre métricas básicas
      if (['nitrogen', 'potassium', 'phosphorus', 'conductivity'].includes(key)) return;

      const value = latestReading[key];
      const config = CROP_THRESHOLDS[key];
      if (value != null && config) {
        const alertId = `alert-${key}`;
        if (value < config.min || value > config.max) {
          addNotification({
            id: alertId, type: 'error', title: `⚠️ Alerta de ${config.label}`,
            message: `Lectura ACTUAL (${Number(value).toFixed(1)}${config.unit}) fuera de rango.`, sensor: key
          });
        } else { deleteNotification(alertId); }
      }
    });
  };

  // --- FETCH DATA ---
  const fetchData = useCallback(async () => {
    let from = new Date();
    let to = new Date();

    if (timeRange === 'custom') { // Diario
      from = new Date(selectedDate); from.setHours(0, 0, 0, 0);
      to = new Date(selectedDate); to.setHours(23, 59, 59, 999);
    } else if (timeRange === 'month') { // Mensual
      from = new Date(selectedDate.getFullYear(), selectedDate.getMonth(), 1);
      to = new Date(selectedDate.getFullYear(), selectedDate.getMonth() + 1, 0);
      to.setHours(23, 59, 59, 999);
    }

    // Fetch sensor types separately to avoid join issues
    const { data: sensorTypes, error: sensorTypesError } = await supabase
      .from('sensor_types')
      .select('id, category');

    // Create category maps (by ID and by serial number for flexibility)
    const sensorCategoryMapById = {};
    const sensorCategoryMapBySerial = {};

    if (!sensorTypesError && sensorTypes) {
      sensorTypes.forEach(st => {
        sensorCategoryMapById[st.id] = st.category;
      });
    }

    // Fetch sensor readings
    const { data: supabaseData, error } = await supabase
      .from('sensor_readings')
      .select('id, timestamp, data, sensor_serial_number, sensor_id')
      .gte('timestamp', from.toISOString())
      .lte('timestamp', to.toISOString())
      .order('timestamp', { ascending: true });

    if (!error) {
      const rawData = supabaseData.map(d => {
        const sensorJson = d.data || {};

        // Try to get category from map, or assign default for simulated sensors
        let category = sensorCategoryMapById[d.sensor_id] || 'unknown';

        // For simulated sensors, assign categories based on ID pattern
        if (category === 'unknown' && d.sensor_id) {
          if (d.sensor_id.includes('sim-1') || d.sensor_id.includes('SENSOR-001')) {
            category = 'soil';
          } else if (d.sensor_id.includes('sim-2') || d.sensor_id.includes('SENSOR-002')) {
            category = 'meteorological';
          } else if (d.sensor_id.includes('sim-3') || d.sensor_id.includes('SENSOR-003')) {
            category = 'solar';
          } else if (d.sensor_id.includes('sim-4') || d.sensor_id.includes('SENSOR-004')) {
            category = 'soil';
          } else if (d.sensor_id.includes('sim-5') || d.sensor_id.includes('SENSOR-005')) {
            category = 'meteorological';
          }
        }

        // Fallback: detect category from sensor_serial_number pattern
        const serialNum = d.sensor_serial_number || '';
        if (category === 'unknown' && serialNum) {
          if (serialNum.startsWith('SOI') || serialNum.includes('SOIL')) {
            category = 'soil';
          } else if (serialNum.startsWith('MET') || serialNum.includes('METEO')) {
            category = 'meteorological';
          } else if (serialNum.startsWith('SOL') || serialNum.includes('SOLAR')) {
            category = 'solar';
          }
        }

        return {
          id: d.id,
          timestamp: d.timestamp,
          sensor_id: d.sensor_serial_number || d.sensor_id || 'unknown',
          sensor_category: category,
          temperature: sensorJson.temperature ?? sensorJson.soil_temperature, // Fallback original
          humidity: sensorJson.humidity,
          soil_moisture: sensorJson.soil_humidity ?? sensorJson.soil_moisture,
          solar_radiation: sensorJson.solar_radiation,
          ph: sensorJson.ph,
          // Nuevas métricas
          nitrogen: sensorJson.nitrogen,
          potassium: sensorJson.potassium,
          phosphorus: sensorJson.phosphorus,
          conductivity: sensorJson.conductivity,
          soil_temperature: sensorJson.soil_temperature, // Explicit override
          pm10: sensorJson.pm10,
          pm25: sensorJson.pm25 ?? sensorJson.pm2_5,
          noise: sensorJson.noise,
          rainfall: sensorJson.rainfall ?? sensorJson.rain,
          wind_speed: sensorJson.wind_speed,
        };
      });

      // Procesar datos (Resumidos, Detallados, o Agrupados)
      const chartReadyData = processDataByRange(rawData, timeRange, showDetail, isGrouped);
      setData(chartReadyData);
      setLoading(false);

      const isHistory = (timeRange === 'custom' || timeRange === 'month') && selectedDate.toDateString() !== new Date().toDateString();
      if (rawData.length > 0 && !isHistory) {
        analyzeCropHealth(rawData[rawData.length - 1]);
      }
    }
  }, [timeRange, selectedDate, showDetail, isGrouped, addNotification, deleteNotification]);

  // --- REALTIME SUBSCRIPTION ---
  useEffect(() => {
    fetchData();
    const isLive = timeRange === 'custom' && selectedDate.toDateString() === new Date().toDateString();
    let channel;
    if (isLive) {
      channel = supabase.channel('realtime-sensors')
        .on('postgres_changes', { event: 'INSERT', schema: 'public', table: 'sensor_readings' }, () => fetchData())
        .subscribe();
    }
    return () => { if (channel) supabase.removeChannel(channel); };
  }, [fetchData, timeRange, selectedDate]);

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
    for (let i = data.length - 1; i >= 0; i--) { if (data[i][key] != null) return data[i][key]; }
    return null;
  };

  // GENERAR LISTA DE MÉTRICAS VISIBLES
  const BASIC_METRICS = ['temperature', 'humidity', 'soil_moisture', 'solar_radiation', 'ph'];
  const EXTENDED_METRICS = [
    'nitrogen', 'potassium', 'phosphorus', 'conductivity', 'soil_temperature',
    'pm10', 'pm25', 'noise', 'rainfall', 'wind_speed'
  ];

  // Según requerimiento: Solo mostrar filtros extendidos en modo MENSUAL
  const AVAILABLE_METRICS = timeRange === 'month'
    ? [...BASIC_METRICS, ...EXTENDED_METRICS]
    : BASIC_METRICS;

  return (
    <div className="space-y-8 pb-12 w-full max-w-[100vw] overflow-x-hidden">

      {/* --- HEADER DASHBOARD --- */}
      <div className="flex flex-col xl:flex-row justify-between items-start xl:items-center gap-4 bg-white dark:bg-gray-800 p-5 rounded-xl border border-gray-200 dark:border-gray-700 shadow-sm relative z-30">

        {/* IZQUIERDA: Título y Controles Básicos */}
        <div className="flex items-center gap-4">
          <div className="flex flex-col">
            <h1 className="text-2xl font-bold text-gray-800 dark:text-white">Monitor Ambiental</h1>
            <p className="text-sm text-gray-500 dark:text-gray-400 mt-0.5">
              {timeRange === 'month'
                ? `Resumen de ${selectedDate.toLocaleDateString('es-ES', { month: 'long', year: 'numeric' })}`
                : `Datos del ${selectedDate.toLocaleDateString()}`}
            </p>
          </div>

          <div className="flex items-center gap-2">
            <button
              onClick={toggleSimulation}
              title={isSimulating ? "Detener Simulación" : "Iniciar Testeo"}
              className={`flex items-center gap-2 rounded-lg transition-all shadow-sm font-bold text-xs sm:text-sm ${isSimulating
                ? 'bg-red-100 text-red-600 dark:bg-red-900/40 dark:text-red-400 hover:bg-red-200 dark:hover:bg-red-900/60 p-1.5 sm:px-3 sm:py-1.5 animate-pulse'
                : 'bg-emerald-100 text-emerald-600 dark:bg-emerald-900/40 dark:text-emerald-400 hover:bg-emerald-200 dark:hover:bg-emerald-900/60 p-1.5 sm:px-3 sm:py-1.5'
                }`}
            >
              {isSimulating ? <Square size={18} /> : <Play size={18} />}
              <span className="hidden sm:inline">{isSimulating ? "Detener" : "Test en Vivo"}</span>
            </button>

            <button
              onClick={() => setShowDetail(!showDetail)}
              title={showDetail ? "Ver Resumen" : "Ver Minuto a Minuto"}
              className={`p-1.5 sm:p-2 rounded-lg transition-all shadow-sm border ${showDetail
                ? 'bg-blue-100 text-blue-600 border-blue-200 ring-1 ring-blue-300 dark:bg-blue-900/40 dark:text-blue-300 dark:border-blue-700'
                : 'bg-white text-gray-500 border-gray-200 hover:bg-gray-50 dark:bg-gray-700 dark:text-gray-300 dark:border-gray-600 dark:hover:bg-gray-600'
                }`}
            >
              <BarChart2 size={20} />
            </button>
          </div>
        </div>

        {/* DERECHA: Filtros Completos */}
        <div className="flex flex-wrap items-center gap-4 w-full xl:w-auto justify-start xl:justify-end">

          {/* Switch Agrupar Sensores */}
          <div className="flex items-center gap-2 mr-2 bg-gray-50 dark:bg-gray-700/50 px-3 py-1.5 rounded-full border border-gray-100 dark:border-gray-600">
            <span className={`text-xs font-bold uppercase tracking-wider ${isGrouped ? 'text-blue-600 dark:text-blue-400' : 'text-gray-500 dark:text-gray-400'}`}>Agrupar</span>
            <Switch
              checked={isGrouped}
              onChange={setIsGrouped}
              className={`${isGrouped ? 'bg-blue-600' : 'bg-gray-300 dark:bg-gray-600'} relative inline-flex h-5 w-9 items-center rounded-full transition-colors focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2`}
            >
              <span className={`${isGrouped ? 'translate-x-4' : 'translate-x-1'} inline-block h-3 w-3 transform rounded-full bg-white transition-transform`} />
            </Switch>
          </div>

          {/* Dropdown Parámetros Dinámico */}
          <div className="relative group">
            <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
              <Filter size={16} className="text-gray-400 group-focus-within:text-blue-500 transition-colors" />
            </div>
            <select
              value={selectedParameter}
              onChange={(e) => setSelectedParameter(e.target.value)}
              className="pl-9 pr-8 py-2 text-sm bg-white dark:bg-gray-700 border border-gray-200 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent block w-full text-gray-700 dark:text-gray-200 shadow-sm transition-all cursor-pointer hover:border-gray-300 dark:hover:border-gray-500"
            >
              <option value="all">Todos los Parámetros</option>
              {AVAILABLE_METRICS.map(key => (
                <option key={key} value={key}>{CROP_THRESHOLDS[key].label}</option>
              ))}
            </select>
          </div>

          <div className="h-6 w-[1px] bg-gray-200 dark:bg-gray-700 hidden sm:block"></div>

          {/* Selector Día/Mes */}
          <div className="flex items-center gap-1 border border-gray-200 dark:border-gray-600 rounded-lg p-1 bg-gray-50 dark:bg-gray-700/50">
            <button onClick={() => setTimeRange('custom')} className={`px-3 py-1.5 text-xs font-bold rounded-md transition-all shadow-sm ${timeRange === 'custom' ? 'bg-white dark:bg-gray-600 text-blue-600 dark:text-blue-300 shadow' : 'text-gray-400 dark:text-gray-500 hover:text-gray-600 dark:hover:text-gray-300'}`}>Diario</button>
            <button onClick={() => setTimeRange('month')} className={`px-3 py-1.5 text-xs font-bold rounded-md transition-all shadow-sm ${timeRange === 'month' ? 'bg-white dark:bg-gray-600 text-blue-600 dark:text-blue-300 shadow' : 'text-gray-400 dark:text-gray-500 hover:text-gray-600 dark:hover:text-gray-300'}`}>Mensual</button>
          </div>

          {/* Navegación Fecha */}
          <DateSelector selectedDate={selectedDate} setSelectedDate={handleDateSelect} mode={timeRange === 'month' ? 'month' : 'day'} />
        </div>
      </div>

      {/* --- MÉTRICAS (Principalmente las Base) --- */}
      <div className="grid grid-cols-2 xl:grid-cols-5 gap-3 md:gap-6 relative z-0">
        {BASIC_METRICS.map(key => {
          const config = CROP_THRESHOLDS[key];
          const rawVal = getLatestValid(key);
          const displayVal = rawVal ? `${Number(rawVal).toFixed(key === 'ph' ? 2 : 1)}${config.unit.replace(' ', '')}` : '--';
          return <MetricCard key={key} title={config.label} value={displayVal} icon={config.icon} color={config.color} loading={loading} />;
        })}
      </div>

      {/* --- GRÁFICAS --- */}
      <div className="flex flex-col gap-8 w-full relative z-0">
        {AVAILABLE_METRICS.map(metric => {
          // Filtro de parámetro activo
          if (selectedParameter !== 'all' && selectedParameter !== metric) return null;

          const config = CROP_THRESHOLDS[metric];
          // Si por alguna razón no hay config, saltar
          if (!config) return null;

          // SI ESTÁ AGRUPADO
          if (isGrouped && data.allSensors && data.allSensors.length > 0) {
            // FILTRAR SENSORES POR CATEGORÍA COMPATIBLE
            const compatibleCategories = METRIC_CATEGORIES[metric] || [];
            const sensorMetadata = data.sensorMetadata || {};

            const compatibleSensors = data.allSensors.filter(sId => {
              const category = sensorMetadata[sId]?.category || 'unknown';
              return compatibleCategories.includes(category);
            });

            // Si no hay sensores compatibles, no mostrar gráfica agrupada
            if (compatibleSensors.length === 0) {
              return null;
            }

            // Generar series dinámicas (Una línea por sensor compatible)
            const series = compatibleSensors.map((sId, idx) => ({
              key: `${metric}_${sId}`,
              name: `${sId}`,
              color: ['#3b82f6', '#ef4444', '#10b981', '#f59e0b', '#8b5cf6', '#ec4899', '#6366f1'][idx % 7]
            }));

            // Determinar qué categorías están presentes
            const activeCategories = [...new Set(
              compatibleSensors.map(sId => sensorMetadata[sId]?.category).filter(Boolean)
            )];

            return (
              <ChartCard
                key={metric}
                title={config.label}
                data={data}
                loading={loading}
                unit={config.unit}
                series={series}
                sensorCategories={activeCategories}
                categoryIcons={CATEGORY_ICONS}
                categoryLabels={CATEGORY_LABELS}
              />
            );
          }


          // SI NO ESTÁ AGRUPADO - Mostrar gráficas individuales por sensor
          if (!isGrouped && data.allSensors && data.allSensors.length > 0) {
            const sensorMetadata = data.sensorMetadata || {};
            const compatibleCategories = METRIC_CATEGORIES[metric] || [];

            // Filtrar sensores compatibles con esta métrica
            const compatibleSensors = data.allSensors.filter(sId => {
              const category = sensorMetadata[sId]?.category || 'unknown';
              return compatibleCategories.includes(category);
            });

            // Renderizar una gráfica por cada sensor compatible
            return compatibleSensors.map(sensorId => {
              // Filtrar datos solo de este sensor
              const sensorData = data.map(timePoint => {
                const sensorKey = `${metric}_${sensorId}`;
                if (timePoint[sensorKey] != null) {
                  return {
                    ...timePoint,
                    [metric]: timePoint[sensorKey]
                  };
                }
                return null;
              }).filter(Boolean);

              if (sensorData.length === 0) return null;

              const category = sensorMetadata[sensorId]?.category || 'unknown';
              const categoryIcon = CATEGORY_ICONS[category] || '📊';
              const categoryLabel = CATEGORY_LABELS[category] || category;

              return (
                <ChartCard
                  key={`${metric}_${sensorId}`}
                  title={`${config.label} - ${sensorId}`}
                  data={sensorData}
                  dataKey={metric}
                  color={config.color}
                  unit={config.unit}
                  loading={loading}
                  sensorCategories={[category]}
                  categoryIcons={CATEGORY_ICONS}
                  categoryLabels={CATEGORY_LABELS}
                />
              );
            });
          }

          // FALLBACK: Modo antiguo (datos agregados sin información de sensores)
          const cleanData = data.filter(d => d[metric] != null);

          return (
            <ChartCard
              key={metric}
              title={config.label}
              data={cleanData}
              dataKey={metric}
              color={config.color}
              unit={config.unit}
              loading={loading}
              noDataMessage={cleanData.length === 0 ? `Esperando datos...` : null}
            />
          );
        })}
      </div>
    </div>
  );
};

export default DashboardView;