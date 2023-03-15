import 'package:freezed_annotation/freezed_annotation.dart';

part 'debt.freezed.dart';
part 'debt.g.dart';

@freezed
class Debt with _$Debt {
  const factory Debt({
    required String taxname,
    required String date,
    required double amount,
}) = _Debt;
  factory Debt.fromJson(Map<String,dynamic> json) => _$DebtFromJson(json);
}

@freezed
class Debts with _$Debts {
  const factory Debts({required List<Debt> debts}) = _Debts;
  factory Debts.fromJson(Map<String,dynamic> json) => _$DebtsFromJson(json);
}
