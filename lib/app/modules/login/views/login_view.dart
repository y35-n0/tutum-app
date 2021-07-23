import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutum_app/app/constant/ui_constants.dart';
import 'package:tutum_app/app/modules/login/controllers/login_controller.dart';
import 'package:tutum_app/app/routes/app_pages.dart';

/// 개발용 로그인 화면
class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    Map<String, GetView> pages = {};

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
              Divider(),
              _buildNavigatorButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectUserContainer(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
      child: Column(
        children: [
          Text('사용자 선택', style: Theme.of(context).textTheme.headline6),
          SizedBox(height: kDefaultPadding / 2),
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
          ),
        ],
      ),
    );
  }

  Widget _buildNavigatorButtons(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
      child: Column(children: [
        Text('화면 이동', style: Theme.of(context).textTheme.headline6),
        SizedBox(height: kDefaultPadding / 2),
        ...developPages.map(
          (e) => ElevatedButton(
            onPressed: () => Get.toNamed(e),
            child: Text(e),
          ),
        ).toList(),
      ]),
    );
  }
}
