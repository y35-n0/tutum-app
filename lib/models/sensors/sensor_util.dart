class SensorUtil {
  /// 2의 보수
  static num complement(value) {
    if ((value & (1 << (16 - 1))) != 0) value = value - (1 << 16);
    return value;
  }
}