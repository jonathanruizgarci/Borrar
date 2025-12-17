import '../database.dart';

class SensorReadingsTable extends SupabaseTable<SensorReadingsRow> {
  @override
  String get tableName => 'sensor_readings';

  @override
  SensorReadingsRow createRow(Map<String, dynamic> data) =>
      SensorReadingsRow(data);
}

class SensorReadingsRow extends SupabaseDataRow {
  SensorReadingsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SensorReadingsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get sensorId => getField<String>('sensor_id');
  set sensorId(String? value) => setField<String>('sensor_id', value);

  DateTime get timestamp => getField<DateTime>('timestamp')!;
  set timestamp(DateTime value) => setField<DateTime>('timestamp', value);

  dynamic get dataField => getField<dynamic>('data')!;
  set dataField(dynamic value) => setField<dynamic>('data', value);

  int? get qualityScore => getField<int>('quality_score');
  set qualityScore(int? value) => setField<int>('quality_score', value);

  int? get transmissionDelayMs => getField<int>('transmission_delay_ms');
  set transmissionDelayMs(int? value) =>
      setField<int>('transmission_delay_ms', value);

  String? get raspberryPiId => getField<String>('raspberry_pi_id');
  set raspberryPiId(String? value) =>
      setField<String>('raspberry_pi_id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get sensorSerialNumber => getField<String>('sensor_serial_number');
  set sensorSerialNumber(String? value) =>
      setField<String>('sensor_serial_number', value);
}
