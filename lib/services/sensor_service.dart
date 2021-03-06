import 'dart:async';
import 'dart:typed_data';
import 'dart:developer';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';

import 'package:tutum_app/app/constant/bluetooth_constant.dart';
import 'package:tutum_app/app/util/server_api.dart';
import 'package:tutum_app/app/util/util.dart';
import 'package:tutum_app/models/device.dart';
import 'package:tutum_app/models/sensor_data.dart';
import 'package:tutum_app/models/sensors/capacity.dart';
import 'package:tutum_app/models/sensors/imu.dart';
import 'package:tutum_app/models/sensors/oxygen.dart';
import 'package:tutum_app/models/sensors/temperature.dart';
import 'package:tutum_app/services/auth_service.dart';
import 'package:tutum_app/services/state_service.dart';

const SENSOR_NAME = "TUTM";
const DISCOVERY_DURATION_SECONDS = 5;
const TRY_CONNECT_DURATION_SECONDS = 1;
const TRY_CONNECT_INTERVAL_SECONDS = 1;
const MAX_CONNECT_RETRY_COUNT = 5;
const PROCESSING_DATA_INTERVAL = Duration(milliseconds: 200);
const SENDING_DATA_INTERVAL = Duration(seconds: 10);

/// [_bluetoothState] 블루투스 상태, [isEnable] 블루투스 사용 가능 여부, [_isDiscovering] 스캔 중 여부,
/// [_address] 연결된 센서 주소, [_connection] 센서 연결 정보
/// [_rawData] Raw Data, [_rawDataWorker] Raw data 처리 워커

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
  final Rxn<DateTime> _connectedTime = Rxn<DateTime>();

  // 데이터 관련
  final RxList<int> _rawData = <int>[].obs;
  late List<int> _rawDataMag = <int>[];
  late Worker _rawDataWorker;
  late Worker _sensorDataWorker;

  bool _isProcessing = true;

  int _count = 0;
  int _cntSend = 0;

  // 파싱된 데이터
  final Rx<SensorData> _sensorData = SensorData().obs;

  bool get isEnabled => _bluetoothState.value == BluetoothState.STATE_ON;

  bool get isDiscovering => _isDiscovering.value;

  String get sensorAddress => _address.value;

  String get sensorName => _name.value;

  bool get sensorIsConnected => _connection.value?.isConnected ?? false;

  String get sensorConnectedTime => _connectedTime.value == null
      ? ""
      : Util.formatter.format(_connectedTime.value!);

  SensorData get sensorData => _sensorData.value;

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

    initWorkers();
  }

  /// 데이터 처리용 worker 등록
  void initWorkers() {
    _rawDataWorker = interval(_rawData, (rawData) {
      rawData as List<int>;
      _processing(rawData);
    }, time: PROCESSING_DATA_INTERVAL);

    _sensorDataWorker = interval(_sensorData, (sensorData) {
      sensorData as SensorData;
      _sending(sensorData);
    }, time: SENDING_DATA_INTERVAL);
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
        .where((BluetoothDevice device) =>
            device.name?.startsWith(SENSOR_NAME) ?? false)
        .toList();
    bondedSensors.forEach((BluetoothDevice sensor) {
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
        _gettingRawData(rawData);
      });

      _connectedTime.value = DateTime.now();
      log("connected");
      return true;
    } catch (error) {
      print(error);
      return false;
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

  /// [address]를 [TRY_CONNECT_INTERVAL_SECONDS]초 간격으로 [maxRetryCount]횟수 만큼 탐색 시도
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

  /// raw 데이터 처리
  void _gettingRawData(Uint8List rawData) {
    // print("_gettingRawData $rawData");
    _rawData.addAll(rawData);
  }

  /// rawData worker
  // TODO: 실행 TEST
  // TODO: 간략하게 만들기
  void _processing(List<int> rawData) {
    // print(rawData.map((d) => d.toRadixString(16)));
    _isProcessing = true;
    SENSOR_TYPE? type;
    while (_isProcessing) {
      // log(_count.toString());
      switch (_count) {
        case COUNT_START:
          // 시작 지점 찾기
          int index = SIGN_START.length - 2;
          do {
            index =
                rawData.indexOf(SIGN_START[SIGN_START.length - 1], index + 1);
          } while (index > -1 &&
              !_isSignStart(
                  rawData.sublist(index - (SIGN_START.length - 1), index + 1)));

          if (rawData.length >= LENGTH_START && index > -1) {
            log("START $_cntSend");
            _count++;
            rawData.removeRange(0, index + 1);
          } else {
            _isProcessing = false;
          }
          continue;

        case COUNT_TEMPERATURE:
          type = SENSOR_TYPE.TEMPERATURE;
          if (rawData.length >= DATA_LENGTH[type]!) {
            _count++;
            final data =
                Temperature.fromIntList(rawData.sublist(0, DATA_LENGTH[type]!));

            _sensorData.value.add(data);
            _sensorData.refresh();
            rawData.removeRange(0, DATA_LENGTH[type]!);
            StateService.to.addSensorData(data);

            // print("${data.temperature}");
          } else {
            _isProcessing = false;
          }
          break;

        case COUNT_IMU_NEXT_TEMPERATURE:
          type = SENSOR_TYPE.IMU;

          if (rawData.length >= DATA_LENGTH[type]!) {
            _count++;
            final data = Imu.fromIntList(
                rawData.sublist(0, DATA_LENGTH[type]!) + _rawDataMag);

            rawData.removeRange(0, DATA_LENGTH[type]!);
            _sensorData.value.add(data);
            _sensorData.refresh();
            // print(
            //     "${imu.accX} ${imu.accY} ${imu.accZ} ${imu.gyroX} ${imu.gyroY} ${imu.gyroZ} ");
          } else {
            _isProcessing = false;
          }
          break;

        case COUNT_CAPACITY:
          type = SENSOR_TYPE.CAPACITY;
          if (rawData.length >= DATA_LENGTH[type]!) {
            _count++;
            final data =
                Capacity.fromIntList(rawData.sublist(0, DATA_LENGTH[type]!));

            _sensorData.value.add(data);
            _sensorData.refresh();
            rawData.removeRange(0, DATA_LENGTH[type]!);
            StateService.to.addSensorData(data);

            // print("${data.capacity}");
          } else {
            _isProcessing = false;
          }
          break;

        case COUNT_MAG_NEXT_CAPACITY:
          type = SENSOR_TYPE.MAG;
          if (rawData.length >= DATA_LENGTH[type]!) {
            _count++;
            _rawDataMag = rawData.sublist(0, DATA_LENGTH[type]);
            rawData.removeRange(0, DATA_LENGTH[type]!);
          } else {
            _isProcessing = false;
          }
          break;
        case COUNT_IMU_NEXT_CAPACITY:
          type = SENSOR_TYPE.IMU;

          if (rawData.length >= DATA_LENGTH[type]!) {
            _count++;
            final data = Imu.fromIntList(
                rawData.sublist(0, DATA_LENGTH[type]!) + _rawDataMag);

            rawData.removeRange(0, DATA_LENGTH[type]!);
            _sensorData.value.add(data);
            _sensorData.refresh();
            // print(
            //     "${imu.accX} ${imu.accY} ${imu.accZ} ${imu.gyroX} ${imu.gyroY} ${imu.gyroZ} ");
          } else {
            _isProcessing = false;
          }
          break;
        case COUNT_OXYGEN:
          type = SENSOR_TYPE.OXYGEN;
          if (rawData.length >= DATA_LENGTH[type]!) {
            _count = 0;
            final data =
                Oxygen.fromIntList(rawData.sublist(0, DATA_LENGTH[type]!));

            _sensorData.value.add(data);
            _sensorData.refresh();
            rawData.removeRange(0, DATA_LENGTH[type]!);
            StateService.to.addSensorData(data);

            // print("${data.oxygen}");
          } else {
            _isProcessing = false;
          }
          break;
        default: // imu
          if (_count % 4 == 1) {
            type = SENSOR_TYPE.MAG;
            if (rawData.length >= DATA_LENGTH[type]!) {
              _count++;
              _rawDataMag = rawData.sublist(0, DATA_LENGTH[type]);
              rawData.removeRange(0, DATA_LENGTH[type]!);
              // log(_rawDataMag.map((e) => e.toRadixString(2)).toString());
            } else {
              _isProcessing = false;
            }
          } else {
            type = SENSOR_TYPE.IMU;

            if (rawData.length >= DATA_LENGTH[type]!) {
              _count++;
              final data = Imu.fromIntList(
                  rawData.sublist(0, DATA_LENGTH[type]!) + _rawDataMag);

              rawData.removeRange(0, DATA_LENGTH[type]!);
              _sensorData.value.add(data);
              _sensorData.refresh();
              // print(
              //     "${imu.accX} ${imu.accY} ${imu.accZ} ${imu.gyroX} ${imu.gyroY} ${imu.gyroZ} ");
            } else {
              _isProcessing = false;
            }
          }
          break;
      }
    }
  }

  /// sign start인지 확인
  bool _isSignStart(List<int> list) {
    if (list.length < SIGN_START.length) return false;
    for (int i = 0; i < SIGN_START.length; i++) {
      if (list[i] != SIGN_START[i]) return false;
    }
    return true;
  }

  /// sensorData worker
  void _sending(SensorData sensorData) {
    sensorDataApi(sensorData, _cntSend++);
    sensorData.clear();
  }

  @override
  void onClose() {
    _connection.value?.dispose();
    _rawDataWorker.dispose();
    _sensorDataWorker.dispose();
    super.onClose();
  }
}
