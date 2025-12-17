import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_web_view.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/mobile/navbar/navbar_widget.dart';
import 'dart:math';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'home_mobile_model.dart';
export 'home_mobile_model.dart';

class HomeMobileWidget extends StatefulWidget {
  const HomeMobileWidget({super.key});

  static String routeName = 'home-mobile';
  static String routePath = '/homeMobile';

  @override
  State<HomeMobileWidget> createState() => _HomeMobileWidgetState();
}

class _HomeMobileWidgetState extends State<HomeMobileWidget>
    with TickerProviderStateMixin {
  late HomeMobileModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeMobileModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (MediaQuery.sizeOf(context).width > kBreakpointSmall) {
        context.pushNamed(HomeDesktopWidget.routeName);
      }
      _model.loading = true;
      _model.supabasedata = [];
      safeSetState(() {});
      FFAppState().refperiod = 'day';
      safeSetState(() {});
      _model.allSensorsMobile = await SensorReadingsTable().queryRows(
        queryFn: (q) => q
            .gtOrNull(
              'timestamp',
              supaSerialize<DateTime>(functions
                  .startandendofdaytime(getCurrentTimestamp, 'day')
                  ?.start),
            )
            .lteOrNull(
              'timestamp',
              supaSerialize<DateTime>(functions
                  .startandendofdaytime(getCurrentTimestamp, 'day')
                  ?.end),
            ),
      );
      for (int loop1Index = 0;
          loop1Index < _model.allSensorsMobile!.length;
          loop1Index++) {
        final currentLoop1Item = _model.allSensorsMobile![loop1Index];
        _model.addToSupabasedata(SupabaseReadStruct(
          id: currentLoop1Item.id,
          sensorId: currentLoop1Item.sensorId,
          timestamp: currentLoop1Item.timestamp,
          data: currentLoop1Item.dataField.toString(),
          qualityScore: currentLoop1Item.qualityScore,
          transmissionDelayMs: currentLoop1Item.transmissionDelayMs,
          raspberryPiId: currentLoop1Item.raspberryPiId,
          createdAt: currentLoop1Item.createdAt,
          sensorSerialNumber: currentLoop1Item.sensorSerialNumber,
        ));
        safeSetState(() {});
      }
      _model.html = functions.buildHTMLfromSupabase(
          _model.supabasedata.toList(),
          getCurrentTimestamp,
          'daily',
          Theme.of(context).brightness == Brightness.dark
              ? '#1a1a1a'
              : '#ffffff',
          Theme.of(context).brightness == Brightness.dark
              ? '#101010'
              : '#f7faf9',
          Theme.of(context).brightness == Brightness.dark
              ? '#93e5c1'
              : '#2e8b57',
          Theme.of(context).brightness == Brightness.dark
              ? '#f1f1f1'
              : '#1b1b1b',
          !_model.groupSensorsValue!);
      safeSetState(() {});
      _model.refdate = getCurrentTimestamp;
      safeSetState(() {});
      _model.loading = false;
      safeSetState(() {});
    });

    _model.groupSensorsValue = true;
    animationsMap.addAll({
      'containerOnPageLoadAnimation1': AnimationInfo(
        loop: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ShimmerEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            color: Color(0x80FFFFFF),
            angle: 0.524,
          ),
        ],
      ),
      'containerOnPageLoadAnimation2': AnimationInfo(
        loop: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ShimmerEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            color: Color(0x80FFFFFF),
            angle: 0.524,
          ),
        ],
      ),
      'containerOnPageLoadAnimation3': AnimationInfo(
        loop: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ShimmerEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            color: Color(0x80FFFFFF),
            angle: 0.524,
          ),
        ],
      ),
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Container(
                    height: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          height: 100.0,
                          decoration: BoxDecoration(),
                          child: Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  24.0, 0.0, 24.0, 0.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          FlutterFlowChoiceChips(
                                            options: [
                                              ChipData('Diario'),
                                              ChipData('Mensual')
                                            ],
                                            onChanged: (val) async {
                                              safeSetState(() =>
                                                  _model.referencePeriodValue =
                                                      val?.firstOrNull);
                                              FFAppState().refperiod = () {
                                                if (_model
                                                        .referencePeriodValue ==
                                                    'Diario') {
                                                  return 'day';
                                                } else if (_model
                                                        .referencePeriodValue ==
                                                    'Mensual') {
                                                  return 'month';
                                                } else {
                                                  return 'year';
                                                }
                                              }();
                                              safeSetState(() {});
                                              _model.loading = true;
                                              safeSetState(() {});
                                              if (FFAppState().refperiod ==
                                                  'day') {
                                                _model.allSensorsDayChchMobile =
                                                    await SensorReadingsTable()
                                                        .queryRows(
                                                  queryFn: (q) => q
                                                      .gtOrNull(
                                                        'timestamp',
                                                        supaSerialize<DateTime>(
                                                            functions
                                                                .startandendofdaytime(
                                                                    _model
                                                                        .refdate,
                                                                    'day')
                                                                ?.start),
                                                      )
                                                      .lteOrNull(
                                                        'timestamp',
                                                        supaSerialize<DateTime>(
                                                            functions
                                                                .startandendofdaytime(
                                                                    _model
                                                                        .refdate,
                                                                    'day')
                                                                ?.end),
                                                      ),
                                                );
                                                _model.supabasedata = [];
                                                safeSetState(() {});
                                                for (int loop1Index = 0;
                                                    loop1Index <
                                                        _model
                                                            .allSensorsDayChchMobile!
                                                            .length;
                                                    loop1Index++) {
                                                  final currentLoop1Item = _model
                                                          .allSensorsDayChchMobile![
                                                      loop1Index];
                                                  _model.addToSupabasedata(
                                                      SupabaseReadStruct(
                                                    id: currentLoop1Item.id,
                                                    sensorId: currentLoop1Item
                                                        .sensorId,
                                                    timestamp: currentLoop1Item
                                                        .timestamp,
                                                    data: currentLoop1Item
                                                        .dataField
                                                        .toString(),
                                                    qualityScore:
                                                        currentLoop1Item
                                                            .qualityScore,
                                                    transmissionDelayMs:
                                                        currentLoop1Item
                                                            .transmissionDelayMs,
                                                    raspberryPiId:
                                                        currentLoop1Item
                                                            .raspberryPiId,
                                                    createdAt: currentLoop1Item
                                                        .createdAt,
                                                    sensorSerialNumber:
                                                        currentLoop1Item
                                                            .sensorSerialNumber,
                                                  ));
                                                  safeSetState(() {});
                                                }
                                                _model.html = functions
                                                    .buildHTMLfromSupabase(
                                                        _model.supabasedata
                                                            .toList(),
                                                        _model.refdate!,
                                                        'daily',
                                                        Theme.of(context)
                                                                    .brightness ==
                                                                Brightness.dark
                                                            ? '#1a1a1a'
                                                            : '#ffffff',
                                                        Theme.of(context)
                                                                    .brightness ==
                                                                Brightness.dark
                                                            ? '#101010'
                                                            : '#f7faf9',
                                                        Theme.of(context)
                                                                    .brightness ==
                                                                Brightness.dark
                                                            ? '#93e5c1'
                                                            : '#2e8b57',
                                                        Theme.of(context)
                                                                    .brightness ==
                                                                Brightness.dark
                                                            ? '#f1f1f1'
                                                            : '#1b1b1b',
                                                        !_model
                                                            .groupSensorsValue!);
                                                safeSetState(() {});
                                                await Future.delayed(
                                                  Duration(
                                                    milliseconds: 300,
                                                  ),
                                                );
                                                _model.loading = false;
                                                safeSetState(() {});
                                              } else if (FFAppState()
                                                      .refperiod ==
                                                  'month') {
                                                _model.allSensorMonthChchMobile =
                                                    await SensorReadingsTable()
                                                        .queryRows(
                                                  queryFn: (q) => q
                                                      .gtOrNull(
                                                        'timestamp',
                                                        supaSerialize<DateTime>(
                                                            functions
                                                                .startandendofdaytime(
                                                                    _model
                                                                        .refdate,
                                                                    'month')
                                                                ?.start),
                                                      )
                                                      .lteOrNull(
                                                        'timestamp',
                                                        supaSerialize<DateTime>(
                                                            functions
                                                                .startandendofdaytime(
                                                                    _model
                                                                        .refdate,
                                                                    'month')
                                                                ?.end),
                                                      ),
                                                );
                                                _model.supabasedata = [];
                                                safeSetState(() {});
                                                for (int loop2Index = 0;
                                                    loop2Index <
                                                        _model
                                                            .allSensorMonthChchMobile!
                                                            .length;
                                                    loop2Index++) {
                                                  final currentLoop2Item = _model
                                                          .allSensorMonthChchMobile![
                                                      loop2Index];
                                                  _model.addToSupabasedata(
                                                      SupabaseReadStruct(
                                                    id: currentLoop2Item.id,
                                                    sensorId: currentLoop2Item
                                                        .sensorId,
                                                    timestamp: currentLoop2Item
                                                        .timestamp,
                                                    data: currentLoop2Item
                                                        .dataField
                                                        .toString(),
                                                    qualityScore:
                                                        currentLoop2Item
                                                            .qualityScore,
                                                    transmissionDelayMs:
                                                        currentLoop2Item
                                                            .transmissionDelayMs,
                                                    raspberryPiId:
                                                        currentLoop2Item
                                                            .raspberryPiId,
                                                    createdAt: currentLoop2Item
                                                        .createdAt,
                                                    sensorSerialNumber:
                                                        currentLoop2Item
                                                            .sensorSerialNumber,
                                                  ));
                                                  safeSetState(() {});
                                                }
                                                _model.html = functions
                                                    .buildHTMLfromSupabase(
                                                        _model.supabasedata
                                                            .toList(),
                                                        _model.refdate!,
                                                        'monthly',
                                                        Theme.of(context)
                                                                    .brightness ==
                                                                Brightness.dark
                                                            ? '#1a1a1a'
                                                            : '#ffffff',
                                                        Theme.of(context)
                                                                    .brightness ==
                                                                Brightness.dark
                                                            ? '#101010'
                                                            : '#f7faf9',
                                                        Theme.of(context)
                                                                    .brightness ==
                                                                Brightness.dark
                                                            ? '#93e5c1'
                                                            : '#2e8b57',
                                                        Theme.of(context)
                                                                    .brightness ==
                                                                Brightness.dark
                                                            ? '#f1f1f1'
                                                            : '#1b1b1b',
                                                        !_model
                                                            .groupSensorsValue!);
                                                safeSetState(() {});
                                                await Future.delayed(
                                                  Duration(
                                                    milliseconds: 300,
                                                  ),
                                                );
                                                _model.loading = false;
                                                safeSetState(() {});
                                              } else {
                                                _model.loading = false;
                                                safeSetState(() {});
                                              }

                                              safeSetState(() {});
                                            },
                                            selectedChipStyle: ChipStyle(
                                              backgroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              textStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts.inter(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .primaryBackground,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                              iconColor:
                                                  FlutterFlowTheme.of(context)
                                                      .info,
                                              iconSize: 16.0,
                                              elevation: 0.0,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            unselectedChipStyle: ChipStyle(
                                              backgroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              textStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts.inter(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                              iconColor:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              iconSize: 16.0,
                                              elevation: 0.0,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            chipSpacing: 8.0,
                                            rowSpacing: 8.0,
                                            multiselect: false,
                                            initialized:
                                                _model.referencePeriodValue !=
                                                    null,
                                            alignment: WrapAlignment.start,
                                            controller: _model
                                                    .referencePeriodValueController ??=
                                                FormFieldController<
                                                    List<String>>(
                                              ['Diario'],
                                            ),
                                            wrapped: true,
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 12.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                _model.loading = true;
                                                safeSetState(() {});
                                                if (FFAppState().refperiod ==
                                                    'day') {
                                                  _model.refdate =
                                                      functions.updatedate(
                                                          _model.refdate!,
                                                          -1,
                                                          'day');
                                                  safeSetState(() {});
                                                  _model.allSensorsDayMobile =
                                                      await SensorReadingsTable()
                                                          .queryRows(
                                                    queryFn: (q) => q
                                                        .gtOrNull(
                                                          'timestamp',
                                                          supaSerialize<
                                                                  DateTime>(
                                                              functions
                                                                  .startandendofdaytime(
                                                                      _model
                                                                          .refdate,
                                                                      'day')
                                                                  ?.start),
                                                        )
                                                        .lteOrNull(
                                                          'timestamp',
                                                          supaSerialize<
                                                                  DateTime>(
                                                              functions
                                                                  .startandendofdaytime(
                                                                      _model
                                                                          .refdate,
                                                                      'day')
                                                                  ?.end),
                                                        ),
                                                  );
                                                  _model.supabasedata = [];
                                                  safeSetState(() {});
                                                  for (int loop1Index = 0;
                                                      loop1Index <
                                                          _model
                                                              .allSensorsDayMobile!
                                                              .length;
                                                      loop1Index++) {
                                                    final currentLoop1Item =
                                                        _model.allSensorsDayMobile![
                                                            loop1Index];
                                                    _model.addToSupabasedata(
                                                        SupabaseReadStruct(
                                                      id: currentLoop1Item.id,
                                                      sensorId: currentLoop1Item
                                                          .sensorId,
                                                      timestamp:
                                                          currentLoop1Item
                                                              .timestamp,
                                                      data: currentLoop1Item
                                                          .dataField
                                                          .toString(),
                                                      qualityScore:
                                                          currentLoop1Item
                                                              .qualityScore,
                                                      transmissionDelayMs:
                                                          currentLoop1Item
                                                              .transmissionDelayMs,
                                                      raspberryPiId:
                                                          currentLoop1Item
                                                              .raspberryPiId,
                                                      createdAt:
                                                          currentLoop1Item
                                                              .createdAt,
                                                      sensorSerialNumber:
                                                          currentLoop1Item
                                                              .sensorSerialNumber,
                                                    ));
                                                    safeSetState(() {});
                                                  }
                                                  _model.html = functions.buildHTMLfromSupabase(
                                                      _model.supabasedata
                                                          .toList(),
                                                      _model.refdate!,
                                                      'daily',
                                                      Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? '#1a1a1a'
                                                          : '#ffffff',
                                                      Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? '#101010'
                                                          : '#f7faf9',
                                                      Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? '#93e5c1'
                                                          : '#2e8b57',
                                                      Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? '#f1f1f1'
                                                          : '#1b1b1b',
                                                      !_model
                                                          .groupSensorsValue!);
                                                  safeSetState(() {});
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 300,
                                                    ),
                                                  );
                                                } else if (FFAppState()
                                                        .refperiod ==
                                                    'month') {
                                                  _model.refdate =
                                                      functions.updatedate(
                                                          _model.refdate!,
                                                          -1,
                                                          'month');
                                                  safeSetState(() {});
                                                  _model.allSensorMonthMobile =
                                                      await SensorReadingsTable()
                                                          .queryRows(
                                                    queryFn: (q) => q
                                                        .gtOrNull(
                                                          'timestamp',
                                                          supaSerialize<
                                                                  DateTime>(
                                                              functions
                                                                  .startandendofdaytime(
                                                                      _model
                                                                          .refdate,
                                                                      'month')
                                                                  ?.start),
                                                        )
                                                        .lteOrNull(
                                                          'timestamp',
                                                          supaSerialize<
                                                                  DateTime>(
                                                              functions
                                                                  .startandendofdaytime(
                                                                      _model
                                                                          .refdate,
                                                                      'month')
                                                                  ?.end),
                                                        ),
                                                  );
                                                  _model.supabasedata = [];
                                                  safeSetState(() {});
                                                  for (int loop2Index = 0;
                                                      loop2Index <
                                                          _model
                                                              .allSensorMonthMobile!
                                                              .length;
                                                      loop2Index++) {
                                                    final currentLoop2Item =
                                                        _model.allSensorMonthMobile![
                                                            loop2Index];
                                                    _model.addToSupabasedata(
                                                        SupabaseReadStruct(
                                                      id: currentLoop2Item.id,
                                                      sensorId: currentLoop2Item
                                                          .sensorId,
                                                      timestamp:
                                                          currentLoop2Item
                                                              .timestamp,
                                                      data: currentLoop2Item
                                                          .dataField
                                                          .toString(),
                                                      qualityScore:
                                                          currentLoop2Item
                                                              .qualityScore,
                                                      transmissionDelayMs:
                                                          currentLoop2Item
                                                              .transmissionDelayMs,
                                                      raspberryPiId:
                                                          currentLoop2Item
                                                              .raspberryPiId,
                                                      createdAt:
                                                          currentLoop2Item
                                                              .createdAt,
                                                      sensorSerialNumber:
                                                          currentLoop2Item
                                                              .sensorSerialNumber,
                                                    ));
                                                    safeSetState(() {});
                                                  }
                                                  _model.html = functions.buildHTMLfromSupabase(
                                                      _model.supabasedata
                                                          .toList(),
                                                      _model.refdate!,
                                                      'monthly',
                                                      Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? '#1a1a1a'
                                                          : '#ffffff',
                                                      Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? '#101010'
                                                          : '#f7faf9',
                                                      Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? '#93e5c1'
                                                          : '#2e8b57',
                                                      Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? '#f1f1f1'
                                                          : '#1b1b1b',
                                                      !_model
                                                          .groupSensorsValue!);
                                                  safeSetState(() {});
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 300,
                                                    ),
                                                  );
                                                } else {
                                                  _model.refdate =
                                                      functions.updatedate(
                                                          _model.refdate!,
                                                          -1,
                                                          'year');
                                                  safeSetState(() {});
                                                }

                                                _model.loading = false;
                                                safeSetState(() {});

                                                safeSetState(() {});
                                              },
                                              child: Icon(
                                                Icons.arrow_back_ios,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                size: 24.0,
                                              ),
                                            ),
                                            Text(
                                              () {
                                                if (FFAppState().refperiod ==
                                                    'day') {
                                                  return dateTimeFormat(
                                                    "MMMd",
                                                    _model.refdate,
                                                    locale: FFLocalizations.of(
                                                            context)
                                                        .languageCode,
                                                  );
                                                } else if (FFAppState()
                                                        .refperiod ==
                                                    'month') {
                                                  return dateTimeFormat(
                                                    "MMM",
                                                    _model.refdate,
                                                    locale: FFLocalizations.of(
                                                            context)
                                                        .languageCode,
                                                  );
                                                } else {
                                                  return dateTimeFormat(
                                                    "y",
                                                    _model.refdate,
                                                    locale: FFLocalizations.of(
                                                            context)
                                                        .languageCode,
                                                  );
                                                }
                                              }(),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts.inter(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                            ),
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                _model.loading = true;
                                                safeSetState(() {});
                                                if (FFAppState().refperiod ==
                                                    'day') {
                                                  _model.refdate =
                                                      functions.updatedate(
                                                          _model.refdate!,
                                                          1,
                                                          'day');
                                                  safeSetState(() {});
                                                  _model.allSensorsDayNextMobile =
                                                      await SensorReadingsTable()
                                                          .queryRows(
                                                    queryFn: (q) => q
                                                        .gtOrNull(
                                                          'timestamp',
                                                          supaSerialize<
                                                                  DateTime>(
                                                              functions
                                                                  .startandendofdaytime(
                                                                      _model
                                                                          .refdate,
                                                                      'day')
                                                                  ?.start),
                                                        )
                                                        .lteOrNull(
                                                          'timestamp',
                                                          supaSerialize<
                                                                  DateTime>(
                                                              functions
                                                                  .startandendofdaytime(
                                                                      _model
                                                                          .refdate,
                                                                      'day')
                                                                  ?.end),
                                                        ),
                                                  );
                                                  _model.supabasedata = [];
                                                  safeSetState(() {});
                                                  for (int loop1Index = 0;
                                                      loop1Index <
                                                          _model
                                                              .allSensorsDayNextMobile!
                                                              .length;
                                                      loop1Index++) {
                                                    final currentLoop1Item =
                                                        _model.allSensorsDayNextMobile![
                                                            loop1Index];
                                                    _model.addToSupabasedata(
                                                        SupabaseReadStruct(
                                                      id: currentLoop1Item.id,
                                                      sensorId: currentLoop1Item
                                                          .sensorId,
                                                      timestamp:
                                                          currentLoop1Item
                                                              .timestamp,
                                                      data: currentLoop1Item
                                                          .dataField
                                                          .toString(),
                                                      qualityScore:
                                                          currentLoop1Item
                                                              .qualityScore,
                                                      transmissionDelayMs:
                                                          currentLoop1Item
                                                              .transmissionDelayMs,
                                                      raspberryPiId:
                                                          currentLoop1Item
                                                              .raspberryPiId,
                                                      createdAt:
                                                          currentLoop1Item
                                                              .createdAt,
                                                      sensorSerialNumber:
                                                          currentLoop1Item
                                                              .sensorSerialNumber,
                                                    ));
                                                    safeSetState(() {});
                                                  }
                                                  _model.html = functions.buildHTMLfromSupabase(
                                                      _model.supabasedata
                                                          .toList(),
                                                      _model.refdate!,
                                                      'daily',
                                                      Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? '#1a1a1a'
                                                          : '#ffffff',
                                                      Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? '#101010'
                                                          : '#f7faf9',
                                                      Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? '#93e5c1'
                                                          : '#2e8b57',
                                                      Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? '#f1f1f1'
                                                          : '#1b1b1b',
                                                      !_model
                                                          .groupSensorsValue!);
                                                  safeSetState(() {});
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 300,
                                                    ),
                                                  );
                                                } else if (FFAppState()
                                                        .refperiod ==
                                                    'month') {
                                                  _model.refdate =
                                                      functions.updatedate(
                                                          _model.refdate!,
                                                          1,
                                                          'month');
                                                  safeSetState(() {});
                                                  _model.allSensorMonthNextMobile =
                                                      await SensorReadingsTable()
                                                          .queryRows(
                                                    queryFn: (q) => q
                                                        .gtOrNull(
                                                          'timestamp',
                                                          supaSerialize<
                                                                  DateTime>(
                                                              functions
                                                                  .startandendofdaytime(
                                                                      _model
                                                                          .refdate,
                                                                      'month')
                                                                  ?.start),
                                                        )
                                                        .lteOrNull(
                                                          'timestamp',
                                                          supaSerialize<
                                                                  DateTime>(
                                                              functions
                                                                  .startandendofdaytime(
                                                                      _model
                                                                          .refdate,
                                                                      'month')
                                                                  ?.end),
                                                        ),
                                                  );
                                                  _model.supabasedata = [];
                                                  safeSetState(() {});
                                                  for (int loop2Index = 0;
                                                      loop2Index <
                                                          _model
                                                              .allSensorMonthNextMobile!
                                                              .length;
                                                      loop2Index++) {
                                                    final currentLoop2Item =
                                                        _model.allSensorMonthNextMobile![
                                                            loop2Index];
                                                    _model.addToSupabasedata(
                                                        SupabaseReadStruct(
                                                      id: currentLoop2Item.id,
                                                      sensorId: currentLoop2Item
                                                          .sensorId,
                                                      timestamp:
                                                          currentLoop2Item
                                                              .timestamp,
                                                      data: currentLoop2Item
                                                          .dataField
                                                          .toString(),
                                                      qualityScore:
                                                          currentLoop2Item
                                                              .qualityScore,
                                                      transmissionDelayMs:
                                                          currentLoop2Item
                                                              .transmissionDelayMs,
                                                      raspberryPiId:
                                                          currentLoop2Item
                                                              .raspberryPiId,
                                                      createdAt:
                                                          currentLoop2Item
                                                              .createdAt,
                                                      sensorSerialNumber:
                                                          currentLoop2Item
                                                              .sensorSerialNumber,
                                                    ));
                                                    safeSetState(() {});
                                                  }
                                                  _model.html = functions.buildHTMLfromSupabase(
                                                      _model.supabasedata
                                                          .toList(),
                                                      _model.refdate!,
                                                      'monthly',
                                                      Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? '#1a1a1a'
                                                          : '#ffffff',
                                                      Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? '#101010'
                                                          : '#f7faf9',
                                                      Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? '#93e5c1'
                                                          : '#2e8b57',
                                                      Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? '#f1f1f1'
                                                          : '#1b1b1b',
                                                      !_model
                                                          .groupSensorsValue!);
                                                  safeSetState(() {});
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 300,
                                                    ),
                                                  );
                                                } else {
                                                  _model.refdate =
                                                      functions.updatedate(
                                                          _model.refdate!,
                                                          1,
                                                          'year');
                                                  safeSetState(() {});
                                                }

                                                _model.loading = false;
                                                safeSetState(() {});

                                                safeSetState(() {});
                                              },
                                              child: Icon(
                                                Icons.arrow_forward_ios,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                size: 24.0,
                                              ),
                                            ),
                                          ].divide(SizedBox(width: 10.0)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Agrupar sensores',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                          ),
                                          Switch.adaptive(
                                            value: _model.groupSensorsValue!,
                                            onChanged: (newValue) async {
                                              safeSetState(() =>
                                                  _model.groupSensorsValue =
                                                      newValue!);
                                            },
                                            activeColor:
                                                FlutterFlowTheme.of(context)
                                                    .primary,
                                            activeTrackColor:
                                                FlutterFlowTheme.of(context)
                                                    .primary,
                                            inactiveTrackColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryText,
                                            inactiveThumbColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                          ),
                                        ],
                                      ),
                                    ].divide(SizedBox(height: 4.0)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: MediaQuery.sizeOf(context).height - 225,
                          decoration: BoxDecoration(),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              if (!_model.loading)
                                FlutterFlowWebView(
                                  content: _model.html!,
                                  width: 900.0,
                                  height:
                                      MediaQuery.sizeOf(context).height - 225,
                                  verticalScroll: true,
                                  horizontalScroll: true,
                                  html: true,
                                ),
                              if (_model.loading)
                                Container(
                                  width: 900.0,
                                  height:
                                      MediaQuery.sizeOf(context).height - 225,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(24.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: 200.0,
                                              height: 100.0,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                            ).animateOnPageLoad(animationsMap[
                                                'containerOnPageLoadAnimation1']!),
                                          ],
                                        ),
                                        Container(
                                          width: double.infinity,
                                          height: 289.4,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                            borderRadius:
                                                BorderRadius.circular(24.0),
                                          ),
                                        ).animateOnPageLoad(animationsMap[
                                            'containerOnPageLoadAnimation2']!),
                                        Container(
                                          width: double.infinity,
                                          height: 100.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                            borderRadius:
                                                BorderRadius.circular(24.0),
                                          ),
                                        ).animateOnPageLoad(animationsMap[
                                            'containerOnPageLoadAnimation3']!),
                                      ].divide(SizedBox(height: 24.0)),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              wrapWithModel(
                model: _model.navbarModel,
                updateCallback: () => safeSetState(() {}),
                child: NavbarWidget(
                  active: 'dashboard',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
