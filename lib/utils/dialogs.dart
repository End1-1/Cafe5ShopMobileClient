import 'package:cafe5_shop_mobile_client/translator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> appDialog(BuildContext context, String message) async {
  showDialog(builder: (context)
  {
    return SimpleDialog(
      alignment: Alignment.center,
      contentPadding: const EdgeInsets.fromLTRB(30, 5, 30, 10),
      children: [
        Image.asset('images/magnet.png', width: 40, height: 40),
        const Divider(height: 1, color: Colors.lightBlueAccent),
        Text(textAlign: TextAlign.center, message, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 20),
        TextButton(onPressed: (){Navigator.pop(context);}, child: Text(tr('Close')))
      ],
    );
  }, context: context);
}