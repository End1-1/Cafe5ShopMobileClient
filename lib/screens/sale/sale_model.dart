import 'package:cafe5_shop_mobile_client/freezed/price_mode.dart';
import 'package:cafe5_shop_mobile_client/freezed/stock.dart';
import 'package:flutter/cupertino.dart';

import '../../freezed/goods.dart';
import '../../freezed/partner.dart';
import '../../freezed/sale.dart';
import '../../models/lists.dart';

class SaleModel {
  final TextEditingController partnerTextController = TextEditingController();
  final TextEditingController priceModeController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController debtController = TextEditingController();
  Partner? partner;
  SaleHeader? saleHeader;
  double? partnerDebt;
  PriceMode priceMode = Lists.priceModeList.list.first;
  final List<Goods> goods = [];
  StockItemList stockItems = StockItemList(list: []);

  static late GoodsList predefinedGoodsList;

  int routeId = 0;
  int routeChecked = 0;
}