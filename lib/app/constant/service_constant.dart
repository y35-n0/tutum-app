/// API url 설정

abstract class ServiceConstants {
  static const DURATION_SECONDS = 2;
}

abstract class ApiServer {
  static const URL_BASE = '13.125.124.58';

  static const INSERT = '/insert';
  static const GET = '/get';

  static const SENSOR_PORT = '8002';
  static const SENSOR_PATH = '/data';


  static const ACCELERATION = '/axis';
  static const GPS = '/gps';
  static const ATMOSPHERIC = '/pressure';
  static const TEMPERATURE = '/temperature';
}
