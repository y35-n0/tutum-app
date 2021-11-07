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
    '업무 중': LEVEL.GOOD,
    '휴식 중': LEVEL.GOOD,
    '퇴근': LEVEL.GOOD,
  },
  '블루투스 연결 상태': {
    '블루투스 연결됨': LEVEL.GOOD,
    '블루투스 연결 안 됨': LEVEL.CAUTION,
  },
  'LTE 통신 상태': {
    'LTE 양호': LEVEL.GOOD,
    'LTE 통신음영': LEVEL.CAUTION,
  },
  '안전모 착용 여부': {
    '안전모 착용': LEVEL.GOOD,
    '안전모 미착용': LEVEL.CAUTION,
  },
  '공기 중 산소 농도': {
    '산소 양호': LEVEL.GOOD,
    '산소 과다': LEVEL.WARNING,
    '산소 결핍': LEVEL.DANGER,
  },
  '기온': {
    '온도 양호': LEVEL.GOOD,
    '온도 관심': LEVEL.GOOD,
    '온도 주의' : LEVEL.CAUTION,
    '온도 경계': LEVEL.WARNING,
    '온도 심각': LEVEL.DANGER,
  },
};
