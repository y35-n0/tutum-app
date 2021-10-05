import 'package:flutter/material.dart';
import 'package:tutum_app/app/constant/ui_constants.dart';

class WorkSettingView extends StatelessWidget {
  late BuildContext cxt;

  @override
  Widget build(BuildContext context) {
    cxt = context;
    return Scaffold(
      appBar: AppBar(title: Text('상태 변경')),
      body: Padding(
        padding: const EdgeInsets.all(UiConstants.PADDING),
        child: Column(
          children: <Widget>[
            _buildButtons(
              title: '근무 상태',
              contents: [
                {'text': '업무 시작', 'function': () {}},
                {'text': '업무 종료', 'function': () {}},
              ],
            ),
            _buildButtons(
              title: '블루투스 연결',
              contents: [
                {'text': '연결', 'function': () {}},
                {'text': '연결 종료', 'function': () {}},
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons({
    required String title,
    required List<Map<String, dynamic>> contents,
  }) {
    return _buildContainer(
      Column(
        children: [
          Text(title, style: Theme.of(cxt).textTheme.subtitle1),
          SizedBox(height: UiConstants.PADDING / 2),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(contents.length * 2 - 1, (index) {
                return index % 2 == 1
                    ? SizedBox(
                        width: UiConstants.PADDING,
                      )
                    : Expanded(
                        child: OutlinedButton(
                          onPressed: contents[index ~/ 2]['function'],
                          child: Text(contents[index ~/ 2]['text']),
                        ),
                      );
              }).toList()),
        ],
      ),
    );
  }

  Widget _buildContainer(Widget child) {
    return Container(
      margin: EdgeInsets.only(bottom: UiConstants.PADDING),
      padding: EdgeInsets.symmetric(
        vertical: UiConstants.PADDING / 2,
        horizontal: UiConstants.PADDING,
      ),
      decoration: UiConstants.CONTAINER_DECORATION,
      child: child,
    );
  }
}
