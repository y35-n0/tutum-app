import 'package:get/get.dart';
import 'package:tutum_app/app/middleware/auth_middleware.dart';
import 'package:tutum_app/app/modules/home/views/home_view.dart';
import 'package:tutum_app/app/modules/login/bindings/login_binding.dart';
import 'package:tutum_app/app/modules/login/views/login_view.dart';
import 'package:tutum_app/app/modules/sensor/views/sensor_view.dart';
import 'package:tutum_app/app/modules/root/views/root_view.dart';
import 'package:tutum_app/app/modules/test/views/test_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();


  static const INITIAL = Routes.TEST;

  static final routes = [
    GetPage(
      name: '/',
      page: () => RootView(),
      children: [
        GetPage(
          name: _Paths.LOGIN,
          page: () => LoginView(),
          binding: LoginBinding(),
          middlewares: [
            // FIXME: Login 화면으로 시작할 때 Splash 표시
            // 로그인되어있지 않을 때만 출력
            // EnsureNotAuthMiddleware(),
          ],
        ),
        GetPage(
          name: _Paths.TEST,
          page: () => TestView(),
          children: [
            GetPage(
              name: _Paths.HOME,
              page: () => HomeView(),
            ),
            GetPage(
              name: _Paths.SENSOR,
              page: () => SensorView(),
            ),
          ],
          middlewares: [
            // 로그인되어 있을 때만 출력
            // EnsureAuthMiddleware(),
          ],
        ),
      ],
    )
  ];
}
