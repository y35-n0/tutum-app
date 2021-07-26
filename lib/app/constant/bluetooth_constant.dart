abstract class BtServices {
  static const information = _BtServiceInformation;
  static const temperature = _BtServiceTemperature;
  static const atmospheric = _BtServiceAtmospheric;
  static const heart = _BtServiceHeart;
  static const imu = _BtServiceImu;
  static const capacity = _BtServiceCapacity;
  static const gas = _BtServiceGas;
  static const risk = _BtServiceRisk;
}

abstract class _BtServiceInformation {
  static const SERVICE_UUID = '1c1d89b9-afb1-4655-bb30-25b15ec6d42f';
  static const NAME = '8b21d584-ff73-4dcf-8b15-34f8cf66d270';
  static const BATTERY = 'ca968f45-7e09-48fc-ad1d-97fdf7b6b80f';
}

abstract class _BtServiceTemperature {
  static const SERVICE_UUID = 'db98d81a-dc88-4cb4-bab5-f63e7067d410';
  static const TEMPERATURE = '84b1893e-1979-404e-8fd6-028f8bd96553';
}

abstract class _BtServiceAtmospheric {
  static const SERVICE_UUID = '8d4a57e6-2975-4003-9f1c-88736d5555be';
  static const PRESSURE = '37d45b9f-7d5a-44ce-ba85-ba276e7ffd9b';
}

abstract class _BtServiceHeart {
  static const SERVICE_UUID = '1077ddbc-2541-4d94-9494-efd447505edb';
  static const HEART_RATE = '8ebe4598-de4c-43fb-977e-c503a3f14a14';
  static const SPO2 = 'f33bd455-d1f5-4614-bc5f-6c6e7efe5e2c';
}

abstract class _BtServiceImu {
  static const SERVICE_UUID = '454607a8-4554-4e42-b15a-e96214bbb541';
  static const ACCELERATION_X = '423d7895-f0e2-43a4-ab80-12c06769dddd';
  static const ACCELERATION_Y = '1db9bd2d-f0aa-4509-8c7c-9d85f4378737';
  static const ACCELERATION_Z = '290ddadd-ea0f-4126-9d45-2e3db2dd8747';
  static const ANGULAR_ACCELERATION_X = '81ea5e48-3c5e-40dd-9ab3-56e0a852b9a8';
  static const ANGULAR_ACCELERATION_Y = 'a3e501aa-11e6-4e03-afa2-1e022fdfceea';
  static const ANGULAR_ACCELERATION_Z = '8151229c-77fa-43e3-82b3-70341fefa56e';
}

abstract class _BtServiceCapacity {
  static const SERVICE_UUID = 'd9ef4aa4-95e4-442b-8ba1-c7297a53c6b2';
  static const CAPACITY = '8e3697ab-24a3-4d73-8b20-d46c50a374c3';
}

abstract class _BtServiceGas {
  static const SERVICE_UUID = '664fc2aa-7d12-47a1-9a0a-d7b982a9bbae';
  static const O2 = '';
}

abstract class _BtServiceRisk {
  static const SERVICE_UUID = '7daa6fce-0e08-4cd1-a90e-7b60396a301b';
  static const RISK_STATUS = '41e3b554-6600-4c72-a07e-e59b538b63ad';
  static const SHADE_STATUS = 'c58967f1-03b4-42cb-a4f7-e08059d4b2b1';
}