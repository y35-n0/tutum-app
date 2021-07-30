import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutum_app/app/constant/ui_constants.dart';
import 'package:tutum_app/app/modules/home/views/state_tile.dart';
import 'package:tutum_app/services/status_service.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          elevation: 1,
          title: Text('현재 상태'),
        ),
        SliverPadding(
          padding: EdgeInsets.only(top: UiConstants.PADDING / 2),
        ),
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          delegate: SliverChildBuilderDelegate((_, int index) =>
              Obx(() => StatusTile(status: StatusService.to.getStatusByIndex(index))),
          childCount: StatusService.to.length),
        ),
      ],
    ));
  }
}
