import 'package:cafe5_shop_mobile_client/screens/order/order_screen.dart';
import 'package:cafe5_shop_mobile_client/screens/screen/app_scaffold.dart';
import 'package:cafe5_shop_mobile_client/translator.dart';
import 'package:cafe5_shop_mobile_client/widgets/rect_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(title: 'Home', showBackButton: false, child: Column(
      children: [
        Wrap(
          children: [
            RectButton(onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => OrderScreen()));
            }, title: tr('New order'), assetPath: 'assets/images/order.png')
          ],
        )
      ],
    ));
  }

}