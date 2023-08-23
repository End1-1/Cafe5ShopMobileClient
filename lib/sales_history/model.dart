import 'dart:async';

import 'package:cafe5_shop_mobile_client/models/http_query/http_query.dart';
import 'package:cafe5_shop_mobile_client/utils/prefs.dart';
import 'package:intl/intl.dart';

class SalesHistoryModel {

  DateTime date1 = DateTime.now();
  DateTime date2 = DateTime.now();
  int viewType = 1;
  final dateStream = StreamController.broadcast();

  DateTime previousDate(DateTime d) {
    d = d.add(const Duration(days: -1));
    dateStream.add(DateFormat('dd/MM/yyyy').format(d));
    return d;
  }

  DateTime nextDate(DateTime d) {
    d = d.add(const Duration(days: 1));
    dateStream.add(DateFormat('dd/MM/yyyy').format(d));
    return d;
  }

  HttpQuery stockQuery() {
    return HttpQuery(hqSales, initData: {
      pkDate1: DateFormat("dd/MM/yyyy").format(date1),
      pkDate2 : DateFormat("dd/MM/yyyy").format(date1),
    });
  }
}