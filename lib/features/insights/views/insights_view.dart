import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../habits/controllers/habits_controller.dart';
import '../../habits/models/completion_stats.dart';
import '../../../core/theme/pulse_spacing.dart';
import '../../../core/widgets/pulse_ai_card.dart';
import '../../../core/responsive/responsive_layout.dart';

/// Kept intentionally simple — no full analytics dashboard, per PULSE's
/// "small app, premium execution" philosophy.
class InsightsView extends StatelessWidget {
  const InsightsView({super.key});

  @override
  Widget build(BuildContext context) {
    final habits = Get.find<HabitsController>();

    return Obx(() {
      final rate = habits.dailyRhythmScore;
      final weeklyScore = _weeklyScore(habits);

      final cards = [
        _InsightCard(label: 'Weekly Score', value: '$weeklyScore', sub: _scoreLabel(weeklyScore)),
        _InsightCard(label: 'Completion Rate', value: '$rate%'),
        _InsightCard(label: 'Habits tracked', value: '${habits.totalTodayCount}'),
      ];

      return SingleChildScrollView(
        padding: const EdgeInsets.all(PulseSpacing.lg),
        child: MaxWidthBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Insights', style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: PulseSpacing.lg),
              ResponsiveLayout(
                mobile: (_) => Column(
                  children: cards
                      .map((c) => Padding(padding: const EdgeInsets.only(bottom: PulseSpacing.md), child: c))
                      .toList(),
                ),
                desktop: (_) => Row(
                  children: cards
                      .map((c) => Expanded(child: Padding(padding: const EdgeInsets.only(right: PulseSpacing.md), child: c)))
                      .toList(),
                ),
              ),
              const SizedBox(height: PulseSpacing.md),
              const PulseAiCard(),
            ],
          ),
        ),
      );
    });
  }

  int _weeklyScore(HabitsController habits) {
    // Simple aggregate: average of today's rhythm and 7-day completion
    // proxy — kept intentionally lightweight per the "no huge analytics
    // dashboard" requirement.
    if (habits.totalTodayCount == 0) return 0;
    return CompletionStats.dailyRhythmScore(
      completedToday: habits.completedTodayCount,
      totalToday: habits.totalTodayCount,
    );
  }

  String _scoreLabel(int score) {
    if (score >= 90) return 'Excellent';
    if (score >= 70) return 'Great';
    if (score >= 40) return 'Good';
    return 'Getting started';
  }
}

class _InsightCard extends StatelessWidget {
  final String label;
  final String value;
  final String? sub;
  const _InsightCard({required this.label, required this.value, this.sub});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(PulseSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 4),
            Text(value, style: Theme.of(context).textTheme.displayMedium),
            if (sub != null) Text(sub!, style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}
