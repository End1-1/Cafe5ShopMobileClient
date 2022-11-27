import 'package:cafe5_shop_mobile_client/class_outlinedbutton.dart';
import 'package:cafe5_shop_mobile_client/translator.dart';
import 'package:flutter/material.dart';

import 'class_dish_comment.dart';

class ClassSetQtyDlg {
  static Future<double?> getQty(BuildContext context, String msg) async {
    return showDialog<double?>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(tr('Quantity of ')  + '\r\n'+ msg),
          content: Container(
              padding: const EdgeInsets.only(top: 5),
              decoration: BoxDecoration(border: Border.all(color: const Color(0xffeaeaea))),
              height: 300,
              width: 300,
              child: Wrap(runSpacing: 4, children: [
                ClassOutlinedButton.create(() {
                  _result(context, 1);
                }, "1", h: 64, w: 64),
                ClassOutlinedButton.create(() {
                  _result(context, 2);
                }, "2", h: 64, w: 64),
                ClassOutlinedButton.create(() {
                  _result(context, 3);
                }, "3", h: 64, w: 64),
                ClassOutlinedButton.create(() {
                  _result(context, 4);
                }, "4", h: 64, w: 64),
                ClassOutlinedButton.create(() {
                  _result(context, 5);
                }, "5", h: 64, w: 64),
                ClassOutlinedButton.create(() {
                  _result(context, 6);
                }, "6", h: 64, w: 64),
                ClassOutlinedButton.create(() {
                  _result(context, 7);
                }, "7", h: 64, w: 64),
                ClassOutlinedButton.create(() {
                  _result(context, 8);
                }, "8", h: 64, w: 64),
                ClassOutlinedButton.create(() {
                  _result(context, 9);
                }, "9", h: 64, w: 64),
                ClassOutlinedButton.create(() {
                  _result(context, 10);
                }, "10", h: 64, w: 64),
                ClassOutlinedButton.create(() {
                  _result(context, -0.5);
                }, "+0.5", h: 64, w: 64),
                ClassOutlinedButton.create(() {
                  _result(context, 0.5);
                }, "0.5", h: 64, w: 64),
                ClassOutlinedButton.create(() {
                  _result(context, -10);
                }, "+10", h: 64, w: 64),
                ClassOutlinedButton.createImage(() {
                  _result(context, -1000);
                }, "images/trash.png", h: 64, w: 64),
              ])),
          actions: [
            TextButton(
              child: Text(tr("Cancel")),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static void _result(BuildContext context, double v) {
    return Navigator.pop(context, v);
  }
}
