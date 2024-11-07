import 'package:cafe5_shop_mobile_client/utils/prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

abstract class MiuraApp extends StatelessWidget {
  const MiuraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(
      minimum: const EdgeInsets.fromLTRB(5, 5, 5, 5),
        child: Stack(children: [body()])));
  }

  AppLocalizations locale() {
    return AppLocalizations.of(prefs.context())!;
  }

  Widget body();

  Widget rowSpace() {
    return const SizedBox(height: 10);
  }
}
