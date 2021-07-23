import 'package:geolocator/geolocator.dart';
import 'package:tutum_app/models/gps.dart';

class GpsMiddleware {
  /// 위치 데이터 가져오기
  static Future<Gps> fetchGps() async {
    // TODO: 권한 확인 및 획득
    bool isEnableAndAllowed = await _isEnableAndAllowed();
    if (isEnableAndAllowed) {
      return Future.error('No permission');
    }


    // TODO: 통신음영이거나 값이 없을 때 방안 추가
    // FIXME: iOS에서 값이 업데이트 되지 않음
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
      timeLimit: Duration(seconds: 5),
    );

    return Gps.fromPosition(position);
  }

  /// 서비스 및 권한 확인
  static Future<bool> _isEnableAndAllowed() async {
    /// GPS 서비스 상태 확인
    bool isEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isEnabled) {
      Geolocator.openLocationSettings();
    }

    /// GPS 권한 확인
    LocationPermission permission = await Geolocator.checkPermission();
    if (_isAllowed(permission)) {
      permission = await Geolocator.requestPermission();
      if (_isAllowed(permission)) {
        await Geolocator.openAppSettings();
      }
    }

    permission = await Geolocator.checkPermission();
    return _isAllowed(permission);
  }

  /// 권한 확인
  static bool _isAllowed(LocationPermission permission) {
    return permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever;
  }
}