import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/auth/firebase_auth/auth_util.dart';

DateTime updatedate(
  DateTime actualdate,
  int amount,
  String refperiod,
) {
  // Add or subtract the amount based on the reference period
  switch (refperiod.toLowerCase()) {
    case 'day':
      return actualdate.add(Duration(days: amount));
    case 'month':
      return DateTime(
        actualdate.year,
        actualdate.month + amount,
        actualdate.day,
        actualdate.hour,
        actualdate.minute,
        actualdate.second,
        actualdate.millisecond,
        actualdate.microsecond,
      );
    case 'year':
      return DateTime(
        actualdate.year + amount,
        actualdate.month,
        actualdate.day,
        actualdate.hour,
        actualdate.minute,
        actualdate.second,
        actualdate.millisecond,
        actualdate.microsecond,
      );
    default:
      // If refperiod is not recognized, default to days
      return actualdate.add(Duration(days: amount));
  }
}

dynamic processReadings(List<DataRecord>? documents) {
  if (documents == null || documents.isEmpty) {
    return {
      "status": "default",
      "data": [
        {
          "sensorId": "default",
          "sensorType": "unknown",
          "xLabels": [DateTime.now().toIso8601String()],
          "values": [0.0],
          "average": 0.0,
          "min": 0.0,
          "max": 0.0,
        }
      ]
    };
  }

  final Map<String, Map<DateTime, double>> sensorData = {};
  final Map<String, List<double>> sensorStats = {};
  final Map<String, String> sensorTypes = {};
  final Map<String, Set<DateTime>> sensorTimestamps = {};

  // Iterar a través de cada documento
  for (var document in documents) {
    if (document.readings == null || document.readings!.isEmpty) continue;

    // Procesar cada reading dentro del documento
    for (var reading in document.readings!) {
      final sensorId = reading.sensorId;
      final sensorType = reading.sensorType;
      final timestamp = reading.timestamp;
      final value = reading.value;

      if (sensorId == null || timestamp == null || value == null) continue;

      final roundedTimestamp = DateTime(timestamp.year, timestamp.month,
          timestamp.day, timestamp.hour, timestamp.minute);

      sensorData.putIfAbsent(sensorId, () => {});
      sensorData[sensorId]![roundedTimestamp] = value;

      sensorStats.putIfAbsent(sensorId, () => []);
      sensorStats[sensorId]!.add(value);

      sensorTypes[sensorId] = sensorType ?? 'unknown';

      sensorTimestamps.putIfAbsent(sensorId, () => {});
      sensorTimestamps[sensorId]!.add(roundedTimestamp);
    }
  }

  final List<Map<String, dynamic>> output = [];

  for (final sensorId in sensorData.keys) {
    final timestamps = sensorTimestamps[sensorId]!.toList()..sort();
    final values = <double>[];
    for (final ts in timestamps) {
      values.add(sensorData[sensorId]![ts]!);
    }

    final stats = sensorStats[sensorId]!;
    double avg = 0.0;
    double min = 0.0;
    double max = 0.0;

    if (stats.isNotEmpty) {
      avg = stats.reduce((a, b) => a + b) / stats.length;
      min = stats.reduce((a, b) => a < b ? a : b);
      max = stats.reduce((a, b) => a > b ? a : b);
    }

    output.add({
      'sensorId': sensorId,
      'sensorType': sensorTypes[sensorId],
      'xLabels': timestamps.map((dt) => dt.toIso8601String()).toList(),
      'values': values.isEmpty ? [0.0] : values,
      'average': double.parse(avg.toStringAsFixed(2)),
      'min': min,
      'max': max,
    });
  }

  // Si por algún motivo no se generó ningún sensor (posible error)
  if (output.isEmpty) {
    return {
      "status": "default",
      "data": [
        {
          "sensorId": "default",
          "sensorType": "unknown",
          "xLabels": [DateTime.now().toIso8601String()],
          "values": [0.0],
          "average": 0.0,
          "min": 0.0,
          "max": 0.0,
        }
      ]
    };
  }

  // Todo bien
  return {"status": "success", "data": output};
}

dynamic extractSensorFilters(List<DataRecord>? documents) {
  if (documents == null || documents.isEmpty) return null;

  final Set<String> sensorTypes = {};
  final Set<String> sensorIds = {};
  final Map<String, Set<String>> sensorMap = {};

  // Iterar a través de cada documento
  for (var document in documents) {
    if (document.readings == null || document.readings!.isEmpty) continue;

    // Procesar cada reading dentro del documento
    for (var reading in document.readings!) {
      final sensorId = reading.sensorId;
      final sensorType = reading.sensorType;

      if (sensorId == null || sensorType == null) continue;

      sensorTypes.add(sensorType);
      sensorIds.add(sensorId);

      sensorMap.putIfAbsent(sensorType, () => <String>{});
      sensorMap[sensorType]!.add(sensorId);
    }
  }

  // Convertir los sets a listas para compatibilidad con JSON
  final sensorMapList =
      sensorMap.map((key, value) => MapEntry(key, value.toList()));

  return {
    'sensorTypes': sensorTypes.toList(),
    'sensorIds': sensorIds.toList(),
    'sensorMap': sensorMapList,
  };
}

int? str2int(String number) {
  // transform the number into an integer, i.e. "2" -> 2
  if (number == null) return null; // Return null if input is null
  return int.tryParse(number); // Attempt to parse the string to an integer
}

