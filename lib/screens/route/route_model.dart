
import 'package:cafe5_shop_mobile_client/models/http_query/http_query.dart';
import 'package:cafe5_shop_mobile_client/screens/bloc/screen_event.dart';
import 'package:cafe5_shop_mobile_client/utils/prefs.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'route_model.freezed.dart';
part 'route_model.g.dart';

@freezed
class RouteItem with _$RouteItem {
  const factory RouteItem({required int partnerid, required String partnername, required String address,
  required int orders}) = _RouteItem;
  factory RouteItem.fromJson(Map<String, Object?> json) => _$RouteItemFromJson(json);
}

class RouteModel {
  final List<RouteItem> route = [];

  SEHttpQuery query() {
    return SEHttpQuery(query: HttpQuery(hqRoute));
  }
}