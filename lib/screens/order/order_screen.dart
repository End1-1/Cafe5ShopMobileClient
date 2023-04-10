import 'package:cafe5_shop_mobile_client/freezed/goods.dart';
import 'package:cafe5_shop_mobile_client/freezed/partner.dart';
import 'package:cafe5_shop_mobile_client/models/http_query/http_query.dart';
import 'package:cafe5_shop_mobile_client/models/model.dart';
import 'package:cafe5_shop_mobile_client/screens/goods_list/goods_list_screen.dart';
import 'package:cafe5_shop_mobile_client/screens/partner_screen/partner_screen.dart';
import 'package:cafe5_shop_mobile_client/screens/screen/app_scaffold.dart';
import 'package:cafe5_shop_mobile_client/translator.dart';
import 'package:cafe5_shop_mobile_client/utils/dialogs.dart';
import 'package:cafe5_shop_mobile_client/utils/prefs.dart';
import 'package:cafe5_shop_mobile_client/widgets/square_button.dart';
import 'package:flutter/material.dart';

import 'order_model.dart';

class OrderScreen extends StatelessWidget {
  final OrderModel model = OrderModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  OrderScreen({super.key, required pricePolitic}) {
    model.pricePolitic = pricePolitic;
  }

  void popupMenu(BuildContext context) {
    showDialog(
      useRootNavigator: false,
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: [
            //Goods list
            ListTile(
                dense: false,
                title: Text(tr('Goods list')),
                leading: Image.asset('assets/images/goods.png'),
                onTap: () async {
                  Navigator.pop(context);
                  var result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GoodsListScreen(
                              pricePolitic: model.pricePolitic,
                              discount: model.partner.discount)));
                  if (result != null && result.isNotEmpty) {
                    model.goods.addAll(result);
                    model.goodsController.add(model.goods);
                    model.inputDataChanged(null);
                  }
                }),
            //Partner
            ListTile(
                dense: false,
                title: Text(tr('Set partner')),
                leading: Image.asset('assets/images/partner.png'),
                onTap: () async {
                  Navigator.pop(context);
                  var result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PartnerScreen(
                                selectMode: true,
                              )));
                  if (result != null) {
                    model.partner = result;
                    model.pricePolitic = model.partner.pricepolitic;
                    model.partnerController.add(model.partner);
                    if (model.goods.isNotEmpty) {
                      for (int i = 0; i < model.goods.length; i++) {
                        model.goods[i] = model.goods[i].copyWith(
                            price: model.pricePolitic == mdPriceRetail
                                ? model.goods[i].price1
                                : model.goods[i].price2);
                      }
                      if (model.partner.discount > 0) {
                        for (int i = 0; i < model.goods.length; i++) {
                          model.goods[i] = model.goods[i].copyWith(
                              price: model.goods[i].price! -
                                  (model.goods[i].price! *
                                      (model.partner.discount / 100)));
                        }
                      }
                      model.goodsController.add(model.goods);
                      model.inputDataChanged(null);
                    }
                  }
                }),
            //Upload order
            ListTile(
                dense: false,
                title: Text(tr('Complete order')),
                leading: Image.asset('assets/images/upload.png'),
                onTap: () async {
                  Navigator.pop(context);
                  String err = '';
                  if (model.partner.id == 0) {
                    err += '${tr('Select partner')}\r\n';
                  }
                  if (model.goods.isEmpty) {
                    err += '${tr('Goods list is empty')}\r\n';
                  }
                  for (var e in model.goods) {
                    if ((e.qtySale ?? 0) == 0 && (e.qtyBack ?? 0) == 0) {
                      err += '${tr('Check quantity of rows')}\r\n';
                      break;
                    }
                  }
                  if (err.isNotEmpty) {
                    appDialog(_scaffoldKey.currentContext!, err);
                    return;
                  }

                  appDialogQuestion(_scaffoldKey.currentContext!, tr('Confirm to save order and quit'), () async {
                    BuildContext dialogContext = _scaffoldKey.currentContext!;
                    showDialog(
                      context: _scaffoldKey.currentContext!,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        dialogContext = context;
                        return Dialog(
                          child: new Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              new CircularProgressIndicator(),
                              new Text(tr('Saving')),
                            ],
                          ),
                        );
                      },
                    );

                    Map<String, Object?> requiestMap = model.toMap();
                    int r = await HttpQuery(hqSaveOrder).request(requiestMap);
                    Navigator.pop(dialogContext);
                    switch (r) {
                      case hrFail:
                        appDialog(_scaffoldKey.currentContext!, requiestMap['message'].toString());
                        return;
                      case hrOk:
                        break;
                      case hrNetworkError:
                        appDialog(_scaffoldKey.currentContext!, requiestMap['message'].toString());
                        return;
                    }
                  }, null);
                }),
            //Exit
            const SizedBox(height: 40),
            ListTile(
                dense: false,
                title: Text(tr('Exit')),
                leading: Image.asset('assets/images/exit.png'),
                onTap: () async {
                  Navigator.pop(context);
                  appDialogQuestion(context, tr('Confirm to quit without saving'), (){
                    Navigator.pop(_scaffoldKey.currentContext!);
                  }, null);
                }),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
    onWillPop: () async => false,
        child: AppScaffold(
      key: _scaffoldKey,
        title: 'Order',
        showBackButton: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        StreamBuilder<Partner>(
        stream: model.partnerController.stream,
        builder: (context, snapshot) {
      return Column(children: [Row(
              children: [
                Text(saleTypeName(model.pricePolitic).toUpperCase(), style: const TextStyle(color: Color(
                    0xff01036b), fontWeight: FontWeight.bold)),
                Expanded(child: Container()),
                model.partner.discount > 0
                    ? Text(
                        '${tr('Discount')}: ${mdFormatDouble(model.partner.discount)}%', style: const TextStyle(color: Color(
                    0xff01036b), fontWeight: FontWeight.bold))
                    : Container()
              ],
            ),
            Row(
              children: [
                Expanded(
                    child:  Container(
                              height: 60,
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              decoration: const BoxDecoration(
                                  border: Border.fromBorderSide(
                                      BorderSide(color: Colors.black12))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    Text(model.partner.name),
                                    Expanded(child: Container()),
                                    Text(model.partner.taxcode),
                                  ]),
                                  Row(
                                    children: [
                                      Flexible(
                                          child: Text(model.partner.address))
                                    ],
                                  ),
                                ],
                              ))
                ),
                squareImageButton(() {
                  popupMenu(context);
                }, 'assets/images/menu.png', height: 60)
              ])
      ]);
                        }),
            const SizedBox(height: 20),
            Expanded(
                child: SingleChildScrollView(
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: StreamBuilder<List<Goods>?>(
                            stream: model.goodsController.stream,
                            builder: (context, snapshot) {
                              return Wrap(
                                spacing: 5,
                                direction: Axis.vertical,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                children: [
                                  for (var e in snapshot.data ?? []) ...[
                                    _GoodsRow(
                                        goods: e,
                                        inputDataChanged:
                                            model.inputDataChanged,
                                    removeGoods: model.removeGoods,)
                                  ]
                                ],
                              );
                            })))),
            StreamBuilder(
                stream: model.totalController.stream,
                builder: (context, snashot) {
                  return Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      decoration: const BoxDecoration(color: Color(0xffbeffff)),
                      height: 50,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(tr('Total'),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          Expanded(child: Container()),
                          Text('[${mdFormatDouble(model.totalSaleQty)}]',
                              style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          Text('[${mdFormatDouble(model.totalBackQty)}]',
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          Text('[${mdFormatDouble(model.totalAmount)}]',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold))
                        ],
                      ));
                })
          ],
        )));
  }
}

