import 'dart:convert';
import 'dart:developer';

import 'package:tutum_app/app/constant/service_constant.dart';
import 'package:tutum_app/models/sensor_data.dart';
import 'package:http/http.dart' as http;
import 'package:tutum_app/models/state_data.dart';
import 'package:tutum_app/services/auth_service.dart';

/// call sensor data api
void sensorDataApi(SensorData sensorData) async {
  var client = http.Client();
  try {
    // TODO: API TEST
    // var response = await client
    //     .post(Uri.http(TutumApiServer.URL_BASE, "data/insert/all"), body: {
    //   "id": AuthService.to.loggedInUser.id.toString(),
    //   "sensorData": sensorData.json,
    // });
    // var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    // print(decodedResponse.toString());
    // sensorData.json;
    // log(sensorData.json);
  } catch (error) {
    print(error);
  }
}

/// call state data api
void stateDataApi(StateData stateData) async {
  var client = http.Client();
  try {
    // TODO: API TEST
    // FIXME: api address
    // var response = await client
    //     .post(Uri.http(TutumApiServer.URL_BASE, "worker/update/state"), body: {
    //   "id": AuthService.to.loggedInUser.id.toString(),
    //   "stateData": stateData.json,
    // });
    // var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    // print(decodedResponse.toString());
    // stateData.json;
    log(stateData.json);
  } catch (error) {
    print(error);
  }
}