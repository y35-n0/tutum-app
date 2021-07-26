import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutum_app/app/constant/ui_constants.dart';
import 'package:tutum_app/app/routes/app_pages.dart';

/// 개발용 로그인 화면
class TestView extends StatelessWidget {
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
              Text('화면 이동', style: Theme.of(context).textTheme.headline6),
              SizedBox(height: kDefaultPadding / 2),
              ...developPages
                  .map(
                    (e) => ElevatedButton(
                      onPressed: () => Get.toNamed(e),
                      child: Text(e),
                    ),
                  )
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }
}
