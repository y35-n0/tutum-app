import 'package:get/get.dart';
import 'package:tutum_app/app/middleware/gps_middleware.dart';
import 'package:tutum_app/models/gps.dart';
import 'package:tutum_app/services/sensor/base_sensor_service.dart';

class GpsService extends BaseSensorService {
  static GpsService get to => Get.find();

  final _gps = Gps.origin().obs;

  DateTime get timestamp => _gps.value.timestamp;

  double get latitude => _gps.value.latitude;

  double get longitude => _gps.value.longitude;

  double get altitude => _gps.value.altitude;

  Future<void> readData() async {
    _gps.value = await GpsMiddleware.fetchGps();
  }
}
