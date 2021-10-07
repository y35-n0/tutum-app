// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:tutum_app/app/constant/ui_constants.dart';
//
// class SensorsTestView extends StatelessWidget {
//   final textController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('블루투스 연결 확인'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(UiConstants.PADDING),
//         child: Center(
//           child: Obx(
//             () => Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children:
//                   [
//                       TextField(
//                         controller: textController,
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(),
//                           labelText: '연결할 센서 ID',
//                         ),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           ElevatedButton(
//                             onPressed: () => BeaconService.to.scanBeacons(),
//                             child: Text('디바이스 스캔'),
//                           ),
//                           SizedBox(width: UiConstants.PADDING),
//                           ElevatedButton(
//                             onPressed: () =>
//                                 BeaconService.to.findDevice(textController.text),
//                             child: Text('센서 연결'),
//                           ),
//                         ],
//                       ),
//                       Expanded(
//                           child: ListView(
//                               children: BeaconService.to.scanResults.map((result) {
//                         return ListTile(
//                             title: Text(result.device.name),
//                             subtitle: Text(result.device.id.toString()),
//                             onTap: () {
//                               textController.text = result.device.id.toString();
//                             });
//                       }).toList())),
//                     ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
// // 15:5F:D0:27:12:5E
