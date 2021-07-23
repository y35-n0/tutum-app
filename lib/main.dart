import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutum_app/app/routes/app_pages.dart';
import 'package:tutum_app/services/auth_service.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: 'Tutum 안전관리 앱',
      defaultTransition: Transition.rightToLeft,
      // route 설정
      initialRoute: Routes.LOGIN,
      getPages: AppPages.routes,
    ),
  );
}