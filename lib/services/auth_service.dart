import 'package:get/get.dart';
import 'package:tutum_app/models/user.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find();

  final _isLoggedIn = false.obs;
  final _loggedInUser = User().obs;

  bool get isLoggedIn => _isLoggedIn.value;
  User get loggedInUser => _loggedInUser.value;

  void login(User user) {
    _isLoggedIn.value = true;
    _loggedInUser.value = user;
    print('${user.id} ${user.name}');
  }

  void logout() {
    _isLoggedIn.value = false;
    _loggedInUser.value = User();
  }
}
