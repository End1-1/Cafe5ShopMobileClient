import 'package:cafe5_shop_mobile_client/translator.dart';
import 'package:flutter/material.dart';

import 'class_dish_comment.dart';

class ClassDishesSpecialCommentDlg {

  static Map<int, List<String>> specialComments = {};

  static void init() {
    for (int i = 0; i < ClassDishComment.list.length; i++) {
      final ClassDishComment cmn = ClassDishComment.list.elementAt(i);
      if (cmn.forid > 0) {
        if (!specialComments.containsKey(cmn.forid)) {
          specialComments[cmn.forid] = [];
        }
        specialComments[cmn.forid]!.add(cmn.name);
      }
    }
  }

  static bool specialCommentForDish(int id) {
    return specialComments.containsKey(id);
  }

  static Future<String?> getComment(BuildContext context, int dishid, String msg) async {

    return showDialog<String>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Align(alignment: Alignment.center, child: Text(tr('Comment for ')  + '\r\n' + msg)),
          content: Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffeaeaea))
            ),
            height: 300,
        width: 300,
        child: Column (
            children: _comments(context, dishid),

          )),
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

  static List<Widget> _comments(BuildContext c, int id) {
    List<Widget> w = [];
    List<String>? comments = specialComments[id];
    if (comments == null) {
      w.add(const Text("Empty"));
    } else {
      for (String s in comments) {
        w.add(GestureDetector(
            onTap: (){
              Navigator.of(c).pop(s);
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 2, top: 2),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xffeaeaea)),
              ) ,
                width: 200,
                height: 50,
                child: Align(
                    alignment: Alignment.center,
                    child: Text(s, style: const TextStyle())
                ))
        ));
      }
    }
    w.add(Expanded(child: Container()));
    return w;
  }

}