import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'package:tutum_app/app/constant/ui_constants.dart';
import 'package:tutum_app/services/ble_service.dart';

class BleView extends StatelessWidget {
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
              children: BleService.to.sensorState ==
                      BluetoothDeviceState.connected
                  ? [
                      Text(
                        BleService.to.sensorID ?? 'N/A',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      ElevatedButton(
                        onPressed: () => BleService.to.disconnectSensor(),
                        child: Text('연결 해제'),
                      ),
                      Expanded(
                        child: ListView(
                            children: BleService.to.connectedDevices
                                .map((device) => ListTile(
                                      title: Text(device.name),
                                      subtitle: Text(device.id.toString()),
                                    ))
                                .toList()),
                      ),
                      ListTile(
                          title: Text('Acceleration'),
                          subtitle: Text(BleService.to.acceleration.toString())),
                      ListTile(
                          title: Text('Temperature'),
                          subtitle: Text(BleService.to.temperature.toString())),
                      ListTile(
                          title: Text('Atmospheric'),
                          subtitle: Text(BleService.to.pressure.toString())),
                      ElevatedButton(
                        onPressed: () => BleService.to.switchCharacteristicsNotify(),
                        child: Text('실시간 값 얻기'),
                      ),
                    ]
                  : [
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
                          ElevatedButton(
                            onPressed: () => BleService.to.scanDevices(),
                            child: Text('디바이스 스캔'),
                          ),
                          SizedBox(width: UiConstants.PADDING),
                          ElevatedButton(
                            onPressed: () =>
                                BleService.to.findDevice(textController.text),
                            child: Text('센서 연결'),
                          ),
                        ],
                      ),
                      Expanded(
                          child: ListView(
                              children: BleService.to.scanResults.map((result) {
                        return ListTile(
                            title: Text(result.device.name),
                            subtitle: Text(result.device.id.toString()),
                            onTap: () {
                              textController.text = result.device.id.toString();
                            });
                      }).toList())),
                    ],
            ),
          ),
        ),
      ),
    );
  }
}
// 15:5F:D0:27:12:5E
