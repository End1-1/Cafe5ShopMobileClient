import 'package:cafe5_shop_mobile_client/models/http_query/http_query.dart';
import 'package:cafe5_shop_mobile_client/models/lists.dart';
import 'package:cafe5_shop_mobile_client/models/model.dart';
import 'package:cafe5_shop_mobile_client/screens/goods_list/goods_list_screen.dart';
import 'package:cafe5_shop_mobile_client/screens/partner_screen/partner_screen.dart';
import 'package:cafe5_shop_mobile_client/screens/screen/app_scaffold.dart';
import 'package:cafe5_shop_mobile_client/utils/data_types.dart';
import 'package:cafe5_shop_mobile_client/utils/dialogs.dart';
import 'package:cafe5_shop_mobile_client/utils/mtext_editing_controller.dart';
import 'package:cafe5_shop_mobile_client/utils/prefs.dart';
import 'package:cafe5_shop_mobile_client/utils/translator.dart';
import 'package:cafe5_shop_mobile_client/widgets/square_button.dart';
import 'package:flutter/material.dart';

import 'order_model.dart';

class OrderScreen extends StatelessWidget {
  final OrderModel model = OrderModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  OrderScreen({super.key, required pricePolitic, Partner? partner = null}) {
    model.pricePolitic = pricePolitic;
    if (partner != null) {
      model.partner = partner;
      model.pricePolitic = partner.pricepolitic;
    }
  }

