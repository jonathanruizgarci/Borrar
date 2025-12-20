/**
 * Procesa los datos crudos de los sensores.
 * SIEMPRE genera datos pivotados con metadata de sensores.
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

  // =========================================================================
  // MODO DETALLADO (Minuto a Minuto)
  // =========================================================================
  if (showDetail) {
    const timeMap = {};

    rawData.forEach(item => {
      const dateObj = new Date(item.timestamp);
      const timeKey = dateObj.toISOString().slice(0, 16);
      const displayLabel = dateObj.toLocaleTimeString('es-MX', {
        hour: '2-digit',
        minute: '2-digit',
        hour12: false
      });

      if (!timeMap[timeKey]) {
        timeMap[timeKey] = {
          id: timeKey,
          name: displayLabel,
          timestamp: item.timestamp
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
    result.allSensors = allSensors;
    result.sensorMetadata = sensorMetadata;
    return result;
  }

  // =========================================================================
  // MODO AGREGADO POR HORA/DÍA
  // =========================================================================
  const timeMap = {};

  rawData.forEach(item => {
    const dateObj = new Date(item.timestamp);
    let timeKey;
    let displayLabel;

    if (range === 'month') {
      // Agrupar por día
      timeKey = dateObj.toISOString().slice(0, 10);
      displayLabel = dateObj.toLocaleDateString('es-MX', { day: '2-digit', month: '2-digit' });
    } else {
      // Agrupar por hora (24h, custom)
      timeKey = `${dateObj.toISOString().slice(0, 13)}`;
      displayLabel = dateObj.toLocaleTimeString('es-MX', { hour: '2-digit', minute: '2-digit' });
    }

    if (!timeMap[timeKey]) {
      timeMap[timeKey] = {
        id: timeKey,
        name: displayLabel,
        timestamp: item.timestamp,
        counts: {},
        sums: {}
      };

      // Inicializar contadores por sensor
      allSensors.forEach(sId => {
        timeMap[timeKey].counts[sId] = {};
        timeMap[timeKey].sums[sId] = {};
        METRICS.forEach(m => {
          timeMap[timeKey].counts[sId][m] = 0;
          timeMap[timeKey].sums[sId][m] = 0;
        });
      });
    }

    const sId = item.sensor_id;
    METRICS.forEach(metric => {
      if (item[metric] != null) {
        timeMap[timeKey].sums[sId][metric] += Number(item[metric]);
        timeMap[timeKey].counts[sId][metric]++;
      }
    });
  });

  // Calcular promedios y generar estructura pivotada
  const result = Object.values(timeMap).map(bucket => {
    const point = {
      id: bucket.id,
      name: bucket.name,
      timestamp: bucket.timestamp
    };

    // Generar claves pivotadas con promedios
    allSensors.forEach(sId => {
      METRICS.forEach(metric => {
        const count = bucket.counts[sId][metric];
        if (count > 0) {
          const avg = bucket.sums[sId][metric] / count;
          point[`${metric}_${sId}`] = parseFloat(avg.toFixed(2));
        }
      });
    });

    return point;
  }).sort((a, b) => new Date(a.timestamp) - new Date(b.timestamp));

  result.allSensors = allSensors;
  result.sensorMetadata = sensorMetadata;

  return result;
};