DateTimeRange? startandendofdaytime(
  DateTime? refdate,
  String? period,
) {
  if (refdate == null) return null;

  DateTime start;
  DateTime end;

  switch (period?.toLowerCase()) {
    case 'day':
      // Primer y último momento del día
      start = DateTime(refdate.year, refdate.month, refdate.day, 0, 0, 0);
      end = DateTime(refdate.year, refdate.month, refdate.day, 23, 59, 59);
      break;

    case 'month':
      // Primer día del mes a las 00:00:00
      start = DateTime(refdate.year, refdate.month, 1, 0, 0, 0);
      // Último día del mes a las 23:59:59
      DateTime firstDayNextMonth = DateTime(refdate.year, refdate.month + 1, 1);
      DateTime lastDayOfMonth = firstDayNextMonth.subtract(Duration(days: 1));
      end = DateTime(lastDayOfMonth.year, lastDayOfMonth.month,
          lastDayOfMonth.day, 23, 59, 59);
      break;

    case 'year':
      // Primer día del año a las 00:00:00
      start = DateTime(refdate.year, 1, 1, 0, 0, 0);
      // Último día del año a las 23:59:59
      end = DateTime(refdate.year, 12, 31, 23, 59, 59);
      break;

    default:
      // Si no se especifica period o es inválido, usar comportamiento por defecto (día)
      start = DateTime(refdate.year, refdate.month, refdate.day, 0, 0, 0);
      end = DateTime(refdate.year, refdate.month, refdate.day, 23, 59, 59);
      break;
  }

  return DateTimeRange(start: start, end: end);
}

List<SensorjsonStruct>? processreadingsdatatype(
    List<ReadingsStruct>? readings) {
  if (readings == null || readings.isEmpty) {
    return [
      SensorjsonStruct(
        sensorId: "default",
        sensorType: "unknown",
        xLabels: [DateTime.now().toIso8601String()],
        values: [0.0],
        average: 0.0,
        min: 0.0,
        max: 0.0,
      ),
    ];
  }

  final Map<String, Map<DateTime, double>> sensorData = {};
  final Map<String, List<double>> sensorStats = {};
  final Map<String, String> sensorTypes = {};
  final Map<String, Set<DateTime>> sensorTimestamps = {};

  for (var reading in readings) {
    final sensorId = reading.sensorId;
    final sensorType = reading.sensorType;
    final timestamp = reading.timestamp;
    final value = reading.value;

    if (sensorId == null || timestamp == null || value == null) continue;

    final roundedTimestamp = DateTime(timestamp.year, timestamp.month,
        timestamp.day, timestamp.hour, timestamp.minute);

    sensorData.putIfAbsent(sensorId, () => {});
    sensorData[sensorId]![roundedTimestamp] = value;

    sensorStats.putIfAbsent(sensorId, () => []);
    sensorStats[sensorId]!.add(value);

    sensorTypes[sensorId] = sensorType ?? 'unknown';

    sensorTimestamps.putIfAbsent(sensorId, () => {});
    sensorTimestamps[sensorId]!.add(roundedTimestamp);
  }

  final List<SensorjsonStruct> output = [];

  for (final sensorId in sensorData.keys) {
    final timestamps = sensorTimestamps[sensorId]!.toList()..sort();
    final values = <double>[];
    for (final ts in timestamps) {
      values.add(sensorData[sensorId]![ts]!);
    }

    final stats = sensorStats[sensorId]!;
    double avg = 0.0;
    double min = 0.0;
    double max = 0.0;

    if (stats.isNotEmpty) {
      avg = stats.reduce((a, b) => a + b) / stats.length;
      min = stats.reduce((a, b) => a < b ? a : b);
      max = stats.reduce((a, b) => a > b ? a : b);
    }

    output.add(SensorjsonStruct(
      sensorId: sensorId,
      sensorType: sensorTypes[sensorId],
      xLabels: timestamps.map((dt) => dt.toIso8601String()).toList(),
      values: values.isEmpty ? [0.0] : values,
      average: double.parse(avg.toStringAsFixed(2)),
      min: min,
      max: max,
    ));
  }

  if (output.isEmpty) {
    return [
      SensorjsonStruct(
        sensorId: "default",
        sensorType: "unknown",
        xLabels: [DateTime.now().toIso8601String()],
        values: [0.0],
        average: 0.0,
        min: 0.0,
        max: 0.0,
      ),
    ];
  }

  return output;
}

List<DateTime> iSO8601todate(List<String> dates) {
  // convert all the dates strings in format ISO 8601 into a datetime format
  //if (dates == null) return null;
  return dates.map((date) => DateTime.parse(date)).toList();
}

