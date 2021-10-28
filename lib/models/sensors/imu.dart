import 'package:tutum_app/models/sensors/sensor_util.dart';

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

  List<num> get value => toNumList();

  Imu.fromIntList(List<int> list) {
    this.accX = SensorUtil.complement((list[0] << 8) | list[1]) * 8 / 32768;
    this.accY = SensorUtil.complement((list[2] << 8) | list[3]) * 8 / 32768;
    this.accZ = SensorUtil.complement((list[4] << 8) | list[5]) * 8 / 32768;
    this.gyroX = SensorUtil.complement((list[6] << 8) | list[7]) * 500 / 32768;
    this.gyroY = SensorUtil.complement((list[8] << 8) | list[9]) * 500 / 32768;
    this.gyroZ = SensorUtil.complement((list[10] << 8) | list[11]) * 500 / 32768;
  }

  Map<String, dynamic> toJson() => {
    "accX": this.accX,
    "accY": this.accY,
    "accZ": this.accZ,
    "gyroX": this.gyroX,
    "gyroY": this.gyroY,
    "gyroZ": this.gyroZ,
  };

  List<num> toNumList() =>
      [this.accX, this.accY, this.accZ, this.gyroX, this.gyroY, this.gyroZ];
}