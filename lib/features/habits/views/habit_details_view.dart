import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/habits_controller.dart';
import '../models/habit_model.dart';
import '../models/completion_stats.dart';
import '../../../core/theme/pulse_spacing.dart';
import '../../../core/theme/pulse_colors.dart';
import '../../../core/responsive/responsive_layout.dart';

class HabitDetailsView extends StatelessWidget {
  const HabitDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final habitId = Get.parameters['id'] ?? '';
    final controller = Get.find<HabitsController>();
    final habit = controller.habits.firstWhereOrNull((h) => h.id == habitId);

    if (habit == null) {
      return const Scaffold(body: Center(child: Text('Habit not found')));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(habit.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              await controller.deleteHabit(habit.id);
              if (context.mounted) Get.back();
            },
          ),
        ],
      ),
      body: StreamBuilder<Set<DateTime>>(
        stream: controller.completionsStream(habit.id),
        builder: (context, snapshot) {
          final completions = snapshot.data ?? {};
          final currentStreak = CompletionStats.currentStreak(completions);
          final bestStreak = CompletionStats.bestStreak(completions);
          final rate = CompletionStats.completionRate(completions);

          return Center(
            child: MaxWidthBox(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(PulseSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(child: _StatCard(label: 'Current streak', value: '🔥 $currentStreak days')),
                        const SizedBox(width: PulseSpacing.md),
                        Expanded(child: _StatCard(label: 'Best streak', value: '$bestStreak days')),
                      ],
                    ),
                    const SizedBox(height: PulseSpacing.md),
                    _StatCard(label: 'Completion (7 days)', value: '$rate%'),
                    const SizedBox(height: PulseSpacing.lg),
                    Text('Weekly completion', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: PulseSpacing.sm),
                    _WeekRow(completions: completions),
                    const SizedBox(height: PulseSpacing.lg),
                    Text('Weekly activity', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: PulseSpacing.sm),
                    SizedBox(height: 180, child: _WeeklyChart(completions: completions)),
                    const SizedBox(height: PulseSpacing.xl),
                    ElevatedButton.icon(
                      onPressed: () => controller.toggleCompletion(habit),
                      icon: const Icon(Icons.check),
                      label: const Text('Mark as completed'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(PulseSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 4),
            Text(value, style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
    );
  }
}

class _WeekRow extends StatelessWidget {
  final Set<DateTime> completions;
  const _WeekRow({required this.completions});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final startOfWeek = DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1));
    const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (i) {
        final day = startOfWeek.add(Duration(days: i));
        final done = completions.contains(DateTime(day.year, day.month, day.day));
        final isFuture = day.isAfter(DateTime(now.year, now.month, now.day));
        return Column(
          children: [
            Text(labels[i], style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 6),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: done
                    ? PulseColors.success
                    : (isFuture ? Colors.transparent : PulseColors.danger.withValues(alpha: 0.15)),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: done ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
            ),
          ],
        );
      }),
    );
  }
}

class _WeeklyChart extends StatelessWidget {
  final Set<DateTime> completions;
  const _WeeklyChart({required this.completions});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final startOfWeek = DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1));

    return BarChart(
      BarChartData(
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: const FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        barGroups: List.generate(7, (i) {
          final day = startOfWeek.add(Duration(days: i));
          final done = completions.contains(DateTime(day.year, day.month, day.day));
          return BarChartGroupData(x: i, barRods: [
            BarChartRodData(
              toY: done ? 1 : 0.05,
              color: done ? PulseColors.pulseBlue : PulseColors.pulseBlue.withValues(alpha: 0.1),
              width: 18,
              borderRadius: BorderRadius.circular(6),
            ),
          ]);
        }),
      ),
    );
  }
}
