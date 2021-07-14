import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tutum_app/api/location.dart';


/// 위치 기능 테스트
/// 제대로 작동하지 않음...
void main() {
  test('위치 서비스 및 권한 확인', () async {
    final result = await Location.enableLocationStream();
    expect(result, true);
  });

  test('현재 위치 얻기', () async {
    final Position position = await Location.getCurrentPosition();
    print('x: ${position.latitude}, y: ${position.longitude}, z: ${position.altitude}');
  });
}
