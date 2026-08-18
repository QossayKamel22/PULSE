import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../habits/controllers/habits_controller.dart';
import '../../habits/widgets/habit_tile.dart';
import '../../habits/widgets/add_habit_form.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../core/theme/pulse_spacing.dart';
import '../../../core/theme/pulse_colors.dart';
import '../../../core/widgets/pulse_ai_card.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../core/routes/app_routes.dart';

/// Home is the most important screen: the user should understand their
/// status within ~2 seconds. Same data/logic on mobile and desktop/web,
/// laid out differently — desktop gets a two-column dashboard.
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final habits = Get.find<HabitsController>();
    final auth = Get.find<AuthController>();

    return Obx(() {
      final greeting = _greeting();
      final rhythm = habits.dailyRhythmScore;

      Widget header = Padding(
        padding: const EdgeInsets.fromLTRB(PulseSpacing.lg, PulseSpacing.lg, PulseSpacing.lg, 0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(greeting, style: Theme.of(context).textTheme.bodyMedium),
                  Text('Build your rhythm.', style: Theme.of(context).textTheme.headlineMedium),
                ],
              ),
            ),
            IconButton(icon: const Icon(Icons.notifications_none_rounded), onPressed: () {}),
          ],
        ),
      );

      Widget rhythmCard = Card(
        child: Padding(
          padding: const EdgeInsets.all(PulseSpacing.lg),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Your rhythm', style: Theme.of(context).textTheme.bodyMedium),
                    Text('$rhythm%', style: Theme.of(context).textTheme.displayLarge),
                  ],
                ),
              ),
              Text('${habits.completedTodayCount} / ${habits.totalTodayCount}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: PulseColors.pulseBlue)),
            ],
          ),
        ),
      );

      Widget todayList = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text("Today's habits", style: Theme.of(context).textTheme.titleLarge)),
              TextButton.icon(
                onPressed: () => AddHabitForm.show(context),
                icon: const Icon(Icons.add),
                label: const Text('Add habit'),
              ),
            ],
          ),
          const SizedBox(height: PulseSpacing.sm),
          if (habits.isLoading.value)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: PulseSpacing.xl),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (habits.habits.isEmpty)
            _EmptyHabits(onAdd: () => AddHabitForm.show(context))
          else
            ...habits.habits.map((h) => Padding(
                  padding: const EdgeInsets.only(bottom: PulseSpacing.sm),
                  child: HabitTile(
                    habit: h,
                    completed: habits.completedTodayIds.contains(h.id),
                    onToggle: () => habits.toggleCompletion(h),
                    onTap: () => Get.toNamed(AppRoutes.habitDetailsPath(h.id)),
                  ),
                )),
        ],
      );

      return ResponsiveLayout(
        mobile: (_) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              header,
              const SizedBox(height: PulseSpacing.md),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: PulseSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    rhythmCard,
                    const SizedBox(height: PulseSpacing.md),
                    const PulseAiCard(),
                    const SizedBox(height: PulseSpacing.lg),
                    todayList,
                  ],
                ),
              ),
              const SizedBox(height: PulseSpacing.xl),
            ],
          ),
        ),
        desktop: (_) => SingleChildScrollView(
          child: MaxWidthBox(
            child: Padding(
              padding: const EdgeInsets.all(PulseSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  header,
                  const SizedBox(height: PulseSpacing.lg),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: todayList),
                      const SizedBox(width: PulseSpacing.lg),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            rhythmCard,
                            const SizedBox(height: PulseSpacing.md),
                            const PulseAiCard(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
  }
}

class _EmptyHabits extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyHabits({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(PulseSpacing.xl),
        child: Column(
          children: [
            Text('No habits yet.', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text('Start building your rhythm.', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: PulseSpacing.md),
            ElevatedButton(onPressed: onAdd, child: const Text('Add your first habit')),
          ],
        ),
      ),
    );
  }
}
