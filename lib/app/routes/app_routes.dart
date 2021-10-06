part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const TEST = _Paths.TEST;
  static const HOME = _Paths.TEST + _Paths.HOME;
  static const SENSOR = _Paths.TEST + _Paths.SENSOR;
  static const LOGIN = _Paths.TEST + _Paths.LOGIN;
  static const BLE = _Paths.TEST +_Paths.BLE;
  static const WORK_SETTING = _Paths.TEST + _Paths.WORK_SETTING;
}

abstract class _Paths {
  static const TEST = '/test';
  static const HOME = '/home';
  static const LOGIN = '/login';
  static const SENSOR = '/sensor';
  static const BLE = '/ble';
  static const WORK_SETTING = '/work_setting';

}

/// 개발용 화면 전환
List<String> developPages = [
  Routes.LOGIN,
  Routes.HOME,
  Routes.WORK_SETTING,
  Routes.SENSOR,
  Routes.BLE,
];