import 'package:flutter/material.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import 'backend/supabase/supabase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _chartsperrow = prefs.getInt('ff_chartsperrow') ?? _chartsperrow;
    });
    _safeInit(() {
      _activetypes = prefs.getStringList('ff_activetypes') ?? _activetypes;
    });
    _safeInit(() {
      if (prefs.containsKey('ff_showsensors')) {
        try {
          final serializedData = prefs.getString('ff_showsensors') ?? '{}';
          _showsensors =
              SensorsStruct.fromSerializableMap(jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
    _safeInit(() {
      _chartsize = prefs.getInt('ff_chartsize') ?? _chartsize;
    });
    _safeInit(() {
      _refperiod = prefs.getString('ff_refperiod') ?? _refperiod;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  int _chartsperrow = 0;
  int get chartsperrow => _chartsperrow;
  set chartsperrow(int value) {
    _chartsperrow = value;
    prefs.setInt('ff_chartsperrow', value);
  }

  List<String> _activetypes = [];
  List<String> get activetypes => _activetypes;
  set activetypes(List<String> value) {
    _activetypes = value;
    prefs.setStringList('ff_activetypes', value);
  }

  void addToActivetypes(String value) {
    activetypes.add(value);
    prefs.setStringList('ff_activetypes', _activetypes);
  }

  void removeFromActivetypes(String value) {
    activetypes.remove(value);
    prefs.setStringList('ff_activetypes', _activetypes);
  }

  void removeAtIndexFromActivetypes(int index) {
    activetypes.removeAt(index);
    prefs.setStringList('ff_activetypes', _activetypes);
  }

  void updateActivetypesAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    activetypes[index] = updateFn(_activetypes[index]);
    prefs.setStringList('ff_activetypes', _activetypes);
  }

  void insertAtIndexInActivetypes(int index, String value) {
    activetypes.insert(index, value);
    prefs.setStringList('ff_activetypes', _activetypes);
  }

  SensorsStruct _showsensors = SensorsStruct.fromSerializableMap(
      jsonDecode('{\"temperature\":\"true\",\"humidity\":\"true\"}'));
  SensorsStruct get showsensors => _showsensors;
  set showsensors(SensorsStruct value) {
    _showsensors = value;
    prefs.setString('ff_showsensors', value.serialize());
  }

  void updateShowsensorsStruct(Function(SensorsStruct) updateFn) {
    updateFn(_showsensors);
    prefs.setString('ff_showsensors', _showsensors.serialize());
  }

  int _chartsize = 0;
  int get chartsize => _chartsize;
  set chartsize(int value) {
    _chartsize = value;
    prefs.setInt('ff_chartsize', value);
  }

  String _refperiod = 'day';
  String get refperiod => _refperiod;
  set refperiod(String value) {
    _refperiod = value;
    prefs.setString('ff_refperiod', value);
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
