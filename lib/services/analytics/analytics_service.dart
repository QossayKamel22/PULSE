import 'package:firebase_analytics/firebase_analytics.dart';

/// Tracks only the useful events named in the master spec — never raw
/// personal data.
class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> logSignUp() => _analytics.logSignUp(signUpMethod: 'email');
  Future<void> logLogin() => _analytics.logLogin(loginMethod: 'email');
  Future<void> logHabitCreated() => _analytics.logEvent(name: 'habit_created');
  Future<void> logHabitCompleted() => _analytics.logEvent(name: 'habit_completed');
  Future<void> logHabitDeleted() => _analytics.logEvent(name: 'habit_deleted');
  Future<void> logInsightViewed() => _analytics.logEvent(name: 'insight_viewed');
  Future<void> logNotificationEnabled() => _analytics.logEvent(name: 'notification_enabled');
}
