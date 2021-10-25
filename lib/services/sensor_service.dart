import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'dart:developer';

const SENSOR_NAME = "TUTUM";

/// [_bluetoothState] 블루투스 상태, [_sensor] 연결된 센서, [_connection] 연결 정보
/// [_isDiscovering] 스캔 중 여부
class SensorService extends GetxService {
  static SensorService get to => Get.find();

  // 블루투스 관련
  final FlutterBluetoothSerial _flutterBluetoothSerial =
      FlutterBluetoothSerial.instance;
  final Rx<BluetoothState> _bluetoothState = BluetoothState.UNKNOWN.obs;
  final Rx<bool> _isDiscovering = false.obs;

  // 센서 관련
  final Rxn<BluetoothDevice> _sensor = Rxn<BluetoothDevice>();
  final Rxn<BluetoothConnection> _connection = Rxn<BluetoothConnection>();

  // 값 관련
  final Rxn<Uint8List> _rawData = Rxn<Uint8List>();
  Worker? _dataWorker;

  // for test page
  final RxMap<String, BluetoothDiscoveryResult> _discoveredResultsMap =
      Map<String, BluetoothDiscoveryResult>().obs;

  bool get isEnabled => _bluetoothState.value == BluetoothState.STATE_ON;

  bool get isDiscovering => _isDiscovering.value;

  BluetoothDevice? get sensor => _sensor.value;

  // for test page
  List<BluetoothDiscoveryResult> get discoveredResults =>
      _discoveredResultsMap.values.toList();

  @override
  void onInit() {
    _flutterBluetoothSerial.state.then((state) {
      _bluetoothState.value = state;
    });
    _bluetoothState.bindStream(_flutterBluetoothSerial.onStateChanged());

    ever(_bluetoothState, (state) => {print(state)});
    super.onInit();
  }

  // for test page
  /// 기기 탐색 및 정보 저장
  void startDiscovery() async {
    await cancelDiscovery();
    _discoveredResultsMap.clear();

    _isDiscovering.value = true;
    _flutterBluetoothSerial.startDiscovery().listen(
      (result) async {
        _discoveredResultsMap[result.device.address] = result;
      },
      onDone: () {
        _isDiscovering.value = false;
      },
      onError: (error) {
        _isDiscovering.value = false;
      },
    );
  }

  /// 탐색 종료
  Future<void> cancelDiscovery() async {
    if (isDiscovering) {
      await _flutterBluetoothSerial.cancelDiscovery();
    }
  }

  // FIXME: 원활하게 진행되는지 센서를 연결해서 확인해 봐야함.
  // FIXME: scan 시, FlutterBlue 영향을 받는 것 같음. FlutterBlue의 scan으로 대체할 수 있도록 해야 함.

  /// 기기 연결
  Future<void> connect(String address) async {
    BluetoothDevice? device;

    await disconnect();
    await cancelDiscovery();
    _isDiscovering.value = true;
    _flutterBluetoothSerial.startDiscovery().listen((result) async {
      if (result.device.address == address) {
        device = result.device;
        cancelDiscovery();
      }
    }, onDone: (() async {
      _isDiscovering.value = false;

      log('found) ${device != null}');
      if (device == null) return;

      // 우리 로직에서는 bonding이 필요 없음
      // bool isBonded = device!.isBonded || await _bonding(address);
      // log('bonded) $isBonded');
      // if (!isBonded) return;

      _connection.value = await _connect(address);
      log('connected) ${_connection.value!.isConnected}');

      await _receive(_connection.value!,
          (data) => log('input) ${device!.name} ${data.join()}'));

      await _send(_connection.value!, "HI");
      log('output) ${device!.name}');
    }));
  }

  // 우리 로직에서는 bonding이 필요 없음
  Future<bool> _bonding(String address) async {
    return await _flutterBluetoothSerial.bondDeviceAtAddress(address) ?? true;
  }

  Future<BluetoothConnection> _connect(String address) async {
    return await BluetoothConnection.toAddress(address);
  }

  Future<void> _send(BluetoothConnection connection,
      String message) async {
    connection.output.add(Uint8List.fromList(utf8.encode(message + '\r\n')));
    await connection.output.allSent;
    return;
  }

  Future<void> _receive(
      BluetoothConnection connection, WorkerCallback callback) async {
    _rawData.bindStream(connection.input!);
    _dataWorker?.dispose();
    _dataWorker = ever(_rawData, callback);
  }

  Future<void> disconnect() async {
    if (_sensor.value?.isConnected ?? false) {
      await _connection.value!.finish();
      _sensor.value = null;
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    _connection.value?.dispose();
    super.onClose();
  }
}
