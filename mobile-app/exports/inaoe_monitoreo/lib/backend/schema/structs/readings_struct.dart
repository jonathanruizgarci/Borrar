// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ReadingsStruct extends FFFirebaseStruct {
  ReadingsStruct({
    DateTime? timestamp,
    double? value,
    String? sensorId,
    String? sensorType,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _timestamp = timestamp,
        _value = value,
        _sensorId = sensorId,
        _sensorType = sensorType,
        super(firestoreUtilData);

  // "timestamp" field.
  DateTime? _timestamp;
  DateTime? get timestamp => _timestamp;
  set timestamp(DateTime? val) => _timestamp = val;

  bool hasTimestamp() => _timestamp != null;

  // "value" field.
  double? _value;
  double get value => _value ?? 0.0;
  set value(double? val) => _value = val;

  void incrementValue(double amount) => value = value + amount;

  bool hasValue() => _value != null;

  // "sensorId" field.
  String? _sensorId;
  String get sensorId => _sensorId ?? '';
  set sensorId(String? val) => _sensorId = val;

  bool hasSensorId() => _sensorId != null;

  // "sensorType" field.
  String? _sensorType;
  String get sensorType => _sensorType ?? '';
  set sensorType(String? val) => _sensorType = val;

  bool hasSensorType() => _sensorType != null;

  static ReadingsStruct fromMap(Map<String, dynamic> data) => ReadingsStruct(
        timestamp: data['timestamp'] as DateTime?,
        value: castToType<double>(data['value']),
        sensorId: data['sensorId'] as String?,
        sensorType: data['sensorType'] as String?,
      );

  static ReadingsStruct? maybeFromMap(dynamic data) =>
      data is Map ? ReadingsStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'timestamp': _timestamp,
        'value': _value,
        'sensorId': _sensorId,
        'sensorType': _sensorType,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'timestamp': serializeParam(
          _timestamp,
          ParamType.DateTime,
        ),
        'value': serializeParam(
          _value,
          ParamType.double,
        ),
        'sensorId': serializeParam(
          _sensorId,
          ParamType.String,
        ),
        'sensorType': serializeParam(
          _sensorType,
          ParamType.String,
        ),
      }.withoutNulls;

  static ReadingsStruct fromSerializableMap(Map<String, dynamic> data) =>
      ReadingsStruct(
        timestamp: deserializeParam(
          data['timestamp'],
          ParamType.DateTime,
          false,
        ),
        value: deserializeParam(
          data['value'],
          ParamType.double,
          false,
        ),
        sensorId: deserializeParam(
          data['sensorId'],
          ParamType.String,
          false,
        ),
        sensorType: deserializeParam(
          data['sensorType'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ReadingsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ReadingsStruct &&
        timestamp == other.timestamp &&
        value == other.value &&
        sensorId == other.sensorId &&
        sensorType == other.sensorType;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([timestamp, value, sensorId, sensorType]);
}

ReadingsStruct createReadingsStruct({
  DateTime? timestamp,
  double? value,
  String? sensorId,
  String? sensorType,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    ReadingsStruct(
      timestamp: timestamp,
      value: value,
      sensorId: sensorId,
      sensorType: sensorType,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

ReadingsStruct? updateReadingsStruct(
  ReadingsStruct? readings, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    readings
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addReadingsStructData(
  Map<String, dynamic> firestoreData,
  ReadingsStruct? readings,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (readings == null) {
    return;
  }
  if (readings.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && readings.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final readingsData = getReadingsFirestoreData(readings, forFieldValue);
  final nestedData = readingsData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = readings.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getReadingsFirestoreData(
  ReadingsStruct? readings, [
  bool forFieldValue = false,
]) {
  if (readings == null) {
    return {};
  }
  final firestoreData = mapToFirestore(readings.toMap());

  // Add any Firestore field values
  readings.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getReadingsListFirestoreData(
  List<ReadingsStruct>? readingss,
) =>
    readingss?.map((e) => getReadingsFirestoreData(e, true)).toList() ?? [];
