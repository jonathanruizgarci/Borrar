// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SupabaseReadStruct extends FFFirebaseStruct {
  SupabaseReadStruct({
    String? id,
    String? sensorId,
    DateTime? timestamp,
    String? data,
    int? qualityScore,
    int? transmissionDelayMs,
    String? raspberryPiId,
    DateTime? createdAt,
    String? sensorSerialNumber,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _id = id,
        _sensorId = sensorId,
        _timestamp = timestamp,
        _data = data,
        _qualityScore = qualityScore,
        _transmissionDelayMs = transmissionDelayMs,
        _raspberryPiId = raspberryPiId,
        _createdAt = createdAt,
        _sensorSerialNumber = sensorSerialNumber,
        super(firestoreUtilData);

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "sensor_id" field.
  String? _sensorId;
  String get sensorId => _sensorId ?? '';
  set sensorId(String? val) => _sensorId = val;

  bool hasSensorId() => _sensorId != null;

  // "timestamp" field.
  DateTime? _timestamp;
  DateTime? get timestamp => _timestamp;
  set timestamp(DateTime? val) => _timestamp = val;

  bool hasTimestamp() => _timestamp != null;

  // "data" field.
  String? _data;
  String get data => _data ?? '';
  set data(String? val) => _data = val;

  bool hasData() => _data != null;

  // "quality_score" field.
  int? _qualityScore;
  int get qualityScore => _qualityScore ?? 0;
  set qualityScore(int? val) => _qualityScore = val;

  void incrementQualityScore(int amount) =>
      qualityScore = qualityScore + amount;

  bool hasQualityScore() => _qualityScore != null;

  // "transmission_delay_ms" field.
  int? _transmissionDelayMs;
  int get transmissionDelayMs => _transmissionDelayMs ?? 0;
  set transmissionDelayMs(int? val) => _transmissionDelayMs = val;

  void incrementTransmissionDelayMs(int amount) =>
      transmissionDelayMs = transmissionDelayMs + amount;

  bool hasTransmissionDelayMs() => _transmissionDelayMs != null;

  // "raspberry_pi_id" field.
  String? _raspberryPiId;
  String get raspberryPiId => _raspberryPiId ?? '';
  set raspberryPiId(String? val) => _raspberryPiId = val;

  bool hasRaspberryPiId() => _raspberryPiId != null;

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  set createdAt(DateTime? val) => _createdAt = val;

  bool hasCreatedAt() => _createdAt != null;

  // "sensor_serial_number" field.
  String? _sensorSerialNumber;
  String get sensorSerialNumber => _sensorSerialNumber ?? '';
  set sensorSerialNumber(String? val) => _sensorSerialNumber = val;

  bool hasSensorSerialNumber() => _sensorSerialNumber != null;

  static SupabaseReadStruct fromMap(Map<String, dynamic> data) =>
      SupabaseReadStruct(
        id: data['id'] as String?,
        sensorId: data['sensor_id'] as String?,
        timestamp: data['timestamp'] as DateTime?,
        data: data['data'] as String?,
        qualityScore: castToType<int>(data['quality_score']),
        transmissionDelayMs: castToType<int>(data['transmission_delay_ms']),
        raspberryPiId: data['raspberry_pi_id'] as String?,
        createdAt: data['created_at'] as DateTime?,
        sensorSerialNumber: data['sensor_serial_number'] as String?,
      );

  static SupabaseReadStruct? maybeFromMap(dynamic data) => data is Map
      ? SupabaseReadStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'sensor_id': _sensorId,
        'timestamp': _timestamp,
        'data': _data,
        'quality_score': _qualityScore,
        'transmission_delay_ms': _transmissionDelayMs,
        'raspberry_pi_id': _raspberryPiId,
        'created_at': _createdAt,
        'sensor_serial_number': _sensorSerialNumber,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'sensor_id': serializeParam(
          _sensorId,
          ParamType.String,
        ),
        'timestamp': serializeParam(
          _timestamp,
          ParamType.DateTime,
        ),
        'data': serializeParam(
          _data,
          ParamType.String,
        ),
        'quality_score': serializeParam(
          _qualityScore,
          ParamType.int,
        ),
        'transmission_delay_ms': serializeParam(
          _transmissionDelayMs,
          ParamType.int,
        ),
        'raspberry_pi_id': serializeParam(
          _raspberryPiId,
          ParamType.String,
        ),
        'created_at': serializeParam(
          _createdAt,
          ParamType.DateTime,
        ),
        'sensor_serial_number': serializeParam(
          _sensorSerialNumber,
          ParamType.String,
        ),
      }.withoutNulls;

  static SupabaseReadStruct fromSerializableMap(Map<String, dynamic> data) =>
      SupabaseReadStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        sensorId: deserializeParam(
          data['sensor_id'],
          ParamType.String,
          false,
        ),
        timestamp: deserializeParam(
          data['timestamp'],
          ParamType.DateTime,
          false,
        ),
        data: deserializeParam(
          data['data'],
          ParamType.String,
          false,
        ),
        qualityScore: deserializeParam(
          data['quality_score'],
          ParamType.int,
          false,
        ),
        transmissionDelayMs: deserializeParam(
          data['transmission_delay_ms'],
          ParamType.int,
          false,
        ),
        raspberryPiId: deserializeParam(
          data['raspberry_pi_id'],
          ParamType.String,
          false,
        ),
        createdAt: deserializeParam(
          data['created_at'],
          ParamType.DateTime,
          false,
        ),
        sensorSerialNumber: deserializeParam(
          data['sensor_serial_number'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'SupabaseReadStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is SupabaseReadStruct &&
        id == other.id &&
        sensorId == other.sensorId &&
        timestamp == other.timestamp &&
        data == other.data &&
        qualityScore == other.qualityScore &&
        transmissionDelayMs == other.transmissionDelayMs &&
        raspberryPiId == other.raspberryPiId &&
        createdAt == other.createdAt &&
        sensorSerialNumber == other.sensorSerialNumber;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        sensorId,
        timestamp,
        data,
        qualityScore,
        transmissionDelayMs,
        raspberryPiId,
        createdAt,
        sensorSerialNumber
      ]);
}

