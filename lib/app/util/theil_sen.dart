import 'dart:math';
import 'package:trotter/trotter.dart';
import 'package:tutum_app/models/pass/expression.dart';

/// Theil-Sen 알고리즘
/// 2차원 식 추정
class TheilSen {
  TheilSen();

  late Map<num, num> _data;

  late num _a;
  late num _b;
  late num _c;

  Map<num, num> get data => _data;

  /// set [_data] from [x], [y]
  Expression calculate(List<num> y, [List<num>? x]) {
    if (x == null) {
      _data = y.asMap();
    } else {
      final length = x.length <= y.length ? x.length : y.length;
      _data = {for (var i = 0; i < length; i += 1) x[i]: y[i]};
    }
    _calculateA();
    _calculateB();
    _calculateC();

    return Expression(_a, _b, _c);
  }

  void _calculateA() {
    final combs = Combinations(3, _data.entries.toList());
    combs.items.shuffle(Random(42));
    List<num> list = [];

    for (final comb in combs().take(10000)) {
      list.add((comb[2].key * (comb[1].value - comb[0].value) +
              comb[1].key * (comb[0].value - comb[2].value) +
              comb[0].key * (comb[2].value - comb[1].value)) /
          ((comb[0].key - comb[1].key) *
              (comb[0].key - comb[2].key) *
              (comb[1].key - comb[2].key)));
    }

    _a = _calculateMedian(list);
  }

  void _calculateB() {
    final combs = Combinations(2, _data.entries.toList());
    List<num> list = [];

    for (final comb in combs()) {
      list.add(((comb[1].value - _a * pow(comb[1].key, 2)) -
              (comb[0].value - _a * pow(comb[0].key, 2))) /
          (comb[1].key - comb[0].key));
    }

    _b = _calculateMedian(list);
  }

  void _calculateC() {
    List<num> list = [];

    for (final datum in _data.entries) {
      list.add((datum.value - _a * pow(datum.key, 2) - _b * datum.key));
    }
    _c = _calculateMedian(list);
  }

  num _calculateMedian(List<num> list) {
    list.sort();
    int mid = list.length ~/ 2;
    if (list.length % 2 == 1) {
      return list[mid];
    } else {
      return (list[mid] + list[mid - 1]) / 2;
    }
  }
}
