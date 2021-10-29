import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'package:tutum_app/app/constant/ui_constants.dart';
import 'package:tutum_app/services/beacon_service.dart';

class BeaconTestView extends StatelessWidget {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beacon test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(UiConstants.PADDING),
        child: Center(
          child: Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _getBody(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _getBody() {
    if (!BeaconService.to.isEnabled) {
      return [const Text("Turn on Bluetooth")];
    } else {
      return [
        Text("PASSED ${BeaconService.to.sensorData.pass}"),
        Flexible(
          child: Column(
            children: BeaconService.to.beacons.map((beacon) {
              return ListTile(
                title: Text(beacon.name),
                subtitle: Text(beacon.address),
                trailing: Text(beacon.rssi?.toString() ?? ''),
              );
            }).toList(),
          ),
        ),
        !(BeaconService.to.isRunning)
            ? new ElevatedButton(
                onPressed: () => BeaconService.to.run(),
                child: const Text("실행"),
              )
            : new ElevatedButton(
                onPressed: () => BeaconService.to.stop(),
                child: const Text("종료"),
              )
      ];
    }
  }
}
