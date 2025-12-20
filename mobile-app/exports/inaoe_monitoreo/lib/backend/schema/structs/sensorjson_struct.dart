// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SensorjsonStruct extends FFFirebaseStruct {
  SensorjsonStruct({
    String? sensorId,
    List<String>? xLabels,
    List<double>? values,
    double? average,
    double? min,
    double? max,
    String? sensorType,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _sensorId = sensorId,
        _xLabels = xLabels,
        _values = values,
        _average = average,
        _min = min,
        _max = max,
        _sensorType = sensorType,
        super(firestoreUtilData);

  // "sensorId" field.
  String? _sensorId;
  String get sensorId => _sensorId ?? '';
  set sensorId(String? val) => _sensorId = val;

  bool hasSensorId() => _sensorId != null;

  // "xLabels" field.
  List<String>? _xLabels;
  List<String> get xLabels => _xLabels ?? const [];
  set xLabels(List<String>? val) => _xLabels = val;

  void updateXLabels(Function(List<String>) updateFn) {
    updateFn(_xLabels ??= []);
  }

  bool hasXLabels() => _xLabels != null;

  // "values" field.
  List<double>? _values;
  List<double> get values => _values ?? const [];
  set values(List<double>? val) => _values = val;

  void updateValues(Function(List<double>) updateFn) {
    updateFn(_values ??= []);
  }

  bool hasValues() => _values != null;

  // "average" field.
  double? _average;
  double get average => _average ?? 0.0;
  set average(double? val) => _average = val;

  void incrementAverage(double amount) => average = average + amount;

  bool hasAverage() => _average != null;

  // "min" field.
  double? _min;
  double get min => _min ?? 0.0;
  set min(double? val) => _min = val;

  void incrementMin(double amount) => min = min + amount;

  bool hasMin() => _min != null;

  // "max" field.
  double? _max;
  double get max => _max ?? 0.0;
  set max(double? val) => _max = val;

  void incrementMax(double amount) => max = max + amount;

  bool hasMax() => _max != null;

  // "sensorType" field.
  String? _sensorType;
  String get sensorType => _sensorType ?? '';
  set sensorType(String? val) => _sensorType = val;

  bool hasSensorType() => _sensorType != null;

  static SensorjsonStruct fromMap(Map<String, dynamic> data) =>
      SensorjsonStruct(
        sensorId: data['sensorId'] as String?,
        xLabels: getDataList(data['xLabels']),
        values: getDataList(data['values']),
        average: castToType<double>(data['average']),
        min: castToType<double>(data['min']),
        max: castToType<double>(data['max']),
        sensorType: data['sensorType'] as String?,
      );

  static SensorjsonStruct? maybeFromMap(dynamic data) => data is Map
      ? SensorjsonStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'sensorId': _sensorId,
        'xLabels': _xLabels,
        'values': _values,
        'average': _average,
        'min': _min,
        'max': _max,
        'sensorType': _sensorType,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'sensorId': serializeParam(
          _sensorId,
          ParamType.String,
        ),
        'xLabels': serializeParam(
          _xLabels,
          ParamType.String,
          isList: true,
        ),
        'values': serializeParam(
          _values,
          ParamType.double,
          isList: true,
        ),
        'average': serializeParam(
          _average,
          ParamType.double,
        ),
        'min': serializeParam(
          _min,
          ParamType.double,
        ),
        'max': serializeParam(
          _max,
          ParamType.double,
        ),
        'sensorType': serializeParam(
          _sensorType,
          ParamType.String,
        ),
      }.withoutNulls;

  static SensorjsonStruct fromSerializableMap(Map<String, dynamic> data) =>
      SensorjsonStruct(
        sensorId: deserializeParam(
          data['sensorId'],
          ParamType.String,
          false,
        ),
        xLabels: deserializeParam<String>(
          data['xLabels'],
          ParamType.String,
          true,
        ),
        values: deserializeParam<double>(
          data['values'],
          ParamType.double,
          true,
        ),
        average: deserializeParam(
          data['average'],
          ParamType.double,
          false,
        ),
        min: deserializeParam(
          data['min'],
          ParamType.double,
          false,
        ),
        max: deserializeParam(
          data['max'],
          ParamType.double,
          false,
        ),
        sensorType: deserializeParam(
          data['sensorType'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'SensorjsonStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is SensorjsonStruct &&
        sensorId == other.sensorId &&
        listEquality.equals(xLabels, other.xLabels) &&
        listEquality.equals(values, other.values) &&
        average == other.average &&
        min == other.min &&
        max == other.max &&
        sensorType == other.sensorType;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([sensorId, xLabels, values, average, min, max, sensorType]);
}

SensorjsonStruct createSensorjsonStruct({
  String? sensorId,
  double? average,
  double? min,
  double? max,
  String? sensorType,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    SensorjsonStruct(
      sensorId: sensorId,
      average: average,
      min: min,
      max: max,
      sensorType: sensorType,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

SensorjsonStruct? updateSensorjsonStruct(
  SensorjsonStruct? sensorjson, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    sensorjson
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addSensorjsonStructData(
  Map<String, dynamic> firestoreData,
  SensorjsonStruct? sensorjson,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (sensorjson == null) {
    return;
  }
  if (sensorjson.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && sensorjson.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final sensorjsonData = getSensorjsonFirestoreData(sensorjson, forFieldValue);
  final nestedData = sensorjsonData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = sensorjson.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getSensorjsonFirestoreData(
  SensorjsonStruct? sensorjson, [
  bool forFieldValue = false,
]) {
  if (sensorjson == null) {
    return {};
  }
  final firestoreData = mapToFirestore(sensorjson.toMap());

  // Add any Firestore field values
  sensorjson.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getSensorjsonListFirestoreData(
  List<SensorjsonStruct>? sensorjsons,
) =>
    sensorjsons?.map((e) => getSensorjsonFirestoreData(e, true)).toList() ?? [];
