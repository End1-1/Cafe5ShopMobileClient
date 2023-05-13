import 'dart:async';

import 'package:cafe5_shop_mobile_client/models/http_query/http_query.dart';
import 'package:cafe5_shop_mobile_client/screens/bloc/screen_event.dart';
import 'package:cafe5_shop_mobile_client/utils/prefs.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'route_model.freezed.dart';

part 'route_model.g.dart';

@freezed
class RouteItem with _$RouteItem {
  const factory RouteItem(
      {required int partnerid,
      required String partnername,
      required String address,
      required int orders,
      required int action}) = _RouteItem;

  factory RouteItem.fromJson(Map<String, Object?> json) =>
      _$RouteItemFromJson(json);
}

class RouteModel {
  final List<RouteItem> route = [];
  late DateTime date;
  final dateStream = StreamController<String>();

  RouteModel() {
    date = DateTime.now();
    date = DateTime(date.year, date.month, date.day);
  }

  void previousDate() {
    DateTime now = DateTime.now();
    now = DateTime(now.year, now.month, now.day);
    date = date.add(const Duration(days: -1));
    dateStream.add(DateFormat('dd/MM/yyyy').format(date));
  }

  void nextDate() {
    date = date.add(const Duration(days: 1));
    dateStream.add(DateFormat('dd/MM/yyyy').format(date));
  }

  SEHttpQuery query(int driver) {
    return SEHttpQuery(
        query: HttpQuery(hqRoute, initData: {
      pkDate: DateFormat('dd/MM/yyyy').format(date),
      pkDriver: driver
    }));
  }
}
