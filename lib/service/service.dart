import 'dart:async';
import 'package:tutum_app/api/location.dart';

class Service {
  final int seconds;
  bool isDisabled = true;


  // FIXME : GPS가 2초마다 수신 됨
  Service({required this.seconds});

  /// 서비스 시작
  void run() async {
    this.isDisabled = false;
    _readData();
  }

  /// 서비스 종료
  void stop() {
    this.isDisabled = true;
  }

  /// x초마다 데이터 가져오기
  void _readData() async {
    Timer.periodic(Duration(seconds: this.seconds), (timer) async {

      // 타이머 종료
      if(this.isDisabled) {
        timer.cancel();
      }

      // TODO: 각 센서 데이터 가져오기

      // 위치 데이터
      Position position;
      position = await Location.getCurrentPosition();

      // TODO: 지우기
      print(
          '${position.timestamp}, ${position.latitude}, ${position.longitude}, ${position.altitude}');

      // TODO: 각 센서 데이터 전송하기

      // TODO: 각 센서 데이터 처리하기


    });
  }
}
