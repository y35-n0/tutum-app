import 'dart:convert';
import 'dart:developer';

import 'package:tutum_app/models/sensors/imu.dart';

class SensorData {
  List<List<num>> _imuList = [];
  DateTime? _imuTimestamp;

  void setImuTimestamp() {
    this._imuTimestamp = DateTime.now();
  }

  DateTime? getImuTimestamp() {
    return _imuTimestamp;
  }

  void addImu(Imu imu) {
    this._imuList.add(imu.value);
  }

  String get json => jsonEncode(toListMap());

  List<Map<String, dynamic>> toListMap() {
    List<Map<String, dynamic>> list = List.empty(growable: true);
    if (_imuTimestamp != null)
      list.add({
        "type": "imu",
        "timestamp": _imuTimestamp.toString(),
        "value": _imuList,
      });
    log("$_imuTimestamp ${_imuList.length}");

    return list;
  }

  void clear() {
    _imuList.clear();
  }
}

class Temperature {}

class Capacity {}
