class Gps {
  Gps({
    required this.timestamp,
    required this.longitude,
    required this.latitude,
    required this.altitude,
  });

  Gps.origin() {
    timestamp = DateTime.now();
    latitude = 0;
    longitude = 0;
    altitude = 0;
  }

  late DateTime timestamp;
  late double latitude;
  late double longitude;
  late double altitude;

  factory Gps.fromPosition(dynamic position) {
    return Gps(
      timestamp: position.timestamp,
      longitude: position.longitude,
      latitude: position.latitude,
      altitude: position.altitude,
    );
  }
}