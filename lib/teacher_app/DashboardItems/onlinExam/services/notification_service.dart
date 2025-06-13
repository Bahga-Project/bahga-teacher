import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    const InitializationSettings initSettings = InitializationSettings(
      android: initSettingsAndroid,
    );
    await _plugin.initialize(initSettings);
  }

  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'quiz_channel',
      'Quiz Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails details = NotificationDetails(android: androidDetails);
    await _plugin.show(0, title, body, details);
  }
}