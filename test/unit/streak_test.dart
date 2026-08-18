import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/features/habits/models/completion_stats.dart';

void main() {
  group('CompletionStats.currentStreak', () {
    test('counts consecutive days ending today', () {
      final today = DateTime(2026, 8, 18);
      final dates = {
        DateTime(2026, 8, 18),
        DateTime(2026, 8, 17),
        DateTime(2026, 8, 16),
      };
      expect(CompletionStats.currentStreak(dates, today: today), 3);
    });

    test('still counts streak when today is not yet completed', () {
      final today = DateTime(2026, 8, 18);
      final dates = {
        DateTime(2026, 8, 17),
        DateTime(2026, 8, 16),
      };
      expect(CompletionStats.currentStreak(dates, today: today), 2);
    });

    test('breaks streak on a missed day before today', () {
      final today = DateTime(2026, 8, 18);
      final dates = {
        DateTime(2026, 8, 18),
        DateTime(2026, 8, 16), // gap at the 17th
      };
      expect(CompletionStats.currentStreak(dates, today: today), 1);
    });

    test('returns 0 for no completions', () {
      expect(CompletionStats.currentStreak({}, today: DateTime(2026, 8, 18)), 0);
    });
  });

  group('CompletionStats.bestStreak', () {
    test('finds the longest consecutive run in history', () {
      final dates = {
        DateTime(2026, 8, 1),
        DateTime(2026, 8, 2),
        DateTime(2026, 8, 3),
        DateTime(2026, 8, 10),
        DateTime(2026, 8, 11),
      };
      expect(CompletionStats.bestStreak(dates), 3);
    });

    test('returns 0 for empty set', () {
      expect(CompletionStats.bestStreak({}), 0);
    });
  });

  group('CompletionStats.completionRate', () {
    test('computes percentage over a 7-day window', () {
      final today = DateTime(2026, 8, 18);
      final dates = {
        DateTime(2026, 8, 18),
        DateTime(2026, 8, 17),
        DateTime(2026, 8, 16),
        DateTime(2026, 8, 15),
      };
      expect(CompletionStats.completionRate(dates, windowDays: 7, today: today), 57);
    });
  });

  group('CompletionStats.dailyRhythmScore', () {
    test('computes percentage of habits done today', () {
      expect(CompletionStats.dailyRhythmScore(completedToday: 4, totalToday: 5), 80);
    });

    test('returns 0 when there are no habits today', () {
      expect(CompletionStats.dailyRhythmScore(completedToday: 0, totalToday: 0), 0);
    });
  });
}
