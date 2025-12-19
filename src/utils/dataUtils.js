/**
 * Procesa los datos crudos de los sensores.
 * SIEMPRE genera datos pivotados con metadata de sensores para soportar ambos modos de visualización.
 */
export const processDataByRange = (rawData, range, showDetail = false, isGrouped = false) => {
  if (!rawData || rawData.length === 0) return [];

  const METRICS = [
    'temperature', 'humidity', 'soil_moisture', 'solar_radiation', 'ph',
    'nitrogen', 'potassium', 'phosphorus', 'conductivity', 'soil_temperature',
    'pm10', 'pm25', 'noise', 'rainfall', 'wind_speed'
  ];

  // Identificar todos los sensores únicos CON SU CATEGORÍA
  const sensorMap = new Map();
  rawData.forEach(d => {
    if (d.sensor_id && !sensorMap.has(d.sensor_id)) {
      sensorMap.set(d.sensor_id, {
        id: d.sensor_id,
        category: d.sensor_category || 'unknown'
      });
    }
  });

  const allSensors = Array.from(sensorMap.keys()).sort();
  const sensorMetadata = Object.fromEntries(sensorMap);

  // Agrupar datos por Timestamp
  const timeMap = {};

  rawData.forEach(item => {
    const dateObj = new Date(item.timestamp);

    let timeKey;
    let displayLabel;

    if (showDetail) {
      timeKey = dateObj.toISOString().slice(0, 16);
      displayLabel = dateObj.toLocaleTimeString('es-MX', { hour: '2-digit', minute: '2-digit' });
    } else if (range === 'month') {
      timeKey = dateObj.toISOString().slice(0, 10);
      displayLabel = dateObj.toLocaleDateString('es-MX', { day: '2-digit', month: '2-digit' });
    } else {
      timeKey = `${dateObj.toISOString().slice(0, 13)}`;
      displayLabel = dateObj.toLocaleTimeString('es-MX', { hour: '2-digit', minute: '2-digit' });
    }

    if (!timeMap[timeKey]) {
      timeMap[timeKey] = {
        id: timeKey,
        name: displayLabel,
        timestamp: item.timestamp,
        originalCount: 0
      };
    }

    const sId = item.sensor_id;
    METRICS.forEach(metric => {
      const key = `${metric}_${sId}`;
      if (item[metric] != null) {
        timeMap[timeKey][key] = Number(item[metric]);
      }
    });
  });

  const result = Object.values(timeMap).sort((a, b) => new Date(a.timestamp) - new Date(b.timestamp));

  // Adjuntar metadata de sensores
  result.allSensors = allSensors;
  result.sensorMetadata = sensorMetadata;

  return result;
};