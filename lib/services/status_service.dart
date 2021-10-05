import 'package:get/get.dart';
import 'package:tutum_app/models/status.dart';

// TODO: 네트워크 통신으로 값 가져오기
// TODO: 저장된 상태 가져오기
// TODO: 상태 변경
// TODO: 최근 변경 순으로 표시
// TODO: 필요에 따라 상태 생성
/// 상태 저장 서비스
class StatusService extends GetxService {
  static StatusService get to => Get.find();

  RxList<Status> _statuses = <Status>[].obs;

  @override
  void onInit() {
    super.onInit();
    _statuses.value = [
      Status(name: '현재 이상상태 수준', datetime: DateTime.now(), content: '위험'),
      Status(name: '근무 상태', datetime: DateTime.now(), content: '업무중'),
      Status(name: '블루투스 연결 상태', datetime: DateTime.now(), content: '연결됨'),
      Status(name: 'LTE 통신 상태', datetime: DateTime.now(), content: '양호'),
      Status(name: '안전모 착용 여부', datetime: DateTime.now(), content: '미착용'),
      Status(name: '낙상 및 추락', datetime: DateTime.now(), content: '미탐지'),
      Status(name: '산소', datetime: DateTime.now(), content: '산소부족'),
      Status(name: '기온', datetime: DateTime.now(), content: '양호'),
      Status(name: '심박수', datetime: DateTime.now(), content: '정상'),
      Status(name: '산소포화도', datetime: DateTime.now(), content: '정상'),
    ];
  }

  int get length => _statuses.length;

  Status getStatusByName(String name) =>
      _statuses.singleWhere((e) => e.name == name);

  Status getStatusByIndex(int index) => _statuses[index];
}
