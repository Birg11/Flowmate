// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _notifications =
//       FlutterLocalNotificationsPlugin();

//   static Future<void> init() async {
//     tz.initializeTimeZones();

//     const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const iosInit = DarwinInitializationSettings(); // ✅ iOS support added

//     const settings = InitializationSettings(
//       android: androidInit,
//       iOS: iosInit,
//     );

//     await _notifications.initialize(settings);
//   }

//   static Future<void> showInstant(String title, String body) async {
//     const androidDetails = AndroidNotificationDetails(
//       'flowmate_channel',
//       'FlowMate Alerts',
//       channelDescription: 'Reminders and wellness alerts from FlowMate',
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     await _notifications.show(
//       0,
//       title,
//       body,
//       const NotificationDetails(android: androidDetails),
//     );
//   }

//   static Future<void> scheduleDaily(
//     String id,
//     int hour,
//     int minute,
//     String title,
//     String body,
//   ) async {
//     const androidDetails = AndroidNotificationDetails(
//       'flowmate_channel',
//       'FlowMate Alerts',
//       channelDescription: 'Daily wellness check-ins',
//       importance: Importance.defaultImportance,
//     );

//     await _notifications.zonedSchedule(
//       id.hashCode,
//       title,
//       body,
//       _nextInstance(hour, minute),
//       const NotificationDetails(android: androidDetails),
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents: DateTimeComponents.time,
//     );
//   }

//   static tz.TZDateTime _nextInstance(int hour, int minute) {
//     final now = tz.TZDateTime.now(tz.local);
//     var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
//     if (scheduled.isBefore(now)) {
//       scheduled = scheduled.add(const Duration(days: 1));
//     }
//     return scheduled;
//   }

//   static Future<void> cancelAll() => _notifications.cancelAll();
// }
