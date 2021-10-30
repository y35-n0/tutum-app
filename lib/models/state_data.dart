import 'dart:convert';
import 'package:tutum_app/models/sensors/capacity.dart';
import 'package:tutum_app/models/sensors/oxygen.dart';
import 'package:tutum_app/models/sensors/temperature.dart';
import 'package:tutum_app/models/states/bluetooth_state.dart';
import 'package:tutum_app/models/states/helmet_state.dart';
import 'package:tutum_app/models/states/oxygen_state.dart';
import 'package:tutum_app/models/states/temperature_state.dart';

class StateData {
  HelmetState? _helmetState;
  TemperatureState _temperatureState = TemperatureState();
  OxygenState? _oxygenState;
  BluetoothState? _bluetoothState;

  void calculate(dynamic data) {
    switch (data.runtimeType) {
      case Capacity:
        this._helmetState = HelmetState.fromCapacity(data);
        break;
      case Temperature:
        this._temperatureState.add(data);
        break;
      case Oxygen:
        this._oxygenState = OxygenState.fromOxygen(data);
        break;
      case bool:
        this._bluetoothState = BluetoothState(data);
        break;
    }
  }

  List<dynamic>? get helmetState => _helmetState?.data;

  List<dynamic>? get temperatureState =>
      _temperatureState.isNotEmpty ? _temperatureState.data : null;

  List<dynamic>? get oxygenState => _oxygenState?.data;

  List<dynamic>? get bluetoothState => _bluetoothState?.data;

  String get json => jsonEncode(toListMap());

  List<Map<String, dynamic>> toListMap() {
    List<Map<String, dynamic>> list = List.empty(growable: true);
    if (_helmetState != null) list.add(_helmetState!.toMap());
    if (_oxygenState != null) list.add(_oxygenState!.toMap());
    if (_bluetoothState != null) list.add(_bluetoothState!.toMap());
    if (_temperatureState.isNotEmpty) list.add(_temperatureState.toMap());

    return list;
  }

  void clear() {
    _helmetState = null;
    _temperatureState.slicing();
    _oxygenState = null;
    _bluetoothState = null;
  }
}
