import 'package:cafe5_shop_mobile_client/freezed/partner.dart';

class OrderModel {
  Partner partner = Partner.empty();

  void toJson() {
    Map<String, dynamic> order = {};
    order['partner'] = partner.toJson();
  }
}
