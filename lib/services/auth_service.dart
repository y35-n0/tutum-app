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

  @override
  /// 저장된 로그인로 초기화
  void onInit() {
    super.onInit();
    _getStoredTokenAndLogin();
  }


  // FIXME: 유저 정보 ->  토큰
  void _getStoredTokenAndLogin() async {
    String userId = await storage.read(key: 'userId') ?? '';
    String userName = await storage.read(key: 'userName') ?? '';
    if (userId != '' && userName != '') {
      login(User(id: num.parse(userId), name: userName), manual: false);
    }
  }

  // FIXME: 토큰으로 서버에서 사용자 정보 가져오기
  /// 사용자 로그인, 수동로그인[manual] 일 때 로그인 정보 저장 [storage.write]
  void login(User user, {bool manual: true}) async {
    _isLoggedIn.value = true;
    _loggedInUser.value = user;
    if (manual) {
      await storage.write(key: 'userId', value: user.id.toString());
      await storage.write(key: 'userName', value: user.name);
    }
  }

  /// 사용자 로그아웃, 로그인 정보 지우기 [storage.deleteAll]
  void logout() async {
    _isLoggedIn.value = false;
    _loggedInUser.value = User();
    await storage.delete(key: 'userId');
    await storage.delete(key: 'userName');
  }
}
