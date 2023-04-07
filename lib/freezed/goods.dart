import 'package:freezed_annotation/freezed_annotation.dart';

part 'goods.freezed.dart';

part 'goods.g.dart';

@freezed
class Goods with _$Goods {
  const factory Goods({required int id,
  required String groupname,
  required String goodsname,
  required double price1,
  required double price2}) = _Goods;

  factory Goods.fromJson(Map<String, Object?> json) => _$GoodsFromJson(json);
}
