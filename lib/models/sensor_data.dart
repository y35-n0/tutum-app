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

  late num accX;
  late num accY;
  late num accZ;
  late num gyroX;
  late num gyroY;
  late num gyroZ;

  Imu.fromIntList(List<int> list) {
    this.accX = _complement((list[0] << 8) | list[1]) * 8 / 32768;
    this.accY = _complement((list[2] << 8) | list[3]) * 8 / 32768;
    this.accZ = _complement((list[4] << 8) | list[5]) * 8 / 32768;
    this.gyroX = _complement((list[6] << 8) | list[7]) * 500 / 32768;
    this.gyroY = _complement((list[8] << 8) | list[9]) * 500 / 32768;
    this.gyroZ = _complement((list[10] << 8) | list[11]) * 500 / 32768;
  }
}

class Temperature {}

class Capacity {}

/// 2의 보수
num _complement(value) {
  if ((value & (1 << (16 - 1))) != 0) value = value - (1 << 16);
  return value;
}
