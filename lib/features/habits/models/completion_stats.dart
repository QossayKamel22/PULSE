/// Pure, framework-free streak / completion math over a set of completed
/// dates (normalized to midnight, local). Kept separate from Firestore so
/// it can be unit tested deterministically — see test/unit/streak_test.dart.
class CompletionStats {
  CompletionStats._();

  static DateTime _normalize(DateTime d) => DateTime(d.year, d.month, d.day);

  /// Current streak counting backwards from [today]. A streak is broken by
  /// any missed day strictly before today; today itself being incomplete
  /// does not yet break an in-progress streak (the day isn't over).
  static int currentStreak(Set<DateTime> completedDates, {DateTime? today}) {
    final normalized = completedDates.map(_normalize).toSet();
    final now = _normalize(today ?? DateTime.now());

    int streak = 0;
    DateTime cursor = now;

    // If today isn't completed yet, start counting from yesterday.
    if (!normalized.contains(cursor)) {
      cursor = cursor.subtract(const Duration(days: 1));
    } else {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }

    while (normalized.contains(cursor)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  /// Longest run of consecutive completed days across all history.
  static int bestStreak(Set<DateTime> completedDates) {
    if (completedDates.isEmpty) return 0;
    final sorted = completedDates.map(_normalize).toList()..sort();

    int best = 1;
    int running = 1;
    for (int i = 1; i < sorted.length; i++) {
      final diff = sorted[i].difference(sorted[i - 1]).inDays;
      if (diff == 1) {
        running++;
      } else if (diff > 1) {
        running = 1;
      }
      if (running > best) best = running;
    }
    return best;
  }

  /// Completion percentage over the last [windowDays] days (inclusive of
  /// today), rounded to nearest whole percent.
  static int completionRate(Set<DateTime> completedDates, {int windowDays = 7, DateTime? today}) {
    final normalized = completedDates.map(_normalize).toSet();
    final now = _normalize(today ?? DateTime.now());
    int completed = 0;
    for (int i = 0; i < windowDays; i++) {
      if (normalized.contains(now.subtract(Duration(days: i)))) completed++;
    }
    return ((completed / windowDays) * 100).round();
  }

  /// Daily rhythm score: percentage of today's active habits completed.
  static int dailyRhythmScore({required int completedToday, required int totalToday}) {
    if (totalToday == 0) return 0;
    return ((completedToday / totalToday) * 100).round();
  }
}
