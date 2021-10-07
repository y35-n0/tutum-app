import 'package:flutter_blue/flutter_blue.dart';

class Beacon {
  Beacon({
    required this.device,
    required this.rssi,
    required this.timestamp,
  });

  late BluetoothDevice device;
  late int rssi;
  late DateTime timestamp;
  late int count = 0;

  Beacon.fromScanResult(ScanResult result) {
    this.device = result.device;
    this.rssi = result.rssi;
    this.timestamp = DateTime.now();
  }

  void update(ScanResult result) {
    this.rssi = result.rssi;
    this.timestamp = DateTime.now();
    count += 1;
  }


}