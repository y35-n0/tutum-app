import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tutum_app/app/modules/test/sensor_test_view.dart';
import 'package:tutum_app/app/modules/test/beacon_test_view.dart';
import 'package:tutum_app/app/modules/home/views/home_view.dart';
import 'package:tutum_app/app/modules/login/bindings/login_binding.dart';
import 'package:tutum_app/app/modules/login/views/login_view.dart';
import 'package:tutum_app/app/modules/root/views/root_view.dart';
import 'package:tutum_app/app/modules/test/test_view.dart';
import 'package:tutum_app/app/modules/work_setting/views/work_setting_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;
  static final routes = [
    GetPage(name: '/', page: () => RootView(), children: [
      GetPage(
        name: Routes.HOME,
        page: () => HomeView(),
      ),
      GetPage(
        name: Routes.TEST,
        page: () => TestView(),
      ),
      GetPage(
        name: Routes.LOGIN,
        page: () => LoginView(),
        binding: LoginBinding(),
      ),
      GetPage(
        name: Routes.WORK_SETTING,
        page: () => WorkSettingView(),
      ),
      GetPage(
        name: Routes.BEACON,
        page: () => BeaconTestView(),
      ),
      GetPage(
        name: Routes.SENSOR,
        page: () => SensorTestView(),
      ),
    ])
  ];
}
