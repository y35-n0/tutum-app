import 'dart:async';
import 'package:geolocator/geolocator.dart';
export 'package:geolocator/geolocator.dart';
import 'permissions_handler.dart';

class Location {
  static Future<bool> setPermissionWithService() =>
      PermissionsHandler.setPermissionWithService(Permission.location);

  // 현재 위치 가져오기
  static Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: Duration(seconds: 5),
    );
  }

}
