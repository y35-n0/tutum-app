import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';

/// 블루투스 상태 관리 및 센서 상태 관리 서비스
/// [flutterBlue] 블루투스 사용을 위한 flutter_blue 객체, [_bluetoothState] 블루투스 서비스 싱태,
/// [_sensor] 연결된 센서 디바이스, [_sensorState] 센서 디바이스 연결 상태,
/// [_services] 센서 디바이스의 서비스들
class BTService extends GetxService {
  static BTService get to => Get.find();

  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final Rx<BluetoothState> _bluetoothState = BluetoothState.unknown.obs;
  final Rxn<BluetoothDevice> _sensor = Rxn<BluetoothDevice>();
  final Rx<BluetoothDeviceState> _sensorState =
      BluetoothDeviceState.disconnected.obs;
  final Rx<String> _findingDeviceId = ''.obs;
  final RxList<BluetoothDevice> _connectedDevices = <BluetoothDevice>[].obs;
  final RxList<ScanResult> _scanResults = <ScanResult>[].obs;

  List<Worker> workers = [];

  BluetoothState get bluetoothState => _bluetoothState.value;

  BluetoothDeviceState get sensorState => _sensorState.value;

  String? get sensorID => _sensor.value?.id.toString();

  RxList<BluetoothDevice> get connectedDevices => _connectedDevices;

  RxList<ScanResult> get scanResults => _scanResults;

  @override
  void onInit() {
    /// 블루투스 서비스 상태 관찰
    _bluetoothState.bindStream(flutterBlue.state);
    Stream<List<BluetoothDevice>> connectedDevicesStream =
        getConnectedDevicesStream();
    _connectedDevices.bindStream(connectedDevicesStream);
    _scanResults.bindStream(flutterBlue.scanResults);
    flutterBlue.scanResults.listen((data) => _scanResults.refresh());

    enrollWorker();
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

  /// 값이 변경되었을 때 할일 등록
  void enrollWorker() {
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
        if (_sensorState.value != BluetoothDeviceState.connected) {
          _findConnectedSensor();
        }
      }),

      /// 스캔된 디바이스 중 연결할 디바이스 ID와 일치하는 센서 연결
      ever(_findingDeviceId, (id) {
        if (id != '') {
          _scanResults.forEach((result) async {
            if (result.device.id == DeviceIdentifier((id as String))) {
              _connectDevice(result.device);
              _findingDeviceId('');
            }
          });
        }
      }),
    ]);
  }

  /// 연결된 기기 확인 및 센서 정보 등록
  void _findConnectedSensor() async {
    _connectedDevices.forEach((device) {
      // 연결된 센서가 있으면 센서 정보 저장
      if (device.name.startsWith('TUTUM')) {
        _sensor(device);
        _sensorState.bindStream(device.state);
        _discoverServices();
        return;
      }
    });
  }

  /// 블루투스 기기를 스캔하여 특정 기기와 연결
  void scanDevices() async {
    flutterBlue.startScan(timeout: Duration(seconds: 5));
  }

  /// 디바이스 연결
  void findDevice(String id) {
    _findingDeviceId.value = id;
  }

  void _connectDevice(BluetoothDevice device) async {
    await device.connect();
  }

  /// 디바이스 연결 해제
  void disconnectSensor() async {
    await _sensor.value!.disconnect();
  }

  void _resetSensor() {
    _sensor(null);
    _sensorState(BluetoothDeviceState.disconnected);
  }

// TODO: 5. 블루투스 서비스 확인
  void _discoverServices() async {
    List<BluetoothService> services = await _sensor.value!.discoverServices();
    services.forEach((element) {});
  }

// TODO: 6. 블루투스 특성 확인

  @override
  void onClose() {
    workers.forEach((worker) => worker.dispose());
  }


}
