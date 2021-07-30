import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutum_app/app/constant/custom_theme_data.dart';
import 'package:tutum_app/app/routes/app_pages.dart';
import 'package:tutum_app/services/auth_service.dart';
import 'package:tutum_app/services/sensor/gps_service.dart';
import 'package:tutum_app/services/status_service.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: 'Tutum 안전관리 앱',
      defaultTransition: Transition.rightToLeftWithFade,
      // route 설정
      initialRoute: Routes.TEST,
      getPages: AppPages.routes,
      initialBinding: BindingsBuilder(
        () {
          Get.put(AuthService());
          Get.put(GpsService());
          Get.put(StatusService());
        },
      ),
      theme: customThemeData,
    ),
  );
}
