import 'package:flutter/material.dart';

enum LEVEL {GOOD, CAUTION, WARNING, DANGER}

const Map<LEVEL, Color> LEVEL_COLOR_MAP = {
  LEVEL.GOOD: Colors.black54,
  LEVEL.CAUTION: Colors.yellow,
  LEVEL.WARNING: Colors.orange,
  LEVEL.DANGER: Colors.red,
};

const Map<String, dynamic> STATUS_LEVEL_MAP = {
  '현재 이상상태 수준': {
    '양호': LEVEL.GOOD,
    '주의' : LEVEL.CAUTION,
    '경고': LEVEL.WARNING,
    '위험': LEVEL.DANGER,
  },
  '근무 상태': {
    '업무중': LEVEL.GOOD,
    '휴식중': LEVEL.GOOD,
    '퇴근': LEVEL.GOOD,
  },
  '블루투스 연결 상태': {
    '연결됨': LEVEL.GOOD,
    '미연결': LEVEL.CAUTION,
  },
  'LTE 통신 상태': {
    '양호': LEVEL.GOOD,
    '통신음영': LEVEL.CAUTION,
  },
  '안전모 착용 여부': {
    '착용': LEVEL.GOOD,
    '미착용': LEVEL.CAUTION,
  },
  '낙상 및 추락': {
    '미탐지': LEVEL.GOOD,
    '낙상': LEVEL.WARNING,
    '추릭': LEVEL.DANGER,
  },
  '산소': {
    '양호': LEVEL.GOOD,
    '산소부족': LEVEL.DANGER,
  },
  '기온': {
    '양호': LEVEL.GOOD,
    '관심': LEVEL.GOOD,
    '주의' : LEVEL.CAUTION,
    '경계': LEVEL.WARNING,
    '심각': LEVEL.DANGER,
  },
  '심박수': {
    '정상': LEVEL.GOOD,
    '빈맥': LEVEL.WARNING,
    '서맥': LEVEL.WARNING,
  },
  '산소포화도': {
    '정상': LEVEL.GOOD,
    '주의' : LEVEL.CAUTION,
    '저산소증': LEVEL.DANGER,
    '매우 심한 저산소증': LEVEL.DANGER,
  }
};
