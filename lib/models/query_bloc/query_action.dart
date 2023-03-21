import 'package:freezed_annotation/freezed_annotation.dart';

part 'query_action.freezed.dart';

abstract class QueryAction {

}

@freezed
class QueryActionLoad extends QueryAction with _$QueryActionLoad {
  const factory QueryActionLoad({required int op, List<dynamic>? optional}) = _QueryActionLoad;
}

@freezed
class QueryActionFilter extends QueryAction with _$QueryActionFilter {
  const factory QueryActionFilter({required String filter}) = _QueryAction;
}

class QueryActionShowFilter extends QueryAction{}