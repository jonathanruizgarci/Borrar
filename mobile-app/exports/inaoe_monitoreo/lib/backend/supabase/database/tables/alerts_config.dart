import '../database.dart';

class AlertsConfigTable extends SupabaseTable<AlertsConfigRow> {
  @override
  String get tableName => 'alerts_config';

  @override
  AlertsConfigRow createRow(Map<String, dynamic> data) => AlertsConfigRow(data);
}

class AlertsConfigRow extends SupabaseDataRow {
  AlertsConfigRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AlertsConfigTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get sensorId => getField<String>('sensor_id');
  set sensorId(String? value) => setField<String>('sensor_id', value);

  String get parameter => getField<String>('parameter')!;
  set parameter(String value) => setField<String>('parameter', value);

  String get conditionType => getField<String>('condition_type')!;
  set conditionType(String value) => setField<String>('condition_type', value);

  double? get thresholdMin => getField<double>('threshold_min');
  set thresholdMin(double? value) => setField<double>('threshold_min', value);

  double? get thresholdMax => getField<double>('threshold_max');
  set thresholdMax(double? value) => setField<double>('threshold_max', value);

  String? get severity => getField<String>('severity');
  set severity(String? value) => setField<String>('severity', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  List<String> get notificationMethods =>
      getListField<String>('notification_methods');
  set notificationMethods(List<String>? value) =>
      setListField<String>('notification_methods', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