  void popupMenu(BuildContext context) {
    showDialog(
      useRootNavigator: false,
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: [
            //Payment type
            ListTile(
                dense: false,
                title: Text(tr('Payment type')),
                leading: Image.asset('assets/images/payment.png'),
                onTap: () async {
                  Navigator.pop(context);
                  showDialog(
                    context: _scaffoldKey.currentContext!,
                    builder: (BuildContext context) {
                      return SimpleDialog(
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.pop(context, 1);
                              },
                              child: Container(
                                  margin: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                                  height: 60,
                                  width: 200,
                                  child: Text(tr('Cash'), style: const TextStyle(fontSize: 18)))),
                          InkWell(
                              onTap: () {
                                Navigator.pop(context, 2);
                              },
                              child: Container(
                                  margin: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                                  height: 60,
                                  width: 200,
                                  child: Text(tr('Cart'), style: const TextStyle(fontSize: 18)))),
                          InkWell(
                              onTap: () {
                                Navigator.pop(context, 3);
                              },
                              child: Container(
                                  margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                                  height: 60,
                                  width: 200,
                                  child: Text(tr('Bank transfer'), style: const TextStyle(fontSize: 18))))
                        ],
                      );
                    },
                  ).then((value) {
                    if (value != null) {
                      model.paymentType = value;
                      model.partnerController.add(model.partner);
                    }
                  });
                }),
            //Storage
            ListTile(
                dense: false,
                title: Text(tr('Storage')),
                leading: Image.asset('assets/images/stock.png'),
                onTap: () async {
                  Navigator.pop(context);
                  showDialog(
                      context: _scaffoldKey.currentContext!,
                      builder: (context) {
                        return SimpleDialog(
                          children: [
                            for (var e in Lists.storages.values) ...[
                              InkWell(
                                  onTap: () {
                                    Navigator.pop(context, e.id);
                                  },
                                  child: Container(
                                      margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                                      height: 60,
                                      width: 200,
                                      child: Text(e.name, style: const TextStyle(fontSize: 18)))),
                              const Divider(height: 4, color: Colors.black12)
                            ]
                          ],
                        );
                      }).then((value) {
                    if (value != null) {
                      model.storage = value;
                      model.partnerController.add(model.partner);
                    }
                  });
                }),
            //Goods list
            ListTile(
                dense: false,
                title: Text(tr('Goods list')),
                leading: Image.asset('assets/images/goods.png'),
                onTap: () async {
                  Navigator.pop(context);
                  _selectGoods(context);
                }),
            //Partner
            ListTile(
                dense: false,
                title: Text(tr('Set partner')),
                leading: Image.asset('assets/images/partner.png'),
                onTap: () async {
                  Navigator.pop(context);
                  _selectPartner(context);
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
                        Navigator.of(_scaffoldKey.currentContext!).pop();
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
                  appDialogQuestion(context, tr('Confirm to quit without saving'), () {
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
                      return Column(children: [
                        Row(
                          children: [
                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(model.storageName(), style: const TextStyle(color: Color(0xff01036b), fontWeight: FontWeight.bold)),
                              Text(saleTypeName(model.pricePolitic).toUpperCase(),
                                  style: const TextStyle(color: Color(0xff01036b), fontWeight: FontWeight.bold))
                            ]),
                            Expanded(child: Container()),
                            Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                              Text(PaymentTypes.name(model.paymentType), style: const TextStyle(color: Color(0xff01036b), fontWeight: FontWeight.bold)),
                              model.partner.discount > 0
                                  ? Text('${tr('Discount')}: ${mdFormatDouble(model.partner.discount)}%',
                                      style: const TextStyle(color: Color(0xff01036b), fontWeight: FontWeight.bold))
                                  : Container()
                            ]),
                            squareImageButton(() {
                              popupMenu(context);
                            }, 'assets/images/menu.png', height: 50)
                          ],
                        ),
                        model.partner.id == 0
                            ? Container(
                                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                decoration: const BoxDecoration(border: Border.fromBorderSide(BorderSide(color: Colors.black12))),
                                height: 75,
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: InkWell(
                                            onTap: () {
                                              _selectPartner(context);
                                            },
                                            child: Center(child: Image.asset('assets/images/newpartner.png'))))
                                  ],
                                ))
                            : Row(children: [
                                Expanded(
                                    child: Container(
                                        height: 75,
                                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                        decoration: const BoxDecoration(border: Border.fromBorderSide(BorderSide(color: Colors.black12))),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(children: [
                                              Text(model.partner.name),
                                              Expanded(child: Container()),
                                              Text(model.partner.taxcode),
                                            ]),
                                            Expanded(child: Container()),
                                            Row(
                                              children: [
                                                Flexible(child: Text(model.partner.address)),
                                                Expanded(child: Container()),
                                                StreamBuilder<double>(
                                                    stream: model.debtController.stream,
                                                    builder: (context, snapshot) {
                                                      if (snapshot.data == null || snapshot.data! == 0 || model.partner.id == 0) {
                                                        return Container();
                                                      } else if (snapshot.data! == -1) {
                                                        return const SizedBox(height: 16, width: 16, child: CircularProgressIndicator());
                                                      } else if (snapshot.data! == -2) {
                                                        return const Text('Err');
                                                      }
                                                      return Text(mdFormatDouble(snapshot.data),
                                                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red));
                                                    })
                                              ],
                                            ),
                                          ],
                                        )))
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
                                      for (int i = 0; i < model.goods.length; i++) ...[
                                        _GoodsRow(
                                          goods: model.goods[i],
                                          index: i,
                                          inputDataChanged: model.inputDataChanged,
                                          removeGoods: model.removeGoods,
                                        )
                                      ],
                                      Row(
                                        children: [
                                          Container(
                                              padding: const EdgeInsets.all(10),
                                              height: 75,
                                              width: MediaQuery.of(context).size.width * 0.99,
                                              child: InkWell(onTap:(){
                                                _selectGoods(context);
                                              }, child: Center(child: Image.asset('assets/images/newproduct.png'))))
                                        ],
                                      )
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
                              Text(tr('Total'), style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                              Expanded(child: Container()),
                              Text('[${mdFormatDouble(model.totalSaleQty)}]',
                                  style: const TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold)),
                              Text('[${mdFormatDouble(model.totalBackQty)}]',
                                  style: const TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold)),
                              Text('[${mdFormatDouble(model.totalAmount)}]',
                                  style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold))
                            ],
                          ));
                    })
              ],
            )));
  }

  Future<void> _selectPartner(BuildContext context) async {
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
          double price = model.pricePolitic == mdPriceRetail ? model.goods[i].price1 : model.goods[i].price2;
          price -= price * model.partner.discount;
          if (Lists.specialPrices.containsKey(model.partner.id)) {
            if (Lists.specialPrices[model.partner.id]!.containsKey(model.goods[i].id)) {
              price = Lists.specialPrices[model.partner.id]![model.goods[i].id]!;
            }
          }
          model.goods[i] = model.goods[i].copyWith(price: price);
        }
        if (model.partner.discount > 0) {
          for (int i = 0; i < model.goods.length; i++) {
            model.goods[i] = model.goods[i].copyWith(price: model.goods[i].price! - (model.goods[i].price! * (model.partner.discount / 100)));
          }
        }
        model.goodsController.add(model.goods);
        model.inputDataChanged(null, -1);
      }
      Map<String, Object?> httpData = {};
      model.debtController.add(-1);
      HttpQuery(hqDebts, initData: {'partner': model.partner.id}).request(httpData).then((value) {
        if (value == hrOk) {
          if ((httpData[pkData]! as List<dynamic>).isNotEmpty) {
            model.debtController.add(double.tryParse((httpData[pkData]! as List<dynamic>)[0]['amount'].toString()) ?? 0);
          } else {
            model.debtController.add(0);
          }
        } else {
          model.debtController.add(-2);
        }
      });
    }
  }

  Future<void> _selectGoods(BuildContext context) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => GoodsListScreen(
                  pricePolitic: model.pricePolitic,
                  discount: model.partner.discount,
                  partnerId: model.partner.id,
                )));
    if (result != null && result.isNotEmpty) {
      model.goods.addAll(result);
      model.goodsController.add(model.goods);
      model.inputDataChanged(null, -1);
    }
  }
}

