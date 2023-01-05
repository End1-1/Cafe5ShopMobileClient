import 'package:cafe5_shop_mobile_client/class_outlinedbutton.dart';
import 'package:cafe5_shop_mobile_client/translator.dart';
import 'package:flutter/material.dart';

class ClassSetQtyDlg {

  static Future<double?> getQty(BuildContext context, String msg) async {
    final TextEditingController _controller = TextEditingController();
    return showDialog<double?>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${tr('Quantity of ')}\r\n$msg'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
              children: [
            Row(children: [Expanded(child: TextFormField(
              maxLines: 1,
              autofocus: true,
              controller: _controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ))])]),
          actions: [
            Row(children:[
            TextButton(
              child: Text(tr("OK")),
              onPressed: () {
                Navigator.of(context).pop(double.parse(_controller.text));
              },
            ),
            Expanded(child: Container()),
            TextButton(
              child: Text(tr("Cancel")),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )]),
          ],
        );
      },
    );
  }

  static void _result(BuildContext context, double v) {
    return Navigator.pop(context, v);
  }
}
