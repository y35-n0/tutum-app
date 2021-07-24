import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutum_app/app/constant/ui_constants.dart';
import 'package:tutum_app/app/modules/sensor/views/base_sensor_tile.dart';
import 'package:tutum_app/services/sensor/gps_service.dart';

/// GPS 센서값 표시 Grid 타일
class GpsTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseSensorTile(
      header: 'GPS',
      children: <Widget>[
        Text('업데이트 시각', style: Theme.of(context).textTheme.subtitle1),
        Obx(() => Text('${GpsService.to.timestamp}')),
        SizedBox(
          height: kDefaultPadding / 4,
        ),
        Text('위치', style: Theme.of(context).textTheme.subtitle1),
        SizedBox(
          height: kDefaultPadding / 4,
        ),
        Obx(() => Text('경도 : ${GpsService.to.latitude}')),
        Obx(() => Text('위도 : ${GpsService.to.longitude}')),
        Obx(() => Text('고도 : ${GpsService.to.altitude}')),
      ],
    );
  }
}