List<SensorjsonStruct>? processReadingsday(List<DataRecord>? documents) {
  if (documents == null || documents.isEmpty) {
    return [
      SensorjsonStruct(
        sensorId: "default",
        sensorType: "unknown",
        xLabels: [DateTime.now().toIso8601String()],
        values: [0.0],
        average: 0.0,
        min: 0.0,
        max: 0.0,
      ),
    ];
  }

  final Map<String, Map<DateTime, double>> sensorData = {};
  final Map<String, List<double>> sensorStats = {};
  final Map<String, String> sensorTypes = {};
  final Map<String, Set<DateTime>> sensorTimestamps = {};

  // Iterar a través de cada documento
  for (var document in documents) {
    if (document.readings == null || document.readings!.isEmpty) continue;

    // Procesar cada reading dentro del documento
    for (var reading in document.readings!) {
      final sensorId = reading.sensorId;
      final sensorType = reading.sensorType;
      final timestamp = reading.timestamp;
      final value = reading.value;

      if (sensorId == null || timestamp == null || value == null) continue;

      final roundedTimestamp = DateTime(timestamp.year, timestamp.month,
          timestamp.day, timestamp.hour, timestamp.minute);

      sensorData.putIfAbsent(sensorId, () => {});
      sensorData[sensorId]![roundedTimestamp] = value;

      sensorStats.putIfAbsent(sensorId, () => []);
      sensorStats[sensorId]!.add(value);

      sensorTypes[sensorId] = sensorType ?? 'unknown';

      sensorTimestamps.putIfAbsent(sensorId, () => {});
      sensorTimestamps[sensorId]!.add(roundedTimestamp);
    }
  }

  final List<SensorjsonStruct> output = [];

  for (final sensorId in sensorData.keys) {
    final timestamps = sensorTimestamps[sensorId]!.toList()..sort();
    final values = <double>[];
    for (final ts in timestamps) {
      values.add(sensorData[sensorId]![ts]!);
    }

    final stats = sensorStats[sensorId]!;
    double avg = 0.0;
    double min = 0.0;
    double max = 0.0;

    if (stats.isNotEmpty) {
      avg = stats.reduce((a, b) => a + b) / stats.length;
      min = stats.reduce((a, b) => a < b ? a : b);
      max = stats.reduce((a, b) => a > b ? a : b);
    }

    output.add(SensorjsonStruct(
      sensorId: sensorId,
      sensorType: sensorTypes[sensorId],
      xLabels: timestamps.map((dt) => dt.toIso8601String()).toList(),
      values: values.isEmpty ? [0.0] : values,
      average: double.parse(avg.toStringAsFixed(2)),
      min: min,
      max: max,
    ));
  }

  if (output.isEmpty) {
    return [
      SensorjsonStruct(
        sensorId: "default",
        sensorType: "unknown",
        xLabels: [DateTime.now().toIso8601String()],
        values: [0.0],
        average: 0.0,
        min: 0.0,
        max: 0.0,
      ),
    ];
  }

  return output;
}

List<SensorjsonStruct>? processReadingsyear(List<DataRecord>? documents) {
  if (documents == null || documents.isEmpty) {
    return [
      SensorjsonStruct(
        sensorId: "default",
        sensorType: "unknown",
        xLabels: [DateTime.now().toIso8601String()],
        values: [0.0],
        average: 0.0,
        min: 0.0,
        max: 0.0,
      ),
    ];
  }

  // Estructura: sensorId -> fecha (solo año-mes) -> lista de valores del mes
  final Map<String, Map<DateTime, List<double>>> sensorMonthlyData = {};
  final Map<String, String> sensorTypes = {};

  // Iterar a través de cada documento
  for (var document in documents) {
    if (document.readings == null || document.readings!.isEmpty) continue;

    // Procesar cada reading dentro del documento
    for (var reading in document.readings!) {
      final sensorId = reading.sensorId;
      final sensorType = reading.sensorType;
      final timestamp = reading.timestamp;
      final value = reading.value;

      if (sensorId == null || timestamp == null || value == null) continue;

      // Redondear timestamp solo al mes (primer día del mes)
      final monthOnly = DateTime(timestamp.year, timestamp.month, 1);

      sensorMonthlyData.putIfAbsent(sensorId, () => {});
      sensorMonthlyData[sensorId]!.putIfAbsent(monthOnly, () => []);
      sensorMonthlyData[sensorId]![monthOnly]!.add(value);

      sensorTypes[sensorId] = sensorType ?? 'unknown';
    }
  }

  final List<SensorjsonStruct> output = [];

  for (final sensorId in sensorMonthlyData.keys) {
    // Obtener todos los meses ordenados
    final months = sensorMonthlyData[sensorId]!.keys.toList()..sort();

    final List<double> monthlyAverages = [];
    final List<double> allValues = []; // Para calcular estadísticas globales

    // Calcular promedio mensual para cada mes
    for (final month in months) {
      final monthValues = sensorMonthlyData[sensorId]![month]!;
      final monthAverage =
          monthValues.reduce((a, b) => a + b) / monthValues.length;
      // Truncar el promedio mensual a 2 decimales
      monthlyAverages.add(double.parse(monthAverage.toStringAsFixed(2)));
      allValues
          .addAll(monthValues); // Agregar todos los valores para estadísticas
    }

    // Calcular estadísticas basadas en los promedios mensuales
    double yearlyAvg = 0.0;
    double minMonthlyAvg = 0.0;
    double maxMonthlyAvg = 0.0;

    if (monthlyAverages.isNotEmpty) {
      yearlyAvg =
          monthlyAverages.reduce((a, b) => a + b) / monthlyAverages.length;
      minMonthlyAvg = monthlyAverages.reduce((a, b) => a < b ? a : b);
      maxMonthlyAvg = monthlyAverages.reduce((a, b) => a > b ? a : b);
    }

    output.add(SensorjsonStruct(
      sensorId: sensorId,
      sensorType: sensorTypes[sensorId],
      xLabels: months.map((dt) => dt.toIso8601String()).toList(),
      values: monthlyAverages.isEmpty ? [0.0] : monthlyAverages,
      average: double.parse(yearlyAvg.toStringAsFixed(2)),
      min: double.parse(minMonthlyAvg.toStringAsFixed(2)),
      max: double.parse(maxMonthlyAvg.toStringAsFixed(2)),
    ));
  }

  if (output.isEmpty) {
    return [
      SensorjsonStruct(
        sensorId: "default",
        sensorType: "unknown",
        xLabels: [DateTime.now().toIso8601String()],
        values: [0.0],
        average: 0.0,
        min: 0.0,
        max: 0.0,
      ),
    ];
  }

  return output;
}

