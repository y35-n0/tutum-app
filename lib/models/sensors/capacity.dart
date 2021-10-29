import 'dart:convert';
import 'dart:developer';

import 'package:tutum_app/app/util/util.dart';

class Capacity {
  late num _capacity;
  late DateTime _timestamp;

  String get timestamp => Util.formatter.format(_timestamp);

  String get json => jsonEncode(toMap());

  num get value => _capacity;

  List<dynamic> get data => [timestamp, value];

  Capacity.fromIntList(List<int> list) {
    this._capacity = Util.complement((list[0] << 8) | list[1]) * 8 / 32768;
    this._timestamp = DateTime.now();
  }

  Map<String, dynamic> toMap() {
    log('capacity $timestamp $value');
    return {
      "type": "capacity",
      "timestamp": timestamp,
      "value": value,
    };
  }
}
