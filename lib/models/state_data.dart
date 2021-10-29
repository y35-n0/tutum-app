import 'dart:convert';

/// 이상상태로 전송할 데이터
class StateData {

  void add(dynamic data) {
    switch (data.runtimeType) {

    }
  }

  String get json => jsonEncode(toListMap());

  List<Map<String, dynamic>> toListMap() {
    List<Map<String, dynamic>> list = List.empty(growable: true);
    return list;
  }

  void clear() {
  }
}
