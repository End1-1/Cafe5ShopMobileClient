<<<<<<< HEAD
=======

>>>>>>> 808994fb81e356ff3e5aeb6c4c054b770eb661ba
import 'package:freezed_annotation/freezed_annotation.dart';

part 'route.freezed.dart';
part 'route.g.dart';

@freezed
class RoutePoint with _$RoutePoint {
  const factory RoutePoint({
    required int id,
<<<<<<< HEAD
    required int partner,
    required String? address,
    required String? taxname,
    required String? taxcode
=======
    required String address,
    required String taxname,
    required String taxcode,
    required int action
>>>>>>> 808994fb81e356ff3e5aeb6c4c054b770eb661ba
}) = _RoutePoint;
  factory RoutePoint.fromJson(Map<String,dynamic> json) => _$RoutePointFromJson(json);
}

@freezed
class RoutePointList with _$RoutePointList {
  const factory RoutePointList({required List<RoutePoint> list}) = _RoutePointList;
  factory RoutePointList.fromJson(Map<String,dynamic> json) => _$RoutePointListFromJson(json);
}