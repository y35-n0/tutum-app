import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:tutum_app/app/constant/custom_theme_data.dart';
import 'package:tutum_app/app/constant/status_level_constants.dart';
import 'package:tutum_app/app/constant/ui_constants.dart';
import 'package:tutum_app/models/status.dart';

// FIXME: 근무 상태가 아닐 때 모두 회색으로 표시

/// 상태[status]를 표시할 타일
/// 상태 종류[status.name], 상태 내용[status.content],
/// 상태 이상상태 수준[status.level], 변경 시각[status.datetime]을 표시.
/// 이상상태 수준에 따라 타일의 색[status.color]을 다르게 함.
class StatusTile extends StatelessWidget {
  const StatusTile({Key? key, required this.status}) : super(key: key);

  final Status status;

  @override
  Widget build(BuildContext context) {
    return Container(
      // 여백 설정
      padding: EdgeInsets.symmetric(
        vertical: UiConstants.PADDING,
        horizontal: UiConstants.PADDING / 2,
      ),
      decoration: BoxDecoration(
        color: primaryColorLight,
        borderRadius: UiConstants.BORDER_RADIUS,

        /// 이상상태 수준에 따라 테두리, 그림자 색 표시
        /// 이상상태 정보가 없거나, 정상인 경우에는 미약하게 표시함.
        border: (status.color == null ||
                status.color == LEVEL_COLOR_MAP[LEVEL.GOOD])
            ? null
            : Border.all(
                color: status.color?.withOpacity(0.4) ??
                    LEVEL_COLOR_MAP[LEVEL.GOOD]!,
                width: 2.5,
              ),
        boxShadow: [
          (status.color == null || status.color == LEVEL_COLOR_MAP[LEVEL.GOOD])
              ? UiConstants.BOX_SHADOW
              : BoxShadow(
                  color: status.color?.withOpacity(0.4) ??
                      LEVEL_COLOR_MAP[LEVEL.GOOD]!,
                  blurRadius: 25,
                  spreadRadius: 1,
                  offset: Offset(0, 2),
                )
        ],
      ),

      child: GridTile(
        /// 상태 종류
        header: Text(
          status.name,
          style: Theme.of(context).textTheme.headline6,
          textAlign: TextAlign.center,
        ),

        /// 상태 변경 시각
        footer: Center(
          child: Text(
            status.datetime == null
                ? 'NULL'
                : DateFormat('yyyy-MM-dd hh:mm:ss.SSS')
                    .format(status.datetime!),
            textAlign: TextAlign.center,
          ),
        ),

        /// 상태 이상상태 수준
        child: Padding(
          padding: const EdgeInsets.all(UiConstants.PADDING / 2),
          // child: FittedBox(
          child: Center(
            child: Text(
              _getContentForTile(),
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(color: status.color),
              maxLines: 2,
              textAlign: TextAlign.center,
              // ),
            ),
          ),
        ),
      ),
    );
  }

  /// 상태 내용 수정 (null 처리, 줄 바꿈)
  String _getContentForTile() {
    switch (status.content) {
      case null:
        return 'NULL';
      case '매우 심한 저산소증':
        return '매우 심한\n저산소증';
      case '통신 음영':
        return '통신\n음영';
      case '산소 부족':
        return '산소\n부족';
      default:
        return status.content!;
    }
  }
}
