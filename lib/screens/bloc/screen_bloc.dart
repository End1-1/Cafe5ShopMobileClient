import 'package:cafe5_shop_mobile_client/models/http_query/http_query.dart';
import 'package:cafe5_shop_mobile_client/screens/bloc/screen_event.dart';
import 'package:cafe5_shop_mobile_client/screens/bloc/screen_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScreenBloc extends Bloc<ScreenEvent, ScreenState> {
  ScreenBloc(super.initialState) {
    on<SEHttpQuery>((event, emit) => _httpQuery(event.query));
  }

  Future<void> _httpQuery(HttpQuery query) async {
    emit(SSInProgress());
    Map<String, Object?> responseData = {};
    int responseCode = await query.request(responseData);
    if (responseCode == hrOk) {
      emit(SSData(data: responseData));
    } else {
      emit(SSError(error: responseData['message'].toString()));
    }
  }
}
