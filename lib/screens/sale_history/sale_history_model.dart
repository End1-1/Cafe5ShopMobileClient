import 'package:flutter/cupertino.dart';

import '../../freezed/sale.dart';

class SaleHistoryModel {
  final TextEditingController filterController = TextEditingController();
  SaleHeaderHistoryList? sales;
  bool showTextFilter = false;
  DateTime date1 = DateTime.now();
  DateTime date2 = DateTime.now();
}