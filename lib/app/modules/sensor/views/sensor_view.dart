import 'package:flutter/material.dart';
import 'package:tutum_app/app/constant/ui_constants.dart';
import 'package:tutum_app/app/modules/sensor/views/gps_tile.dart';
import 'package:tutum_app/services/sensor/base_sensor_service.dart';
import 'package:tutum_app/services/sensor/gps_service.dart';
import 'package:get/get.dart';

class SensorView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('센서 값 변화 확인'),
          centerTitle: true,
        ),
        floatingActionButton: _buildFloatingActionButton(),
        body: _buildBody(),
    );
  }

  /// 각 센서 값을 Grid 화면에서 표시
  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Container(
        child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: kDefaultPadding / 2,
            crossAxisSpacing: kDefaultPadding / 2,
          ),
          children: <Widget>[
            GpsTile(),
            // TODO: 다른 센서 값 타일도 표시
            GpsTile(),
            GpsTile(),
            GpsTile(),
            GpsTile(),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Obx(() {
      List<BaseSensorService> services = [GpsService.to];
      bool isRunning = services.every((e) => e.isRunning);

      return FloatingActionButton(
        // TODO: 센서 값 변화 시작
        onPressed: () {
          if (isRunning) {
            services.forEach((e) => e.stop());
          } else {
            services.forEach((e) => e.run());
          }
        },
        child: isRunning ? Icon(Icons.stop) : Icon(Icons.play_arrow),
      );
    });
  }
}
