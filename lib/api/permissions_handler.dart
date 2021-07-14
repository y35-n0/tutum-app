import 'package:permission_handler/permission_handler.dart';
export 'package:permission_handler/permission_handler.dart';
import 'package:system_settings/system_settings.dart';


class PermissionsHandler {

  /// 서비스 포함된 권한에 대해서
  static Future<bool> setPermissionWithService (PermissionWithService targetPermission) async {
    ServiceStatus serviceEnabled;
    PermissionStatus permission;

    // 서비스 작동 여부 확인
    serviceEnabled = await targetPermission.serviceStatus;
    if (serviceEnabled == ServiceStatus.disabled) {
      // TODO: 위치 서비스 작동하라고 알림

      // 시스템 설정 열기
      if (targetPermission == Permission.location) {
        await SystemSettings.location();
      }

      serviceEnabled = await targetPermission.serviceStatus;

      // TODO: 권한이 없으면 접근 불가. 뒤로가기
      assert(serviceEnabled == ServiceStatus.disabled, 'Location is disabled');
    }

    // 권한 확인
    permission = await targetPermission.request();
    if (!(permission.isGranted)) {
      // TODO: 위치 권한 동의하라고 알림

      // 앱 설정 열기
      await openAppSettings();

      // TODO: 권한이 없으면 접근 불가. 뒤로가기
      throw('${targetPermission.toString()} is disabled');
    }

    return true;
  }
}