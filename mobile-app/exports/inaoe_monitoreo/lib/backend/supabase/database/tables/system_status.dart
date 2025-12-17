import '../database.dart';

class SystemStatusTable extends SupabaseTable<SystemStatusRow> {
  @override
  String get tableName => 'system_status';

  @override
  SystemStatusRow createRow(Map<String, dynamic> data) => SystemStatusRow(data);
}

class SystemStatusRow extends SupabaseDataRow {
  SystemStatusRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SystemStatusTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get raspberryPiId => getField<String>('raspberry_pi_id')!;
  set raspberryPiId(String value) => setField<String>('raspberry_pi_id', value);

  String? get locationId => getField<String>('location_id');
  set locationId(String? value) => setField<String>('location_id', value);

  DateTime get lastHeartbeat => getField<DateTime>('last_heartbeat')!;
  set lastHeartbeat(DateTime value) =>
      setField<DateTime>('last_heartbeat', value);

  double? get cpuUsage => getField<double>('cpu_usage');
  set cpuUsage(double? value) => setField<double>('cpu_usage', value);

  double? get memoryUsage => getField<double>('memory_usage');
  set memoryUsage(double? value) => setField<double>('memory_usage', value);

  double? get diskUsage => getField<double>('disk_usage');
  set diskUsage(double? value) => setField<double>('disk_usage', value);

  double? get temperature => getField<double>('temperature');
  set temperature(double? value) => setField<double>('temperature', value);

  int? get wifiSignalStrength => getField<int>('wifi_signal_strength');
  set wifiSignalStrength(int? value) =>
      setField<int>('wifi_signal_strength', value);

  int? get activeSensors => getField<int>('active_sensors');
  set activeSensors(int? value) => setField<int>('active_sensors', value);

  int? get failedReadingsLastHour => getField<int>('failed_readings_last_hour');
  set failedReadingsLastHour(int? value) =>
      setField<int>('failed_readings_last_hour', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  List<String> get errorMessages => getListField<String>('error_messages');
  set errorMessages(List<String>? value) =>
      setListField<String>('error_messages', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