List<SensorjsonStruct>? processReadingsmonth(List<DataRecord>? documents) {
  if (documents == null || documents.isEmpty) {
    return [
      SensorjsonStruct(
        sensorId: "default",
        sensorType: "unknown",
        xLabels: [DateTime.now().toIso8601String()],
        values: [0.0],
        average: 0.0,
        min: 0.0,
        max: 0.0,
      ),
    ];
  }

  // Estructura: sensorId -> fecha (solo día) -> lista de valores del día
  final Map<String, Map<DateTime, List<double>>> sensorDailyData = {};
  final Map<String, String> sensorTypes = {};

  // Variables para determinar el mes de los datos
  int? targetYear;
  int? targetMonth;

  // Iterar a través de cada documento
  for (var document in documents) {
    if (document.readings == null || document.readings!.isEmpty) continue;

    // Procesar cada reading dentro del documento
    for (var reading in document.readings!) {
      final sensorId = reading.sensorId;
      final sensorType = reading.sensorType;
      final timestamp = reading.timestamp;
      final value = reading.value;

      if (sensorId == null || timestamp == null || value == null) continue;

      // Redondear timestamp solo al día (sin hora/minuto)
      final dayOnly = DateTime(timestamp.year, timestamp.month, timestamp.day);

      // Detectar el mes de los datos (usar el primer timestamp válido)
      if (targetYear == null || targetMonth == null) {
        targetYear = timestamp.year;
        targetMonth = timestamp.month;
      }

      sensorDailyData.putIfAbsent(sensorId, () => {});
      sensorDailyData[sensorId]!.putIfAbsent(dayOnly, () => []);
      sensorDailyData[sensorId]![dayOnly]!.add(value);

      sensorTypes[sensorId] = sensorType ?? 'unknown';
    }
  }

  final List<SensorjsonStruct> output = [];

  // Si no hay fechas válidas, usar el mes actual
  if (targetYear == null || targetMonth == null) {
    final now = DateTime.now();
    targetYear = now.year;
    targetMonth = now.month;
  }

  // Generar lista completa de días para el mes completo
  final firstDayOfMonth = DateTime(targetYear!, targetMonth!, 1);
  final lastDayOfMonth = DateTime(targetYear!, targetMonth! + 1, 0);

  final List<DateTime> allDays = [];
  DateTime currentDay = firstDayOfMonth;
  while (currentDay.isBefore(lastDayOfMonth.add(Duration(days: 1)))) {
    allDays.add(currentDay);
    currentDay = currentDay.add(Duration(days: 1));
  }

  for (final sensorId in sensorDailyData.keys) {
    final List<double> dailyAverages = [];
    final List<double> allValues = []; // Para calcular estadísticas globales

    // Calcular promedio diario para cada día (incluyendo días sin datos)
    for (final day in allDays) {
      if (sensorDailyData[sensorId]!.containsKey(day)) {
        // Día con datos
        final dayValues = sensorDailyData[sensorId]![day]!;
        final dayAverage = dayValues.reduce((a, b) => a + b) / dayValues.length;
        // Redondear a 2 decimales y agregar
        dailyAverages.add(double.parse(dayAverage.toStringAsFixed(2)));
        allValues.addAll(dayValues);
      } else {
        // Día sin datos - agregar 0
        dailyAverages.add(0.0);
      }
    }

    // Calcular estadísticas basadas en los promedios diarios (excluyendo los ceros)
    final nonZeroAverages = dailyAverages.where((avg) => avg > 0).toList();

    double monthlyAvg = 0.0;
    double minDailyAvg = 0.0;
    double maxDailyAvg = 0.0;

    if (nonZeroAverages.isNotEmpty) {
      monthlyAvg =
          nonZeroAverages.reduce((a, b) => a + b) / nonZeroAverages.length;
      minDailyAvg = nonZeroAverages.reduce((a, b) => a < b ? a : b);
      maxDailyAvg = nonZeroAverages.reduce((a, b) => a > b ? a : b);
    }

    output.add(SensorjsonStruct(
      sensorId: sensorId,
      sensorType: sensorTypes[sensorId],
      xLabels: allDays.map((dt) => dt.toIso8601String()).toList(),
      values: dailyAverages.isEmpty ? [0.0] : dailyAverages,
      average: double.parse(monthlyAvg.toStringAsFixed(2)),
      min: double.parse(minDailyAvg.toStringAsFixed(2)),
      max: double.parse(maxDailyAvg.toStringAsFixed(2)),
    ));
  }

  if (output.isEmpty) {
    return [
      SensorjsonStruct(
        sensorId: "default",
        sensorType: "unknown",
        xLabels: [DateTime.now().toIso8601String()],
        values: [0.0],
        average: 0.0,
        min: 0.0,
        max: 0.0,
      ),
    ];
  }

  return output;
}

