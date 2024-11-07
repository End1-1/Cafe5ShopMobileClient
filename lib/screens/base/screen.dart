import 'package:cafe5_shop_mobile_client/models/http_query/http_query.dart';
import 'package:cafe5_shop_mobile_client/utils/prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'screen.part.dart';

abstract class MiuraApp extends StatelessWidget {
  const MiuraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            minimum: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: Stack(children: [body(context), _loading()])));
  }

  AppLocalizations locale() {
    return AppLocalizations.of(prefs.context())!;
  }

  Widget body(BuildContext context);

  Widget _loading() {
    return BlocBuilder<HttpBloc, HttpState>(
        buildWhen: (p, c) => c.loading,
        builder: (context, state) {
          return Container(
              color: Colors.black38,
              child: const Center(child: CircularProgressIndicator()));
        });
  }

  Widget _errorWidget() {
    return BlocBuilder<HttpBloc, HttpState>(
        buildWhen: (p, c) => c.errorCode != 200,
        builder: (context, state) {
        return Container(
            color: Colors.black38,
            child: Center(
                child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.white),
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.sizeOf(context).height * 0.8,
                        maxWidth: MediaQuery.sizeOf(context).width * 0.8,
                        minWidth: MediaQuery.sizeOf(context).width * 0.8),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Row(children: [
                        Expanded(
                            child: Container(
                                alignment: Alignment.center,
                                height: 40,
                                decoration:
                                const BoxDecoration(color: Colors.indigo),
                                child: Text('Smoke Free Armenia',
                                    style: const TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center)))
                      ]),
                      Container(
                          constraints: BoxConstraints(
                              maxHeight:
                              MediaQuery.sizeOf(context).height * 0.6),
                          child: SingleChildScrollView(
                              child: Container(
                                  margin: const EdgeInsets.all(10),
                                  child: Text(state.errorMessage,
                                      textAlign: TextAlign.center)))),
                      rowSpace(),
                      Row(children: [
                        Expanded(
                            child: Container(
                                margin: const EdgeInsets.all(10),
                                child: ElevatedButton(
                                    onPressed: _dissmissDialogs,
                                    style: appmodel.elevatedButtonStyle,
                                    child: Text(locale().close))))
                      ])
                    ]))));
      }
      return Container();
    });
  }

}

Widget rowSpace() {
  return const SizedBox(height: 10);
}}
