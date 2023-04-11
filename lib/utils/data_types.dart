import 'package:cafe5_shop_mobile_client/utils/translator.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'data_types.freezed.dart';

part 'data_types.g.dart';

@freezed
class Storage with _$Storage {
  const factory Storage({required int id, required String name}) = _Storage;

  factory Storage.fromJson(Map<String, Object?> json) =>
      _$StorageFromJson(json);
}

@freezed
class Goods with _$Goods {
  const factory Goods(
      {required int id,
        required String groupname,
        required String goodsname,
        required double? price,
        required double price1,
        required double price2,
        required double? qtySale,
        required double? qtyBack}) = _Goods;

  factory Goods.fromJson(Map<String, Object?> json) => _$GoodsFromJson(json);
}

@freezed
class GoodsSpecialPrice with _$GoodsSpecialPrice {
  const factory GoodsSpecialPrice({required int partner, required int goods, required double price}) = _GoodsSpecialPrice;
  factory GoodsSpecialPrice.fromJson(Map<String, Object?> json) => _$GoodsSpecialPriceFromJson(json);
}

@freezed
class GoodsGroup with _$GoodsGroup {
  const factory GoodsGroup({required int id, required String name}) = _GoodsGroup;
  factory GoodsGroup.fromJson(Map<String, Object?> json) => _$GoodsGroupFromJson(json);
}

@freezed
class Config with _$Config {
  const factory Config({required int storage}) = _Config;

  factory Config.fromJson(Map<String, Object?> json) => _$ConfigFromJson(json);
}

@freezed
class StockItem with _$StockItem {
  const factory StockItem({
    required int goodsid,
      required String groupname,
      required String goodsname,
      required double qty}) = _StockItem;

  factory StockItem.fromJson(Map<String, Object?> json) =>
      _$StockItemFromJson(json);
}

@freezed
class Partner with _$Partner {
  const Partner._();

  const factory Partner(
      {required int id,
        required String category,
        required String group,
        required String status,
        required String name,
        required String address,
        required String taxname,
        required String taxcode,
        required String contact,
        required String phonenumber,
        required double discount,
        required int pricepolitic}) = _Partner;

  factory Partner.empty() => const Partner(
      id: 0,
      category: '',
      group: '',
      status: '',
      name: '',
      address: '',
      taxname: '',
      taxcode: '',
      contact: '',
      phonenumber: '',
      discount: 0,
      pricepolitic: 1
  );

  factory Partner.fromJson(Map<String, Object?> json) =>
      _$PartnerFromJson(json);
}

class PaymentTypes {
  static int defaultType() {
    return 3;
  }

  static String name(int id) {
    switch (id) {
      case 1:
        return tr('Cash');
      case 2:
        return tr('Cash');
      case 3:
        return tr('Bank transfer');
    }
    return 'undefined';
  }
}
