import 'package:cafe5_shop_mobile_client/translator.dart';
import 'package:cafe5_shop_mobile_client/utils/app_theme.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final bool showBackButton;
  final List<Widget> headerWidgets;

  const AppScaffold(
      {super.key,
      required this.title,
      required this.child,
      this.showBackButton = true,
      this.headerWidgets = const []});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBgColor,
        body: SafeArea(
            minimum: const EdgeInsets.fromLTRB(5, 35, 5, 5),
            child: Column(children: [
              Row(children: [
                showBackButton
                    ? Row(children: [
                        Expanded(
                            child: Container(
                                color: Colors.white,
                                child: Row(children: [
                                  InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: SizedBox(
                                          height: 30,
                                          width: 30,
                                          child:
                                              Image.asset('assets/images/back.png'))),
                                  SizedBox(width: 10, child: Text(tr(title))),
                                  Expanded(child: Container()),
                                  for (var e in headerWidgets) ...[
                                    e,
                                  ]
                                ])))
                      ])
                    : Container()
              ]),
              Expanded(
                child: child,
              )
            ])));
  }
}
