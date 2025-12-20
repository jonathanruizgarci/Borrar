import '../database.dart';

class SensorsTable extends SupabaseTable<SensorsRow> {
  @override
  String get tableName => 'sensors';

  @override
  SensorsRow createRow(Map<String, dynamic> data) => SensorsRow(data);
}

class SensorsRow extends SupabaseDataRow {
  SensorsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SensorsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get locationId => getField<String>('location_id');
  set locationId(String? value) => setField<String>('location_id', value);

  String? get sensorTypeId => getField<String>('sensor_type_id');
  set sensorTypeId(String? value) => setField<String>('sensor_type_id', value);

  String? get serialNumber => getField<String>('serial_number');
  set serialNumber(String? value) => setField<String>('serial_number', value);

  int get modbusAddress => getField<int>('modbus_address')!;
  set modbusAddress(int value) => setField<int>('modbus_address', value);

  DateTime? get installationDate => getField<DateTime>('installation_date');
  set installationDate(DateTime? value) =>
      setField<DateTime>('installation_date', value);

  DateTime? get calibrationDate => getField<DateTime>('calibration_date');
  set calibrationDate(DateTime? value) =>
      setField<DateTime>('calibration_date', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  String? get notes => getField<String>('notes');
  set notes(String? value) => setField<String>('notes', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
