import 'dart:async';
import 'package:tutum_app/api/data_get_action.dart';
import 'package:tutum_app/api/permission_get_action.dart';
import 'package:geolocator/geolocator.dart';

class Service {
  final int seconds;
  bool isDisabled = true;


  Service({required this.seconds});

  /// 서비스 시작
  void run() async {
    this.isDisabled = false;
    _setAllPermission();
    _readAndSendData();
  }

  /// 서비스 종료
  void stop() {
    this.isDisabled = true;
  }

  void _setAllPermission() async {
    await PermissionGetAction.setPermissionWithService(Permission.location);
  }

  /// x초마다 데이터 가져오기
  void _readAndSendData() async {
    Timer.periodic(Duration(seconds: this.seconds), (timer) async {

      // 타이머 종료
      if(this.isDisabled) {
        timer.cancel();
      }

      // TODO: 각 센서 데이터 가져오기

      // 위치 데이터
      Position position = await DataGetAction.getPosition();

      // TODO: 각 센서 데이터 전송하기

      // TODO: 각 센서 데이터 처리하기


    });
  }


}
