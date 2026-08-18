class AppConstants {
  AppConstants._();

  static const String appName = 'PULSE';
  static const String tagline = 'Build your rhythm.';
  static const String appVersion = '0.1.0';
}

/// Local, static mock content for the PULSE AI visual placeholder.
/// There is NO real AI integration in this version — see README roadmap.
class PulseAiMocks {
  PulseAiMocks._();

  static const List<String> messages = [
    'Good progress today. 🔥',
    "You're most consistent on weekdays.",
    'Try completing your reading habit in the morning.',
    'Your rhythm has been steady for 3 days straight.',
    'Small wins add up — keep the streak alive.',
  ];

  static String randomMessage() {
    final index = DateTime.now().day % messages.length;
    return messages[index];
  }
}
