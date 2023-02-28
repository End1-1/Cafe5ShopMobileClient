import 'dart:math';
import 'dart:typed_data';

import 'package:cafe5_shop_mobile_client/base_widget.dart';
import 'package:cafe5_shop_mobile_client/class_currency.dart';
import 'package:cafe5_shop_mobile_client/class_outlinedbutton.dart';
import 'package:cafe5_shop_mobile_client/class_price_type.dart';
import 'package:cafe5_shop_mobile_client/class_sale_goods.dart';
import 'package:cafe5_shop_mobile_client/class_sale_goods_record.dart';
import 'package:cafe5_shop_mobile_client/class_set_qty_dlg.dart';
import 'package:cafe5_shop_mobile_client/config.dart';
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

class WidgetSaleDocumentState extends BaseWidgetState<WidgetSaleDocument> with TickerProviderStateMixin {
  final TextEditingController _barcodeController = TextEditingController();
  final NetworkTable _ntData = NetworkTable();
  double _totalAmount = 0;
  List<SaleGoodsRecord> _goods = [];
  final List<double> _goodsColumnWidths = [0, 0, 0, 100, 80, 80, 80];
  late AnimationController _animationController;
  late Animation<double> _animation;
  late AnimationController _animationController2;
  late Animation<double> _animation2;
  List<int> _indexOfSugges = [];

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
          widget.saleUuid = m.getString();
          break;
        case SocketMessage.op_add_goods_to_draft:
          SaleGoodsRecord s = SaleGoodsRecord(id: m.getString(), state: m.getInt(), goods: m.getInt(), name: m.getString(), qty: m.getDouble(), price: m.getDouble());
          s.name = SaleGoods.names[s.goods]!;
          _totalAmount = m.getDouble();
          if (s.state == 2) {
            for (int i = 0; i < _goods.length; i++) {
              if (_goods[i].id == s.id) {
                _goods.removeAt(i);
                break;
              }
            }
          } else {
            bool isnew = true;
            for (int i = 0; i < _goods.length; i++) {
              if (_goods[i].id == s.id) {
                _goods[i] = s;
                isnew = false;
                break;
              }
            }
            if (isnew) {
              _goods.add(s);
            }
          }
          setState(() {});
          break;
        case SocketMessage.op_open_sale_draft_document:
          setState(() {
            _totalAmount = m.getDouble();
          });

