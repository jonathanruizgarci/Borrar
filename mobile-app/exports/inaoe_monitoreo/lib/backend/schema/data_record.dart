import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DataRecord extends FirestoreRecord {
  DataRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "date" field.
  DateTime? _date;
  DateTime? get date => _date;
  bool hasDate() => _date != null;

  // "readings" field.
  List<ReadingsStruct>? _readings;
  List<ReadingsStruct> get readings => _readings ?? const [];
  bool hasReadings() => _readings != null;

  void _initializeFields() {
    _date = snapshotData['date'] as DateTime?;
    _readings = getStructList(
      snapshotData['readings'],
      ReadingsStruct.fromMap,
    );
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('data');

  static Stream<DataRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => DataRecord.fromSnapshot(s));

  static Future<DataRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => DataRecord.fromSnapshot(s));

  static DataRecord fromSnapshot(DocumentSnapshot snapshot) => DataRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static DataRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      DataRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'DataRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is DataRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createDataRecordData({
  DateTime? date,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'date': date,
    }.withoutNulls,
  );

  return firestoreData;
}

class DataRecordDocumentEquality implements Equality<DataRecord> {
  const DataRecordDocumentEquality();

  @override
  bool equals(DataRecord? e1, DataRecord? e2) {
    const listEquality = ListEquality();
    return e1?.date == e2?.date &&
        listEquality.equals(e1?.readings, e2?.readings);
  }

  @override
  int hash(DataRecord? e) => const ListEquality().hash([e?.date, e?.readings]);

  @override
  bool isValidKey(Object? o) => o is DataRecord;
}
