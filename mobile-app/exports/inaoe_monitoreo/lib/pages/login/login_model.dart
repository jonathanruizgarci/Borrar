import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'login_widget.dart' show LoginWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginModel extends FlutterFlowModel<LoginWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for email-tf widget.
  FocusNode? emailTfFocusNode;
  TextEditingController? emailTfTextController;
  String? Function(BuildContext, String?)? emailTfTextControllerValidator;
  // State field(s) for pass-tf widget.
  FocusNode? passTfFocusNode;
  TextEditingController? passTfTextController;
  late bool passTfVisibility;
  String? Function(BuildContext, String?)? passTfTextControllerValidator;

  @override
  void initState(BuildContext context) {
    passTfVisibility = false;
  }

  @override
  void dispose() {
    emailTfFocusNode?.dispose();
    emailTfTextController?.dispose();

    passTfFocusNode?.dispose();
    passTfTextController?.dispose();
  }
}
