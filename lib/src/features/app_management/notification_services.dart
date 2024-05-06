import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vaayo/src/common_widgets/custom_extensions.dart';

class LocalNotificationServices {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationPlugins =
      FlutterLocalNotificationsPlugin();

  Int32List flags = Int32List.fromList([32]);
  //init function
  Future init() async {
    InitializationSettings initializationSettings =
        const InitializationSettings(
            android: AndroidInitializationSettings('@mipmap/ic_launcher'));
    flutterLocalNotificationPlugins.initialize(initializationSettings);
    await flutterLocalNotificationPlugins
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Calcutta'));
  }

  Future showNotification(
      {required int id, required String title, required String body}) async {
    await flutterLocalNotificationPlugins.show(
        id,
        title,
        body,
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'vaayo_channel_id', 'vaayo_channel_name',
                channelDescription: 'Basic Vaayo Channel',
                importance: Importance.high,
                priority: Priority.high)));
  }

  Future scheduleNotification(
      {required DateTime time,
      required int id,
      required String title,
      required String body}) async {
    await flutterLocalNotificationPlugins.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.now(tz.local).fromDateTime(time),
        NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description',
                autoCancel: false,
                additionalFlags: flags)),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}
