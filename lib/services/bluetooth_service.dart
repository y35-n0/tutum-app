import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'package:tutum_app/app/constant/bluetooth_constant.dart';

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

  Map<int, BluetoothService> _services = {};
  Map<String, BluetoothCharacteristic> _characteristics = {};

  List<Worker> workers = [];

  BluetoothState get bluetoothState => _bluetoothState.value;

  BluetoothDeviceState get sensorState => _sensorState.value;

  String? get sensorID => _sensor.value?.id.toString();

  List<BluetoothDevice> get connectedDevices => _connectedDevices;

  List<ScanResult> get scanResults => _scanResults;


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
  void _findConnectedSensor() {
    _connectedDevices.forEach((device) async {
      // 연결된 센서가 있으면 센서 정보 저장
      if (device.name.startsWith('TUTUM')) {
        _sensor(device);
        _sensorState.bindStream(device.state);
        await _enrollServices(device);
        _services.forEach((serviceIndex, service) =>
            _enrollCharacteristics(serviceIndex, service));
        return;
      }
    });
  }

  /// 블루투스 기기를 스캔하여 특정 기기와 연결
  void scanDevices() async =>
      flutterBlue.startScan(timeout: Duration(seconds: 5));

  /// 디바이스 연결
  void findDevice(String id) => _findingDeviceId.value = id;

  void _connectDevice(BluetoothDevice device) async => await device.connect();

  /// 디바이스 연결 해제
  void disconnectSensor() async => await _sensor.value!.disconnect();

  void _resetSensor() {
    _sensor(null);
    _sensorState(BluetoothDeviceState.disconnected);
  }

  /// 블루투스 서비스 등록
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

  /// 블루투스 특성 등록
  void _enrollCharacteristics(
      int serviceIndex, BluetoothService service) async {
    List<BLECharacteristic> constCharacteristics =
        BLEServices.services[serviceIndex].characteristics;

    List<BluetoothCharacteristic> characteristics = service.characteristics;
    characteristics.forEach((characteristic) {
      int index =
          constCharacteristics.indexWhere((c) => c.uuid == characteristic.uuid);
      if (index != -1) {
        _characteristics
            .addAll({constCharacteristics[index].name: characteristic});
        characteristic.setNotifyValue(true);
      }
    });
  }

  @override
  void onClose() {
    workers.forEach((worker) => worker.dispose());
  }
}
