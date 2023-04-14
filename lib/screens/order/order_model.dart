import 'dart:async';
import 'dart:convert';

import 'package:cafe5_shop_mobile_client/models/lists.dart';
import 'package:cafe5_shop_mobile_client/utils/data_types.dart';
import 'package:flutter/cupertino.dart';

class OrderModel {
  final StreamController<Partner> partnerController = StreamController();
  final StreamController<List<Goods>> goodsController = StreamController();
  final StreamController totalController = StreamController();
  final StreamController<double> debtController = StreamController();
  final editComment = TextEditingController();

  String orderId = '';
  bool editable = true;
  Partner partner = Partner.empty();
  late int pricePolitic;
  int storage = Lists.config.storage;
  int paymentType = PaymentTypes.defaultType();
  final List<Goods> goods = [];
  double totalSaleQty = 0.0;
  double totalBackQty = 0.0;
  double totalAmount = 0.0;

  OrderModel() {
    storage = Lists.config.storage;
  }

  void inputDataChanged(Goods? g, int index) {
    if (index > -1) {
        goods[index] = g!;
    }
    totalSaleQty = 0;
    totalBackQty = 0;
    totalAmount = 0;
    for (var e in goods) {
      totalSaleQty += e.qtysale ?? 0;
      totalBackQty += e.qtyback ?? 0;
      totalAmount += (e.qtysale ?? 0) * (e.price ?? 0);
    }
    totalController.add(null);
  }

  void removeGoods(Goods g) {
    goods.remove(g);
    goodsController.add(goods);
    inputDataChanged(null, -1);
  }

  void gift(Goods g) {
    double totalGiftAmount = 0, totalGiftQty = g.qtysale!;
    for (int i = 0; i < goods.length; i++) {
      if (g.id == goods[i].id && goods[i].intuuid != g.intuuid) {
        totalGiftAmount += goods[i].price! * goods[i].qtysale!;
        totalGiftQty += goods[i].qtysale!;
      }
    }
    double newprice = totalGiftAmount / (totalGiftQty > 0 ? totalGiftQty : 1);
    for (int i = 0; i < goods.length; i++) {
      if (g.id == goods[i].id) {
        goods[i] = goods[i].copyWith(price: newprice);
      }
    }
    goodsController.add(goods);
    inputDataChanged(null, -1);
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  Map<String, Object?> toMap() {
    Map<String, dynamic> order = {};
    order['partner'] = partner.toJson();
    order['goods'] = <Object?>[];
    order['goods'].addAll(goods.map((e) => e.toJson()));
    order['storage'] = storage;
    order['paymenttype'] = paymentType;
    return order;
  }

  String storageName() {
    Storage? s = Lists.storages[storage] ?? const Storage(id: 0, name: 'undefined');
    return s.name;
  }
}
