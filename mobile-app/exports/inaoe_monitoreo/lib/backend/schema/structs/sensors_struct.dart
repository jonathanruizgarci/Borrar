// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SensorsStruct extends FFFirebaseStruct {
  SensorsStruct({
    bool? temperature,
    bool? humidity,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _temperature = temperature,
        _humidity = humidity,
        super(firestoreUtilData);

  // "temperature" field.
  bool? _temperature;
  bool get temperature => _temperature ?? false;
  set temperature(bool? val) => _temperature = val;

  bool hasTemperature() => _temperature != null;

  // "humidity" field.
  bool? _humidity;
  bool get humidity => _humidity ?? false;
  set humidity(bool? val) => _humidity = val;

  bool hasHumidity() => _humidity != null;

  static SensorsStruct fromMap(Map<String, dynamic> data) => SensorsStruct(
        temperature: data['temperature'] as bool?,
        humidity: data['humidity'] as bool?,
      );

  static SensorsStruct? maybeFromMap(dynamic data) =>
      data is Map ? SensorsStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'temperature': _temperature,
        'humidity': _humidity,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'temperature': serializeParam(
          _temperature,
          ParamType.bool,
        ),
        'humidity': serializeParam(
          _humidity,
          ParamType.bool,
        ),
      }.withoutNulls;

  static SensorsStruct fromSerializableMap(Map<String, dynamic> data) =>
      SensorsStruct(
        temperature: deserializeParam(
          data['temperature'],
          ParamType.bool,
          false,
        ),
        humidity: deserializeParam(
          data['humidity'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'SensorsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is SensorsStruct &&
        temperature == other.temperature &&
        humidity == other.humidity;
  }

  @override
  int get hashCode => const ListEquality().hash([temperature, humidity]);
}

SensorsStruct createSensorsStruct({
  bool? temperature,
  bool? humidity,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    SensorsStruct(
      temperature: temperature,
      humidity: humidity,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

SensorsStruct? updateSensorsStruct(
  SensorsStruct? sensors, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    sensors
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addSensorsStructData(
  Map<String, dynamic> firestoreData,
  SensorsStruct? sensors,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (sensors == null) {
    return;
  }
  if (sensors.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && sensors.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final sensorsData = getSensorsFirestoreData(sensors, forFieldValue);
  final nestedData = sensorsData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = sensors.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getSensorsFirestoreData(
  SensorsStruct? sensors, [
  bool forFieldValue = false,
]) {
  if (sensors == null) {
    return {};
  }
  final firestoreData = mapToFirestore(sensors.toMap());

  // Add any Firestore field values
  sensors.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getSensorsListFirestoreData(
  List<SensorsStruct>? sensorss,
) =>
    sensorss?.map((e) => getSensorsFirestoreData(e, true)).toList() ?? [];
