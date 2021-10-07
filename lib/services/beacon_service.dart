import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'package:tutum_app/models/beacon.dart';
import 'package:tutum_app/services/sensor/base_sensor_service.dart';

const SCAN_DURATION = Duration(days: 1);
const DEVICE_NAME = "TUTUM";

/// 블루투스 상태 관리 및 센서 상태 관리 서비스
/// [_flutterBlue] 블루투스 사용을 위한 flutter_blue 객체
/// [_isScanning]  scan 기능 활성화 유무 [_isRunning] 시스템 작동 여부
/// [_scanResult] 현재 탐색된 디바이스, [_beacons] 탐지된 beacons
class BeaconService extends BaseSensorService {
  static BeaconService get to => Get.find();

  final FlutterBlue _flutterBlue = FlutterBlue.instance;
  final Rx<BluetoothState> _bluetoothState = BluetoothState.unknown.obs;
  final Rx<bool> _isScanning = false.obs;
  final Rx<bool> _isRunning = false.obs;
  final Rxn<ScanResult> _scanResult = Rxn<ScanResult>();
  final RxList<Beacon> _beacons = <Beacon>[].obs;

  final List<Worker> workers = [];

  BluetoothState get bluetoothState => _bluetoothState.value;

  bool get isRunning => _isRunning.value;

  List<Beacon> get beacons => _beacons;

  @override
  void onInit() {
    _bluetoothState.bindStream(_flutterBlue.state);
    _isScanning.bindStream(_flutterBlue.isScanning);
    _scanResult.bindStream(_flutterBlue.scanResult);
    initWorkers();
    super.onInit();
  }

  void initWorkers() {
    /// rssi 상태 관찰
    workers.addAll([
      ever(_scanResult, (result) {
        result as ScanResult;
        if (isRunning) {
          if (result.device.name.startsWith(DEVICE_NAME)) {
            int index = _beacons.indexWhere(
                (Beacon _beacon) => _beacon.device.id == result.device.id);

            if (index == -1) {
              _beacons.add(Beacon.fromScanResult(result));
            } else {
              _beacons[index].update(result);
              _beacons.refresh();
            }
            // TODO: RSSI를 이용한 문 통과 확인 로직
            // TODO: 데이터 Parsing 및 API 전송
          }
        }
      }),

      /// isScanning에 따라서 isRunning 도 변경함.
      ever(_isScanning, (isScanning) {
        isScanning as bool;
        if (isRunning ^ isScanning) {
          _isRunning.value = isScanning;
        }
      }),
    ]);
  }

  /// Beacon 스캔 시작
  @override
  void run() {
    if (!isRunning) {
      _beacons.value = [];
      _flutterBlue.startScan(
        timeout: SCAN_DURATION,
        allowDuplicates: true,
      );
      _isRunning(true);
    }
  }

  /// Beacon 스캔 종료
  @override
  void stop() {
    if (isRunning) {
      _flutterBlue.stopScan();
      _isRunning(false);
    }
  }

  /// 종료할 때 worker들 모두 종료
  @override
  void onClose() {
    super.onClose();
    workers.forEach((worker) => worker.dispose());
  }
}
