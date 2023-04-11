import 'dart:convert';

import 'package:cafe5_shop_mobile_client/freezed/data_types.dart';
import 'package:cafe5_shop_mobile_client/freezed/goods.dart';
import 'package:cafe5_shop_mobile_client/freezed/goods_special_price.dart';
import 'package:cafe5_shop_mobile_client/freezed/partner.dart';
import 'package:cafe5_shop_mobile_client/utils/dir.dart';
import 'dart:io';


class Lists {

  static Map<int, Goods> goods = {};
  static Map<int, GoodsGroup> goodsGroup = {};
  static Map<int, Partner> partners = {};
  static Map<int, Map<int, double>> specialPrices = {};
  static Map<int, Storage> storages = {};
  static late Config config;

  static Future<void> load() async {
    goods.clear();
    goodsGroup.clear();
    partners.clear();
    File file = File(await Dir.dataFile());
    try {
      String s = await file.readAsString();
      Map<String, dynamic> data = jsonDecode(s);
      for (var e in data['goods']) {
        goods[e['id']] = Goods.fromJson(e);
      }
      for (var e in data['goodsgroup']) {
        goodsGroup[e['id']] = GoodsGroup.fromJson(e);
      }
      for (var e in data['partners']) {
        partners[e['id']] = Partner.fromJson(e);
      }
      for (var e in data['specialprices']) {
        GoodsSpecialPrice gsp = GoodsSpecialPrice.fromJson(e);
        if (!specialPrices.containsKey(gsp.partner)) {
          specialPrices[gsp.partner] = {};
        }
        specialPrices[gsp.partner]![gsp.goods] = gsp.price;
      }
      for (var e in data['storages']) {
        storages[e['id']] = Storage.fromJson(e);
      }
      config = Config.fromJson(data['config']);
    } catch (e) {
      if (!e.toString().contains('Cannot open file')) {
        file.delete();
      }
      print(e.toString());
    }
  }

  static List<Partner> filteredPartners(String filter) {
    if (filter.isEmpty) {
      return partners.values.toList();
    }
    List<Partner> l = [];
    filter = filter.toLowerCase();
    partners.forEach((key, value) {
      if (value.name.toLowerCase().contains(filter) || value.address.toLowerCase().contains(filter) || value.taxname.toLowerCase().contains(filter)) {
        l.add(value);
      }
    });
    return l;
  }

  static List<Goods> filteredGoods(String? filter) {
    final List<Goods> l = [];
    if (filter == null) {
      l.addAll(goods.values.where((element) => element.groupname == (filter ?? '')).toList());
    }
    return l;
  }
}