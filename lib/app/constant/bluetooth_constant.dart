import 'package:flutter_blue/flutter_blue.dart';

enum BT_SERVICE { NAME, UUID, CHARACTERISTICS }
enum BT_CHARACTERISTIC { NAME, UUID }

class BLEService {
  String name;
  Guid uuid;
  List<BLECharacteristic> characteristics;

  BLEService(
      {required this.name, required this.uuid, required this.characteristics});
}

class BLECharacteristic {
  String name;
  Guid uuid;

  BLECharacteristic({required this.name, required this.uuid});
}

class BLEServices {
  static final services = [
    // Service(
    //     name: 'information',
    //     uuid: Guid('1c1d89b9-afb1-4655-bb30-25b15ec6d42f'),
    //     characteristics: [
    //       Characteristic(
    //           name: 'name', uuid: Guid('8b21d584-ff73-4dcf-8b15-34f8cf66d270')),
    //       Characteristic(
    //           name: 'battery',
    //           uuid: Guid('ca968f45-7e09-48fc-ad1d-97fdf7b6b80f')),
    //     ]),
    BLEService(
        name: 'temperature',
        uuid: Guid('db98d81a-dc88-4cb4-bab5-f63e7067d410'),
        characteristics: [
          BLECharacteristic(
              name: 'temperature',
              uuid: Guid('84b1893e-1979-404e-8fd6-028f8bd96553')),
        ]),
    BLEService(
        name: 'atmospheric',
        uuid: Guid('8d4a57e6-2975-4003-9f1c-88736d5555be'),
        characteristics: [
          BLECharacteristic(
              name: 'pressure',
              uuid: Guid('37d45b9f-7d5a-44ce-ba85-ba276e7ffd9b')),
        ]),
    // Service(
    //     name: 'heart',
    //     uuid: Guid('1077ddbc-2541-4d94-9494-efd447505edb'),
    //     characteristics: [
    //       Characteristic(
    //           name: 'heartRate',
    //           uuid: Guid('8ebe4598-de4c-43fb-977e-c503a3f14a14')),
    //       Characteristic(
    //           name: 'spo2', uuid: Guid('f33bd455-d1f5-4614-bc5f-6c6e7efe5e2c')),
    //     ]),
    BLEService(
        name: 'imu',
        uuid: Guid('454607a8-4554-4e42-b15a-e96214bbb541'),
        characteristics: [
          BLECharacteristic(
              name: 'accelerationX',
              uuid: Guid('423d7895-f0e2-43a4-ab80-12c06769dddd')),
          BLECharacteristic(
              name: 'accelerationY',
              uuid: Guid('1db9bd2d-f0aa-4509-8c7c-9d85f4378737')),
          BLECharacteristic(
              name: 'accelerationZ',
              uuid: Guid('290ddadd-ea0f-4126-9d45-2e3db2dd8747')),
        ]),
    // Service(
    //     name: 'capacity',
    //     uuid: Guid('d9ef4aa4-95e4-442b-8ba1-c7297a53c6b2'),
    //     characteristics: [
    //       Characteristic(
    //           name: 'capacity',
    //           uuid: Guid('8e3697ab-24a3-4d73-8b20-d46c50a374c3')),
    //     ]),
    // Service(
    //     name: 'gas',
    //     uuid: Guid('664fc2aa-7d12-47a1-9a0a-d7b982a9bbae'),
    //     characteristics: [
    //       Characteristic(name: 'o2', uuid: Guid('')),
    //     ]),
    BLEService(name: 'risk',
        uuid: Guid('7daa6fce-0e08-4cd1-a90e-7b60396a301b'),
        characteristics: [
          BLECharacteristic(name: 'riskStatus',
              uuid: Guid('41e3b554-6600-4c72-a07e-e59b538b63ad')),
          BLECharacteristic(name: 'shade_status',
              uuid: Guid('c58967f1-03b4-42cb-a4f7-e08059d4b2b1')),
        ])
  ];
}