import 'package:freezed_annotation/freezed_annotation.dart';

part 'price_mode.freezed.dart';

@freezed
class PriceMode with _$PriceMode {
  const factory PriceMode({required int id, required String name}) = _PriceMode;
}

@freezed
class PriceModeList with _$PriceModeList{
  const factory PriceModeList({required List<PriceMode> list}) = _PriceModeList;
}