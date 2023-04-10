import 'package:cafe5_shop_mobile_client/screens/bloc/screen_bloc.dart';
import 'package:cafe5_shop_mobile_client/screens/bloc/screen_state.dart';
import 'package:cafe5_shop_mobile_client/screens/data_download/data_download_screen.dart';
import 'package:cafe5_shop_mobile_client/screens/home/home_screen.dart';
import 'package:cafe5_shop_mobile_client/screens/login/pin_form.dart';
import 'package:cafe5_shop_mobile_client/screens/screen/app_scaffold.dart';
import 'package:cafe5_shop_mobile_client/utils/translator.dart';
import 'package:cafe5_shop_mobile_client/utils/dialogs.dart';
import 'package:cafe5_shop_mobile_client/utils/prefs.dart';
import 'package:cafe5_shop_mobile_client/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        title: 'Sign in',
        showBackButton: false,
        child: BlocProvider<ScreenBloc>(
            create: (_) => ScreenBloc(SSInit()),
            child: BlocListener<ScreenBloc, ScreenState>(
              listener: (context, state) {
                if (state is SSError) {
                  appDialog(context, state.error);
                  return;
                }
                if (state is SSData) {
                  prefs.setString(pkLastName, state.data[pkLastName]);
                  prefs.setString(pkFirstName, state.data[pkFirstName]);
                  prefs.setString(pkPassHash, state.data[pkPassHash]);
                  appDialog(context, '${tr('Welcome')}, ${state.data[pkLastName]} ${state.data[pkLastName]}').then((value) {
                    if (prefs.getBool(pkDataLoaded) ?? false) {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen()), (route) => false);
                    } else {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                          builder: (context) => const DataDownloadScreen(pop: false)), (
                          route) => false);
                    }
                  });
                }
              },
              child: BlocBuilder<ScreenBloc, ScreenState>(
                  builder: (context, state) {
                if (state is SSInProgress) {
                  return Loading(tr('Signing in'));
                } else {
                  return PinForm();
                }
              }),
            )));
  }
}
