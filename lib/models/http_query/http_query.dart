import 'dart:convert';

import 'package:cafe5_shop_mobile_client/utils/prefs.dart';

abstract class HttpQuery {
  Map<String, dynamic> data = {};

  void makeJson(Map<String, Object?> other) {
    data['serverAPIKey'] = prefs.getString(pkServerAPIKey);
    data['fcmToken'] = prefs.getString(pkFcmToken);
    data.addAll(other);
  }
  
  Future<String> body() async {
    return jsonEncode(data);
  }
}
