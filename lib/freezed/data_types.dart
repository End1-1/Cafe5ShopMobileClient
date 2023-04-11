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
  const factory StockItem(
      {required String stockname,
      required String groupname,
      required String goodsname,
      required double qty}) = _StockItem;

  factory StockItem.fromJson(Map<String, Object?> json) =>
      _$StockItemFromJson(json);
}

class PaymentTypes {
  static int defaultType() {
    return 2;
  }

  static String name(int id) {
    switch (id) {
      case 1:
        return tr('Cash');
      case 2:
        return tr('Bank transfer');
    }
    return 'undefined';
  }
}
