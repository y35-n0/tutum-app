import 'dart:convert';
import 'dart:developer';

import 'package:tutum_app/app/constant/service_constant.dart';
import 'package:tutum_app/models/sensor_data.dart';
import 'package:http/http.dart' as http;
import 'package:tutum_app/models/state_data.dart';
import 'package:tutum_app/services/auth_service.dart';

/// call sensor data api
void sensorDataApi(SensorData sensorData, int count) async {
  var client = http.Client();
  try {
    // // TODO: API TEST
    final now = DateTime.now();
    final id = AuthService.to.loggedInUser.id.toString();
    print("$now send $id $count");
    var response = await client.post(
        Uri.http(TutumApiServer.URL_BASE, "data/insert/all"),
        body: {
          "id": id,
          "sensorData": sensorData.json
        }.toString());
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    print(now.toString() + decodedResponse.toString());
    // log(sensorData.json);
  } catch (error) {
    print(error);
  }
}

/// call state data api
void stateDataApi(StateData stateData) async {
  var client = http.Client();
  try {
    // // TODO: API TEST
    // // FIXME: api address
    final id = AuthService.to.loggedInUser.id.toString();
    var response = await client.post(
        Uri.http(TutumApiServer.URL_BASE, "worker/update/state"),
        headers: <String, String>{
          "Content-Type": "application/json",
        },
        body: {'"id"': id, '"state"': stateData.json}.toString());
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    // print(decodedResponse.toString() + ' ' + id.toString());
    // log(stateData.json);
  } catch (error) {
    print(error);
  }
}
