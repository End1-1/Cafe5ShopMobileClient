import 'dart:math';
import 'dart:typed_data';

import 'package:cafe5_shop_mobile_client/base_widget.dart';
import 'package:cafe5_shop_mobile_client/class_currency.dart';
import 'package:cafe5_shop_mobile_client/class_outlinedbutton.dart';
import 'package:cafe5_shop_mobile_client/class_sale_goods.dart';
import 'package:cafe5_shop_mobile_client/config.dart';
import 'package:cafe5_shop_mobile_client/network_table.dart';
import 'package:cafe5_shop_mobile_client/socket_message.dart';
import 'package:cafe5_shop_mobile_client/translator.dart';
import 'package:cafe5_shop_mobile_client/widget_datatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class WidgetSaleDrafts extends StatefulWidget {

  const WidgetSaleDrafts({super.key});

  @override
  State<StatefulWidget> createState() {
    return WidgetSaleDraftsSate();
  }
}

class WidgetSaleDraftsSate extends BaseWidgetState<WidgetSaleDrafts> {
  final NetworkTable _ntData = NetworkTable();


  @override
  void handler(Uint8List data) async {
    SocketMessage m = SocketMessage(messageId: 0, command: 0);
    m.setBuffer(data);
    if (!checkSocketMessage(m)) {
      return;
    }
    print("command ${m.command}");
    if (m.command == SocketMessage.c_dllplugin) {
      int op = m.getInt();
      int dllok = m.getByte();
      if (dllok == 0) {
        sd(m.getString());
        return;
      }
      switch (op) {
        case SocketMessage.op_create_empty_sale:

          break;
      }
    }
  }

  @override
  void initState() {
      SocketMessage m = SocketMessage.dllplugin(SocketMessage.op_show_drafts_sale);
      sendSocketMessage(m);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            minimum: const EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 35),
            child: Stack(children: [Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                ClassOutlinedButton.createTextAndImage(() {
                  Navigator.pop(context);
                }, tr("Drafts"), "images/back.png", w: 300),
                Expanded(child: Container()),
                // ClassOutlinedButton.createImage(_showAppendGoods, "images/plus.png"),
                // ClassOutlinedButton.createImage(_showMainMenu, "images/menu.png")
              ]),
              const Divider(height: 20, thickness: 2, color: Colors.black26),
              ])
            ])));
  }
}
