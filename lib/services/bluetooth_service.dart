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
  final RxList<BluetoothDevice> _connectedDevices = <BluetoothDevice>[].obs;
  final Rxn<BluetoothDevice> _sensor = Rxn<BluetoothDevice>();
  final Rx<BluetoothDeviceState> _sensorState =
      BluetoothDeviceState.disconnected.obs;

  BluetoothState get bluetoothState => _bluetoothState.value;

  BluetoothDeviceState get sensorState => _sensorState.value;

  String get sensorID => _sensor.value?.id.toString() ?? 'N/A';

  @override
  void onInit() {
    /// 블루투스 서비스 상태 관찰
    _bluetoothState.bindStream(flutterBlue.state);
    _connectedDevices.bindStream(flutterBlue.connectedDevices.asStream());

    enrollWorker();

    super.onInit();
  }

  /// 연결된 기기 확인 및 센서 정보 등록
  void findConnectedDevice() async {
    _connectedDevices.forEach((device) {
      // 연결된 센서가 있으면 센서 정보 저장
      if (device.name.startsWith('TUTUM')) {
        print('센서 연결됨 : ${device.name}, ${device.id}');
        _sensor(device);
        _sensorState.bindStream(device.state);
        return;
      }
    });
  }

  void enrollWorker() {
    /// 블루투스 서비스가 켜지면 연결된 기기 확인 및 센서 정보 등록
    /// 블루투스 서비스가 꺼지면 센서 정보 초기화
    ever(_bluetoothState, (state) {
      if (state == BluetoothState.on) {
        findConnectedDevice();
      } else {
        _sensor.value = null;
        _sensorState(BluetoothDeviceState.disconnected);
        _connectedDevices.value = [];
      }
    });

    /// 센서 연결이 끊기면 센서 정보 초기화
    ever(_sensorState, (state) {
      if (state != BluetoothDeviceState.connected) {
        _sensor.value = null;
      }
    });

    /// 등록된 센서가 없을 때 연결된 디바이스 목록이 바뀐 후 1초 후 마다 기기 확인 및 센서 정보 등록
    debounce(_connectedDevices, (devices) {
      print((devices as List<BluetoothDevice>).length.toString());
      if (_sensor.value == null) {
        findConnectedDevice();
      }
    }, time: Duration(seconds: 1));
  }

// TODO: 3. 블루투스 스캔 목록 확인
// RxList<BluetoothDevice> connectedDevices = <BluetoothDevice>[].obs;
// Rx<bool> isScanning = false.obs;
// RxList<ScanResult> scanResult = <ScanResult>[].obs;
// void scanSensors(String id) {}
//
// TODO: 4. 블루투스 디바이스 연결
// Rx<bool> isDiscoveringServices = false.obs;
// void connectSensor(BluetoothDevice device) {}

// TODO: 5. 블루투스 서비스 확인

// TODO: 6. 블루투스 특성 확인

}
