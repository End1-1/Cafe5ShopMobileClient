import 'package:flutter/cupertino.dart';

import '../../freezed/goods.dart';
import '../../freezed/partner.dart';

class SaleModel {
  Partner? partner;
  final TextEditingController partnerTextController = TextEditingController();
  int saleType = 1;
  final List<Goods> goods = [];

  static late GoodsList predefinedGoodsList;
}