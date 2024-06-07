import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static NotificationService service = NotificationService._();

  NotificationService._();

  FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(
        tz.getLocation(await FlutterTimezone.getLocalTimezone()));
    AndroidInitializationSettings initandroid =
        const AndroidInitializationSettings('img');
    DarwinInitializationSettings initIos = const DarwinInitializationSettings();
    InitializationSettings initSetting =
        InitializationSettings(android: initandroid, iOS: initIos);
    await localNotificationsPlugin.initialize(initSetting);
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();
  }

  Future<void> showNotification({required String title,required String body}) async {
    AndroidNotificationDetails androidNotificationDetails =
         AndroidNotificationDetails(
      "$title",
      "$body",
      priority: Priority.high,
      importance: Importance.max,
      // largeIcon: DrawableResourceAndroidBitmap('r3'),
      styleInformation: BigPictureStyleInformation(
        DrawableResourceAndroidBitmap('r3'),
      ),
         );
    DarwinNotificationDetails iosNotificationDetails =
        const DarwinNotificationDetails();
    NotificationDetails details = NotificationDetails(
        iOS: iosNotificationDetails, android: androidNotificationDetails);

    await localNotificationsPlugin.show(1, "hello", "how are you", details);
  }

  Future<void> schedulingNotification({required String title,required String msg}) async {
    AndroidNotificationDetails androidNotificationDetails =
         AndroidNotificationDetails(
      title,
      msg,
      priority: Priority.high,
      importance: Importance.max,
    );
    DarwinNotificationDetails iosNotificationDetails =
        const DarwinNotificationDetails();
    NotificationDetails details = NotificationDetails(
        iOS: iosNotificationDetails, android: androidNotificationDetails);

    await localNotificationsPlugin.zonedSchedule(1, "hii", "hello",
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)), details,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}

