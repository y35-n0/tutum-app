import 'package:get/get.dart';
import 'package:tutum_app/model/develop/user.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find();

  final isLoggedIn = false.obs;
  final LoggedInUser = User().obs;

  bool get isLoggedInValue => isLoggedIn.value;

  void login(User user) {
    isLoggedIn.value = true;
    LoggedInUser.value = user;
  }

  void logout() {
    isLoggedIn.value = false;
    LoggedInUser.value = User();
  }
}
