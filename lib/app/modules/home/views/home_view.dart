import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutum_app/app/constant/ui_constants.dart';
import 'package:tutum_app/app/modules/home/views/state_tile.dart';
import 'package:tutum_app/services/abnormal_state_service.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('현재 상태'),
        ),
        body: Container(
          padding: const EdgeInsets.all(UiConstants.PADDING),
          child: GridView(
            clipBehavior: Clip.none,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: UiConstants.PADDING / 2,
              crossAxisSpacing: UiConstants.PADDING / 2,
            ),
            children: List.generate(
                StateService.to.length,
                (index) => Obx(() => StatusTile(
                    state: StateService.to.getStatusByIndex(index)))),
          ),
        ));
  }
}
