import 'dart:convert';

import 'package:cafe5_shop_mobile_client/models/http_query/http_query.dart';
import 'package:cafe5_shop_mobile_client/utils/prefs.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class HttpRegisterDevice extends HttpQuery {
  final String serverAPIKey;
  HttpRegisterDevice(this.serverAPIKey) ;

  @override
  Future<String> body() async {
    final fcmToken = await FirebaseMessaging.instance.getToken() ?? '';
    prefs.setString(pkFcmToken, fcmToken);
    data['action'] = hqRegisterDevice;
    data['serverAPIKey'] = serverAPIKey;
    data['fcmToken'] = fcmToken;
    return jsonEncode(data);
  }
}