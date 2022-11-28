import 'dart:io';
import 'dart:typed_data';

import 'package:cafe5_shop_mobile_client/base_widget.dart';
import 'package:cafe5_shop_mobile_client/class_outlinedbutton.dart';
import 'package:cafe5_shop_mobile_client/socket_message.dart';
import 'package:cafe5_shop_mobile_client/translator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class WidgetCheckQty extends StatefulWidget {
  const WidgetCheckQty({super.key});

  @override
  State<StatefulWidget> createState() {
    return WidgetCheckQtyState();
  }
}

class WidgetCheckQtyState extends BaseWidgetState<WidgetCheckQty> {

  final TextEditingController _barcodeController = TextEditingController();

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
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            minimum: const EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 35),
            child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                ClassOutlinedButton.createTextAndImage(() {
                  Navigator.pop(context);
                }, tr("Check quantity"), "images/back.png", w: 300),
                Expanded(child: Container()),
              ]),
              const Divider(height: 20, thickness: 2, color: Colors.black26),
              Row(children: [
              Container(
                margin: const EdgeInsets.only(right: 3),
                  width: 250,
                  child: TextFormField(
                controller: _barcodeController,
              )),
                ClassOutlinedButton.createImage((){_barcodeController.clear();}, "images/cancel.png"),
                ClassOutlinedButton.createImage(_search, "images/search.png"),
                ClassOutlinedButton.createImage(_readBarcode, "images/barcode.png")
              ]),

            ])));
  }

  void _search() {
    if (_barcodeController.text.isEmpty) {
      return;
    }
    SocketMessage m = SocketMessage.dllplugin(SocketMessage.op_check_qty);
    m.addString(_barcodeController.text);
    sendSocketMessage(m);
  }

  void _readBarcode() {
    FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.BARCODE).then((barcodeScanRes) {
      _barcodeController.text = barcodeScanRes;
      _search();
    });
  }
}