class _GoodsRow extends StatelessWidget {
  late Goods goods;
  late int index;
  final TextEditingController editSale = MTextEditingController();
  final TextEditingController editBack = MTextEditingController();
  final TextEditingController editPrice = MTextEditingController();
  final Function(Goods, int) inputDataChanged;
  final Function(Goods) removeGoods;

  _GoodsRow({required this.goods, required this.index, required this.inputDataChanged, required this.removeGoods});

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
                child: Text(goods.goodsname, style: const TextStyle(fontSize: 18))),
            //Quantity sale
            Container(
                height: 55,
                decoration: const BoxDecoration(color: Color(0xffcefdce), border: Border.fromBorderSide(BorderSide(width: 0.2))),
                width: 50,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 18),
                  decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.all(2)),
                  controller: editSale
                    ..addListener(() {
                      goods = goods.copyWith(qtySale: double.tryParse(editSale.text));
                      inputDataChanged(goods, index);
                    }),
                  onTap: () {
                    editSale.selection = TextSelection(baseOffset: 0, extentOffset: editSale.text.length);
                  },
                )),
            //Quantity back
            Container(
                height: 55,
                decoration: const BoxDecoration(color: Color(0xfffdcece), border: Border.fromBorderSide(BorderSide(width: 0.2))),
                width: 50,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 18),
                  decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.all(2)),
                  controller: editBack
                    ..addListener(() {
                      goods = goods.copyWith(qtyBack: double.tryParse(editBack.text));
                      inputDataChanged(goods, index);
                    }),
                  onTap: () {
                    editBack.selection = TextSelection(baseOffset: 0, extentOffset: editBack.text.length);
                  },
                )),
            //Price
            Container(
                height: 55,
                decoration: const BoxDecoration(color: Color(0xfffdfcce), border: Border.fromBorderSide(BorderSide(width: 0.2))),
                width: 100,
                child: TextFormField(
                  readOnly: true,
                  controller: editPrice,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 18),
                  decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.all(2)),
                )),
            //Delete button
            Container(
              height: 55,
              child: squareImageButton(() {
                removeGoods(goods);
              }, 'assets/images/trash.png'),
            )
          ],
        )
      ],
    );
  }
}