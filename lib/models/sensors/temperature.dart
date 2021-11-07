import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:tutum_app/app/util/util.dart';

class Temperature {
  late num _temperature;
  late DateTime _timestamp;

  String get timestamp => Util.formatter.format(_timestamp);

  String get json => jsonEncode(toMap());

  num get value => _temperature;

  List<dynamic> get data => [timestamp, value];

  Temperature.fromIntList(List<int> list) {
    this._temperature =
        Uint8List.fromList(list).buffer.asFloat32List().toList()[0];
    this._timestamp = DateTime.now();
  }

  Map<String, dynamic> toMap() {
    // log("temperature $timestamp $value");
    return {
      "type": "temperature",
      "timestamp": timestamp,
      "value": value,
    };
  }
}
