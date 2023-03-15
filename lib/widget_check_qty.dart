import 'dart:io';
import 'dart:typed_data';

import 'package:cafe5_shop_mobile_client/base_widget.dart';
import 'package:cafe5_shop_mobile_client/class_outlinedbutton.dart';
import 'package:cafe5_shop_mobile_client/socket_message.dart';
import 'package:cafe5_shop_mobile_client/translator.dart';
import 'package:cafe5_shop_mobile_client/widget_datatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:cafe5_shop_mobile_client/network_table.dart';

class WidgetCheckQty extends StatefulWidget {
  const WidgetCheckQty({super.key});

  @override
  State<StatefulWidget> createState() {
    return WidgetCheckQtyState();
  }
}

class WidgetCheckQtyState extends BaseWidgetState<WidgetCheckQty> {

  final TextEditingController _barcodeController = TextEditingController();
  final NetworkTable _ntData = NetworkTable();
  String _name = "";

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
        case SocketMessage.op_check_qty:
          setState((){
            _ntData.readFromSocketMessage(m);
            _name = m.getString();
          });
          break;
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
                }, tr("Check quantity"), "images/back.png", w: null),
                Expanded(child: Container()),
                ClassOutlinedButton.createImage(
                        (){}, 'images/menu.png'
                )]),
              const Divider(height: 20, thickness: 2, color: Colors.black26),
              Row(children: [
                Expanded(child:
              Form(child: Container(
                margin: const EdgeInsets.only(right: 3),
                  child: TextFormField(
                controller: _barcodeController,
              )))),
                ClassOutlinedButton.createImage((){_barcodeController.clear();}, "images/cancel.png"),
                ClassOutlinedButton.createImage(_search, "images/search.png"),
                ClassOutlinedButton.createImage(_readBarcode, "images/barcode.png")
              ]),
              const Divider(),
              Text(_name),
              Expanded(
                child: WidgetNetworkDataTable(networkTable: _ntData,)
              )
            ])));
  }

  void _search() {
    if (_barcodeController.text.isEmpty) {
      return;
    }
    SocketMessage m = SocketMessage.dllplugin(SocketMessage.op_check_qty);
    m.addString(_barcodeController.text);
    m.addInt(1);
    sendSocketMessage(m);
  }

  void _readBarcode() {
    FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.BARCODE).then((barcodeScanRes) {
      if (barcodeScanRes != "-1") {
        _barcodeController.text = barcodeScanRes;
        _search();
      }
    });
  }
}
