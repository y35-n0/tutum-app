import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutum_app/app/constant/ui_constants.dart';
import 'package:tutum_app/services/sensor_service.dart';

// 연결된 센서 데이터 파싱 값 확인
class SensorParsingTestView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('센서 데이터 확인'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(UiConstants.PADDING),
        child: Center(
          child: Obx(
            () => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: getBody()),
          ),
        ),
      ),
    );
  }

  List<Widget> getBody() {
    // 블루투스 연결 되어있지 않음.
    if (!(SensorService.to.isEnabled)) {
      return [const Text("Turn on Bluetooth")];
      // 센서 연결되어 있지 않음
    } else {
      return [
        Column(
          children: <Widget>[
            Text("센서"),
            ListTile(
              leading: const Text("state"),
              title: Text(SensorService.to.sensorIsConnected
                  ? "Connected"
                  : "Disconnected"),
              subtitle: Text(SensorService.to.sensorConnectedTime),
            ),
            ListTile(
              leading: const Text("name"),
              title: Text(SensorService.to.sensorName),
              subtitle: Text(SensorService.to.sensorAddress),
            ),
          ],
        ),
        Divider(),
        Column(
          children: <Widget>[
            Text("데이터"),
            ListTile(
              leading: const Text("IMU"),
              title: Text(SensorService.to.sensorData.imu?[1].toString() ?? ""),
              subtitle:
                  Text(SensorService.to.sensorData.imu?[0].toString() ?? ""),
            ),
            ListTile(
              leading: const Text("Capacity"),
              title: Text(
                  SensorService.to.sensorData.capacity?[1].toString() ?? ""),
              subtitle: Text(
                  SensorService.to.sensorData.capacity?[0].toString() ?? ""),
            ),
            ListTile(
              leading: const Text("Temperature"),
              title: Text(
                  SensorService.to.sensorData.temperature?[1].toString() ?? ""),
              subtitle: Text(
                  SensorService.to.sensorData.temperature?[0].toString() ?? ""),
            ),
            ListTile(
              leading: const Text("Oxygen"),
              title:
                  Text(SensorService.to.sensorData.oxygen?[1].toString() ?? ""),
              subtitle:
                  Text(SensorService.to.sensorData.oxygen?[0].toString() ?? ""),
            ),
          ],
        ),
      ];
    }
  }
}
