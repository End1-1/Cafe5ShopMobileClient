import 'dart:async';
import 'package:cafe5_shop_mobile_client/freezed/goods.dart';
import 'package:cafe5_shop_mobile_client/models/lists.dart';
import 'package:cafe5_shop_mobile_client/screens/screen/app_scaffold.dart';
import 'package:cafe5_shop_mobile_client/translator.dart';
import 'package:cafe5_shop_mobile_client/widgets/square_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GoodsListScreen extends StatelessWidget {
  final List<Goods> goods = [];
  final StreamController<String?> goodsGroupController = StreamController();
  final StreamController<List<Goods>> goodsController = StreamController();
  final StreamController<double> totalController = StreamController();
  late Stream<String?> goodsGroupStream;
  late Stream<List<Goods>?> goodsStream;

  GoodsListScreen({super.key}) {
    goodsGroupStream = goodsGroupController.stream;
    goodsStream = goodsController.stream;
    goods.addAll(Lists.goods.values.map((e) => e.copyWith()));
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        title: 'Goods list',
        headerWidgets: [
          smallSquareImageButton((){}, 'assets/images/done.png')
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Expanded(
                  child: StreamBuilder<String?>(
                      stream: goodsGroupStream,
                      builder: (context, snapshot) {
                        return DropdownButton<String>(
                            value: snapshot.data,
                            items: Lists.goodsGroup.map((e) {
                              return DropdownMenuItem<String>(
                                  value: e, child: Text(e));
                            }).toList(),
                            onChanged: (text) {
                              goodsGroupController.add(text);
                              List<Goods> goodsList = Lists.goods.values
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
                            stream: goodsStream,
                            builder: (context, snapshot) {
                              return Wrap(
                                spacing: 5,
                                direction: Axis.vertical,
                                crossAxisAlignment:WrapCrossAlignment.start,
                                children: [
                                  for (var e in snapshot.data ?? []) ...[
                                    GoodsRow(goods: e)
                                  ]
                                ],
                              );
                            })))),
            Container(
              height: 50,
              child: Row(
                children: [
                  Text(tr('Total')),
                  Expanded(child: Container()),
                  Text('[0] 0.00')
                ],
              )
            )
          ],
        ));
  }
}

class GoodsRow extends StatelessWidget {
  final Goods goods;

  GoodsRow({required this.goods});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 50, decoration: const BoxDecoration(
              color: Color(0xffbcbcec),
            ), width: MediaQuery.of(context).size.width * 0.7, child: Text(goods.goodsname,
                    style: const TextStyle(fontSize: 18))),
            Container(
              height: 50,
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
                )),
            Container(
                height: 50,
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
                )),
            Container(
                height: 50,
                decoration: const BoxDecoration(
                    color: Color(0xfffdfcce),
                    border: Border.fromBorderSide(BorderSide(width: 0.2))),
                width: 100,
                child: TextFormField(
                  readOnly: true,
                  initialValue: goods.price1.toString(),
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 18),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(2)),
                )),
            Container(
                height: 50,
                decoration: const BoxDecoration(
                    color: Color(0xfffdfcce),
                    border: Border.fromBorderSide(BorderSide(width: 0.2))),
                width: 100,
                child: TextFormField(
                  readOnly: true,
                  initialValue: goods.price2.toString(),
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 18),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(2)),
                ))
          ],
        )
      ],
    );
  }
}