String buildHTMLfromSupabase(
  List<SupabaseReadStruct> supabasedata,
  DateTime refDate,
  String viewMode,
  String primaryBG,
  String cardBG,
  String buttonBG,
  String textColor,
  bool groupBySensor,
) {
  if (supabasedata.isEmpty) {
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Sin Datos</title>
  <style>
    body { 
      font-family: Arial, sans-serif; 
      padding: 50px; 
      text-align: center; 
      background: $primaryBG;
      color: $textColor;
    }
    .error { 
      color: #dc3545; 
      font-size: 24px; 
    }
  </style>
</head>
<body>
  <h2 class="error">⚠️ No hay datos disponibles</h2>
  <p>No se encontraron lecturas de sensores para mostrar.</p>
</body>
</html>
''';
  }

  // Validar viewMode
  if (!['daily', 'monthly', 'yearly'].contains(viewMode)) {
    viewMode = 'daily';
  }

  // Identificar todos los parámetros disponibles
  Set<String> allParameters = {};
  for (var reading in supabasedata) {
    try {
      if (reading.data != null && reading.data!.isNotEmpty) {
        String jsonString = reading.data!.replaceAllMapped(
          RegExp(r'(\w+):'),
          (match) => '"${match.group(1)}":',
        );
        Map<String, dynamic> dataMap = jsonDecode(jsonString);

        // Solo parámetros de medición (excluir offset y factor)
        dataMap.keys.forEach((key) {
          if (!key.contains('offset') && !key.contains('factor')) {
            allParameters.add(key);
          }
        });
      }
    } catch (e) {
      print('Error parsing data: $e');
    }
  }

  // Nombres en español para los parámetros
  Map<String, String> parameterNames = {
    'ph': 'pH',
    'tds': 'TDS (mg/L)',
    'nitrogen': 'Nitrógeno (mg/kg)',
    'salinity': 'Salinidad (mg/L)',
    'potassium': 'Potasio (mg/kg)',
    'phosphorus': 'Fósforo (mg/kg)',
    'conductivity': 'Conductividad (μS/cm)',
    'soil_humidity': 'Humedad del Suelo (%)',
    'soil_temperature': 'Temperatura del Suelo (°C)',
    'temperature': 'Temperatura (°C)',
    'humidity': 'Humedad (%)',
    'atmospheric_pressure': 'Presión Atmosférica (kPa)',
    'wind_speed': 'Velocidad del Viento (m/s)',
    'wind_direction': 'Dirección del Viento (°)',
    'solar_radiation': 'Radiación Solar (W/m²)',
    'noise': 'Ruido (dB)',
    'pm25': 'PM2.5 (μg/m³)',
    'pm10': 'PM10 (μg/m³)',
    'illuminance': 'Iluminación (Lux)',
    'rainfall': 'Lluvia (mm)',
  };

  String getParameterName(String param) {
    return parameterNames[param] ?? param;
  }

  // Colores para las gráficas
  List<String> colors = [
    '#FF6384',
    '#36A2EB',
    '#FFCE56',
    '#4BC0C0',
    '#9966FF',
    '#FF9F40',
    '#E74C3C',
    '#2ECC71',
    '#3498DB',
    '#F39C12',
    '#8E44AD',
    '#E67E22',
    '#16A085',
    '#C0392B',
    '#2980B9',
  ];

  // Serializar datos para JavaScript
  List<Map<String, dynamic>> serializedData = supabasedata.map((reading) {
    return {
      'id': reading.id,
      'sensor_id': reading.sensorId,
      'timestamp': reading.timestamp?.toIso8601String(),
      'data': reading.data,
      'quality_score': reading.qualityScore,
      'raspberry_pi_id': reading.raspberryPiId,
      'sensor_serial_number': reading.sensorSerialNumber,
    };
  }).toList();

  String formattedRefDate = refDate.toIso8601String();

  // Títulos según el modo
  String getViewTitle() {
    switch (viewMode) {
      case 'daily':
        return DateFormat('EEEE, d \'de\' MMMM yyyy', 'es').format(refDate);
      case 'monthly':
        return DateFormat('MMMM yyyy', 'es').format(refDate);
      case 'yearly':
        return refDate.year.toString();
      default:
        return DateFormat('MMMM yyyy', 'es').format(refDate);
    }
  }

  String viewTitle = getViewTitle();
  String viewDescription = viewMode == 'daily'
      ? 'Monitoreo por Hora'
      : viewMode == 'monthly'
          ? 'Promedios Diarios del Mes'
          : 'Promedios Mensuales del Año';

  return '''
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Dashboard Sensores - $viewTitle</title>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-adapter-date-fns"></script>
<style>
* { margin: 0; padding: 0; box-sizing: border-box; }

body {
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  background: $primaryBG;
  color: $textColor;
  min-height: 100vh;
  padding: 20px;
}

.container { max-width: 1400px; margin: 0 auto; }

.stats {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 20px;
  margin-bottom: 30px;
}

.stat-card {
  background: $cardBG;
  border-radius: 12px;
  padding: 20px;
  box-shadow: 0 4px 16px rgba(0,0,0,0.1);
  text-align: center;
  transition: transform 0.3s;
}

.stat-card:hover {
  transform: translateY(-5px);
}

.stat-number {
  font-size: 2.5em;
  font-weight: bold;
  color: $buttonBG;
  margin-bottom: 8px;
}

.stat-label {
  color: $textColor;
  opacity: 0.7;
  font-size: 0.9em;
  text-transform: uppercase;
  letter-spacing: 1px;
}

.controls {
  background: $cardBG;
  border-radius: 15px;
  padding: 25px;
  margin-bottom: 30px;
  box-shadow: 0 4px 16px rgba(0,0,0,0.1);
}

.control-group {
  display: flex;
  align-items: center;
  gap: 15px;
  margin-bottom: 15px;
  flex-wrap: wrap;
}

.control-group label {
  font-weight: 600;
  color: $textColor;
  min-width: 100px;
}

.control-group select {
  padding: 10px 15px;
  border: 2px solid $textColor;
  border-opacity: 0.2;
  border-radius: 8px;
  font-size: 14px;
  transition: border-color 0.3s;
  flex: 1;
  max-width: 250px;
  background: $primaryBG;
  color: $textColor;
}

.control-group select:focus {
  outline: none;
  border-color: $buttonBG;
}

.control-group button {
  padding: 10px 25px;
  background: $buttonBG;
  color: white;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-weight: 600;
  transition: all 0.3s;
}

.control-group button:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0,0,0,0.3);
  opacity: 0.9;
}

