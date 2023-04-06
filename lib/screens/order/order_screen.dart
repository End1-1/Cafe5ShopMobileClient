import 'package:cafe5_shop_mobile_client/screens/screen/app_scaffold.dart';
import 'package:cafe5_shop_mobile_client/widgets/square_button.dart';
import 'package:flutter/cupertino.dart';

import 'order_model.dart';

class OrderScreen extends StatelessWidget {
  final OrderModel model = OrderModel();
  OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(title: 'Order', child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text('POS\r\nPOS')),
            smallSquareImageButton(() { }, 'assets/images/edit.png')
          ],
        )
      ],
    ));
  }

}