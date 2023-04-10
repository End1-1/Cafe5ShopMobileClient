import 'package:cafe5_shop_mobile_client/utils/translator.dart';
import 'package:flutter/material.dart';

Future<void> appDialog(BuildContext context, String message) async {
  return showDialog(
      builder: (context) {
        return SimpleDialog(
          alignment: Alignment.center,
          contentPadding: const EdgeInsets.fromLTRB(30, 5, 30, 10),
          children: [
            Image.asset('assets/images/magnet.png', width: 40, height: 40),
            const Divider(height: 20, color: Colors.lightBlueAccent),
            Text(
                textAlign: TextAlign.center,
                message,
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(tr('Close')))
          ],
        );
      },
      context: context);
}

Future<void> appDialogQuestion(
    BuildContext context, String message, Function? yes, Function? no) async {
  return showDialog(
      builder: (context) {
        return SimpleDialog(
          alignment: Alignment.center,
          contentPadding: const EdgeInsets.fromLTRB(30, 5, 30, 10),
          children: [
            Image.asset('assets/images/magnet.png', width: 40, height: 40),
            const Divider(height: 20, color: Colors.lightBlueAccent),
            Text(
                textAlign: TextAlign.center,
                message,
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(child: Container()),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (yes != null) {
                      yes();
                    }
                  },
                  child: Text(tr('Yes'))),
              const SizedBox(width: 20),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (no != null) {
                      no();
                    }
                  },
                  child: Text(tr('No'))),
              Expanded(child: Container())
            ])
          ],
        );
      },
      context: context);
}
