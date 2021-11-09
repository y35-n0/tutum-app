import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutum_app/app/constant/ui_constants.dart';
import 'package:tutum_app/app/modules/login/controllers/login_controller.dart';
import 'package:tutum_app/models/user.dart';

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
            SizedBox(height: UiConstants.PADDING / 2),
            ElevatedButton(
              child: Text("None"),
              onPressed: () => controller.selectUserByIndex(0),
            ),
            Obx(() => DropdownButton(
                value: controller.selectedUserIndex == -1
                    ? null
                    : controller.selectedUserIndex,
                items: controller.users
                    .map((e) => DropdownMenuItem(
                        value: e.id as int, child: Text(e.id.toString())))
                    .toList(),
                onChanged: (id) {
                  id as int?;
                  controller.selectUserByIndex(id ?? -1);
                })),
          ],
        ),
      ),
    );
  }
}
