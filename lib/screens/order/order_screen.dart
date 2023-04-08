import 'dart:async';

import 'package:cafe5_shop_mobile_client/freezed/partner.dart';
import 'package:cafe5_shop_mobile_client/screens/goods_list/goods_list_screen.dart';
import 'package:cafe5_shop_mobile_client/screens/partner_screen/partner_screen.dart';
import 'package:cafe5_shop_mobile_client/screens/screen/app_scaffold.dart';
import 'package:cafe5_shop_mobile_client/widgets/square_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'order_model.dart';

class OrderScreen extends StatelessWidget {
  final OrderModel model = OrderModel();
  final StreamController<Partner> partnerController = StreamController();
  late final Stream<Partner> partnerStream;

  OrderScreen({super.key}) {
    partnerStream = partnerController.stream;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        title: 'Order',
        headerWidgets: [
          smallSquareImageButton(() async{
            var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => GoodsListScreen()));
            if (result != null) {

            }
          }, 'assets/images/goods.png'),
          smallSquareImageButton(() async {
            var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => PartnerScreen(selectMode: true,)));
            if (result != null) {
              model.partner = result;
              partnerController.add(model.partner);
            }
          }, 'assets/images/edit.png')
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child:
                StreamBuilder<Partner>(
                stream: partnerStream,
                    builder: (context, snapshot) {return Container(
                    margin: const EdgeInsets.fromLTRB(0, 5, 5, 0),
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                    decoration: const BoxDecoration(
                        border: Border.fromBorderSide(BorderSide(color: Colors.black12))
                    ),
                    child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            children: [
                              Text(model.partner.name),
                              Expanded(child: Container()),
                              Text(model.partner.taxcode),
                            ]
                        ),
                        Row(children: [
                          Flexible(child: Text(model.partner.address))
                        ],)
                      ],
                    ));})),
              ],
            )
          ],
        ));
  }
}
