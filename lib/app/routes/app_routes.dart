part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const HOME = _Paths.HOME;
  static const SENSOR = _Paths.HOME + _Paths.SENSOR;
  static const LOGIN = _Paths.LOGIN;
}

abstract class _Paths {
  static const HOME = '/home';
  static const LOGIN = '/login';
  static const SENSOR = '/sensor';
}
