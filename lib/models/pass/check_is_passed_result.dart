import 'package:tutum_app/app/constant/bluetooth_constant.dart';

class CheckIsPassedResult {
  CheckIsPassedResult({
    required this.isPassed,
    required this.index,
    required this.direction,
  });

  bool isPassed;
  int index;
  DIRECTION direction;
}
