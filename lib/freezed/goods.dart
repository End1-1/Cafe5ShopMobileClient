import 'package:freezed_annotation/freezed_annotation.dart';

part 'goods.freezed.dart';
part 'goods.g.dart';

@freezed
class Goods with _$Goods {
  const factory Goods({
    required int id,
    required String name,
    required String barcode,
    required double price1,
    required double price2
}) = _Goods;
  factory Goods.fromJson(Map<String,dynamic> json) => _$GoodsFromJson(json);
}

@freezed
class GoodsList with _$GoodsList {
  const factory GoodsList({required List<Goods> goods}) = _GoodsList;
  factory GoodsList.fromJson(Map<String, dynamic> json) => _$GoodsListFromJson(json);
}