SupabaseReadStruct createSupabaseReadStruct({
  String? id,
  String? sensorId,
  DateTime? timestamp,
  String? data,
  int? qualityScore,
  int? transmissionDelayMs,
  String? raspberryPiId,
  DateTime? createdAt,
  String? sensorSerialNumber,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    SupabaseReadStruct(
      id: id,
      sensorId: sensorId,
      timestamp: timestamp,
      data: data,
      qualityScore: qualityScore,
      transmissionDelayMs: transmissionDelayMs,
      raspberryPiId: raspberryPiId,
      createdAt: createdAt,
      sensorSerialNumber: sensorSerialNumber,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

SupabaseReadStruct? updateSupabaseReadStruct(
  SupabaseReadStruct? supabaseRead, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    supabaseRead
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addSupabaseReadStructData(
  Map<String, dynamic> firestoreData,
  SupabaseReadStruct? supabaseRead,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (supabaseRead == null) {
    return;
  }
  if (supabaseRead.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && supabaseRead.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final supabaseReadData =
      getSupabaseReadFirestoreData(supabaseRead, forFieldValue);
  final nestedData =
      supabaseReadData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = supabaseRead.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getSupabaseReadFirestoreData(
  SupabaseReadStruct? supabaseRead, [
  bool forFieldValue = false,
]) {
  if (supabaseRead == null) {
    return {};
  }
  final firestoreData = mapToFirestore(supabaseRead.toMap());

  // Add any Firestore field values
  supabaseRead.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getSupabaseReadListFirestoreData(
  List<SupabaseReadStruct>? supabaseReads,
) =>
    supabaseReads?.map((e) => getSupabaseReadFirestoreData(e, true)).toList() ??
    [];
