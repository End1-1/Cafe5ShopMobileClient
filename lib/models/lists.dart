import 'dart:convert';

import 'package:cafe5_shop_mobile_client/freezed/goods.dart';
import 'package:cafe5_shop_mobile_client/freezed/partner.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';


class Lists {

  static Map<int, Goods> goods = {};
  static Map<int, Partner> partners = {};

  static Future<void> load() async {
    goods.clear();
    partners.clear();
    final dir = await getApplicationDocumentsDirectory();
    File file = File('${dir.path}/magnitdata.json');
    String s = await file.readAsString();
    Map<String, dynamic> data = jsonDecode(s);
    for (var e in data['goods']) {
      goods[e['id']] = Goods.fromJson(e);
    }
    for (var e in data['partners']) {
      partners[e['id']] = Partner.fromJson(e);
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
}