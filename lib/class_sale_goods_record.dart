import 'package:freezed_annotation/freezed_annotation.dart';

part 'class_sale_goods_record.freezed.dart';
part 'class_sale_goods_record.g.dart';

@freezed
class SaleGoodsRecord with _$SaleGoodsRecord {
  const factory SaleGoodsRecord({
  required String id,
  required int state,
  required int goods,
  required String name,
  required double qty,
  required double back,
  required double price }) = _SaleGoodsRecord;

  factory SaleGoodsRecord.fromJson(Map<String,dynamic> json) => _$SaleGoodsRecordFromJson(json);
}