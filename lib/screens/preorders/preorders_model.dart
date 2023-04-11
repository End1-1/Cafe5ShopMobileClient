import 'package:freezed_annotation/freezed_annotation.dart';

part 'preorders_model.freezed.dart';
part 'preorders_model.g.dart';

@freezed
class Preorder with _$Preorder {
  const factory Preorder({required String id,
    required int payment,
  required String date,
  required String partnername,
  required String address,
  required double amount}) = _Preorder;

  factory Preorder.fromJson(Map<String, Object?> json) => _$PreorderFromJson(json);
}

class PreordersModel {
  final List<Preorder> data = [];
}