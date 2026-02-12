import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_filex/open_filex.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notifications;

  NotificationService(this.notifications);

  Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await notifications.initialize(
      const InitializationSettings(android: android),
      onDidReceiveNotificationResponse: (response) {
        final path = response.payload;
        if (path != null) {
          OpenFilex.open(path);
        }
      },
    );
  }

 // SHOW PROGRESS / LOADING NOTIFICATION
  Future<void> showDownloading({
    required int id,
    required String channelId,
    required String channelName,
    required String title,
    required String body,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: 'Progress notifications',
      importance: Importance.low,
      priority: Priority.low,
      showProgress: true,
      indeterminate: true,
      ongoing: true,
    );

    await notifications.show(
      id,
      title,
      body,
      NotificationDetails(android: androidDetails),
    );
  }

  // SHOW COMPLETED NOTIFICATION
  Future<void> showCompleted({
    required int id,
    required String channelId,
    required String channelName,
    required String title,
    required String body,
    required String payload,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: 'Completion notifications',
      importance: Importance.high,
      priority: Priority.high,
      ongoing: false,
    );

    await notifications.show(
      id,
      title,
      body,
      NotificationDetails(android: androidDetails),
      payload: payload,
    );
  }

  // CLEAR NOTIFICATION
  Future<void> cancel(int id) async {
    await notifications.cancel(id);
  }
}
