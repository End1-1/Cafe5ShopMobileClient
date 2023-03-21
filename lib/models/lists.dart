import 'package:cafe5_shop_mobile_client/freezed/price_mode.dart';
import 'package:cafe5_shop_mobile_client/translator.dart';

import '../freezed/partner.dart';
import '../freezed/route.dart';
import '../freezed/storagename.dart';

class Lists {
  static late StorageNames storageNames;
  static late Partners partners;
  static late RoutePointList route;
  static PriceModeList priceModeList = PriceModeList(list: [PriceMode(id: 1, name: tr('Retail')), PriceMode(id: 2, name: tr('Whosale'))]);
  static late RoutePointList route;

  static Partner? findPartner(int id) {
    for (var p in partners.partners) {
      if (id == p.id) {
        return p;
      }
    }
    return null;
  }
}