import 'dart:convert';
import 'dart:developer';

import 'package:tutum_app/models/sensors/imu.dart';
import 'package:tutum_app/app/util/util.dart';

class ImuList {
  List<Imu> _list = [];
  DateTime _timestamp = DateTime.now();

  String get timestamp => Util.formatter.format(_timestamp);

  String get json => jsonEncode(toMap());

  List<List<num>> get value => toList();

  bool get isEmpty => _list.isEmpty;

  void setTimestamp() {
    this._timestamp = DateTime.now();
  }

  void add(Imu imu) {
    this._list.add(imu);
  }

  Map<String, dynamic> toMap() {
    log("imu $timestamp ${_list.length}");
    return {
      "type": "imu",
      "timestamp": timestamp,
      "value": value,
    };
  }

  List<List<num>> toList() {
    return _list.map((Imu imu) {
      return imu.value;
    }).toList();
  }

  void clear() {
    _list.clear();
  }

}
