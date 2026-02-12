import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> requestStorage() async {
    if (await Permission.storage.isGranted) return true;
    return (await Permission.storage.request()).isGranted;
  }

  Future<void> requestNotificationPermission(
      FlutterLocalNotificationsPlugin notifications) async {
    final androidPlugin =
        notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();
  }
}