.charts-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(500px, 1fr));
  gap: 25px;
  margin-bottom: 30px;
}

.chart-container {
  background: $cardBG;
  border-radius: 15px;
  padding: 25px;
  box-shadow: 0 4px 16px rgba(0,0,0,0.1);
}

.chart-title {
  font-size: 1.3em;
  font-weight: 600;
  color: $textColor;
  margin-bottom: 20px;
  text-align: center;
  border-bottom: 3px solid $buttonBG;
  padding-bottom: 10px;
}

canvas {
  max-height: 300px;
}

.loading {
  text-align: center;
  padding: 50px;
  font-size: 1.5em;
  color: $buttonBG;
}

.no-data-message {
  background: $cardBG;
  color: $textColor;
  padding: 30px;
  border-radius: 12px;
  text-align: center;
  font-size: 1.2em;
  border: 2px solid $buttonBG;
  opacity: 0.8;
}

@media (max-width: 768px) {
  .charts-grid {
    grid-template-columns: 1fr;
  }
  
  .control-group {
    flex-direction: column;
    align-items: stretch;
  }
  
  .control-group label {
    min-width: auto;
  }
  
  canvas {
    max-height: 400px;
  }
}
</style>
</head>
<body>
<div class="container">
  <div class="stats">
    <div class="stat-card">
      <div class="stat-number" id="totalReadings">${supabasedata.length}</div>
      <div class="stat-label">Lecturas Totales</div>
    </div>
  </div>

  <div class="controls">
    <div class="control-group">
      <label>Parámetro:</label>
      <select id="parameterSelect" onchange="updateCharts()">
        <option value="all">Todos los Parámetros</option>
        ${allParameters.map((param) => '<option value="$param">${getParameterName(param)}</option>').join('\n')}
      </select>
      <button onclick="exportData()">📥 Exportar CSV</button>
    </div>
  </div>

  <div class="charts-grid" id="chartsContainer">
    <div class="loading">Cargando gráficas...</div>
  </div>
</div>

<script>
const sensorData = ${jsonEncode(serializedData)};
const allParameters = ${jsonEncode(allParameters.toList())};
const refDate = new Date('$formattedRefDate');
const viewMode = '$viewMode';
const groupBySensor = $groupBySensor;
const colors = ${jsonEncode(colors)};
const parameterNames = ${jsonEncode(parameterNames)};
const textColor = '$textColor';

let charts = [];

function parseData(dataToProcess) {
  const parsedReadings = [];
  
  dataToProcess.forEach(reading => {
    if (!reading.data) return;
    
    try {
      const jsonString = reading.data.replace(/(\\w+):/g, '"\$1":');
      const dataObj = JSON.parse(jsonString);
      
      parsedReadings.push({
        timestamp: new Date(reading.timestamp),
        sensorId: reading.sensor_id,
        sensorSerial: reading.sensor_serial_number || reading.sensor_id?.substring(0, 8) || 'Sin ID',
        raspberryPiId: reading.raspberry_pi_id,
        qualityScore: reading.quality_score,
        data: dataObj
      });
    } catch (e) {
      console.error('Error parsing:', e);
    }
  });
  
  return parsedReadings;
}

function processReadings(readings) {
  if (viewMode === 'daily') {
    return readings.sort((a, b) => a.timestamp - b.timestamp);
  } else if (viewMode === 'monthly') {
    return calculateDailyAverages(readings);
  } else if (viewMode === 'yearly') {
    return calculateMonthlyAverages(readings);
  }
  return readings;
}

function calculateDailyAverages(readings) {
  const dailyData = {};
  
  readings.forEach(reading => {
    const dateKey = reading.timestamp.toISOString().split('T')[0];
    const sensorKey = groupBySensor ? reading.sensorId : 'all';
    const combinedKey = dateKey + '_' + sensorKey;
    
    if (!dailyData[combinedKey]) {
      dailyData[combinedKey] = {
        date: dateKey,
        sensorId: reading.sensorId,
        sensorSerial: reading.sensorSerial,
        params: {}
      };
      allParameters.forEach(param => {
        dailyData[combinedKey].params[param] = { sum: 0, count: 0 };
      });
    }
    
    Object.keys(reading.data).forEach(param => {
      if (dailyData[combinedKey].params[param]) {
        const value = parseFloat(reading.data[param]);
        if (!isNaN(value)) {
          dailyData[combinedKey].params[param].sum += value;
          dailyData[combinedKey].params[param].count++;
        }
      }
    });
  });
  
  const averages = [];
  Object.keys(dailyData).sort().forEach(combinedKey => {
    const avgData = {};
    Object.keys(dailyData[combinedKey].params).forEach(param => {
      if (dailyData[combinedKey].params[param].count > 0) {
        avgData[param] = dailyData[combinedKey].params[param].sum / dailyData[combinedKey].params[param].count;
      }
    });
    
    averages.push({
      timestamp: new Date(dailyData[combinedKey].date + 'T12:00:00'),
      sensorId: dailyData[combinedKey].sensorId,
      sensorSerial: dailyData[combinedKey].sensorSerial,
      data: avgData
    });
  });
  
  return averages;
}

