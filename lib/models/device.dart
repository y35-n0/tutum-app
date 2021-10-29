import 'package:flutter_blue/flutter_blue.dart' as FB;
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart' as FBS;

class Device {
  Device({
    required this.address,
    required this.name,
    this.isConnected,
    this.rssi,
  });

  late String address;
  late String name;
  late bool? isConnected;
  late int? rssi;

  Device.fromScanResult(FB.ScanResult result) {
    this.address = result.device.id.toString();
    this.name = result.device.name;
    this.rssi = result.rssi;
  }

  Device.fromBluetoothDiscoveryResult(FBS.BluetoothDiscoveryResult result) {
    this.address = result.device.address;
    this.name = result.device.name ?? '';
    this.rssi = result.rssi;
    this.isConnected = false;
  }

  Device.fromBluetoothDeviceOfFBS(FBS.BluetoothDevice device) {
    this.address = device.address;
    this.name = device.name ?? '';
    this.isConnected = device.isConnected;
  }
}
