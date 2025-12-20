import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'create_account_widget.dart' show CreateAccountWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CreateAccountModel extends FlutterFlowModel<CreateAccountWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for email-tf widget.
  FocusNode? emailTfFocusNode;
  TextEditingController? emailTfTextController;
  String? Function(BuildContext, String?)? emailTfTextControllerValidator;
  // State field(s) for name-tf widget.
  FocusNode? nameTfFocusNode;
  TextEditingController? nameTfTextController;
  String? Function(BuildContext, String?)? nameTfTextControllerValidator;
  // State field(s) for last-tf widget.
  FocusNode? lastTfFocusNode;
  TextEditingController? lastTfTextController;
  String? Function(BuildContext, String?)? lastTfTextControllerValidator;
  // State field(s) for pass-tf widget.
  FocusNode? passTfFocusNode;
  TextEditingController? passTfTextController;
  late bool passTfVisibility;
  String? Function(BuildContext, String?)? passTfTextControllerValidator;
  // State field(s) for confirmpass-tf widget.
  FocusNode? confirmpassTfFocusNode;
  TextEditingController? confirmpassTfTextController;
  late bool confirmpassTfVisibility;
  String? Function(BuildContext, String?)? confirmpassTfTextControllerValidator;

  @override
  void initState(BuildContext context) {
    passTfVisibility = false;
    confirmpassTfVisibility = false;
  }

  @override
  void dispose() {
    emailTfFocusNode?.dispose();
    emailTfTextController?.dispose();

    nameTfFocusNode?.dispose();
    nameTfTextController?.dispose();

    lastTfFocusNode?.dispose();
    lastTfTextController?.dispose();

    passTfFocusNode?.dispose();
    passTfTextController?.dispose();

    confirmpassTfFocusNode?.dispose();
    confirmpassTfTextController?.dispose();
  }
}
