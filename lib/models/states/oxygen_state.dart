import 'dart:convert';
import 'dart:developer';

import 'package:tutum_app/app/constant/abnormal_state_constants.dart';
import 'package:tutum_app/app/util/util.dart';
import 'package:tutum_app/models/sensors/oxygen.dart';

class OxygenState {
  final String _type = '공기 중 산소 농도';
  late num _oxygen;
  late DateTime _timestamp;
  late String _content;
  late LEVEL _level;

  String get timestamp => Util.formatter.format(_timestamp);

  int get state => _level.index;

  String get json => jsonEncode(toMap());

  List<dynamic> get data => [_timestamp, _level, _content];

  OxygenState.fromOxygen(Oxygen data) {
    this._oxygen = data.value;
    this._timestamp = Util.formatter.parse(data.timestamp);

    if (_oxygen < 18) {
      _content = "산소 결핍";
    } else if (_oxygen >= 23.5) {
      _content = "산소 과다";
    } else {
      _content = "산소 양호";
    }

    _level = STATUS_LEVEL_MAP[_type][_content];
  }

  Map<String, dynamic> toMap() {
    // log("OxygenState $timestamp $_oxygen $state ");
    return {
      "type": "oxygen",
      "timestamp": timestamp,
      "state": state,
    };
  }
}
