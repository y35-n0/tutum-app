import 'package:get/get.dart';
import 'package:tutum_app/models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// 로그인 정보
/// [_isLoggedIn] 로그인 유무, [_loggedInUser] 로그인 한 사용자 정보
class AuthService extends GetxService {
  static AuthService get to => Get.find();

  final _isLoggedIn = false.obs;
  final _loggedInUser = User().obs;
  final storage = FlutterSecureStorage();

  bool get isLoggedIn => _isLoggedIn.value;

  User get loggedInUser => _loggedInUser.value;

  // FIXME: 초기화 때까지 splash 스크린 표시
  /// 저장된 로그인로 초기화
  @override
  void onInit() {
    super.onInit();
    _getStoredUserAndLogin();
  }

  // FIXME: 유저 정보 ->  토큰
  Future<void> _getStoredUserAndLogin() async {
    List<String> user = (await storage.read(key: 'user') ?? '').split(' ');
    if (user.length > 1) {
      login(User(id: num.parse(user[0]), name: user[1]));
    }
  }

  // FIXME: 토큰으로 서버에서 사용자 정보 가져오기
  /// 사용자 로그인, 수동로그인[manual] 일 때 로그인 정보 저장 [storage.write]
  void login(User user, {bool manual: false}) async {
    _isLoggedIn.value = true;
    _loggedInUser.value = user;
    if (manual) {
      await storage.write(key: 'user', value: '${user.id.toString()} ${user.name}');
    }
    print(_isLoggedIn.value.toString());
  }

  /// 사용자 로그아웃, 로그인 정보 지우기 [storage.delete]
  void logout() async {
    _isLoggedIn.value = false;
    _loggedInUser.value = User();
    await storage.delete(key: 'user');
  }
}
