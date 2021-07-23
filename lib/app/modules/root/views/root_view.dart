import 'package:flutter/material.dart';

class RootView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = '/root';
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Container(),
    );
  }
}
