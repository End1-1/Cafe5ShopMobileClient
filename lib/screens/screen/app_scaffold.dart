import 'package:cafe5_shop_mobile_client/utils/translator.dart';
import 'package:cafe5_shop_mobile_client/utils/app_theme.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final bool showBackButton;
  final VoidCallbackAction? onBack;
  final List<Widget> headerWidgets;

  const AppScaffold(
      {super.key,
      required this.title,
      required this.child,
      this.showBackButton = true,
      this.headerWidgets = const [],
      this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appBgColor,
        body: SafeArea(
            minimum: const EdgeInsets.fromLTRB(5, 35, 5, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Row(children: [
                showBackButton
                    ? Expanded(
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            InkWell(
                                onTap: () {
                                  if (onBack == null) {
                                    Navigator.pop(context);
                                  }
                                },
                                child: SizedBox(
                                    height: 30,
                                    width: 30,
                                    child:
                                        Image.asset('assets/images/back.png'))),
                            const SizedBox(width: 10,),
                            Text(tr(title), style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                            Expanded(child: Container()),
                            for (var e in headerWidgets) ...[
                              e,
                            ]
                          ]))
                    : Container()
              ]),
              Expanded(
                child: child,
              )
            ])));
  }
}
