import 'package:freezed_annotation/freezed_annotation.dart';

part 'screen_state.freezed.dart';

abstract class ScreenState {}

class SSInit extends ScreenState {}

class SSInProgress extends ScreenState {}

@freezed
class SSData extends ScreenState with _$SSData {
  const factory SSData({required dynamic data}) = _SSData;
}

@freezed
class SSError extends ScreenState with _$SSError {
  const factory SSError({required String error}) = _SSError;
}
