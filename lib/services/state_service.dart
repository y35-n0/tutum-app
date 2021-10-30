import 'package:get/get.dart';
import 'package:tutum_app/app/util/server_api.dart';
import 'package:tutum_app/models/state_data.dart';
import 'package:tutum_app/services/sensor_service.dart';

// TODO: 네트워크 통신으로 값 가져오기
// TODO: 저장된 상태 가져오기
// TODO: 상태 변경
// TODO: 최근 변경 순으로 표시
// TODO: 필요에 따라 상태 생성

const SENDING_DATA_INTERVAL = Duration(seconds: 1);

/// 상태 저장 서비스
class StateService extends GetxService {
  static StateService get to => Get.find();

  final Rx<StateData> _stateData = StateData().obs;

  StateData get stateData => _stateData.value;

  late Worker _stateDataWorker;

  @override
  void onInit() {
    super.onInit();
    _stateDataWorker = interval(_stateData, (stateData) {
      stateData as StateData;
      stateDataApi(stateData);
      stateData.clear();


    }, time: SENDING_DATA_INTERVAL);
  }

  void addSensorData(dynamic data) {
    _stateData.value.calculate(data);
    _stateData.refresh();
  }

  @override
  void onClose() {
    _stateDataWorker.dispose();
    super.onClose();
  }
}
