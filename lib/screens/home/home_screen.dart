import 'package:cafe5_shop_mobile_client/models/lists.dart';
import 'package:cafe5_shop_mobile_client/models/model.dart';
import 'package:cafe5_shop_mobile_client/screens/data_download/data_download_screen.dart';
import 'package:cafe5_shop_mobile_client/screens/order/order_screen.dart';
import 'package:cafe5_shop_mobile_client/screens/preorders/preorders_screen.dart';
import 'package:cafe5_shop_mobile_client/screens/screen/app_scaffold.dart';
import 'package:cafe5_shop_mobile_client/screens/stock/stock_screen.dart';
import 'package:cafe5_shop_mobile_client/utils/translator.dart';
import 'package:cafe5_shop_mobile_client/utils/dialogs.dart';
import 'package:cafe5_shop_mobile_client/utils/prefs.dart';
import 'package:cafe5_shop_mobile_client/widgets/rect_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(title: 'Home', showBackButton: false, child: Column(
      children: [ Expanded(child:
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.center,
          direction: Axis.horizontal,
          spacing: 10,
          runSpacing: 10,
          children: [
            RectButton(onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => OrderScreen(pricePolitic: mdPriceRetail)));
            }, title: tr('New order'), assetPath: 'assets/images/order.png'),

            RectButton(onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => StockScreen()));
            }, title: tr('Stock'), assetPath: 'assets/images/stock.png'),

            RectButton(onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => PreordersScreen(state: 1)));
            }, title: tr('Pending preorders'), assetPath: 'assets/images/preorders.png'),

            RectButton(onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => PreordersScreen(state: 2)));
            }, title: tr('Preorders'), assetPath: 'assets/images/preorders.png'),

            RectButton(onTap: (){
              appDialogQuestion(context, tr('Refresh data?'), () {
                prefs.setBool(pkDataLoaded, false);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const DataDownloadScreen(pop: true,)));
              }, null);
            }, title: tr('Refresh data'), assetPath: 'assets/images/refresh.png'),

          ],
        ))
      ],
    ));
  }

}