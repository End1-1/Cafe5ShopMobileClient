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