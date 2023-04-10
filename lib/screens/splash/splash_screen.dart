import 'dart:convert';

import 'package:cafe5_shop_mobile_client/models/http_query/http_check_pass_hash.dart';
import 'package:cafe5_shop_mobile_client/models/lists.dart';
import 'package:cafe5_shop_mobile_client/screens/home/home_screen.dart';
import 'package:cafe5_shop_mobile_client/screens/login/login_screen.dart';
import 'package:cafe5_shop_mobile_client/screens/register_device/register_device_screen.dart';
import 'package:cafe5_shop_mobile_client/utils/app_theme.dart';
import 'package:cafe5_shop_mobile_client/utils/prefs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Firebase.initializeApp().then((app) async {
        Map<Permission, PermissionStatus> statuses = await  [
          Permission.storage,
          Permission.manageExternalStorage
        ].request();

        final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
        remoteConfig.setConfigSettings(RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 20),
          minimumFetchInterval: const Duration(minutes: 1),
        ));
        await remoteConfig.fetchAndActivate();
        String json = remoteConfig.getString(rcServerList);
        List<dynamic> listServers =
            jsonDecode(json);
        servers.clear();
        for (var e in listServers) {
          e.keys.forEach((k) => servers.add({k: e[k]}));
        }
        if (mounted) {
          bool httpOk = false;
          while (!httpOk) {
            if (prefs.getString(pkServerAPIKey) == null) {
              httpOk = true;
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                  builder: (context) => RegisterDeviceScreen()), (
                  route) => false);
            } else {
              int isSignIn = await CheckPassHash().request({});
              switch (isSignIn) {
                case 0:
                  httpOk = true;
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()), (
                          route) => false);
                  break;
                case 1:
                  httpOk = true;
                  await Lists.load();
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()), (
                          route) => false);
                  break;
                case 2:
                  break;
              }
            }
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appBgColor,
        body: Center(
            child: SizedBox(
                height: 200,
                width: 200,
                child: Image.asset('assets/images/magnet.png'))));
  }
}
