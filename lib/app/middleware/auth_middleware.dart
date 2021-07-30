import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutum_app/app/routes/app_pages.dart';
import 'package:tutum_app/services/auth_service.dart';

/// 로그인 상태가 아니면 로그인 화면 표시
class EnsureAuthMiddleware extends GetMiddleware {
  @override
  int? priority = 0;

  @override
  RouteSettings? redirect(String? route) {
    print(AuthService.to.isLoggedIn.toString());
    return AuthService.to.isLoggedIn
        ? null
        : RouteSettings(name: Routes.LOGIN);
  }
}

/// 로그인 상태가 아닐 때만 로그인 화면 표시
class EnsureNotAuthMiddleware extends GetMiddleware {
  @override
  int? priority = 1;

  @override
  RouteSettings? redirect(String? route) {
    return AuthService.to.isLoggedIn
        ? null
        : RouteSettings(name: route);
  }
}