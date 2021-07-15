import 'package:tutum_app/api/permission_get_action.dart';
import 'package:geolocator/geolocator.dart';

/// 센서 데이터 가져오기
class DataGetAction {
  /// 위치 데이터 가져오기
  static Future<Position> getPosition() async {
    /// 권한 획득
    bool isEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isEnabled) {
      Geolocator.openLocationSettings();
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
      }
    }

    // FIXME: iOS에서 값이 업데이트 되지 않음
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
      timeLimit: Duration(seconds: 5),
    );

    // 지워야 할 코드
    print(
        '${position.timestamp}, ${position.latitude}, ${position.longitude}, ${position.altitude}');

    // TODO: 통신음영이거나 값이 없을 때 방안 추가

    return position;
  }
}
