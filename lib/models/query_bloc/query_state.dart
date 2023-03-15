import 'package:freezed_annotation/freezed_annotation.dart';

part 'query_state.freezed.dart';

abstract class QueryState {

}

@freezed
class QueryStateNeedUserAction extends QueryState with _$QueryStateNeedUserAction {
  const factory QueryStateNeedUserAction({required String message}) = _QueryStateNeedUserAction;
}

@freezed
class QueryStateError extends QueryState with _$QueryStateError {
  const factory QueryStateError({required String error}) = _QueryStateError;
}

@freezed
class QueryStateProgress extends QueryState with _$QueryStateProgress {
  const factory QueryStateProgress() = _QueryStateProgress;
}

@freezed
class QueryStateReady extends QueryState with _$QueryStateReady {
  const factory QueryStateReady({required int op, required String data}) = _QueryStateReady;
}