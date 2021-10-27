import 'dart:typed_data';

class SensorData {}

class Imu {
  Imu({
    required this.accX,
    required this.accY,
    required this.accZ,
    required this.gyroX,
    required this.gyroY,
    required this.gyroZ,
  });

  num accX;
  num accY;
  num accZ;
  num gyroX;
  num gyroY;
  num gyroZ;
}

class Temperature {}

class Capacity {}
