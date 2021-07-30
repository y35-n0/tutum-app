import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:tutum_app/app/constant/ui_constants.dart';

/// 센서 값을 표시할 base grid tile
class BaseSensorTile extends StatelessWidget {
  const BaseSensorTile({Key? key, required this.children, required this.header})
      : super(key: key);
  final List<Widget> children;

  final String header;

  @override
  Widget build(BuildContext context) {
    return GridTile(
      header: GridTileBar(
        title: Text(header,
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.center
        ),
      ),
      child: Container(
        padding: EdgeInsets.only(top: UiConstants.PADDING),
        decoration: UiConstants.CONTAINER_DECORATION,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children:
          [
            ...children],
        ),
      ),
    );
  }
}
