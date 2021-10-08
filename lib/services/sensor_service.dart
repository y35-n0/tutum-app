import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'package:tutum_app/services/sensor/base_sensor_service.dart';

const SENSOR_NAME = "TUTUM";

/// [bluetoothState] 블루투스 상태
class SensorService extends BaseSensorService {
  static SensorService get to => Get.find();

  final FlutterBluetoothSerial _flutterBluetoothSerial =
      FlutterBluetoothSerial.instance;
  final Rx<BluetoothState> _bluetoothState = BluetoothState.UNKNOWN.obs;

  final Rxn<BluetoothDevice> _sensor = Rxn<BluetoothDevice>();
  final Rxn<BluetoothConnection> _connection = Rxn<BluetoothConnection>();
  final Rx<bool> _isDiscovering = false.obs;

  List<Worker> workers = [];

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

    super.onInit();
  }

  // for test page
  /// 기기 탐색
  void startDiscovery() async {
    await cancelDiscovery();
    _discoveredResultsMap.clear();

    _isDiscovering.value = true;
    _flutterBluetoothSerial.startDiscovery().listen((result) async {
      _discoveredResultsMap[result.device.address] = result;
    }, onDone: (() {
      _isDiscovering.value = false;
    }));
  }

  /// 탐색 종료
  Future<void> cancelDiscovery() async {
    if (isDiscovering) {
      await _flutterBluetoothSerial.cancelDiscovery();
    }
  }

  /// 기기 연결
  void connect(String address) async {
    await disconnect();

    _isDiscovering.value = true;
    _flutterBluetoothSerial.startDiscovery().listen((result) async {
      if ((result.device.address == address) &&
          (result.device.name?.startsWith(SENSOR_NAME) ?? false)) {
        _connection.value = await BluetoothConnection.toAddress(address);
        _sensor.value = result.device;
      }
    }, onDone: (() {
      _isDiscovering.value = false;
    }));
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
