import 'dart:async';
import 'dart:convert';

import 'package:cafe5_shop_mobile_client/models/http_query/http_query.dart';
import 'package:cafe5_shop_mobile_client/models/lists.dart';
import 'package:cafe5_shop_mobile_client/utils/data_types.dart';
import 'package:cafe5_shop_mobile_client/utils/prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class OrderModel {
  final StreamController<Partner> partnerController = StreamController();
  final StreamController<List<Goods>> goodsController = StreamController();
  final StreamController totalController = StreamController();
  final StreamController<double> debtController = StreamController();
  final editComment = TextEditingController();

  String orderId = '';
  bool editable = true;
  DateTime deliveryDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  int executor = prefs.getInt(pkDriver) ?? 0;
  Partner partner = Partner.empty();
  late int pricePolitic;
  int storage = Lists.config.storage;
  int paymentType = PaymentTypes.defaultType();
  final List<Goods> goods = [];
  double totalSaleQty = 0.0;
  double totalBackQty = 0.0;
  double totalAmount = 0.0;
  bool mark = false;

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
      double totalPrice = e.qtysale! * e.price!;
      totalPrice -= totalPrice * (e.discount! / 100);
      totalAmount += totalPrice;
    }
    totalController.add(null);
  }

  void removeGoods(Goods g) {
    if (g.dbuuid == null) {
      goods.remove(g);
      goodsController.add(goods);
      inputDataChanged(null, -1);
    } else {
      Map<String, Object?> data = {'dbuuid': g.dbuuid};
      HttpQuery(hqRemoveOrderRow).request(data).then((value) {
        if (value == hrOk) {
          goods.remove(g);
          goodsController.add(goods);
          inputDataChanged(null, -1);
        }
      });
    }
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
    order['orderid'] = orderId;
    order['executor'] = executor;
    order['partner'] = partner.toJson();
    order['goods'] = <Object?>[];
    order['goods'].addAll(goods.map((e) => e.toJson()));
    order['storage'] = storage;
    order['paymenttype'] = paymentType;
    order['comment'] = editComment.text;
    order['deliverydate'] = DateFormat('dd/MM/yyyy').format(deliveryDate);
    order['mark'] = mark ? 1 : 0;
    return order;
  }

  String storageName() {
    Storage? s =
        Lists.storages[storage] ?? const Storage(id: 0, name: 'undefined');
    return s.name;
  }
}
