import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:cafe5_shop_mobile_client/utils/prefs.dart';

const hrFail = 0;
const hrOk = 1;
const hrNetworkError = 2;

class HttpState extends Equatable {
  static int _counter = 0;
  late final int version;
  final bool loading;
  final int errorCode;
  final String errorMessage;
  final dynamic data;
  HttpState(this.loading, this.data, {this.errorCode = 200, this.errorMessage = ''}) {
    version = ++_counter;
  }
  @override
  List<Object?> get props => [];
}

class HttpEvent extends Equatable {
  final String route;
  final Map<String, String> data;
  const HttpEvent(this.route, this.data);
  @override
  List<Object?> get props => [];
}

class HttpBloc extends Bloc<HttpEvent, HttpState> {
  HttpBloc(super.initialState) {
    on<HttpEvent>((event, emit) => _httpQuery(event));
  }

  void _httpQuery(HttpEvent e) async {
    emit (HttpState(true, ''));
    HttpQuery(e.route, e.data).request();
  }
}

class HttpQuery {
  final String route;
  Map<String, dynamic> data = {};

  HttpQuery({required this.route, Map<String, dynamic> initData = const {}}) {
    data.addAll(initData);
  }

  void makeJson(Map<String, Object?> other) {
    data[pkFcmToken] = prefs.getString(pkFcmToken);
    data[pkPassHash] = prefs.getString(pkPassHash);
    data.addAll(other);
  }
  
  Future<String> body() async {
    return jsonEncode(data);
  }

  Future<int> request(Map<String, Object?> other) async {
    makeJson(other);
    String strBody = await body();
    other.clear();
    if (kDebugMode) {
      print(strBody);
    }
    try {
      var response = await http.post(
          Uri.https(prefs.string(pkServerAddress), ),
          headers: {
            'Content-Type': 'application/json',
            'Content-Length': '${utf8.encode(strBody).length}'
          },
          body: utf8.encode(strBody)).timeout(const Duration(seconds: 10), onTimeout: (){return http.Response('Timeout', 408);});
      String s = utf8.decode(response.bodyBytes);
      print(s);
      if (response.statusCode < 299) {
        other.addAll(jsonDecode(s));
        if (other.containsKey('ok')) {
          return int.tryParse(other['ok'].toString()) ?? 0;
        } else {
          other['ok'] = 0;
          other['message'] = s;
          return hrNetworkError;
        }
      } else {
        other['ok'] = 0;
        other['message'] = s;
        return hrNetworkError;
      }
    } catch (e) {
      other['ok'] = 0;
      other['message'] = e.toString();
      print(e.toString());
      return hrNetworkError;
    }
  }
}
