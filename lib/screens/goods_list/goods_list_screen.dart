import 'dart:async';

import 'package:cafe5_shop_mobile_client/freezed/goods.dart';
import 'package:cafe5_shop_mobile_client/models/lists.dart';
import 'package:cafe5_shop_mobile_client/models/model.dart';
import 'package:cafe5_shop_mobile_client/screens/screen/app_scaffold.dart';
import 'package:cafe5_shop_mobile_client/translator.dart';
import 'package:cafe5_shop_mobile_client/widgets/square_button.dart';
import 'package:flutter/material.dart';

class GoodsListScreen extends StatelessWidget {
  final List<Goods> goods = [];
  final StreamController<String?> goodsGroupController = StreamController();
  final StreamController<List<Goods>> goodsController = StreamController();
  final StreamController<dynamic?> totalController = StreamController();
  final int pricePolitic;
  double totalSaleQty = 0.0;
  double totalBackQty = 0.0;
  double totalAmount = 0.0;

  GoodsListScreen(
      {super.key, required this.pricePolitic, required double discount}) {
    goods.addAll(Lists.goods.values.map((e) {
      double price = pricePolitic == mdPriceRetail ? e.price1 : e.price2;
      if (discount > 0) {
        discount /= 100;
      }
      price -= price * discount;
      Goods g = e.copyWith(price: price);
      return g;
    }));
  }

  void inputDataChanged(Goods g) {
    Goods gg = goods.firstWhere((element) => element.id == g.id);
    int index = goods.indexOf(gg);
    goods[index] = g;
    totalSaleQty = 0;
    totalBackQty = 0;
    totalAmount = 0;
    for (var e in goods) {
      totalSaleQty += e.qtySale ?? 0;
      totalBackQty += e.qtyBack ?? 0;
      totalAmount += (e.qtySale ?? 0) * (e.price ?? 0);
    }
    totalController.add(null);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        title: 'Goods list',
        headerWidgets: [
          smallSquareImageButton(() {
            final List<Goods> list = [];
            for (var e in goods) {
              if ((e.qtySale ?? 0) > 0 || (e.qtyBack ?? 0) > 0) {
                list.add(e);
              }
            }
            Navigator.pop(context, list);
          }, 'assets/images/done.png')
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Text(tr('List')),
              const SizedBox(width: 20),
              Expanded(
                  child: StreamBuilder<String?>(
                      stream: goodsGroupController.stream,
                      builder: (context, snapshot) {
                        return DropdownButton<String>(
                            isExpanded: true,
                            value: snapshot.data,
                            items: Lists.goodsGroup.map((e) {
                              return DropdownMenuItem<String>(
                                  value: e, child: Text(e));
                            }).toList(),
                            onChanged: (text) {
                              goodsGroupController.add(text);
                              List<Goods> goodsList = goods
                                  .where((element) => element.groupname == text)
                                  .toList();
                              goodsController.add(goodsList);
                            });
                      }))
            ]),
            Expanded(
                child: SingleChildScrollView(
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: StreamBuilder<List<Goods>?>(
                            stream: goodsController.stream,
                            builder: (context, snapshot) {
                              return Wrap(
                                spacing: 5,
                                direction: Axis.vertical,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                children: [
                                  for (var e in snapshot.data ?? []) ...[
                                    _GoodsRow(
                                        goods: e,
                                        inputDataChanged: inputDataChanged)
                                  ]
                                ],
                              );
                            })))),
            StreamBuilder<dynamic?>(
                stream: totalController.stream,
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
                          Text('[${mdFormatDouble(totalSaleQty)}]',
                              style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          Text('[${mdFormatDouble(totalBackQty)}]',
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          Text('[${mdFormatDouble(totalAmount)}]',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold))
                        ],
                      ));
                })
          ],
        ));
  }
}

class _GoodsRow extends StatelessWidget {
  late Goods goods;
  final TextEditingController editSale = TextEditingController();
  final TextEditingController editBack = TextEditingController();
  final TextEditingController editPrice = TextEditingController();
  final Function(Goods) inputDataChanged;

  _GoodsRow({required this.goods, required this.inputDataChanged});

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
          ],
        )
      ],
    );
  }
}
