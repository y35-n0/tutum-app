import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'package:tutum_app/models/discovery_result.dart';

const DISCOVERY_DURATION = Duration(days: 1);
const DEVICE_NAME = "TUTUM";

/// 블루투스 상태 관리 및 센서 상태 관리 서비스
/// [_flutterBlue] 블루투스 사용을 위한 flutter_blue 객체
/// [_isEnable]  블루투스 활성화 유무
/// [_isDiscovering]  discovery 기능 활성화 유무
/// [_discoveryResult] 현재 탐색된 디바이스

class BaseBluetoothService extends GetxService {
  static BaseBluetoothService get to => Get.find();

  final FlutterBlue _flutterBlue = FlutterBlue.instance;
  final Rx<bool> _isEnable = false.obs;
  final Rx<bool> _isDiscovering = false.obs;
  final Rxn<DiscoveryResult> _discoveryResult = Rxn<DiscoveryResult>();

  bool get isEnable => _isEnable.value;

  bool get isDiscovering => _isDiscovering.value;

  Stream<DiscoveryResult?> get discoveryResultStream => _discoveryResult.stream;



  /// 초기화 (Stream to Obx)
  @override
  void onInit() {
    StreamTransformer<BluetoothState, bool> transformBluetoothStateToBool =
        StreamTransformer<BluetoothState, bool>.fromHandlers(
      handleData: (state, sink) => sink.add(state == BluetoothState.on),
    );

    _isEnable.bindStream(
        _flutterBlue.state.transform(transformBluetoothStateToBool));

    _isDiscovering.bindStream(_flutterBlue.isScanning);

    StreamTransformer<ScanResult, DiscoveryResult>
        transformScanResultToDiscoveryResult =
        StreamTransformer<ScanResult, DiscoveryResult>.fromHandlers(
      handleData: (result, sink) =>
          sink.add(DiscoveryResult.fromScanResult(result)),
    );

    _discoveryResult.bindStream(
      _flutterBlue.scanResult.transform(transformScanResultToDiscoveryResult),
    );

    super.onInit();

  }

  /// 스캔 시작
  void startDiscovery() {
    if (!_isDiscovering.value) {
      _flutterBlue.startScan(
        timeout: DISCOVERY_DURATION,
        allowDuplicates: true,
      );
    }
  }

  /// 스캔 종료
  void stopDiscovery() {
    if (_isDiscovering.value) {
      _flutterBlue.stopScan();
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
