// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// import 'package:get/get.dart';
//
// /// [bluetoothState] 블루투스 상태
// class SensorsService extends GetxService {
//   static SensorsService get to => Get.find();
//
//   final FlutterBluetoothSerial _flutterBluetoothSerial = FlutterBluetoothSerial.instance;
//   final Rx<BluetoothState> _bluetoothState = BluetoothState.UNKNOWN.obs;
//   final Rxn<BluetoothConnection> _connection = Rxn<BluetoothConnection>();
//
//   BluetoothState get bluetoothState => _bluetoothState.value;
//
//   @override
//   void onInit() {
//     _bluetoothState.bindStream(_flutterBluetoothSerial.onStateChanged());
//     // address
//     // discovery
//     // connection.toAddress
//
//     super.onInit();
//   }
//
//   Future<bool> connect(String address) {
//     _flutterBluetoothSerial.startDiscovery().listen((BluetoothDiscoveryResult result) async {
//       if (result.device.address == address) {
//         await _flutterBluetoothSerial.cancelDiscovery();
//         _connection.value = await BluetoothConnection.toAddress(address);
//       }
//     });
//   }
//
//   @override
//   void onClose() {
//     // TODO: implement onClose
//     super.onClose();
//   }
// }