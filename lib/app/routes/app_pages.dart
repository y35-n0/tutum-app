import 'package:get/get.dart';
import 'package:tutum_app/app/modules/bluetooth/bluetooth_view.dart';
import 'package:tutum_app/app/modules/home/views/home_view.dart';
import 'package:tutum_app/app/modules/login/bindings/login_binding.dart';
import 'package:tutum_app/app/modules/login/views/login_view.dart';
import 'package:tutum_app/app/modules/sensor/views/sensor_view.dart';
import 'package:tutum_app/app/modules/root/views/root_view.dart';
import 'package:tutum_app/app/modules/test/views/test_view.dart';
import 'package:tutum_app/app/modules/work_setting/views/work_setting_view.dart';
import 'package:tutum_app/services/bluetooth_service.dart';

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
        name: Routes.SENSOR,
        page: () => SensorView(),
      ),
      GetPage(
        name: Routes.WORK_SETTING,
        page: () => WorkSettingView(),
      ),
      GetPage(
        name: Routes.BLUETOOTH,
        page: () => BluetoothView(),
      ),
    ])
  ];
}
