import 'package:cafe5_shop_mobile_client/class_outlinedbutton.dart';
import 'package:cafe5_shop_mobile_client/translator.dart';
import 'package:cafe5_shop_mobile_client/base_widget.dart';
import 'package:flutter/material.dart';

class WidgetDishManualComment extends StatefulWidget {

  const WidgetDishManualComment({super.key});

  @override
  State<StatefulWidget> createState() {
    return WidgetDishManualCommentState();
  }
}

class WidgetDishManualCommentState extends BaseWidgetState<WidgetDishManualComment> {

  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            minimum: const EdgeInsets.all(3),
            child: Flex(direction: Axis.vertical, mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                ClassOutlinedButton.createImage(() {
                  _cancel();
                }, "images/cancel.png"),
                Expanded(child: Container()),
                Text(tr("Dish manual comment"), style: const TextStyle(fontWeight: FontWeight.bold)),
                Expanded(child: Container()),
                ClassOutlinedButton.createImage((){
                  Navigator.pop(context, _commentController.text);
                }, "images/done.png")
              ]),
              Container(color: Colors.blueGrey, height: 5,),
              TextFormField(
                autofocus: true,
                controller: _commentController,
              )
            ])));
  }


  void _cancel() {
    Navigator.pop(context);
  }
}
