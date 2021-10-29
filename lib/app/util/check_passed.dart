import 'dart:math';

import 'package:tutum_app/app/constant/bluetooth_constrant.dart';
import 'package:tutum_app/app/util/theil_sen.dart';

class CheckPassed {
  CheckPassed();

  late TheilSen _theilSen = TheilSen();
  late bool _isPassed;
  late int _passedIndex;
  late PASSED_DIRECTION _passedDirection;

  bool get isPassed => _isPassed;

  int get passedIndex => _passedIndex;

  PASSED_DIRECTION get passSide => _passedDirection;

  void calculate(List<int> data) {
    _theilSen.calculate(data);
    if (_theilSen.a == 0) {
      _isPassed = false;
      _passedIndex = -1;
      _passedDirection = PASSED_DIRECTION.UNKNOWN;
    }
    int rawMaxY = data.reduce(max);
    int rawMaxX = data.indexOf(rawMaxY);

    num predMaxX = -_theilSen.b / (2 * _theilSen.a);

    bool isClose = rawMaxY >= -50;
    bool isConcave = _theilSen.a < 0;

    _isPassed = isClose & isConcave;
    _passedIndex = rawMaxX;
    _passedDirection = rawMaxX - predMaxX > 0 ? PASSED_DIRECTION.OUT_IN : PASSED_DIRECTION.IN_OUT;
  }
}