import 'package:freezed_annotation/freezed_annotation.dart';

part 'partner.freezed.dart';
part 'partner.g.dart';

@freezed
class Partner with _$Partner {
  const factory Partner({required int id,
  required String taxname,
  required String taxcode,
  required String contact,
  required String phone,
  required double discount}) = _Partner;
  factory Partner.fromJson(Map<String,dynamic> json) => _$PartnerFromJson(json);
}

@freezed
class Partners with _$Partners {
  const factory Partners({required List<Partner> partners}) = _Partners;
  factory Partners.fromJson(Map<String,dynamic> json) => _$PartnersFromJson(json);
}