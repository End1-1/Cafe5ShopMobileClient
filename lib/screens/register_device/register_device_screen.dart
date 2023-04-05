import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cafe5_shop_mobile_client/models/http_query/http_register_device.dart';
import 'package:cafe5_shop_mobile_client/screens/bloc/screen_bloc.dart';
import 'package:cafe5_shop_mobile_client/screens/bloc/screen_event.dart';
import 'package:cafe5_shop_mobile_client/screens/bloc/screen_state.dart';
import 'package:cafe5_shop_mobile_client/screens/register_device/server_list.dart';
import 'package:cafe5_shop_mobile_client/screens/screen/app_scaffold.dart';
import 'package:cafe5_shop_mobile_client/translator.dart';
import 'package:cafe5_shop_mobile_client/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterDeviceScreen extends StatelessWidget {
  final TextEditingController _editServerKey = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        title: 'Register device',
        showBackButton: false,
        child: BlocProvider<ScreenBloc>(
            create: (_) => ScreenBloc(SSInit()),
            child:
                BlocBuilder<ScreenBloc, ScreenState>(builder: (context, state) {
              if (state is SSInProgress) {
                return Loading(tr('Registering device, please wait'));
              } else {
                return Column(children: [
                  Align(
                      alignment: Alignment.center,
                      child: Text(tr('Select server'))),
                  const Divider(
                    height: 20,
                    color: Colors.indigo,
                  ),
                  const ServerList(),
                  Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          label: Text(tr('Server key')),
                        ),
                        controller: _editServerKey,
                      ),
                      TextButton(onPressed: () {
                        BlocProvider.of<ScreenBloc>(context).add(SEHttpQuery(query: HttpRegisterDevice(_editServerKey.text)));
                      }, child: Text(tr('Register')))
                    ],
                  )
                ]);
              }
            })));
  }
}
