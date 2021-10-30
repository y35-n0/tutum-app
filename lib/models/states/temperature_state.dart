import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:tutum_app/app/constant/abnormal_state_constants.dart';
import 'package:tutum_app/app/util/util.dart';
import 'package:tutum_app/models/sensors/temperature.dart';

const _COLLECTING_TIMES = 6;
const _COLLECTING_INTERVAL = 10;

class TemperatureState {
  TemperatureState();

  final String _type = '기온';
  Queue<Temperature> _temperatureQueue = Queue<Temperature>();
  late num _avgTemperature;
  late String _content;
  late LEVEL _level;
  DateTime _updated = DateTime.now();

  List<num> get value =>
      _temperatureQueue.map((Temperature temp) => temp.value).toList();

  List<Temperature> get list => _temperatureQueue.toList();

  bool get isNotEmpty => _temperatureQueue.isNotEmpty;

  String get timestamp => Util.formatter.format(_updated);

  int get state => _level.index;

  String get json => jsonEncode(toMap());

  List<dynamic> get data => [_updated, _level, _content];

  void add(Temperature data) {
    _temperatureQueue.addLast(data);
    _avgTemperature =
        _temperatureQueue.map((temp) => temp.value).reduce((a, b) => a + b) /
            _temperatureQueue.length;

    this._updated = Util.formatter.parse(data.timestamp);

    if (_avgTemperature >= 38) {
      _content = "심각";
    } else if (_avgTemperature >= 35) {
      _content = "경계";
    } else if (_avgTemperature >= 33) {
      _content = "경계";
    } else if (_avgTemperature >= 31) {
      _content = "관심";
    } else {
      _content = "양호";
    }

    _level = STATUS_LEVEL_MAP[_type][_content];
  }

  void slicing() {
    final now = DateTime.now();

    while (isNotEmpty &&
        Util.formatter.parse(this._temperatureQueue.first.timestamp).isBefore(
            now.add(-const Duration(
                seconds: _COLLECTING_TIMES * _COLLECTING_INTERVAL)))) {
      _temperatureQueue.removeFirst();
    }
  }

  Map<String, dynamic> toMap() {
    log("TemperatureState $timestamp $_avgTemperature $state ");
    return {
      "type": "temperature",
      "timestamp": timestamp,
      "state": state,
    };
  }
}
