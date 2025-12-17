import '../database.dart';

class DataExportLogsTable extends SupabaseTable<DataExportLogsRow> {
  @override
  String get tableName => 'data_export_logs';

  @override
  DataExportLogsRow createRow(Map<String, dynamic> data) =>
      DataExportLogsRow(data);
}

class DataExportLogsRow extends SupabaseDataRow {
  DataExportLogsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DataExportLogsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get exportType => getField<String>('export_type');
  set exportType(String? value) => setField<String>('export_type', value);

  DateTime? get dateRangeStart => getField<DateTime>('date_range_start');
  set dateRangeStart(DateTime? value) =>
      setField<DateTime>('date_range_start', value);

  DateTime? get dateRangeEnd => getField<DateTime>('date_range_end');
  set dateRangeEnd(DateTime? value) =>
      setField<DateTime>('date_range_end', value);

  List<String> get locations => getListField<String>('locations');
  set locations(List<String>? value) =>
      setListField<String>('locations', value);

  List<String> get sensorTypes => getListField<String>('sensor_types');
  set sensorTypes(List<String>? value) =>
      setListField<String>('sensor_types', value);

  List<String> get parameters => getListField<String>('parameters');
  set parameters(List<String>? value) =>
      setListField<String>('parameters', value);

  int? get recordCount => getField<int>('record_count');
  set recordCount(int? value) => setField<int>('record_count', value);

  int? get fileSizeBytes => getField<int>('file_size_bytes');
  set fileSizeBytes(int? value) => setField<int>('file_size_bytes', value);

  String? get exportStatus => getField<String>('export_status');
  set exportStatus(String? value) => setField<String>('export_status', value);

  String? get downloadUrl => getField<String>('download_url');
  set downloadUrl(String? value) => setField<String>('download_url', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get expiresAt => getField<DateTime>('expires_at');
  set expiresAt(DateTime? value) => setField<DateTime>('expires_at', value);
}
