import 'package:freezed_annotation/freezed_annotation.dart';

part 'sale.freezed.dart';
part 'sale.g.dart';

@freezed
class SaleHeader with _$SaleHeader {
  const factory SaleHeader({
    required String uuid,
    required String date,
    required int partner,
    required int isdebt,
    required double discount,
    required double amount
}) = _SaleHeader;
  factory SaleHeader.fromJson(Map<String,dynamic> json) => _$SaleHeaderFromJson(json);
}

@freezed
class SalesHeaderList with _$SalesHeaderList {
  const factory SalesHeaderList ({required List<SaleHeader> list}) = _SalesHeaderList;
  factory SalesHeaderList.fromJson(Map<String,dynamic> json) => _$SalesHeaderListFromJson(json);
}

@freezed
class SaleHeaderHistory with _$SaleHeaderHistory {
  const factory SaleHeaderHistory({required String id, required String date, required String taxcode, required String taxname, required double amount}) = _SaleHeaderHistory;
  factory SaleHeaderHistory.fromJson(Map<String,dynamic> json) => _$SaleHeaderHistoryFromJson(json);
}

@freezed
class SaleHeaderHistoryList with _$SaleHeaderHistoryList {
  const factory SaleHeaderHistoryList({required List<SaleHeaderHistory> list}) = _SaleHeaderHistoryList;
  factory SaleHeaderHistoryList.fromJson(Map<String,dynamic> json) => _$SaleHeaderHistoryListFromJson(json);
}