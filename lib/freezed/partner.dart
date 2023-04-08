import 'package:freezed_annotation/freezed_annotation.dart';

part 'partner.freezed.dart';

part 'partner.g.dart';

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
