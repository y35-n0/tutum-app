part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const TEST = _Paths.TEST;
  static const HOME = _Paths.TEST + _Paths.HOME;
  static const SENSOR = _Paths.TEST + _Paths.SENSOR;
  static const LOGIN = _Paths.TEST + _Paths.LOGIN;
  static const BLUETOOTH = _Paths.TEST +_Paths.BLUETOOTH;
}

abstract class _Paths {
  static const TEST = '/test';
  static const HOME = '/home';
  static const LOGIN = '/login';
  static const SENSOR = '/sensor';
  static const BLUETOOTH = '/bluetooth';

}

/// 개발용 화면 전환
List<String> developPages = [
  Routes.LOGIN,
  Routes.SENSOR,
  Routes.BLUETOOTH,
  Routes.HOME,
];