function calculateMonthlyAverages(readings) {
  const monthlyData = {};
  
  readings.forEach(reading => {
    const monthKey = reading.timestamp.getFullYear() + '-' + 
                     String(reading.timestamp.getMonth() + 1).padStart(2, '0');
    const sensorKey = groupBySensor ? reading.sensorId : 'all';
    const combinedKey = monthKey + '_' + sensorKey;
    
    if (!monthlyData[combinedKey]) {
      monthlyData[combinedKey] = {
        month: monthKey,
        sensorId: reading.sensorId,
        sensorSerial: reading.sensorSerial,
        params: {}
      };
      allParameters.forEach(param => {
        monthlyData[combinedKey].params[param] = { sum: 0, count: 0 };
      });
    }
    
    Object.keys(reading.data).forEach(param => {
      if (monthlyData[combinedKey].params[param]) {
        const value = parseFloat(reading.data[param]);
        if (!isNaN(value)) {
          monthlyData[combinedKey].params[param].sum += value;
          monthlyData[combinedKey].params[param].count++;
        }
      }
    });
  });
  
  const averages = [];
  Object.keys(monthlyData).sort().forEach(combinedKey => {
    const avgData = {};
    Object.keys(monthlyData[combinedKey].params).forEach(param => {
      if (monthlyData[combinedKey].params[param].count > 0) {
        avgData[param] = monthlyData[combinedKey].params[param].sum / monthlyData[combinedKey].params[param].count;
      }
    });
    
    averages.push({
      timestamp: new Date(monthlyData[combinedKey].month + '-15T12:00:00'),
      sensorId: monthlyData[combinedKey].sensorId,
      sensorSerial: monthlyData[combinedKey].sensorSerial,
      data: avgData
    });
  });
  
  return averages;
}

function updateStats() {
  const readings = parseData(sensorData);
  
  if (readings.length === 0) {
    return;
  }
}

function updateCharts() {
  const selectedParam = document.getElementById('parameterSelect').value;
  let readings = parseData(sensorData);
  const container = document.getElementById('chartsContainer');
  
  charts.forEach(chart => chart.destroy());
  charts = [];
  container.innerHTML = '';
  
  if (readings.length === 0) {
    container.innerHTML = '<div class="no-data-message">📭 No hay datos disponibles</div>';
    return;
  }
  
  readings = processReadings(readings);
  const paramsToShow = selectedParam === 'all' ? allParameters : [selectedParam];
  
  if (groupBySensor) {
    createChartsBySensor(readings, paramsToShow, container);
  } else {
    createChartsByParameter(readings, paramsToShow, container);
  }
}

function createChartsBySensor(readings, paramsToShow, container) {
  const uniqueSensors = [...new Set(readings.map(r => r.sensorId))];
  
  uniqueSensors.forEach((sensorId, sensorIndex) => {
    const sensorReadings = readings.filter(r => r.sensorId === sensorId);
    const sensorSerial = sensorReadings[0]?.sensorSerial || 'Sin ID';
    
    paramsToShow.forEach(param => {
      const hasData = sensorReadings.some(r => r.data[param] !== undefined);
      if (!hasData) return;
      
      const chartDiv = document.createElement('div');
      chartDiv.className = 'chart-container';
      
      const title = document.createElement('div');
      title.className = 'chart-title';
      title.textContent = (parameterNames[param] || param) + ' - ' + sensorSerial;
      
      const canvas = document.createElement('canvas');
      
      chartDiv.appendChild(title);
      chartDiv.appendChild(canvas);
      container.appendChild(chartDiv);
      
      const chartData = sensorReadings
        .filter(r => r.data[param] !== undefined)
        .map(r => ({
          x: r.timestamp,
          y: parseFloat(r.data[param])
        }))
        .sort((a, b) => a.x - b.x);
      
      createChart(canvas, param, chartData, colors[sensorIndex % colors.length]);
    });
  });
}

