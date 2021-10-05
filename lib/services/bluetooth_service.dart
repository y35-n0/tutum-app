import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'package:tutum_app/app/constant/bluetooth_constant.dart';
import 'package:tutum_app/services/sensor/base_sensor_service.dart';

// FIXME: 기능 분리하기

/// 블루투스 상태 관리 및 센서 상태 관리 서비스
/// [flutterBlue] 블루투스 사용을 위한 flutter_blue 객체, [_bluetoothState] 블루투스 서비스 싱태,
/// [_sensor] 연결된 센서 디바이스, [_sensorState] 센서 디바이스 연결 상태,
/// [_services] 센서 디바이스의 서비스들, [_characteristics] 센서 서비스의 특성들,
/// [_rawPressure], [_rawTemperature], [_rawAcceleration] 센서 raw 데이터
class BTService extends BaseSensorService {
  static BTService get to => Get.find();

  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final Rx<BluetoothState> _bluetoothState = BluetoothState.unknown.obs;
  final Rxn<BluetoothDevice> _sensor = Rxn<BluetoothDevice>();
  final Rx<BluetoothDeviceState> _sensorState =
      BluetoothDeviceState.disconnected.obs;
  final Rx<String> _findingDeviceId = ''.obs;
  final RxList<BluetoothDevice> _connectedDevices = <BluetoothDevice>[].obs;
  final RxList<ScanResult> _scanResults = <ScanResult>[].obs;

  Map<int, BluetoothService> _services = {};
  Map<String, BluetoothCharacteristic> _characteristics = {};

  final RxList<int> _rawAcceleration = <int>[].obs;
  final RxList<double> _acceleration = <double>[].obs;

  final RxList<int> _rawTemperature = <int>[].obs;
  final Rx<double> _temperature = (0.0).obs;

  final RxList<int> _rawPressure = <int>[].obs;
  final Rx<double> _pressure = (0.0).obs;

  List<Worker> workers = [];

  final Rx<bool> _isRunning = false.obs;

  BluetoothState get bluetoothState => _bluetoothState.value;

  BluetoothDeviceState get sensorState => _sensorState.value;

  String? get sensorID => _sensor.value?.id.toString();

  List<BluetoothDevice> get connectedDevices => _connectedDevices;

  List<ScanResult> get scanResults => _scanResults;

  List<double>? get acceleration => _acceleration;

  double? get temperature => _temperature.value;

  double? get pressure => _pressure.value;

  bool get isRunning => _isRunning.value;

  @override
  void onInit() {
    /// 블루투스 서비스 상태 관찰
    _bluetoothState.bindStream(flutterBlue.state);
    Stream<List<BluetoothDevice>> connectedDevicesStream =
        getConnectedDevicesStream();
    _connectedDevices.bindStream(connectedDevicesStream);
    _scanResults.bindStream(flutterBlue.scanResults);
    flutterBlue.scanResults.listen((data) => _scanResults.refresh());

    initDeviceWorker();
    initValueWorker();
    super.onInit();
  }

