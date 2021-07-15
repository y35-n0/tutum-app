import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tutum_app/api/data_get_action.dart';
import 'package:tutum_app/service/service.dart';

void main() {
  runApp(MyApp());

  // FIXME: 업무중일 때만 서비스처럼 작동
  Service service = Service(seconds: 2)..run();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String latitude = '';
  String longitude = '';

  Future<Position> _determinePosition() async {
    return await DataGetAction.getPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                Position position = await _determinePosition();
                setState(() {
                  latitude = position.latitude.toString();
                  longitude = position.longitude.toString();
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on),
                  SizedBox(width: 10),
                  Text(
                    'Get Current Location',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Text('현재 위치 : $latitude, $longitude'),
          ],
        ),
      ),
    );
  }
}
