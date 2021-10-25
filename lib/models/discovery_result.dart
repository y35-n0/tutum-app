import 'package:flutter_blue/flutter_blue.dart';

class DiscoveryResult {
  DiscoveryResult({
    required this.address,
    required this.name,
    required this.rssi,
  });

  late String address;
  late String name;
  late int rssi;

  DiscoveryResult.fromScanResult(ScanResult result) {
    this.address = result.device.id.toString();
    this.name = result.device.name;
    this.rssi = result.rssi;
  }
}
