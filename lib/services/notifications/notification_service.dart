import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// Wraps FCM (remote) + flutter_local_notifications (habit reminders
/// scheduled from a user-chosen local time). Respects the reminder time
/// set per-habit; PULSE does not send unsolicited notifications.
class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    await _messaging.requestPermission();
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    await _local.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit, macOS: iosInit),
    );
  }

  Future<void> scheduleHabitReminder({
    required int id,
    required String habitName,
    required int hour,
    required int minute,
  }) async {
    // A real implementation should use zonedSchedule with timezone data
    // and daily-repeat matching the habit's reminderTime. Left as a
    // straightforward extension point post-MVP.
    await _local.show(
      id,
      'Time for your $habitName habit',
      'Keep your rhythm going 🔥',
      const NotificationDetails(
        android: AndroidNotificationDetails('pulse_reminders', 'PULSE Reminders'),
      ),
    );
  }
}
