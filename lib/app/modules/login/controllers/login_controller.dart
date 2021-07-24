import 'package:get/get.dart';
import 'package:tutum_app/models/user.dart';
import 'package:tutum_app/services/auth_service.dart';

/// 사용자 로그인 정보 비즈니스 로직
/// 현재 테스트용 사용자 비즈니스 로직
// TODO: 실사용자용으로 변경
class LoginController extends GetxController {
  final List<User> _users = developUsers;

  /// -1일 때 선택된 사용자 X
  final _selectedUserId = (-1).obs;
  final _selectedUserIndex = (-1).obs;
  final _isSelected = List<bool>.filled(developUsers.length, false).obs;

  List<User> get users => _users;

  int get selectedUserId => _selectedUserId.value;

  int get selectedUserIndex => _selectedUserIndex.value;

  User get selectedUser => _selectedUserIndex.value == -1
      ? User()
      : _users[_selectedUserIndex.value];

  List<bool> get isSelected => this._isSelected;

  /// 아이디로 사용 중인 유저 선택
  void selectUserById(int id) {
    if (_selectedUserId.value == id) {
      _deselectUser();
      return;
    } else {
      if (_selectedUserIndex.value != -1)
        _isSelected[_selectedUserIndex.value] = false;
      _selectedUserId.value = id;
      _selectedUserIndex.value = _users.indexWhere((e) => e.id == id);
      _isSelected[_selectedUserIndex.value] = true;
    }
  }

  /// 인덱스로 사용 중인 유저 선택
  void selectUserByIndex(int index) {
    if (_selectedUserIndex.value == index) {
      _deselectUser();
      return;
    } else {
      if (_selectedUserIndex.value != -1)
        _isSelected[_selectedUserIndex.value] = false;
      _selectedUserIndex.value = index;
      _selectedUserId.value = _users[index].id.toInt();
      _isSelected[_selectedUserIndex.value] = true;
      AuthService.to.login(selectedUser);
    }
  }

  void _deselectUser() {
    _isSelected[_selectedUserIndex.value] = false;
    _selectedUserIndex.value = -1;
    _selectedUserId.value = -1;
    AuthService.to.logout();
  }
}

/// 개발용 유저
List<User> developUsers = [
  User(id: 1, name: '김예슬'),
  User(id: 2, name: '양진우'),
  User(id: 3, name: '유한길'),
];
