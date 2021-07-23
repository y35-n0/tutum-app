import 'package:get/get.dart';
import 'package:tutum_app/app/modules/login/bindings/login_binding.dart';
import 'package:tutum_app/app/modules/login/views/login_view.dart';
import 'package:tutum_app/app/modules/sensor/views/sensor_view.dart';
import 'package:tutum_app/app/modules/root/views/root_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;
  static final routes = [
    GetPage(name: '/', page: () => RootView(),
      children: [
        GetPage(
          name: Routes.LOGIN,
          page: () => LoginView(),
          binding: LoginBinding(),
        ),
        GetPage(
          name: Routes.SENSOR,
          page: () => SensorView(),
        )
      ]
    )
  ];
}