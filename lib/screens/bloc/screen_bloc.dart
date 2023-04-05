import 'dart:convert';

import 'package:cafe5_shop_mobile_client/models/http_query/http_query.dart';
import 'package:cafe5_shop_mobile_client/screens/bloc/screen_event.dart';
import 'package:cafe5_shop_mobile_client/screens/bloc/screen_state.dart';
import 'package:cafe5_shop_mobile_client/utils/prefs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class ScreenBloc extends Bloc<ScreenEvent, ScreenState> {
  ScreenBloc(super.initialState) {
    on<SEHttpQuery>((event, emit) => _httpQuery(event.query));
  }

  Future<void> _httpQuery(HttpQuery query) async {
    emit(SSInProgress());
    try {
      String body = await query.body();
      var response = await http.post(
        Uri.parse(
            'https://${prefs.getString(pkServerAddress)}:${prefs.getString(pkServerPort)}/magnit'),
        headers: {'Content-Type': 'application/json', 'Content-Length' : '${body.length}'},
        body: body
      );
      String s = utf8.decode(response.bodyBytes);
      print(s);
      if (response.statusCode < 299) {
        Map<String, dynamic> responseData = jsonDecode(s);
        if (!responseData.containsKey('ok'))  {
          emit(SSError(error: s));
          return;
        }
        if (responseData['ok'] == 0) {
          emit(SSError(error: responseData['message']));
          return;
        }
        emit(SSData(data: responseData));
      } else {
        emit(SSError(error: s));
      }
    } catch (e) {
      print(e.toString());
      emit(SSError(error: e.toString()));
    }
  }
}
