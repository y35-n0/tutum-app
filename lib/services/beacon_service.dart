import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'package:tutum_app/app/constant/bluetooth_constrant.dart';
import 'package:tutum_app/app/util/check_passed.dart';
import 'package:tutum_app/models/beacon/rssi.dart';
import 'package:tutum_app/models/beacon/beacon.dart';
import 'package:tutum_app/models/device.dart';

const SCAN_DURATION = Duration(days: 1);

/// 블루투스 상태 관리 및 센서 상태 관리 서비스
/// [_flutterBlue] 블루투스 사용을 위한 flutter_blue 객체
/// [_isScanning]  scan 기능 활성화 유무 [_isRunning] 시스템 작동 여부
/// [_scanResult] 현재 탐색된 디바이스, [_beacons] 탐지된 beacons
class BeaconService extends GetxService {
  static BeaconService get to => Get.find();

  final FlutterBlue _flutterBlue = FlutterBlue.instance;
  final Rx<BluetoothState> _bluetoothState = BluetoothState.unknown.obs;
  final Rx<bool> _isScanning = false.obs;
  final Rx<bool> _isRunning = false.obs;
  final Rxn<ScanResult> _scanResult = Rxn<ScanResult>();

  // 데이터 저장
  final RxMap<String, Beacon> _beacons = <String, Beacon>{}.obs;
  final CheckPassed _checkPassed = CheckPassed();

  final List<Worker> workers = [];

  BluetoothState get bluetoothState => _bluetoothState.value;
  List<Device> get beacons => getDevices();

  bool get isRunning => _isRunning.value;

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
        // 실행 중이 아니면 종료
        if (!isRunning) return;
        // Tutum 비콘이 아니면 종료
        if (!result.device.name.startsWith(DEVICE_NAME)) return;

        // rssi 데이터 추가
        if (!_beacons.containsKey(result.device.name)) {
          _beacons[result.device.name] = Beacon.fromScanResult(result);
        }
        _beacons[result.device.name]!.add(Rssi(result.rssi));


        _beacons.refresh();
        // TODO: RSSI를 이용한 문 통과 확인 로직
        // TODO: 데이터 Parsing 및 API 전송
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
  void run() {
    if (!isRunning) {
      _beacons.clear();
      _flutterBlue.startScan(
        timeout: SCAN_DURATION,
        allowDuplicates: true,
      );
      _isRunning(true);
    }
  }

  /// Beacon 스캔 종료
  void stop() {
    if (isRunning) {
      _flutterBlue.stopScan();
      _isRunning(false);
    }
  }

  // for test
  /// device 반환
  List<Device> getDevices() {
    return _beacons.values.map<Device>((value) => value.device).toList();
  }

  /// 종료할 때 worker들 모두 종료
  @override
  void onClose() {
    stop();
    workers.forEach((worker) => worker.dispose());
    super.onClose();
  }
}
