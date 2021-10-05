import 'package:permission_handler/permission_handler.dart';
import 'package:system_settings/system_settings.dart';

/// 권한 관리
class PermissionGetAction {
  /// 서비스가 포함된 권한에 대해 설정
  static Future<bool> setPermissionWithService(
      PermissionWithService targetPermission) async {
    ServiceStatus serviceEnabled;
    PermissionStatus permission;

    /// 서비스 작동 여부 확인
    serviceEnabled = await targetPermission.serviceStatus;
    if (serviceEnabled == ServiceStatus.disabled) {
      // TODO: 위치 서비스 작동하라고 알림

      /// 종류별 시스템 설정 열기
      if (targetPermission == Permission.location) {
        await SystemSettings.location();
      } else {
        throw ('설정할 수 있는 서비스가 아님');
      }

      serviceEnabled = await targetPermission.serviceStatus;

      // TODO: 권한이 없으면 접근 불가 알림 후 뒤로가기
      assert(serviceEnabled == ServiceStatus.disabled, '서비스가 비활성화 되어 있음');
    }

    /// 권한 확인
    permission = await targetPermission.request();
    if (!(permission.isGranted)) {
      // TODO: 위치 권한 동의하라고 알림

      /// 앱 설정 열기
      await openAppSettings();

      // TODO: 권한이 없으면 접근 불가. 뒤로가기
      throw ('권한이 거부되었음');
    }

    return true;
  }
}