class _GoodsRow extends StatelessWidget {
  late Goods goods;
  final TextEditingController editSale = TextEditingController();
  final TextEditingController editBack = TextEditingController();
  final TextEditingController editPrice = TextEditingController();
  final Function(Goods) inputDataChanged;
  final Function(Goods) removeGoods;

  _GoodsRow({required this.goods, required this.inputDataChanged, required this.removeGoods});

  @override
  Widget build(BuildContext context) {
    editSale.text = mdFormatDouble(goods.qtySale);
    editBack.text = mdFormatDouble(goods.qtyBack);
    editPrice.text = mdFormatDouble(goods.price);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                height: 55,
                decoration: const BoxDecoration(
                  color: Color(0xffbcbcec),
                ),
                width: MediaQuery.of(context).size.width * 0.7,
                child: Text(goods.goodsname,
                    style: const TextStyle(fontSize: 18))),
            //Quantity sale
            Container(
                height: 55,
                decoration: const BoxDecoration(
                    color: Color(0xffcefdce),
                    border: Border.fromBorderSide(BorderSide(width: 0.2))),
                width: 50,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 18),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(2)),
                  controller: editSale
                    ..addListener(() {
                      goods = goods.copyWith(
                          qtySale: double.tryParse(editSale.text));
                      inputDataChanged(goods);
                    }),
                  onTap: () {
                    editSale.selection = TextSelection(
                        baseOffset: 0, extentOffset: editSale.text.length);
                  },
                )),
            //Quantity back
            Container(
                height: 55,
                decoration: const BoxDecoration(
                    color: Color(0xfffdcece),
                    border: Border.fromBorderSide(BorderSide(width: 0.2))),
                width: 50,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 18),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(2)),
                  controller: editBack
                    ..addListener(() {
                      goods = goods.copyWith(
                          qtyBack: double.tryParse(editBack.text));
                      inputDataChanged(goods);
                    }),
                  onTap: () {
                    editBack.selection = TextSelection(
                        baseOffset: 0, extentOffset: editBack.text.length);
                  },
                )),
            //Price
            Container(
                height: 55,
                decoration: const BoxDecoration(
                    color: Color(0xfffdfcce),
                    border: Border.fromBorderSide(BorderSide(width: 0.2))),
                width: 100,
                child: TextFormField(
                  readOnly: true,
                  controller: editPrice,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 18),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(2)),
                )),
            //Delete button
            Container(
              height: 55,
              child: squareImageButton(() {

              }, 'assets/images/trash.png'),
            )
          ],
        )
      ],
    );
  }
}
