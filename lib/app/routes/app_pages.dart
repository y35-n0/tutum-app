import 'package:get/get.dart';
import 'package:tutum_app/app/modules/develop/login/bindings/login_binding.dart';
import 'package:tutum_app/app/modules/develop/login/views/login_view.dart';
import 'package:tutum_app/app/modules/root/views/root_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;
  static final routes = [
    GetPage(name: '/', page: () => RootView(),
      children: [
        GetPage(
          name: _Paths.LOGIN,
          page: () => LoginView(),
          binding: LoginBinding(),
        )
      ]
    )
  ];
}