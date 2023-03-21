import 'package:freezed_annotation/freezed_annotation.dart';

part 'stock.freezed.dart';

part 'stock.g.dart';

@freezed
class StockItem with _$StockItem {
  const StockItem._();
  const factory StockItem(
      {required int goods,
      required double myStock,
      required double otherStock,
      required double orderStock}) = _StockItem;

  factory StockItem.fromJson(Map<String, dynamic> json) =>
      _$StockItemFromJson(json);

  double total() {
    return myStock + otherStock - orderStock;
  }
}

@freezed
class StockItemList with _$StockItemList {
  const StockItemList._();
  const factory StockItemList({required List<StockItem> list}) = _StockItemList;

  factory StockItemList.fromJson(Map<String, dynamic> json) =>
      _$StockItemListFromJson(json);

  StockItem? stockItem(int id) {
    if (list.isEmpty) {
      return null;
    }
    return list.where((element) => element.goods == id).first;
  }
}
