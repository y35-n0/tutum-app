/// class for saving RSSI log
class Rssi {
  Rssi(this.rssi);

  final DateTime timestamp = DateTime.now();
  final int rssi;
}
