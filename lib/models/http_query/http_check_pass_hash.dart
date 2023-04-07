import 'dart:convert';

import 'package:cafe5_shop_mobile_client/utils/prefs.dart';
import 'package:http/http.dart' as http;

class CheckPassHash {
  static Future<bool> checkPassHash() async {
    Map<String, Object?> bodyMap = {};
    bodyMap[pkServerAPIKey] = prefs.getString(pkServerAPIKey);
    bodyMap[pkFcmToken] = prefs.getString(pkFcmToken);
    bodyMap[pkAction] = hqCheckPassHash;
    bodyMap[pkPassHash] = prefs.getString(pkPassHash);
    String body = jsonEncode(bodyMap);
    var response = await http.post(
        Uri.parse(
            'https://${prefs.getString(pkServerAddress)}:${prefs.getString(pkServerPort)}/magnit'),
        headers: {'Content-Type': 'application/json', 'Content-Length' : '${body.length}'},
        body: body
    );
    String s = utf8.decode(response.bodyBytes);
    try {
      Map<String, Object?> data = jsonDecode(s);
      return data['ok'] == 1;
    } catch (e) {
      return false;
    }
  }
}