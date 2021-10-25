import 'package:get/get.dart';
import 'package:tutum_app/models/state.dart';

// TODO: 네트워크 통신으로 값 가져오기
// TODO: 저장된 상태 가져오기
// TODO: 상태 변경
// TODO: 최근 변경 순으로 표시
// TODO: 필요에 따라 상태 생성
/// 상태 저장 서비스
class StateService extends GetxService {
  static StateService get to => Get.find();

  RxList<AbnormalState> _statuses = <AbnormalState>[].obs;

  @override
  void onInit() {
    super.onInit();
    _statuses.value = [
      AbnormalState(name: '현재 이상상태 수준', datetime: DateTime.now(), content: '위험'),
      AbnormalState(name: '근무 상태', datetime: DateTime.now(), content: '업무중'),
      AbnormalState(name: '블루투스 연결 상태', datetime: DateTime.now(), content: '연결됨'),
      AbnormalState(name: 'LTE 통신 상태', datetime: DateTime.now(), content: '양호'),
      AbnormalState(name: '안전모 착용 여부', datetime: DateTime.now(), content: '미착용'),
      AbnormalState(name: '산소', datetime: DateTime.now(), content: '산소부족'),
      AbnormalState(name: '기온', datetime: DateTime.now(), content: '양호'),
    ];
  }

  int get length => _statuses.length;

  AbnormalState getStatusByName(String name) =>
      _statuses.singleWhere((e) => e.name == name);

  AbnormalState getStatusByIndex(int index) => _statuses[index];
}
