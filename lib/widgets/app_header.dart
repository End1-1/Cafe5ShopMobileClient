import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../class_outlinedbutton.dart';
import '../translator.dart';

class AppHeader extends StatelessWidget {
  late final String title;
  List<Widget> widgets = [];

  AppHeader({required this.title, this.widgets = const []});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(children: [
        Expanded(
            child: Container(
              color: Colors.white,                child: Row(children: [
          ClassOutlinedButton.createTextAndImage(() {
            Navigator.pop(context);
          }, tr(title), "images/back.png", w: 280),
          for (var e in widgets) ...[
            e,
          ]
        ])))
      ]),
      const Divider(height: 20, thickness: 2, color: Colors.black26)
    ]);
  }
}
