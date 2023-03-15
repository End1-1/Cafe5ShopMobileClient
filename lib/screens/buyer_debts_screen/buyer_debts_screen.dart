import 'package:cafe5_shop_mobile_client/screens/buyer_debts_screen/buyer_debts_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../class_outlinedbutton.dart';
import '../../translator.dart';
import 'buyer_debts_state.dart';

class BuyerDebtsScreen extends StatelessWidget {
  const BuyerDebtsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => BuyerDebtsBlock(BuyerDebtsStateProgress()),
        child: Scaffold(
            body: SafeArea(
          minimum: const EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 35),
          child: BlocListener<BuyerDebtsBlock, BuyerDebtsState>(
            listener: (context, state) {

            },
            child: BlocBuilder<BuyerDebtsBlock, BuyerDebtsState>(
                builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    ClassOutlinedButton.createTextAndImage(() {
                      Navigator.pop(context);
                    }, tr("Debts"), "images/back.png", w: 280),
                    Expanded(child: Container()),
                  ]),
                  const Divider(
                      height: 20, thickness: 2, color: Colors.black26),
                  Expanded(
                    child: state is BuyerDebtsStateProgress ?
                        const Align(alignment: Alignment.center, child: CircularProgressIndicator()) :
                        SingleChildScrollView(child: Column(
                          children: _data(state)
                        ),)
                  )
                ],
              );
            }),
          ),
        )));
  }

  List<Widget> _data(BuyerDebtsStateReady d) {
    List<Widget>  l = [];

  }
}
