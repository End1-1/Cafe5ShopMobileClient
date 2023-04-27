import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:cafe5_shop_mobile_client/utils/prefs.dart';

const hrFail = 0;
const hrOk = 1;
const hrNetworkError = 2;

class HttpQuery {
  Map<String, dynamic> data = {};

  HttpQuery(int action, {Map<String, dynamic> initData = const {}}) {
    data[pkAction] = action;
    data.addAll(initData);
  }

  void makeJson(Map<String, Object?> other) {
    data[pkServerAPIKey] = prefs.getString(pkServerAPIKey);
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
          Uri.parse(
              'https://${prefs.getString(pkServerAddress)}:${prefs.getString(pkServerPort)}/magnit'),
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
