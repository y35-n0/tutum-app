import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutum_app/app/constant/ui_constants.dart';
import 'package:tutum_app/app/modules/develop/login/controllers/login_controller.dart';

/// 개발용 로그인 화면
class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('개발용 홈'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildSelectUserContainer(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectUserContainer(context) {
    return Column(
      children: [
        Text('사용자 선택', style: Theme.of(context).textTheme.headline6),
        SizedBox(height: 10),
        Obx(
          () => ToggleButtons(
            constraints: BoxConstraints.expand(
              width: Get.width / (controller.users.length + 1),
            ),
            borderRadius: BorderRadius.circular(15),
            children: controller.users
                .map((e) => Padding(
                      padding: const EdgeInsets.all(kDefaultPadding),
                      child: Text('${e.id} : ${e.name}'),
                    ))
                .toList(),
            isSelected: controller.isSelected,
            onPressed: (int index) {
              controller.selectUserByIndex(index);
            },
          ),
        )
      ],
    );
  }
}
