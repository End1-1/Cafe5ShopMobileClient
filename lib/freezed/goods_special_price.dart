import 'package:freezed_annotation/freezed_annotation.dart';

part 'goods_special_price.freezed.dart';
part 'goods_special_price.g.dart';

@freezed
class GoodsSpecialPrice with _$GoodsSpecialPrice {
  const factory GoodsSpecialPrice({required int partner, required int goods, required double price}) = _GoodsSpecialPrice;
  factory GoodsSpecialPrice.fromJson(Map<String, Object?> json) => _$GoodsSpecialPriceFromJson(json);
}