import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutum_app/app/constant/ui_constants.dart';
import 'package:tutum_app/app/modules/login/controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('사용자 선택'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
      ),
    );
  }
}
