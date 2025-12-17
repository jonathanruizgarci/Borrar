import '../database.dart';

class DailySummaryTable extends SupabaseTable<DailySummaryRow> {
  @override
  String get tableName => 'daily_summary';

  @override
  DailySummaryRow createRow(Map<String, dynamic> data) => DailySummaryRow(data);
}

class DailySummaryRow extends SupabaseDataRow {
  DailySummaryRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DailySummaryTable();

  String? get location => getField<String>('location');
  set location(String? value) => setField<String>('location', value);

  DateTime? get date => getField<DateTime>('date');
  set date(DateTime? value) => setField<DateTime>('date', value);

  String? get sensorCategory => getField<String>('sensor_category');
  set sensorCategory(String? value) =>
      setField<String>('sensor_category', value);

  int? get readingCount => getField<int>('reading_count');
  set readingCount(int? value) => setField<int>('reading_count', value);

  double? get avgTemperature => getField<double>('avg_temperature');
  set avgTemperature(double? value) =>
      setField<double>('avg_temperature', value);

  double? get avgHumidity => getField<double>('avg_humidity');
  set avgHumidity(double? value) => setField<double>('avg_humidity', value);

  double? get avgSoilMoisture => getField<double>('avg_soil_moisture');
  set avgSoilMoisture(double? value) =>
      setField<double>('avg_soil_moisture', value);
}
