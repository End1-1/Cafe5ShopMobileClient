import 'dart:convert';

import 'package:cafe5_shop_mobile_client/utils/prefs.dart';

import 'http_query.dart';

class CheckPassHash extends HttpQuery {
  CheckPassHash() : super(hqCheckPassHash) {
    makeJson({pkPassHash: prefs.getString(pkPassHash)});
  }
}
