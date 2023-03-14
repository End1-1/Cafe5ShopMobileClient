import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../class_outlinedbutton.dart';
import '../../translator.dart';

class BuyerDebtsScreen extends StatelessWidget {
  const BuyerDebtsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) =>
        child: Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 35),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              ClassOutlinedButton.createTextAndImage(() {
                Navigator.pop(context);
              }, tr("Debts"), "images/back.png", w: 280),
              Expanded(child: Container()),
            ]),
            const Divider(height: 20, thickness: 2, color: Colors.black26),
          ],
        ),
      ),
    ));
  }
}
