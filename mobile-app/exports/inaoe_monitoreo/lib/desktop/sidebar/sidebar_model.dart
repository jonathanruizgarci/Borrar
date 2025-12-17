import '/auth/firebase_auth/auth_util.dart';
import '/desktop/sidebar_item/sidebar_item_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'sidebar_widget.dart' show SidebarWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SidebarModel extends FlutterFlowModel<SidebarWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for sidebar_item component.
  late SidebarItemModel sidebarItemModel1;
  // Model for sidebar_item component.
  late SidebarItemModel sidebarItemModel2;
  // Model for sidebar_item component.
  late SidebarItemModel sidebarItemModel3;
  // State field(s) for darkmode widget.
  bool? darkmodeValue;

  @override
  void initState(BuildContext context) {
    sidebarItemModel1 = createModel(context, () => SidebarItemModel());
    sidebarItemModel2 = createModel(context, () => SidebarItemModel());
    sidebarItemModel3 = createModel(context, () => SidebarItemModel());
  }

  @override
  void dispose() {
    sidebarItemModel1.dispose();
    sidebarItemModel2.dispose();
    sidebarItemModel3.dispose();
  }
}
