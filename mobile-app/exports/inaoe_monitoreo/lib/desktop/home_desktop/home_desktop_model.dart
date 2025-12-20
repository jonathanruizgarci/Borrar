import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/desktop/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_web_view.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:math';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'home_desktop_widget.dart' show HomeDesktopWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeDesktopModel extends FlutterFlowModel<HomeDesktopWidget> {
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

  // Stores action output result for [Backend Call - Query Rows] action in home-desktop widget.
  List<SensorReadingsRow>? allSensors;
  // Model for sidebar component.
  late SidebarModel sidebarModel;
  // State field(s) for reference_period widget.
  FormFieldController<List<String>>? referencePeriodValueController;
  String? get referencePeriodValue =>
      referencePeriodValueController?.value?.firstOrNull;
  set referencePeriodValue(String? val) =>
      referencePeriodValueController?.value = val != null ? [val] : [];
  // Stores action output result for [Firestore Query - Query a collection] action in reference_period widget.
  List<DataRecord>? chipchoiceData;
  // Stores action output result for [Backend Call - Query Rows] action in reference_period widget.
  List<SensorReadingsRow>? allSensorsDayChch;
  // Stores action output result for [Backend Call - Query Rows] action in reference_period widget.
  List<SensorReadingsRow>? allSensorMonthChch;
  // State field(s) for group_sensors widget.
  bool? groupSensorsValue;
  // Stores action output result for [Backend Call - Query Rows] action in Icon widget.
  List<SensorReadingsRow>? allSensorsDay;
  // Stores action output result for [Backend Call - Query Rows] action in Icon widget.
  List<SensorReadingsRow>? allSensorMonth;
  // Stores action output result for [Backend Call - Query Rows] action in Icon widget.
  List<SensorReadingsRow>? allSensorsDayNext;
  // Stores action output result for [Backend Call - Query Rows] action in Icon widget.
  List<SensorReadingsRow>? allSensorMonthNext;

  @override
  void initState(BuildContext context) {
    sidebarModel = createModel(context, () => SidebarModel());
  }

  @override
  void dispose() {
    sidebarModel.dispose();
  }
}
