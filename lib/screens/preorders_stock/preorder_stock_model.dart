import 'dart:async';

import 'package:cafe5_shop_mobile_client/models/http_query/http_query.dart';
import 'package:cafe5_shop_mobile_client/models/lists.dart';
import 'package:cafe5_shop_mobile_client/utils/data_types.dart';
import 'package:cafe5_shop_mobile_client/utils/prefs.dart';

class PreordersStockModel {
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

  HttpQuery stockQuery() {
    return HttpQuery(hqPreorderStock, initData: {
      pkStock: store,
      pkGroup : goodsGroup
    });
  }
}