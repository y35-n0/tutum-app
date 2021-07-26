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
            textAlign: TextAlign.center),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [UiConstants.BOX_SHADOW],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }
}
