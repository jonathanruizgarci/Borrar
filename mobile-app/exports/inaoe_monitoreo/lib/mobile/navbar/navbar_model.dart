import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/mobile/navbaritem/navbaritem_widget.dart';
import 'dart:ui';
import '/index.dart';
import 'navbar_widget.dart' show NavbarWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NavbarModel extends FlutterFlowModel<NavbarWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for navbaritem component.
  late NavbaritemModel navbaritemModel1;
  // Model for navbaritem component.
  late NavbaritemModel navbaritemModel2;
  // Model for navbaritem component.
  late NavbaritemModel navbaritemModel3;
  // Model for navbaritem component.
  late NavbaritemModel navbaritemModel4;

  @override
  void initState(BuildContext context) {
    navbaritemModel1 = createModel(context, () => NavbaritemModel());
    navbaritemModel2 = createModel(context, () => NavbaritemModel());
    navbaritemModel3 = createModel(context, () => NavbaritemModel());
    navbaritemModel4 = createModel(context, () => NavbaritemModel());
  }

  @override
  void dispose() {
    navbaritemModel1.dispose();
    navbaritemModel2.dispose();
    navbaritemModel3.dispose();
    navbaritemModel4.dispose();
  }
}
