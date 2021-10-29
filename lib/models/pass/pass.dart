import 'dart:convert';
import 'dart:developer';

import 'package:tutum_app/app/constant/bluetooth_constant.dart';
import 'package:tutum_app/app/util/util.dart';

class Pass {
  Pass({
    required id,
    required timestamp,
    required direction,
  })  : this._id = id,
        this._timestamp = timestamp,
        this._direction = direction;

  final int _id;
  final DateTime _timestamp;
  final DIRECTION _direction;

  String get timestamp => Util.formatter.format(_timestamp);

  String get json => jsonEncode(toMap());

  num get value => _id;

  List<dynamic> get data => [timestamp, value];

  Map<String, dynamic> toMap() {
    log("pass $_timestamp $_id $_direction");
    return {
      "type": "pass_beacon",
      "timestamp": timestamp,
      "value": value,
    };
  }
}
