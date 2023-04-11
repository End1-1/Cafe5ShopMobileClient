import 'dart:async';

import 'package:cafe5_shop_mobile_client/freezed/data_types.dart';
import 'package:cafe5_shop_mobile_client/models/lists.dart';

class StockModel {
  final StreamController filterController = StreamController();
  List<StockItem> stock = [];
  int goodsGroup = 0;
  int store = Lists.config.storage;

  String stockName() {
    return store == 0 ? '' : Lists.storages[store]!.name;
  }

  String groupName() {
    return goodsGroup == 0 ? '' : Lists.goodsGroup[goodsGroup]!.name;
  }
}