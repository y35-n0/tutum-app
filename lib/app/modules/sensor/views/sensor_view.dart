import 'package:flutter/material.dart';
import 'package:tutum_app/app/constant/ui_constants.dart';
import 'package:tutum_app/services/beacon_service.dart';
import 'package:tutum_app/services/sensor/base_sensor_service.dart';
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
    return Container(
      padding: const EdgeInsets.all(UiConstants.PADDING),
      child: GridView(
        clipBehavior: Clip.none,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: UiConstants.PADDING / 2,
          crossAxisSpacing: UiConstants.PADDING / 2,
        ),
        children: <Widget>[
          // TODO: 다른 센서 값 타일도 표시
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Obx(() {
      List<BaseSensorService> services = [BeaconService.to];
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
