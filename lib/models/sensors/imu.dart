import 'dart:developer';

import 'package:tutum_app/app/util/util.dart';

class Imu {
  Imu({
    required this.accX,
    required this.accY,
    required this.accZ,
    required this.gyroX,
    required this.gyroY,
    required this.gyroZ,
    required this.magX,
    required this.magY,
    required this.magZ
  });

  late num accX;
  late num accY;
  late num accZ;
  late num gyroX;
  late num gyroY;
  late num gyroZ;
  late num magX;
  late num magY;
  late num magZ;

  List<num> get value => toNumList();

  Imu.fromIntList(List<int> list) {
    this.accX = Util.complement((list[0] << 8) | list[1]) * 8 / 32768;
    this.accY = Util.complement((list[2] << 8) | list[3]) * 8 / 32768;
    this.accZ = Util.complement((list[4] << 8) | list[5]) * 8 / 32768;
    this.gyroX = Util.complement((list[6] << 8) | list[7]) * 500 / 32768;
    this.gyroY = Util.complement((list[8] << 8) | list[9]) * 500 / 32768;
    this.gyroZ = Util.complement((list[10] << 8) | list[11]) * 500 / 32768;
    this.magX = Util.complement((list[13] << 8) | list[12]) / 32768 * 16;
    this.magY = Util.complement((list[15] << 8) | list[14]) / 32768 * 16;
    this.magZ = Util.complement((list[17] << 8) | list[16]) / 32768 * 16;

  }

  List<num> toNumList() =>
      [this.accX, this.accY, this.accZ, this.gyroX, this.gyroY, this.gyroZ, this.magX, this.magY, this.magZ];
}