function createChartsByParameter(readings, paramsToShow, container) {
  paramsToShow.forEach((param, index) => {
    const hasData = readings.some(r => r.data[param] !== undefined);
    if (!hasData) return;
    
    const chartDiv = document.createElement('div');
    chartDiv.className = 'chart-container';
    
    const title = document.createElement('div');
    title.className = 'chart-title';
    title.textContent = parameterNames[param] || param;
    
    const canvas = document.createElement('canvas');
    
    chartDiv.appendChild(title);
    chartDiv.appendChild(canvas);
    container.appendChild(chartDiv);
    
    if (viewMode === 'daily') {
      const uniqueSensors = [...new Set(readings.map(r => r.sensorId))];
      
      const datasets = uniqueSensors
        .map((sensorId, sensorIndex) => {
          const sensorReadings = readings.filter(r => r.sensorId === sensorId);
          const sensorSerial = sensorReadings[0]?.sensorSerial || 'Sin ID';
          
          const chartData = sensorReadings
            .filter(r => r.data[param] !== undefined)
            .map(r => ({
              x: r.timestamp,
              y: parseFloat(r.data[param])
            }))
            .sort((a, b) => a.x - b.x);
          
          if (chartData.length === 0) return null;
          
          return {
            label: sensorSerial,
            data: chartData,
            borderColor: colors[sensorIndex % colors.length],
            backgroundColor: colors[sensorIndex % colors.length] + '20',
            borderWidth: 2,
            fill: true,
            tension: 0.4,
            pointRadius: 4,
            pointHoverRadius: 7
          };
        })
        .filter(d => d !== null);
      
      createMultiSensorChart(canvas, param, datasets);
    } else {
      const chartData = readings
        .filter(r => r.data[param] !== undefined)
        .map(r => ({
          x: r.timestamp,
          y: parseFloat(r.data[param])
        }))
        .sort((a, b) => a.x - b.x);
      
      createChart(canvas, param, chartData, colors[index % colors.length]);
    }
  });
}

function createChart(canvas, param, chartData, color) {
  let timeConfig = {};
  
  if (viewMode === 'daily') {
    const dayStart = new Date(refDate.getFullYear(), refDate.getMonth(), refDate.getDate(), 0, 0, 0);
    const dayEnd = new Date(refDate.getFullYear(), refDate.getMonth(), refDate.getDate(), 23, 59, 59);
    
    timeConfig = {
      unit: 'hour',
      displayFormats: { hour: 'HH:mm' },
      min: dayStart.getTime(),
      max: dayEnd.getTime()
    };
  } else if (viewMode === 'monthly') {
    timeConfig = {
      unit: 'day',
      displayFormats: { day: 'dd MMM' }
    };
  } else {
    timeConfig = {
      unit: 'month',
      displayFormats: { month: 'MMM' }
    };
  }
  
  const ctx = canvas.getContext('2d');
  const chart = new Chart(ctx, {
    type: 'line',
    data: {
      datasets: [{
        label: parameterNames[param] || param,
        data: chartData,
        borderColor: color,
        backgroundColor: color + '20',
        borderWidth: 2,
        fill: true,
        tension: 0.4,
        pointRadius: viewMode === 'daily' ? 4 : 3,
        pointHoverRadius: 7
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: {
          display: true,
          position: 'top',
          labels: { color: textColor }
        },
        tooltip: {
          mode: 'index',
          intersect: false
        }
      },
      scales: {
        x: {
          type: 'time',
          time: timeConfig,
          title: {
            display: true,
            text: viewMode === 'daily' ? 'Hora' : viewMode === 'monthly' ? 'Día' : 'Mes',
            color: textColor
          },
          ticks: { 
            color: textColor
          },
          grid: { color: textColor + '20' }
        },
        y: {
          title: {
            display: true,
            text: parameterNames[param] || param,
            color: textColor
          },
          ticks: { color: textColor },
          grid: { color: textColor + '20' },
          beginAtZero: false
        }
      }
    }
  });
  
  charts.push(chart);
}

function createMultiSensorChart(canvas, param, datasets) {
  const dayStart = new Date(refDate.getFullYear(), refDate.getMonth(), refDate.getDate(), 0, 0, 0);
  const dayEnd = new Date(refDate.getFullYear(), refDate.getMonth(), refDate.getDate(), 23, 59, 59);
  
  const ctx = canvas.getContext('2d');
  const chart = new Chart(ctx, {
    type: 'line',
    data: { datasets: datasets },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: {
          display: true,
          position: 'top',
          labels: { color: textColor }
        },
        tooltip: {
          mode: 'index',
          intersect: false
        }
      },
      scales: {
        x: {
          type: 'time',
          time: {
            unit: 'hour',
            displayFormats: { hour: 'HH:mm' },
            min: dayStart.getTime(),
            max: dayEnd.getTime()
          },
          title: {
            display: true,
            text: 'Hora',
            color: textColor
          },
          ticks: { 
            color: textColor
          },
          grid: { color: textColor + '20' }
        },
        y: {
          title: {
            display: true,
            text: parameterNames[param] || param,
            color: textColor
          },
          ticks: { color: textColor },
          grid: { color: textColor + '20' },
          beginAtZero: false
        }
      }
    }
  });
  
  charts.push(chart);
}

function exportData() {
  let readings = parseData(sensorData);
  
  if (readings.length === 0) {
    alert('No hay datos para exportar');
    return;
  }
  
  readings = processReadings(readings);
  
  const filename = 'sensor_data_${viewTitle.replaceAll(' ', '_')}_${viewMode}.csv';
  
  let csv = 'Timestamp,Sensor Serial';
  allParameters.forEach(param => {
    csv += ',' + (parameterNames[param] || param);
  });
  csv += '\\n';
  
  readings.forEach(reading => {
    csv += reading.timestamp.toISOString() + ',' + (reading.sensorSerial || '');
    
    allParameters.forEach(param => {
      csv += ',' + (reading.data[param] || '');
    });
    csv += '\\n';
  });
  
  const blob = new Blob([csv], { type: 'text/csv' });
  const url = window.URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = filename;
  a.click();
}

updateStats();
updateCharts();
</script>
</body>
</html>
''';
}
