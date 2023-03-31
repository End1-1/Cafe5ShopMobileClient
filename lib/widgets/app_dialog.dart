import 'package:cafe5_shop_mobile_client/class_outlinedbutton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../translator.dart';

class AppDialog {
  final BuildContext context;
  final String message;
  AppDialog({required this.context, required this.message});

  void show() async {
    await showDialog(builder: (context)
    {
      return SimpleDialog(
        alignment: Alignment.center,
        contentPadding: const EdgeInsets.fromLTRB(30, 5, 30, 10),
        children: [
          Text(textAlign: TextAlign.center, message, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 20),
          ClassOutlinedButton.create ((){Navigator.pop(context);},  tr('Close'))
        ],
      );
    }, context: context);
  }
}