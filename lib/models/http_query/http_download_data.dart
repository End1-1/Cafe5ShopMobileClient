import 'package:cafe5_shop_mobile_client/models/http_query/http_query.dart';
import 'package:cafe5_shop_mobile_client/utils/prefs.dart';

class HttpDownloadData extends HttpQuery {
  HttpDownloadData() {
    makeJson({'action': hqDownloadData});
  }
}