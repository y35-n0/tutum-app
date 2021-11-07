import 'dart:convert';
import 'dart:developer';

import 'package:tutum_app/app/constant/abnormal_state_constants.dart';
import 'package:tutum_app/app/util/util.dart';

class BluetoothState {
  final String _type = '블루투스 연결 상태';
  late bool _isConnected;
  final DateTime _timestamp = DateTime.now();
  late String _content;
  late LEVEL _level;

  String get timestamp => Util.formatter.format(_timestamp);

  int get state => _level.index;

  String get json => jsonEncode(toMap());

  List<dynamic> get data => [_timestamp, _level, _content];

  BluetoothState(bool isConnected) {
    this._isConnected = isConnected;

    if (this._isConnected) {
      _content = "연결됨";
    } else {
      _content = "연결 안 됨";
    }

    _level = STATUS_LEVEL_MAP[_type][_content];
  }

  Map<String, dynamic> toMap() {
    // log("BluetoothState $timestamp $_isConnected $state ");
    return {
      "type": "bluetooth",
      "timestamp": timestamp,
      "state": state,
    };
  }
}
