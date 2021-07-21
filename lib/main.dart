import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String appTitle = 'Tutum app BLE test';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => BluetoothPage()));
            },
            child: Text('BLUETOOTH TEST'),
          ),
        ));
  }
}

class BluetoothPage extends StatefulWidget {
  const BluetoothPage({Key? key}) : super(key: key);

  @override
  _BluetoothPageState createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  FlutterBlue flutterBlue = FlutterBlue.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            /// 스캔한 디바이스 표시
            StreamBuilder<List>(
              stream: flutterBlue.scanResults,
              initialData: [],
              builder: (c, snapshot) => Column(
                children: snapshot.data!
                .map((r) => ScanResultTile(result: r)
                ).toList(),
              ),
            ),
          ],
        )
      ),
      /// 디바이스 검색
      floatingActionButton: StreamBuilder<bool>(
        stream: flutterBlue.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data!) {
            return FloatingActionButton(
              child: Icon(Icons.stop),
              onPressed: () => flutterBlue.stopScan(),
            );
          } else {
            return FloatingActionButton(
              child: Icon(Icons.search),
              onPressed: ()  => flutterBlue.startScan(timeout: Duration(seconds: 10))
            );
          }
        },
      ),
    );
  }
}

class ScanResultTile extends StatelessWidget {
  const ScanResultTile({Key? key, required this.result}) : super(key: key);

  final ScanResult result;


  @override
  Widget build(BuildContext context) {
    return ListTile(

          title: Text(
            result.device.name,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            result.device.id.toString(),
            style: Theme.of(context).textTheme.caption,
          ),
    );
  }
}

