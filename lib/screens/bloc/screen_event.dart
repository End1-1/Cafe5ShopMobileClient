import 'package:cafe5_shop_mobile_client/models/http_query/http_query.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'screen_event.freezed.dart';

abstract class ScreenEvent {}

@freezed
class SEHttpQuery extends ScreenEvent with _$SEHttpQuery {
  const factory SEHttpQuery({required HttpQuery query}) = _SEHttpQuery;
}