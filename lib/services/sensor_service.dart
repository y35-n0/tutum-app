import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'dart:developer';

import 'package:tutum_app/app/constant/bluetooth_constrant.dart';
import 'package:tutum_app/models/device.dart';
import 'package:tutum_app/models/sensor_data.dart';

// FIXME: TUTM => TUTUM
const SENSOR_NAME = "TUTM";
const DISCOVERY_DURATION_SECONDS = 10;
const TRY_CONNECT_DURATION_SECONDS = 1;
const TRY_CONNECT_INTERVAL_SECONDS = 1;
const MAX_CONNECT_RETRY_COUNT = 5;

/// [_bluetoothState] 블루투스 상태, [isEnable] 블루투스 사용 가능 여부, [_isDiscovering] 스캔 중 여부,
/// [_address] 연결된 센서 주소, [_connection] 센서 연결 정보
/// [_rawData] Raw Data

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
  final List<int> _rawData = <int>[];
  bool _start = false;
  int _count = 0;

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
    try {
      // address인지 확인
      if (!_isAddress(address)) {
        return false;
      }

      // 기기가 연결되어 있는지 확인
      if (await _isBonded(address))
        await _flutterBluetoothSerial.removeDeviceBondWithAddress(address);

      // 기기 탐색
      final result =
          await _findDeviceByAddressWithRetry(address, MAX_CONNECT_RETRY_COUNT);
      if (result == null) return false;

      // 투툼 센서가 맞는지 확인
      if (!_isSensor(result)) return false;

      // 연결 시도
      final connection =
          await _connectionWithRetry(address, MAX_CONNECT_RETRY_COUNT);
      if (connection == null) return false;

      // 연결 결과 정리
      _address.value = address;
      _name.value = result.device.name!;
      _connection.value = connection;

      connection.input!.listen((rawData) {
        _processingData(rawData);
      });

      log("connected");
      return true;
    } catch (error) {
      print(error);
      return false;
    }
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

  /// address 형식이 맞는지 확인
  bool _isAddress(String address) {
    return RegExp(r'^([0-9a-fA-F]{2}:){5}[0-9a-fA-F]{2}$').hasMatch(address);
  }

  /// 해당 address가 연결되어있는지 확인
  Future<bool> _isBonded(String address) async {
    await _findBondedDevices();
    return _bondedDevicesMap[address] != null;
  }

  Future<BluetoothDiscoveryResult?> _findDeviceByAddressWithRetry(
      String address, int maxRetryCount) async {
    BluetoothDiscoveryResult? result;

    await _startDiscovery();

    for (int i = 0; i < maxRetryCount; i++) {
      result = _discoveredResultsMap[address];
      if (result != null) {
        await _stopDiscovery();
        break;
      }
      await Future.delayed(Duration(seconds: TRY_CONNECT_INTERVAL_SECONDS));
    }

    return result;
  }

  /// 센서가 맞는지 확인
  bool _isSensor(BluetoothDiscoveryResult result) {
    return (result.device.name?.startsWith(SENSOR_NAME) ?? false);
  }

  /// 재시도를 포함한 연결 시도
  Future<BluetoothConnection?> _connectionWithRetry(
      String address, int maxRetryCount) async {
    BluetoothConnection? connection;

    for (int i = 0; i < maxRetryCount; i++) {
      connection = await _connect(address);
      if (connection != null) {
        break;
      }
    }

    return connection;
  }

  /// raw 데이터 처리
  void _processingData(Uint8List rawData) {
    _rawData.addAll(rawData);
    bool running = true;
    while (running) {
      switch (_count) {
        case COUNT_START:
          // 시작 지점 찾기
          // FIXME: Sync를 맞춰야 함.
          if (!_start) {
            int index = 0;
            do {
              index = _rawData.indexOf(SIGN_START[1], index + 1);
            } while (index > -1 && _rawData[index - 1] != SIGN_START[0]);
            if (_rawData.length >= LENGTH_START && index > -1) {
              _rawData.removeRange(0, index + 1);
              _count++;
              _start = true;
            } else {
              running = false;
            }
          }
          _count++;
          log("start ${DateTime.now()} ${_rawData.length}");
          break;
        case COUNT_TEMPERATURE:
          _count++;
          break;
        case COUNT_CAPACITY:
          _count++;
          break;
        case COUNT_OXYGEN:
          _count = 0;
          break;
        default: // imu
          if (_rawData.length >= LENGTH_IMU) {
            final imu = Imu(
              accX: complement((_rawData[0] << 8) | _rawData[1]) * 8 / 32768,
              accY: complement((_rawData[2] << 8) | _rawData[3]) * 8 / 32768,
              accZ: complement((_rawData[4] << 8) | _rawData[5]) * 8 / 32768,
              gyroX: complement((_rawData[6] << 8) | _rawData[7]) * 500 / 32768,
              gyroY: complement((_rawData[8] << 8) | _rawData[9]) * 500 / 32768,
              gyroZ:
                  complement((_rawData[10] << 8) | _rawData[11]) * 500 / 32768,
            );
            _rawData.removeRange(0, LENGTH_IMU);
            _count++;
            print(
                '$_count ${imu.accX} ${imu.accY} ${imu.accZ} ${imu.gyroX} ${imu.gyroY} ${imu.gyroZ}');
          } else {
            running = false;
          }
      }
    }
  }

  /// 2의 보수
  num complement(value) {
    if ((value & (1 << (16 - 1))) != 0) value = value - (1 << 16);
    return value;
  }

  @override
  void onClose() {
    _connection.value?.dispose();
    super.onClose();
  }
}
