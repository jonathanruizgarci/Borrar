import '../database.dart';

class SensorTypesTable extends SupabaseTable<SensorTypesRow> {
  @override
  String get tableName => 'sensor_types';

  @override
  SensorTypesRow createRow(Map<String, dynamic> data) => SensorTypesRow(data);
}

class SensorTypesRow extends SupabaseDataRow {
  SensorTypesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SensorTypesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String get model => getField<String>('model')!;
  set model(String value) => setField<String>('model', value);

  String get category => getField<String>('category')!;
  set category(String value) => setField<String>('category', value);

  String? get protocol => getField<String>('protocol');
  set protocol(String? value) => setField<String>('protocol', value);

  dynamic? get parameters => getField<dynamic>('parameters');
  set parameters(dynamic? value) => setField<dynamic>('parameters', value);

  String? get manualUrl => getField<String>('manual_url');
  set manualUrl(String? value) => setField<String>('manual_url', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
