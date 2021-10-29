import 'dart:collection';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:tutum_app/app/constant/bluetooth_constant.dart';
import 'package:tutum_app/models/pass/rssi.dart';
import 'package:tutum_app/models/device.dart';

/// Rssi 데이터를 관리하는 리스트 클래스
class Beacon {
  late String _address;
  late String _name;
  Queue<Rssi> _rssiQueue = Queue<Rssi>();
  DateTime _updated = DateTime.now();

  Beacon.fromScanResult(ScanResult result) {
    this._address = result.device.id.toString();
    this._name = result.device.name;
  }

  Device get device => toDevice();

  String get address => _address;

  int get id => int.parse(_name.substring(DEVICE_NAME.length));

  List<int> get value => _rssiQueue.map((Rssi rssi) => rssi.rssi).toList();

  List<Rssi> get list => _rssiQueue.toList();

  bool get isNotEmpty => _rssiQueue.isNotEmpty;

  DateTime get updated => _updated;

  Device toDevice() {
    return Device(
        address: this._address,
        name: this._name,
        rssi: _rssiQueue.isNotEmpty ? _rssiQueue.last.rssi : null);
  }

  void slice(int seconds) {
    DateTime now = DateTime.now();
    while (_rssiQueue.isNotEmpty &&
        _rssiQueue.first.timestamp
            .isBefore(now.add(-Duration(seconds: seconds)))) {
      _rssiQueue.removeFirst();
    }
  }

  void add(Rssi rssi) {
    _rssiQueue.add(rssi);
    _updated = rssi.timestamp;
  }
}
