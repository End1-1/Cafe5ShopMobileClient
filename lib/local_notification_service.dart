import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;

final _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

class LocalNotificationService {
  Future<void> setup() async {
    // #1
    const androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSetting = DarwinInitializationSettings();

    // #2
    const initSettings = InitializationSettings(android: androidSetting, iOS: iosSetting);

    // #3
    await _localNotificationsPlugin.initialize(initSettings).then((_) {
      debugPrint('setupPlugin: setup success');
    }).catchError((Object error) {
      debugPrint('Error: $error');
    });
  }

  Future<void> addNotification(String title, String body) async {
    // #1
    tzData.initializeTimeZones();
    final scheduleTime = tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, DateTime.now().millisecondsSinceEpoch + 1000);

// #2
    const androidDetail = AndroidNotificationDetails("channel_id", "channel_name");

    const iosDetail = DarwinNotificationDetails();

    const noticeDetail = NotificationDetails(
      iOS: iosDetail,
      android: androidDetail,
    );

    List<String> l = body.split(";");
    int id = l.length == 2 ? int.tryParse(l[0]) ?? 0 : 0 ;

// #4
    await _localNotificationsPlugin.zonedSchedule(
      id,
      title,
      l.length == 2 ? l[1] : body,
      scheduleTime,
      noticeDetail,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }
}
