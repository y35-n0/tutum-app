import 'dart:convert';
import 'dart:developer';

import 'package:tutum_app/app/constant/abnormal_state_constants.dart';
import 'package:tutum_app/app/util/util.dart';
import 'package:tutum_app/models/sensors/capacity.dart';

class HelmetState {
  final String _type = '안전모 착용 여부';
  late num _capacity;
  late DateTime _timestamp;
  late String _content;
  late LEVEL _level;

  String get timestamp => Util.formatter.format(_timestamp);

  int get state => _level.index;

  List<dynamic> get data => [_timestamp, _level, _content];

  String get json => jsonEncode(toMap());

  HelmetState.fromCapacity(Capacity data) {
    this._capacity = data.value;
    this._timestamp = Util.formatter.parse(data.timestamp);

    if (_capacity < 255) {
      _content = "안전모 미착용";
    } else {
      _content = "안전모 착용";
    }

    _level = STATUS_LEVEL_MAP[_type][_content];
  }

  Map<String, dynamic> toMap() {
    // log("CapacityState $timestamp $_capacity $state ");
    return {
      "type": "helmet",
      "timestamp": timestamp,
      "state": state,
    };
  }
}
