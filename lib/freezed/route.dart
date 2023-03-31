import 'package:freezed_annotation/freezed_annotation.dart';

part 'route.freezed.dart';
part 'route.g.dart';

@freezed
class RoutePoint with _$RoutePoint {
  const factory RoutePoint({
    required int id,
    required int partner,
    required String? address,
    required String? taxname,
    required String? taxcode,
    required int action
}) = _RoutePoint;
  factory RoutePoint.fromJson(Map<String,dynamic> json) => _$RoutePointFromJson(json);
}

@JsonSerializable()
class RoutePointList extends Object {
  RoutePointList._();
  late List<RoutePoint> list;
  RoutePointList({required this.list});
  factory RoutePointList.fromJson(Map<String,dynamic> json) => _$RoutePointListFromJson(json);

  bool makeAction(int partner, int action) {
    for (int i = 0; i < list.length; i++) {
      final e = list[i];
      if (e.partner == partner) {
        list[i] = e.copyWith(action: action);
        return true;
      }
    }
    return false;
  }
}