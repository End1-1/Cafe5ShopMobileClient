import 'dart:io';

import 'package:cafe5_shop_mobile_client/local_notification_service.dart';
import 'package:cafe5_shop_mobile_client/screens/splash/splash_screen.dart';
import 'package:cafe5_shop_mobile_client/utils/http_overrides.dart';
import 'package:cafe5_shop_mobile_client/utils/prefs.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   //await Firebase.initializeApp();
//   //LocalNotificationService().addNotification(message.notification!.title!, message.notification!.body!);
//   print("Handling a background message: ${message.messageId}");
// }

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  await LocalNotificationService().setup();
  PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    prefs.setString(pkAppVersion, '$version.$buildNumber');
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShopMobile',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
