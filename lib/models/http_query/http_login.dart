import 'package:cafe5_shop_mobile_client/utils/prefs.dart';

import 'http_query.dart';

class HttpLogin extends HttpQuery  {
  HttpLogin({required String pin}) : super(hqLogin) {
    makeJson({'pin': pin});
  }
}