import 'dart:math';
import 'dart:developer';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'package:tutum_app/app/constant/bluetooth_constant.dart';
import 'package:tutum_app/app/util/server_api.dart';
import 'package:tutum_app/app/util/theil_sen.dart';
import 'package:tutum_app/models/pass/pass.dart';
import 'package:tutum_app/models/pass/rssi.dart';
import 'package:tutum_app/models/pass/beacon.dart';
import 'package:tutum_app/models/pass/check_is_passed_result.dart';
import 'package:tutum_app/models/device.dart';
import 'package:tutum_app/models/sensor_data.dart';

const _SLICE_SECONDS = 6;
const _SCAN_DURATION = Duration(days: 1);
const _PROCESSING_BEACONS_INTERVAL = Duration(seconds: 1);
const _SENDING_DATA_INTERVAL = Duration(seconds: 1);

/// 블루투스 상태 관리 및 센서 상태 관리 서비스
/// [_flutterBlue] 블루투스 사용을 위한 flutter_blue 객체
/// [_isRunning] 프로세스 작동 상태
/// [_beaconMap] 탐지된 beacons
class BeaconService extends GetxService {
  static BeaconService get to => Get.find();

  final FlutterBlue _flutterBlue = FlutterBlue.instance;
  final Rx<BluetoothState> _bluetoothState = BluetoothState.unknown.obs;
  final Rx<bool> _isRunning = false.obs;

  // 비콘 관련
  final RxMap<String, Beacon> _beaconMap = <String, Beacon>{}.obs;

  // 로직 관련
  final TheilSen _theilSen = TheilSen();

  // 데이터 관련
  final Rx<SensorData> _sensorData = SensorData().obs;

  late Worker _processingDataWorker;
  late Worker _sendDataWorker;

  List<Device> get beacons => getDevices();

  bool get isEnabled => _bluetoothState.value == BluetoothState.on;

  bool get isRunning => _isRunning.value;

  // for test
  SensorData get sensorData => _sensorData.value;

  @override
  void onInit() {
    _bluetoothState.bindStream(_flutterBlue.state);
    _flutterBlue.isScanning.listen((isScanning) {
      if (isRunning ^ isScanning) {
        _isRunning(isScanning);
      }
    });
    _flutterBlue.scanResult.listen((result) {
      _processingScanResult(result);
    });
    initWorkers();
    super.onInit();
  }

  void initWorkers() {
    /// 비콘 rssi 데이터에 따라 지나감 여부를 판별함
    _processingDataWorker = interval(_beaconMap, (beaconMap) {
      beaconMap as Map<String, Beacon>;
      _checkIsPassedBeacons(beaconMap);
    }, time: _PROCESSING_BEACONS_INTERVAL);

    _sendDataWorker = interval(_sensorData, (sensorData) {
      sensorData as SensorData;
      _sending(sensorData);
    }, time: _SENDING_DATA_INTERVAL);
  }

  /// 탐색한 기기가 TUTUM 비콘 이라면 경우 RSSI를 추가함.
  void _processingScanResult(ScanResult result) {
    // 실행 중이 아니면 종료
    if (!isRunning) return;
    // Tutum 비콘이 아니면 종료
    if (!result.device.name.startsWith(DEVICE_NAME)) return;

    // rssi 데이터 추가
    if (!_beaconMap.containsKey(result.device.name)) {
      _beaconMap[result.device.name] = Beacon.fromScanResult(result);
    }
    _beaconMap[result.device.name]!.add(Rssi(result.rssi));

    _beaconMap.refresh();
  }

  /// 각 비콘 별로 지나감 여부를 판별함
  void _checkIsPassedBeacons(Map<String, Beacon> beaconMap) {
    // print("_checkIsPassedBeacons ${beaconMap.length}");
    beaconMap.values.forEach((beacon) {
      _checkIsPassedBeacon(beaconMap, beacon);
    });
  }

  /// 비콘을 지나갔는지 판별
  void _checkIsPassedBeacon(Map<String, Beacon> beaconMap, Beacon beacon) {
    // print("_checkIsPassedBeacon ${beacon.id} ${beacon.value.length}");

    beacon.slice(_SLICE_SECONDS);
    if (beacon.isNotEmpty) {
      final result = _checkPassed(beacon.value);
      // print(
      //     "${beacon.updated} ${result.isPassed} ${result.direction} ${result.isPassed ? beacon.list[result.index].timestamp.toString() : ""}");

      if (result.isPassed) {
        _sensorData.value.add(Pass(
          id: beacon.id,
          timestamp: beacon.list[result.index].timestamp,
          direction: result.direction,
        ));
        _sensorData.refresh();
      }
    } else {
      beaconMap.remove(beacon.address);
    }
  }

  /// rssi로 지나갔는지 확인 후 결과 전달
  CheckIsPassedResult _checkPassed(List<int> data) {
    final expression = _theilSen.calculate(data);
    if (expression.a == 0)
      return CheckIsPassedResult(
        isPassed: false,
        index: -1,
        direction: DIRECTION.UNKNOWN,
      );

    int rawMaxY = data.reduce(max);
    int rawMaxX = data.indexOf(rawMaxY);

    num predMaxX = -expression.b / (2 * expression.a);

    bool isClose = rawMaxY >= -50;
    bool isConcave = expression.a < 0;

    bool isPassed = isClose & isConcave;
    int index = isPassed ? rawMaxX : -1;
    DIRECTION direction = isPassed
        ? ((rawMaxX - predMaxX > 0) ? DIRECTION.OUT_IN : DIRECTION.IN_OUT)
        : DIRECTION.UNKNOWN;

    return CheckIsPassedResult(
      isPassed: isPassed,
      index: index,
      direction: direction,
    );
  }

  /// pass 데이터 전송
  void _sending(SensorData sensorData) {
    sensorDataApi(sensorData, 0);
    sensorData.clear();
  }

  /// Beacon 스캔 시작
  void run() {
    if (!isRunning) {
      _beaconMap.clear();
      _flutterBlue.startScan(
        timeout: _SCAN_DURATION,
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
    return _beaconMap.values.map<Device>((value) => value.device).toList();
  }

  /// 종료할 때 worker들 모두 종료
  @override
  void onClose() {
    stop();
    _processingDataWorker.dispose();
    _sendDataWorker.dispose();
    super.onClose();
  }
}