          m = SocketMessage.dllplugin(SocketMessage.op_open_sale_draft_body);
          m.addString(widget.saleUuid);
          sendSocketMessage(m);
          break;
        case SocketMessage.op_open_sale_draft_body:
          _ntData.readFromSocketMessage(m);
          for (int i = 0; i < _ntData.rowCount; i++) {
            SaleGoodsRecord s = SaleGoodsRecord(id: _ntData.getRawData(i, 0), state: 1, goods: _ntData.getRawData(i, 1), name: "", qty: _ntData.getRawData(i, 2), price: _ntData.getRawData(i, 2));
            s.name = SaleGoods.names[s.goods]!;
            _goods.add(s);
          }
          setState(() {

          });
          break;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    );
    _animationController2 = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation2 = CurvedAnimation(
      parent: _animationController2,
      curve: Curves.linear,
    );
    if (widget.saleUuid.isEmpty) {
      SocketMessage m = SocketMessage.dllplugin(SocketMessage.op_create_empty_sale);
      sendSocketMessage(m);
    } else {
      SocketMessage m = SocketMessage.dllplugin(SocketMessage.op_open_sale_draft_document);
      m.addString(widget.saleUuid);
      sendSocketMessage(m);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            minimum: const EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 35),
            child: Stack(children: [
              Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  ClassOutlinedButton.createTextAndImage(() {
                    Navigator.pop(context);
                  }, tr("Sale document"), "images/back.png", w: 280),
                  Expanded(child: Container()),
                  ClassOutlinedButton.createImage(_showAppendGoods, "images/plus.png"),
                  ClassOutlinedButton.createImage(_showMainMenu, "images/menu.png")
                ]),
                const Divider(height: 20, thickness: 2, color: Colors.black26),
                _appendMenu(),
                const Divider(),
                Expanded(
                    child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: SingleChildScrollView(scrollDirection: Axis.vertical, child: Column(
                  children: _listOfGoods(),
                )))),
                const Divider(
                  height: 3,
                ),
                Row(
                  children: [Text(tr("Total")), const VerticalDivider(width: 5), Text(_totalAmount.toString())],
                )
              ]),
              _showMenu()
            ])));
  }

  void _buildSearchList(String suggestion) {
    _indexOfSugges.clear();
    if (suggestion.length < 4) {
      setState(() {});
      return;
    }
    for (int i = 0; i < SaleGoods.list.length; i++) {
      final SaleGoods s = SaleGoods.list[i];
      if (s.name.toLowerCase().contains(suggestion.toLowerCase()) || s.barcode == suggestion) {
        _indexOfSugges.add(i);
      }
    }
    setState(() {});
  }

  List<Widget> _listOfGoods() {
    List<Widget> l = [];
    for (int i = 0; i < _goods.length; i++) {
      SaleGoodsRecord s = _goods[i];
      l.add(Row(
        children: [
          ClassOutlinedButton.createImage(() {
            sq(tr("Confirm to remove row"), ()
            {
              SocketMessage m = SocketMessage.dllplugin(SocketMessage.op_add_goods_to_draft);
              m.addString(s.id);
              m.addString(widget.saleUuid);
              m.addInt(s.goods);
              m.addInt(2); //state
              m.addDouble(s.qty);
              m.addDouble(s.price);
              sendSocketMessage(m);
            }, (){});
          }, "images/cancel.png"),
          Container(padding: const EdgeInsets.all(3), width: 100, child: Text(s.name)),
          GestureDetector(onTap: () {
            ClassSetQtyDlg.getQty(context, s.name).then((value){
              if (value != null) {
                s.qty = value;
                SocketMessage m = SocketMessage.dllplugin(SocketMessage.op_add_goods_to_draft);
                m.addString(s.id);
                m.addString(widget.saleUuid);
                m.addInt(s.goods);
                m.addInt(value == -1000 ? 2 : 1); //state
                m.addDouble(s.qty);
                m.addDouble(s.price);
                sendSocketMessage(m);
              }
            });
          }, child: Container(padding: const EdgeInsets.all(3), width: 80, child: Text(s.qty.toString()))),
          GestureDetector(onTap:(){
            
          }, child: Container(padding: const EdgeInsets.all(3), width: 80, child: Text(s.price.toString()))),
          Container(padding: const EdgeInsets.all(3), width: 80, child: Text((s.qty * s.price).toString()))],
      ));
    }
    return l;
  }

  List<Widget> _listOfSuggestions() {
    List<Widget> l = [];
    for (int i = 0; i < _indexOfSugges.length; i++) {
      final SaleGoods s = SaleGoods.list[_indexOfSugges[i]];
      l.add(Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          ClassOutlinedButton.createImage(() {
            SocketMessage m = SocketMessage.dllplugin(SocketMessage.op_add_goods_to_draft);
            m.addString("");
            m.addString(widget.saleUuid);
            m.addInt(s.goods);
            m.addInt(1); //state
            m.addDouble(1);
            m.addDouble(Config.getInt(key_local_price_type) == 2 ? s.price2 : s.price1);
            sendSocketMessage(m);
          }, "images/plus.png", h: 30, w: 30),
          const VerticalDivider(width: 5),
          Container(width: 100, child: Text(s.barcode, textAlign: TextAlign.start)),
          const VerticalDivider(
            width: 5,
          ),
          Container(
              width: 150,
              child: Text(
                s.name,
                textAlign: TextAlign.start,
              )),
          const VerticalDivider(
            width: 5,
          ),
          SizedBox(width: 100, child: Text(Config.getInt(key_local_price_type) == 2 ? s.price2.toString() : s.price1.toString()))
        ],
      ));
      l.add(const Divider(
        height: 5,
      ));
    }
    return l;
  }

  void _showAppendGoods() {
    if (_animation.status != AnimationStatus.completed) {
      _animationController.forward();
    } else {
      _animationController.animateBack(0, duration: const Duration(milliseconds: 300));
    }
  }

  void _showMainMenu() {
    if (_animation2.status != AnimationStatus.completed) {
      _animationController2.forward();
    } else {
      _animationController2.animateBack(0, duration: const Duration(milliseconds: 300));
    }
  }

  Widget _appendMenu() {
    return SizeTransition(
        sizeFactor: _animation,
        axis: Axis.vertical,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
          Row(children: [
            Expanded(
                child: Container(
                    margin: const EdgeInsets.only(right: 3),
                    child: TextFormField(
                      onChanged: _buildSearchList,
                      controller: _barcodeController,
                    ))),
            ClassOutlinedButton.createImage(() {
              _barcodeController.clear();
              _buildSearchList("");
            }, "images/cancel.png"),
            ClassOutlinedButton.createImage(_search, "images/search.png"),
            ClassOutlinedButton.createImage(_readBarcode, "images/barcode.png")
          ]),
          const Divider(
            height: 15,
          ),
          SizedBox(
              height: 300,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _listOfSuggestions(),
                      ))))
        ]));
  }

  Widget _showMenu() {
    return SizeTransition(
        sizeFactor: _animation2,
        axis: Axis.horizontal,
        child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Column(children: [
              Row(
                children: [
                  Text(tr("Currency")),
                  const VerticalDivider(width: 5),
                  DropdownButton<Currency>(
                    value: Currency.valueOf(Config.getInt(key_local_currency_id)),
                    items: Currency.list.map((Currency value) {
                      return DropdownMenuItem<Currency>(
                        value: value,
                        child: Text(value.name),
                      );
                    }).toList(),
                    onChanged: (v) {
                      Config.setInt(key_local_currency_id, v!.id);
                    },
                  ),
                  Expanded(child: Container()),
                  const VerticalDivider(
                    width: 5,
                  ),
                  ClassOutlinedButton.createImage(_showMainMenu, "images/cancel.png")
                ],
              ),
              Row(
                children: [
                  Text(tr("Price")),
                  const VerticalDivider(width: 5),
                  DropdownButton<PriceType>(
                    value: PriceType.valueOf(Config.getInt(key_local_price_type)),
                    items: PriceType.list.map((PriceType value) {
                      return DropdownMenuItem<PriceType>(
                        value: value,
                        child: Text(value.name),
                      );
                    }).toList(),
                    onChanged: (v) {
                      setState(() {
                        Config.setInt(key_local_price_type, v!.id);
                      });
                    },
                  ),
                  Expanded(child: Container()),
                ],
              )
            ])));
  }

  void _search() {
    if (_barcodeController.text.isEmpty) {
      return;
    }
    _buildSearchList(_barcodeController.text);
    // SocketMessage m = SocketMessage.dllplugin(SocketMessage.op_check_qty);
    // m.addString(_barcodeController.text);
    // m.addInt(1);
    // sendSocketMessage(m);
  }

  void _readBarcode() {
    FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.BARCODE).then((barcodeScanRes) {
      if (barcodeScanRes != "-1") {
        _barcodeController.text = barcodeScanRes;
        _buildSearchList(barcodeScanRes);
        //_search();
      }
    });
  }
}
