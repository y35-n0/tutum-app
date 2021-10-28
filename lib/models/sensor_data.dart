import 'dart:convert';
import 'package:tutum_app/app/constant/bluetooth_constrant.dart';
import 'package:tutum_app/models/sensors/capacity.dart';
import 'package:tutum_app/models/sensors/imu.dart';
import 'package:tutum_app/models/sensors/imu_list.dart';
import 'package:tutum_app/models/sensors/oxygen.dart';
import 'package:tutum_app/models/sensors/temperature.dart';

class SensorData {
  ImuList _imuList = ImuList();
  Capacity? _capacity;
  Temperature? _temperature;
  Oxygen? _oxygen;

  void add(dynamic data) {
    switch (data.runtimeType) {
      case Imu:
        if (this._imuList.isEmpty) this._imuList.setTimestamp();
        this._imuList.add(data);
        break;
      case Capacity:
        this._capacity = data;
        break;
      case Temperature:
        this._temperature = data;
        break;
      case Oxygen:
        this._oxygen = data;
        break;
    }
  }

  String get json => jsonEncode(toListMap());

  List<Map<String, dynamic>> toListMap() {
    List<Map<String, dynamic>> list = List.empty(growable: true);
    if (_capacity != null) list.add(_capacity!.toMap());
    if (_temperature != null) list.add(_temperature!.toMap());
    if (_oxygen != null) list.add(_oxygen!.toMap());
    if (!_imuList.isEmpty) list.add(_imuList.toMap());
    return list;
  }

  void clear() {
    _imuList.clear();
    _capacity = null;
    _temperature = null;
    _oxygen = null;
  }
}
