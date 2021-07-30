
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'custom_theme_data.dart';

class UiConstants {
  static const PADDING = 20.0;
  static final BORDER_RADIUS = BorderRadius.circular(15);
  static final BOX_SHADOW = BoxShadow(
    color: primaryColorDark,
    blurRadius: 25,
    spreadRadius: 1,
    offset: Offset(0, 2),
  );
  static final CONTAINER_DECORATION = BoxDecoration(
      color: primaryColorLight,
      borderRadius: UiConstants.BORDER_RADIUS,
      boxShadow: [UiConstants.BOX_SHADOW],
  );
}
