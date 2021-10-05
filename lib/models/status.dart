import 'package:flutter/material.dart';
import 'package:tutum_app/app/constant/status_level_constants.dart';

class Status {
  Status({
    required this.name,
    this.datetime,
    this.content,
  })  : level = STATUS_LEVEL_MAP[name][content] ?? null,
        color = LEVEL_COLOR_MAP[STATUS_LEVEL_MAP[name][content]] ?? null;

  String name;
  DateTime? datetime;
  String? content;
  LEVEL? level;
  Color? color;
}
