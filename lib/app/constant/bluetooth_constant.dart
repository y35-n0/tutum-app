const DEVICE_NAME = "TUTUM";

const PAIRING_PIN = '0216';

const COUNT_START = 0;
const SIGN_START = [0xFF, 0xFF, 0xFF, 0xFE];
const LENGTH_START = 1;

enum SENSOR_TYPE {
  IMU,
  CAPACITY,
  TEMPERATURE,
  OXYGEN,
}

const DATA_LENGTH = {
  SENSOR_TYPE.IMU: LENGTH_IMU,
  SENSOR_TYPE.CAPACITY: LENGTH_CAPACITY,
  SENSOR_TYPE.TEMPERATURE: LENGTH_TEMPERATURE,
  SENSOR_TYPE.OXYGEN: LENGTH_OXYGEN,
};

const COUNT_TEMPERATURE = 2379;
const LENGTH_TEMPERATURE = 4;

const COUNT_CAPACITY = 2381;
const LENGTH_CAPACITY = 2;

const COUNT_OXYGEN = 2383;
const LENGTH_OXYGEN = 4;

const COUNT_IMU_START = 1;
const LENGTH_EACH_IMU = 2;
const LENGTH_IMU = LENGTH_EACH_IMU * 6;

enum DIRECTION { UNKNOWN, IN_OUT, OUT_IN }
