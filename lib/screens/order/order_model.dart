import 'dart:async';
import 'dart:convert';

import 'package:cafe5_shop_mobile_client/freezed/goods.dart';
import 'package:cafe5_shop_mobile_client/freezed/partner.dart';

class OrderModel {
  final StreamController<Partner> partnerController = StreamController();
  final StreamController<List<Goods>> goodsController = StreamController();
  final StreamController totalController = StreamController();
  final StreamController<double> debtController = StreamController();

  Partner partner = Partner.empty();
  late int pricePolitic;
  final List<Goods> goods = [];
  double totalSaleQty = 0.0;
  double totalBackQty = 0.0;
  double totalAmount = 0.0;

  void inputDataChanged(Goods? g) {
    if (g != null) {
      if (goods.where((element) => element.id == g.id).isEmpty) {
        goods.add(g);
      } else {
        Goods gg = goods.firstWhere((element) => element.id == g.id);
        int index = goods.indexOf(gg);
        goods[index] = g;
      }
    }
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

  void removeGoods(Goods g) {
    goods.remove(g);
    goodsController.add(goods);
    inputDataChanged(null);
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  Map<String, Object?> toMap() {
    Map<String, dynamic> order = {};
    order['partner'] = partner.toJson();
    order['goods'] = <Object?>[];
    order['goods'].addAll(goods.map((e) => e.toJson()));
    return order;
  }
}
