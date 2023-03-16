import 'package:cafe5_shop_mobile_client/freezed/price_mode.dart';
import 'package:flutter/cupertino.dart';

import '../../freezed/goods.dart';
import '../../freezed/partner.dart';
import '../../freezed/sale.dart';
import '../../models/lists.dart';

class SaleModel {
  final TextEditingController partnerTextController = TextEditingController();
  final TextEditingController priceModeController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  Partner? partner;
  SaleHeader? saleHeader;
  PriceMode priceMode = Lists.priceModeList.list.first;
  final List<Goods> goods = [];

  static late GoodsList predefinedGoodsList;
}