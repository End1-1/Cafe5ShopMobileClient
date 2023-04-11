import 'package:cafe5_shop_mobile_client/models/http_query/http_query.dart';
import 'package:cafe5_shop_mobile_client/utils/data_types.dart';
import 'package:cafe5_shop_mobile_client/utils/prefs.dart';

class GoodsListModel {
  final Map<int, StockItem> stock = {};
  final Map<int, StockItem> preorderStock = {};

  GoodsListModel() {
    Map<String, dynamic> data = {};
    HttpQuery(hqStock, initData: {
      pkStock: 0,
      pkGroup : 0
    }).request(data).then((value) {
      for (var e in data[pkData]) {
        stock[e['goodsid']] = StockItem.fromJson(e);
      }
    });
    HttpQuery(hqPreorderStock, initData: {
      pkStock: 0,
      pkGroup : 0
    }).request(data).then((value) {
      for (var e in data[pkData]) {
        preorderStock[e['goodsid']] = StockItem.fromJson(e);
      }
    });
  }

  double stockQty(int id) {
    double s = stock.containsKey(id) ? stock[id]!.qty : 0;
    double p = preorderStock.containsKey(id) ? preorderStock[id]!.qty : 0;
    return s - p;
  }
}