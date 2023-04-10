import 'package:cafe5_shop_mobile_client/utils/prefs.dart';

import 'http_query.dart';

class HttpPreorders extends HttpQuery {
  HttpPreorders(int state) : super(hqPreorders, initData: {'state' : state}) ;
}