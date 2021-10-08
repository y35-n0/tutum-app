import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutum_app/app/constant/ui_constants.dart';
import 'package:tutum_app/services/sensor_service.dart';

// TODO: QR 코드로 인식할 수 있도록 처리
class SensorConnectTestView extends StatelessWidget {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('블루투스 연결 확인'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(UiConstants.PADDING),
        child: Center(
          child: Obx(
            () => Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
        TextField(
          controller: textController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: '연결할 센서 ID',
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SensorService.to.isDiscovering
                ? ElevatedButton(
                    onPressed: () => SensorService.to.cancelDiscovery(),
                    child: const Text("디바이스 스캔 종료"))
                : ElevatedButton(
                    onPressed: () => SensorService.to.startDiscovery(),
                    child: const Text("디바이스 스캔 시작")),
            SizedBox(width: UiConstants.PADDING),
            ElevatedButton(
              onPressed: () {
                SensorService.to.connect(textController.text);
              },
              child: Text('센서 연결'),
            ),
          ],
        ),
        Expanded(
            child: ListView(
                children: SensorService.to.discoveredResults.map((result) {
          return ListTile(
              title: Text(result.device.name ?? ''),
              subtitle: Text(result.device.address),
              onTap: () {
                textController.text = result.device.address;
              });
        }).toList())),
      ];
    }
  }
}
