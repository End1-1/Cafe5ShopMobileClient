import 'package:cafe5_shop_mobile_client/screens/bloc/screen_bloc.dart';
import 'package:cafe5_shop_mobile_client/screens/bloc/screen_state.dart';
import 'package:cafe5_shop_mobile_client/screens/login/pin_form.dart';
import 'package:cafe5_shop_mobile_client/translator.dart';
import 'package:cafe5_shop_mobile_client/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WidgetHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: BlocProvider<ScreenBloc>(
      create: (_) => ScreenBloc(SSInit()),
      child: BlocBuilder<ScreenBloc, ScreenState>(builder: (context, state) {
        if (state is SSInProgress) {
          return Loading(tr('Signing in'));
        } else {
          return PinForm();
        }
      }),
    )));
  }
}
