import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:tutum_app/app/util/util.dart';

class Oxygen {
  late num _oxygen;
  late DateTime _timestamp;

  String get timestamp => Util.formatter.format(_timestamp);

  String get json => jsonEncode(toMap());

  num get value => _oxygen;

  Oxygen.fromIntList(List<int> list) {
    this._oxygen = Uint8List.fromList(list).buffer.asFloat32List().toList()[0];
    this._timestamp = DateTime.now();
  }

  Map<String, dynamic> toMap() {
    log("oxygen $timestamp $value");
    return {
      "type": "oxygen",
      "timestamp": timestamp,
      "value": value,
    };
  }
}
