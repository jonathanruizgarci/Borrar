import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'navbaritem_model.dart';
export 'navbaritem_model.dart';

class NavbaritemWidget extends StatefulWidget {
  const NavbaritemWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.tag,
    required this.active,
  });

  final Widget? icon;
  final String? label;
  final String? tag;
  final String? active;

  @override
  State<NavbaritemWidget> createState() => _NavbaritemWidgetState();
}

class _NavbaritemWidgetState extends State<NavbaritemWidget> {
  late NavbaritemModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NavbaritemModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        widget!.icon!,
        Text(
          valueOrDefault<String>(
            widget!.label,
            'Dashboard',
          ),
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.inter(
                  fontWeight:
                      FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                ),
                color: widget!.active == widget!.tag
                    ? FlutterFlowTheme.of(context).primary
                    : FlutterFlowTheme.of(context).secondaryText,
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
        ),
      ].divide(SizedBox(height: 4.0)),
    );
  }
}
