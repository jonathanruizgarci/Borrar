import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/mobile/navbaritem/navbaritem_widget.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'navbar_model.dart';
export 'navbar_model.dart';

class NavbarWidget extends StatefulWidget {
  const NavbarWidget({
    super.key,
    required this.active,
  });

  final String? active;

  @override
  State<NavbarWidget> createState() => _NavbarWidgetState();
}

class _NavbarWidgetState extends State<NavbarWidget> {
  late NavbarModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NavbarModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              context.pushNamed(HomeMobileWidget.routeName);
            },
            child: wrapWithModel(
              model: _model.navbaritemModel1,
              updateCallback: () => safeSetState(() {}),
              child: NavbaritemWidget(
                icon: Icon(
                  Icons.space_dashboard_rounded,
                  color: widget!.active == 'dashboard'
                      ? FlutterFlowTheme.of(context).primary
                      : FlutterFlowTheme.of(context).secondaryText,
                  size: 20.0,
                ),
                label: 'Dashboard',
                tag: 'dashboard',
                active: widget!.active!,
              ),
            ),
          ),
          InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              context.pushNamed(SensorsMobileWidget.routeName);
            },
            child: wrapWithModel(
              model: _model.navbaritemModel2,
              updateCallback: () => safeSetState(() {}),
              child: NavbaritemWidget(
                icon: Icon(
                  Icons.sensors_sharp,
                  color: widget!.active == 'sensors'
                      ? FlutterFlowTheme.of(context).primary
                      : FlutterFlowTheme.of(context).secondaryText,
                  size: 20.0,
                ),
                label: 'Sensores',
                tag: 'sensors',
                active: widget!.active!,
              ),
            ),
          ),
          InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              context.pushNamed(SystemMobileWidget.routeName);
            },
            child: wrapWithModel(
              model: _model.navbaritemModel3,
              updateCallback: () => safeSetState(() {}),
              child: NavbaritemWidget(
                icon: Icon(
                  Icons.computer,
                  color: widget!.active == 'system'
                      ? FlutterFlowTheme.of(context).primary
                      : FlutterFlowTheme.of(context).secondaryText,
                  size: 20.0,
                ),
                label: 'Sistema',
                tag: 'system',
                active: widget!.active!,
              ),
            ),
          ),
          InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              context.pushNamed(SettingsMobileWidget.routeName);
            },
            child: wrapWithModel(
              model: _model.navbaritemModel4,
              updateCallback: () => safeSetState(() {}),
              child: NavbaritemWidget(
                icon: Icon(
                  Icons.settings_sharp,
                  color: widget!.active == 'settings'
                      ? FlutterFlowTheme.of(context).primary
                      : FlutterFlowTheme.of(context).secondaryText,
                  size: 20.0,
                ),
                label: 'Ajustes',
                tag: 'settings',
                active: widget!.active!,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
