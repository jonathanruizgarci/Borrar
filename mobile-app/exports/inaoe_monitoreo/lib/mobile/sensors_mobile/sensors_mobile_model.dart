import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/mobile/navbar/navbar_widget.dart';
import 'dart:ui';
import 'sensors_mobile_widget.dart' show SensorsMobileWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SensorsMobileModel extends FlutterFlowModel<SensorsMobileWidget> {
  ///  Local state fields for this page.

  dynamic jsonfull;

  DateTime? refdate;

  DataRecord? dataretrieved;

  List<String> listofsensors = [];
  void addToListofsensors(String item) => listofsensors.add(item);
  void removeFromListofsensors(String item) => listofsensors.remove(item);
  void removeAtIndexFromListofsensors(int index) =>
      listofsensors.removeAt(index);
  void insertAtIndexInListofsensors(int index, String item) =>
      listofsensors.insert(index, item);
  void updateListofsensorsAtIndex(int index, Function(String) updateFn) =>
      listofsensors[index] = updateFn(listofsensors[index]);

  List<SensorjsonStruct> specificdata = [];
  void addToSpecificdata(SensorjsonStruct item) => specificdata.add(item);
  void removeFromSpecificdata(SensorjsonStruct item) =>
      specificdata.remove(item);
  void removeAtIndexFromSpecificdata(int index) => specificdata.removeAt(index);
  void insertAtIndexInSpecificdata(int index, SensorjsonStruct item) =>
      specificdata.insert(index, item);
  void updateSpecificdataAtIndex(
          int index, Function(SensorjsonStruct) updateFn) =>
      specificdata[index] = updateFn(specificdata[index]);

  dynamic jsonfilters;

  List<String> activetypes = ['temperature'];
  void addToActivetypes(String item) => activetypes.add(item);
  void removeFromActivetypes(String item) => activetypes.remove(item);
  void removeAtIndexFromActivetypes(int index) => activetypes.removeAt(index);
  void insertAtIndexInActivetypes(int index, String item) =>
      activetypes.insert(index, item);
  void updateActivetypesAtIndex(int index, Function(String) updateFn) =>
      activetypes[index] = updateFn(activetypes[index]);

  bool loading = true;

  List<SensorjsonStruct> chartinfo = [];
  void addToChartinfo(SensorjsonStruct item) => chartinfo.add(item);
  void removeFromChartinfo(SensorjsonStruct item) => chartinfo.remove(item);
  void removeAtIndexFromChartinfo(int index) => chartinfo.removeAt(index);
  void insertAtIndexInChartinfo(int index, SensorjsonStruct item) =>
      chartinfo.insert(index, item);
  void updateChartinfoAtIndex(int index, Function(SensorjsonStruct) updateFn) =>
      chartinfo[index] = updateFn(chartinfo[index]);

  List<DataRecord> dataretrievedmonth = [];
  void addToDataretrievedmonth(DataRecord item) => dataretrievedmonth.add(item);
  void removeFromDataretrievedmonth(DataRecord item) =>
      dataretrievedmonth.remove(item);
  void removeAtIndexFromDataretrievedmonth(int index) =>
      dataretrievedmonth.removeAt(index);
  void insertAtIndexInDataretrievedmonth(int index, DataRecord item) =>
      dataretrievedmonth.insert(index, item);
  void updateDataretrievedmonthAtIndex(
          int index, Function(DataRecord) updateFn) =>
      dataretrievedmonth[index] = updateFn(dataretrievedmonth[index]);

  String? html;

  List<SupabaseReadStruct> supabasedata = [];
  void addToSupabasedata(SupabaseReadStruct item) => supabasedata.add(item);
  void removeFromSupabasedata(SupabaseReadStruct item) =>
      supabasedata.remove(item);
  void removeAtIndexFromSupabasedata(int index) => supabasedata.removeAt(index);
  void insertAtIndexInSupabasedata(int index, SupabaseReadStruct item) =>
      supabasedata.insert(index, item);
  void updateSupabasedataAtIndex(
          int index, Function(SupabaseReadStruct) updateFn) =>
      supabasedata[index] = updateFn(supabasedata[index]);

  ///  State fields for stateful widgets in this page.

  // Model for navbar component.
  late NavbarModel navbarModel;

  @override
  void initState(BuildContext context) {
    navbarModel = createModel(context, () => NavbarModel());
  }

  @override
  void dispose() {
    navbarModel.dispose();
  }
}
