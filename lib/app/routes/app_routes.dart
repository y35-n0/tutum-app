part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const TEST = _Paths.TEST;
  static const HOME = _Paths.TEST + _Paths.HOME;
  static const LOGIN = _Paths.TEST + _Paths.LOGIN;
  static const WORK_SETTING = _Paths.TEST + _Paths.WORK_SETTING;
  static const BEACON = _Paths.TEST + _Paths.BEACON;
  static const SENSOR_CONNECT = _Paths.TEST + _Paths.SENSOR_CONNECT;
  static const SENSOR_PARSING = _Paths.TEST + _Paths.SENSOR_PARSING;
}

abstract class _Paths {
  static const TEST = '/test';
  static const HOME = '/home';
  static const LOGIN = '/login';
  static const WORK_SETTING = '/work_setting';
  static const BEACON = '/beacon';
  static const SENSOR_CONNECT = '/sensor_connect';
  static const SENSOR_PARSING = '/sensor_parsing';
}

/// 개발용 화면 전환
List<String> developPages = [
  Routes.LOGIN,
  Routes.HOME,
  Routes.WORK_SETTING,
  Routes.BEACON,
  Routes.SENSOR_CONNECT,
  Routes.SENSOR_PARSING,
];
