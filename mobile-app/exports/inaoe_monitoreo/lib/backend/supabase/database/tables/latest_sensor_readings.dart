import '../database.dart';

class LatestSensorReadingsTable extends SupabaseTable<LatestSensorReadingsRow> {
  @override
  String get tableName => 'latest_sensor_readings';

  @override
  LatestSensorReadingsRow createRow(Map<String, dynamic> data) =>
      LatestSensorReadingsRow(data);
}

class LatestSensorReadingsRow extends SupabaseDataRow {
  LatestSensorReadingsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => LatestSensorReadingsTable();

  String? get sensorId => getField<String>('sensor_id');
  set sensorId(String? value) => setField<String>('sensor_id', value);

  String? get serialNumber => getField<String>('serial_number');
  set serialNumber(String? value) => setField<String>('serial_number', value);

  String? get sensorType => getField<String>('sensor_type');
  set sensorType(String? value) => setField<String>('sensor_type', value);

  String? get category => getField<String>('category');
  set category(String? value) => setField<String>('category', value);

  String? get locationName => getField<String>('location_name');
  set locationName(String? value) => setField<String>('location_name', value);

  String? get fieldZone => getField<String>('field_zone');
  set fieldZone(String? value) => setField<String>('field_zone', value);

  DateTime? get timestamp => getField<DateTime>('timestamp');
  set timestamp(DateTime? value) => setField<DateTime>('timestamp', value);

  dynamic? get dataField => getField<dynamic>('data');
  set dataField(dynamic? value) => setField<dynamic>('data', value);

  int? get qualityScore => getField<int>('quality_score');
  set qualityScore(int? value) => setField<int>('quality_score', value);
}
