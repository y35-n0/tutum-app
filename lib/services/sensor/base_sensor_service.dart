import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tutum_app/app/constant/service_constant.dart';
import 'package:tutum_app/services/service_interface.dart';

class BaseSensorService extends GetxService implements ServiceInterface {
  final _isRunning = false.obs;

  @override
  bool get isRunning => _isRunning.value;

  /// 서비스 시작
  @override
  void run() {
    _isRunning.value = true;
    readAndSendData();
  }

  /// 서비스 종료
  @override
  void stop() {
    _isRunning.value = false;
  }

  /// x초마다 데이터 가져오기
  @protected
  void readAndSendData() async {
    Timer.periodic(Duration(seconds: ServiceConstants.DURATION_SECONDS), (timer) async {
      // 타이머 종료
      if (!(_isRunning.value)) {
        timer.cancel();
      }
      await readData();
      await sendData();
      // TODO: 센서 데이터 처리 및 전송하기
    });
  }

  /// 데이터 가져오기
  /// 가져오는 방식을 표현해야 함
  @protected
  Future<void> readData() async {}

  @protected
  Future<void> sendData() async {}

// TODO: 센서 데이터 처리 및 전송하기
}