  /// Future인 connectedDevices를 변경된 값을 반환하는 Stream으로 변경
  Stream<List<BluetoothDevice>> getConnectedDevicesStream() async* {
    List<BluetoothDevice> before = [], after;
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      after = await flutterBlue.connectedDevices;
      if (before.length != after.length) {
        yield after;
      }
      before = after;
    }
  }

  /// 디바이스 연결할 때 필요한 값이 변경되었을 때 할일 등록
  void initDeviceWorker() {
    workers.addAll([
      /// 블루투스 서비스가 켜지면 연결된 기기 확인 및 센서 정보 등록
      /// 블루투스 서비스가 꺼지면 센서 정보 초기화
      ever(_bluetoothState, (state) {
        if (state == BluetoothState.on) {
          _findConnectedSensor();
        } else {
          _resetSensor();
        }
      }),

      /// 센서 연결이 끊기면 센서 정보 초기화
      ever(_sensorState, (state) {
        if (state != BluetoothDeviceState.connected) {
          _resetSensor();
        }
      }),

      /// 등록된 센서가 없을 때 연결된 디바이스 목록에서 센서 탐색 및 정보 등록
      ever(_connectedDevices, (devices) {
        if (_sensor.value == null) {
          _findConnectedSensor();
        }
      }),

      /// 스캔된 디바이스 중 연결할 디바이스 ID와 일치하는 센서 연결
      ever(_findingDeviceId, (id) {
        if (id != '') {
          _scanResults.forEach((result) async {
            if (result.device.id == DeviceIdentifier((id as String))) {
              await _connectDevice(result.device);
              _findingDeviceId('');
            }
          });
        }
      }),

      ever(_isRunning, (bool isRunning) async {
        await Future.forEach(
            _characteristics.values,
            (BluetoothCharacteristic c) async =>
                await c.setNotifyValue(isRunning));
      }),
    ]);
  }

  /// 데이터 값이 변경되었을 때 할일 등록
  void initValueWorker() {
    workers.addAll([
      ever(_rawAcceleration, (List<int> raw) {
        if (raw.isEmpty) return;
        String tmpString = String.fromCharCodes(raw);
        List<String> tmpList = tmpString.split(' ').sublist(0, 3);
        _acceleration.value =
            tmpList.map((element) => double.parse(element)).toList();
      }),
      ever(_rawTemperature, (List<int> raw) {
        if (raw.isEmpty) return;
        ByteBuffer buffer = Int8List.fromList(raw).buffer;
        ByteData byteData = ByteData.view(buffer);
        _temperature.value = byteData.getFloat32(0, Endian.little);
      }),
      ever(_rawPressure, (List<int> raw) {
        if (raw.isEmpty) return;
        ByteBuffer buffer = Int8List.fromList(raw).buffer;
        ByteData byteData = ByteData.view(buffer);
        _pressure.value = byteData.getFloat32(0, Endian.little);
      }),
    ]);
  }

  /// 연결된 기기 확인 및 센서 정보 등록
  Future<void> _findConnectedSensor() async {
    _connectedDevices.forEach((device) async {
      // 연결된 센서가 있으면 센서 정보 저장
      // FIXME: Arduino 빼기
      if (device.name.startsWith('TUTUM') ||
          device.name.startsWith('Arduino')) {
        _sensor.value = device;
        _sensorState.bindStream(device.state);
        await _enrollServices(device);
        await Future.forEach(_services.entries,
            (MapEntry e) async => await _enrollCharacteristics(e.key, e.value));
        if (Platform.isAndroid) await device.requestMtu(128);
        return;
      }
    });
  }

  /// 블루투스 기기를 스캔하여 특정 기기와 연결
  void scanDevices() async =>
      flutterBlue.startScan(timeout: Duration(seconds: 5));

  /// 디바이스 연결
  void findDevice(String id) => _findingDeviceId.value = id;

  Future<void> _connectDevice(BluetoothDevice device) async {
    await device.connect();
  }

  /// 디바이스 연결 해제
  void disconnectSensor() async => await _sensor.value!.disconnect();

  void _resetSensor() {
    _sensor.value = null;
    _sensorState.value = BluetoothDeviceState.disconnected;
    _services = {};
    _characteristics = {};
  }

  /// 서비스 등록
  Future<void> _enrollServices(BluetoothDevice device) async {
    List<BluetoothService> services = await device.discoverServices();
    services.forEach((service) {
      int index =
          BLEServices.serviceUuids.indexWhere((uuid) => uuid == service.uuid);
      if (index != -1) {
        _services.addAll({index: service});
      }
    });
  }

  /// 서비스별 특성 등록
  Future<void> _enrollCharacteristics(
      int serviceIndex, BluetoothService service) async {
    List<BLECharacteristic> constCharacteristics =
        BLEServices.services[serviceIndex].characteristics;

    List<BluetoothCharacteristic> characteristics = service.characteristics;
    await Future.forEach(characteristics,
        (BluetoothCharacteristic characteristic) async {
      int index =
          constCharacteristics.indexWhere((c) => c.uuid == characteristic.uuid);
      if (index != -1) {
        String name = constCharacteristics[index].name;
        _characteristics.addAll({name: characteristic});
        // 특성 종류마다 바인딩
        switch (name) {
          case 'acceleration':
            _rawAcceleration.bindStream(characteristic.value);
            break;
          case 'temperature':
            _rawTemperature.bindStream(characteristic.value);
            break;
          case 'pressure':
            _rawPressure.bindStream(characteristic.value);
            break;
        }
      }
    });
  }

  /// 특성 notify 설정 변경
  void switchCharacteristicsNotify([bool? isNotifying]) async {
    _isRunning.value = isNotifying ?? !_isRunning.value;
  }

  @override
  void run() {
    _isRunning.value = true;
  }

  @override
  void stop() {
    _isRunning.value = false;
  }

  @override
  void onClose() {
    workers.forEach((worker) => worker.dispose());
  }
}
