import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'dart:developer';

import 'package:tutum_app/app/constant/bluetooth_constrant.dart';
import 'package:tutum_app/models/device.dart';

// FIXME: TUTM => TUTUM
const SENSOR_NAME = "TUTM";
const DISCOVERY_DURATION_SECONDS = 10;
const TRY_CONNECT_DURATION_SECONDS = 5;
const TRY_CONNECT_INTERVAL_SECONDS = 1;

/// [_bluetoothState] 블루투스 상태, [isEnable] 블루투스 사용 가능 여부, [_isDiscovering] 스캔 중 여부,
/// [_address] 연결된 센서 주소, [_connection] 센서 연결 정보
/// [_rawData] Raw Data, [_dataWorker] raw data를 처리할 워커

class SensorService extends GetxService {
  static SensorService get to => Get.find();

  // 블루투스 관련
  final FlutterBluetoothSerial _flutterBluetoothSerial =
      FlutterBluetoothSerial.instance;
  final Rx<BluetoothState> _bluetoothState = BluetoothState.UNKNOWN.obs;

  final Rx<bool> _isDiscovering = false.obs;

  // 센서 관련
  final Rx<String> _address = "".obs;
  final Rx<String> _name = "".obs;
  final Rxn<BluetoothConnection> _connection = Rxn<BluetoothConnection>();

  // 데이터 관련
  final RxList<Uint8List> _rawData = <Uint8List>[].obs;
  bool get isEnabled => _bluetoothState.value == BluetoothState.STATE_ON;

  bool get isDiscovering => _isDiscovering.value;

  String get sensorAddress => _address.value;

  String get sensorName => _name.value;

  bool get sensorIsConnected => _connection.value?.isConnected ?? false;

  // 연결된 기기
  final RxMap<String, BluetoothDevice> _bondedDevicesMap =
      Map<String, BluetoothDevice>().obs;
  final RxMap<String, BluetoothDiscoveryResult> _discoveredResultsMap =
      Map<String, BluetoothDiscoveryResult>().obs;

  List<Device> get devices => getDevices();

  @override
  void onInit() async {
    super.onInit();

    /// listen bluetooth states
    _flutterBluetoothSerial.state.then((state) {
      _bluetoothState.value = state;
    });
    _bluetoothState.bindStream(_flutterBluetoothSerial.onStateChanged());

    _flutterBluetoothSerial.setPairingRequestHandler(
      (BluetoothPairingRequest request) {
        if (request.pairingVariant == PairingVariant.Pin) {
          return Future.value("$PAIRING_PIN");
        } else {
          return Future.value(null);
        }
      },
    );
  }

  /// 주변 기기 탐색 시작
  void startFindingDevices() async {
    Timer(Duration(seconds: DISCOVERY_DURATION_SECONDS), () {
      _stopDiscovery();
    });

    _startDiscovery();
    _findBondedDevices();
  }

  /// 주변 기기 탐색 종료
  void stopFindingDevices() {
    _stopDiscovery();
  }

  /// 기기 목록
  List<Device> getDevices() {
    List<Device> devices = [];
    devices.addAll(_bondedDevicesMap.values
        .map((device) => Device.fromBluetoothDeviceOfFBS(device)));
    devices.addAll(_discoveredResultsMap.values
        .map((result) => Device.fromBluetoothDiscoveryResult(result)));
    return devices;
  }

  /// 신규 기기 탐색 시작
  Future<void> _startDiscovery() async {
    if (isDiscovering) await _stopDiscovery();
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

  /// 신규 기기 탐색 종료
  Future<void> _stopDiscovery() async {
    if (isDiscovering) {
      await _flutterBluetoothSerial.cancelDiscovery();
      _isDiscovering.value = false;
    }
  }

  /// 연결된 기기 탐색
  Future<void> _findBondedDevices() async {
    _bondedDevicesMap.clear();
    final bondedDevices = await _flutterBluetoothSerial.getBondedDevices();
    final bondedSensors = bondedDevices
        .where((device) => device.name?.startsWith(SENSOR_NAME) ?? false)
        .toList();
    bondedSensors.forEach((sensor) {
      _bondedDevicesMap[sensor.address] = sensor;
    });
  }

  /// 기기 연결 시도
  /// [TRY_CONNECT_DURATION_SECONDS]초 동안 연결 시도
  Future<bool> connect(String address) async {
    // address인지 확인
    if (!_isAddress(address)) {
      return false;
    }

    // 기기가 연결되어 있는지 확인
    await _findBondedDevices();
    if (_bondedDevicesMap[address] != null) {
      final isUnbonded =
          await _flutterBluetoothSerial.removeDeviceBondWithAddress(address) ??
              false;
      if (!isUnbonded) return false;
    }

    // 기기 탐색 및 이름 확인
    BluetoothDiscoveryResult? result;
    await _startDiscovery();
    Timer timerDiscovering =
        Timer(Duration(seconds: TRY_CONNECT_DURATION_SECONDS), () {
      _isDiscovering.value = false;
    });
    while (isDiscovering) {
      result = _discoveredResultsMap[address];
      if (result != null) {
        _isDiscovering.value = false;
        timerDiscovering.cancel();
        if (!(result.device.name?.startsWith(SENSOR_NAME) ?? false)) {
          return false;
        }
      }
      await Future.delayed(Duration(seconds: TRY_CONNECT_INTERVAL_SECONDS));
    }
    if (result == null) return false;

    // 연결 시도
    BluetoothConnection? connection;
    bool isConnecting = true;
    Timer timerConnecting =
        Timer(Duration(seconds: TRY_CONNECT_DURATION_SECONDS ~/ 2), () {
      isConnecting = false;
    });
    while (isConnecting) {
      connection = await _connect(address);
      if (connection != null) {
        isConnecting = false;
        timerConnecting.cancel();
      }
    }
    if (connection == null) return false;

    connection.input!.listen((rawData) {
      _processingData(rawData);
    });
    // 연결 결과 정리
    _address.value = address;
    _name.value = result.device.name!;
    _connection.value = connection;

    log("connected");
    return true;
  }

  /// 기기 연결
  Future<BluetoothConnection?> _connect(String address) async {
    try {
      final connection = await BluetoothConnection.toAddress(address);
      final isConnected = connection.isConnected;
      if (!isConnected) return null;

      return connection;
    } catch (error) {
      printError(info: error.toString());
      return null;
    }
  }

  bool _isAddress(String address) {
    final units = address.split(":");
    return units.length == 6 &&
        units.every((unit) => unit.length == 2 && unit.isNumericOnly);
  }

  void _processingData(Uint8List rawData) {}

  @override
  void onClose() {
    _connection.value?.dispose();
    super.onClose();
  }
}
