import 'dart:typed_data';

import 'package:cafe5_shop_mobile_client/base_widget.dart';
import 'package:cafe5_shop_mobile_client/class_outlinedbutton.dart';
import 'package:cafe5_shop_mobile_client/network_table.dart';
import 'package:cafe5_shop_mobile_client/socket_message.dart';
import 'package:cafe5_shop_mobile_client/translator.dart';
import 'package:cafe5_shop_mobile_client/widget_datatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class WidgetSaleDocument extends StatefulWidget {

  String saleUuid;

  WidgetSaleDocument({super.key, required this.saleUuid});

  @override
  State<StatefulWidget> createState() {
    return WidgetSaleDocumentState();
  }
}

class WidgetSaleDocumentState extends BaseWidgetState<WidgetSaleDocument> with TickerProviderStateMixin  {

  final TextEditingController _barcodeController = TextEditingController();
  final NetworkTable _ntData = NetworkTable();
  int _menuAnimationDuration = 300;
  bool _hideMenu = true;
  double _startMenuY = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;

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
          });
          break;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastLinearToSlowEaseIn,
    );
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
                }, tr("Sale document"), "images/back.png", w: 300),
                Expanded(child: Container()),
                ClassOutlinedButton.createImage(_showAppendGoods, "images/plus.png")
              ]),
              const Divider(height: 20, thickness: 2, color: Colors.black26),
              _appendMenu(),
              const Divider(),
              Expanded(
                  child: WidgetNetworkDataTable(networkTable: _ntData,)
              )
            ])));
  }

  void _showAppendGoods() {
    if (_animation.status != AnimationStatus.completed) {
      _animationController.forward();
    } else {
      _animationController.animateBack(0, duration: const Duration(seconds: 1));
    }
  }

  Widget _appendMenu() {
    return SizeTransition(sizeFactor: _animation,
    axis: Axis.vertical,
    child: Row(children: [
      Container(
          margin: const EdgeInsets.only(right: 3),
          width: 250,
          child: TextFormField(
            controller: _barcodeController,
          )),
      ClassOutlinedButton.createImage((){_barcodeController.clear();}, "images/cancel.png"),
      ClassOutlinedButton.createImage(_search, "images/search.png"),
      ClassOutlinedButton.createImage(_readBarcode, "images/barcode.png")
    ]));
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
      _barcodeController.text = barcodeScanRes;
      _search();
    });
  }
}
