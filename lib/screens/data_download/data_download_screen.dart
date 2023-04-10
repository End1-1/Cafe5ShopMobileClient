import 'dart:convert';
import 'dart:io';
import 'package:cafe5_shop_mobile_client/models/lists.dart';
import 'package:cafe5_shop_mobile_client/utils/dir.dart';
import 'package:cafe5_shop_mobile_client/utils/prefs.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cafe5_shop_mobile_client/models/http_query/http_download_data.dart';
import 'package:cafe5_shop_mobile_client/screens/bloc/screen_bloc.dart';
import 'package:cafe5_shop_mobile_client/screens/bloc/screen_event.dart';
import 'package:cafe5_shop_mobile_client/screens/bloc/screen_state.dart';
import 'package:cafe5_shop_mobile_client/screens/home/home_screen.dart';
import 'package:cafe5_shop_mobile_client/screens/login/login_screen.dart';
import 'package:cafe5_shop_mobile_client/screens/screen/app_scaffold.dart';
import 'package:cafe5_shop_mobile_client/utils/translator.dart';
import 'package:cafe5_shop_mobile_client/utils/dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DataDownloadScreen extends StatelessWidget {
  final bool pop;
  const DataDownloadScreen({super.key, required this.pop});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        title: 'Data',
        showBackButton: false,
        child: BlocProvider<ScreenBloc>(
            create: (_) => ScreenBloc(SSInit())..add(SEHttpQuery(query: HttpDownloadData())),
            child: BlocListener<ScreenBloc, ScreenState>(
                listener: (context, state) async {
                  if (state is SSError) {
                    appDialog(context, state.error).then((value) {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
                    });
                  }
                  if (state is SSData) {
                    String s = jsonEncode(state.data);
                    final dir = await Dir.appPath();
                    await Directory(dir).create(recursive: true);
                    File file = File(await Dir.dataFile());
                    await file.writeAsString(s);
                    await Lists.load();
                    prefs.setBool(pkDataLoaded, true);
                    if (pop) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                          builder: (context) => HomeScreen()), (
                          route) => false);
                    }
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                        height: 36,
                        width: 36,
                        child: CircularProgressIndicator()),
                    const Divider(height: 20, color: Colors.indigo),
                    Text(tr('Downloading data...'))
                  ],
                ))));
  }
}
