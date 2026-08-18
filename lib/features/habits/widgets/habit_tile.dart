import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/habit_model.dart';
import '../../../core/theme/pulse_colors.dart';
import '../../../core/theme/pulse_spacing.dart';

class HabitTile extends StatelessWidget {
  final HabitModel habit;
  final bool completed;
  final VoidCallback onToggle;
  final VoidCallback onTap;

  const HabitTile({
    super.key,
    required this.habit,
    required this.completed,
    required this.onToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(PulseRadius.lg),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(PulseSpacing.md),
          child: Row(
            children: [
              Icon(habit.icon, color: PulseColors.pulseBlue),
              const SizedBox(width: PulseSpacing.md),
              Expanded(
                child: Text(habit.name, style: Theme.of(context).textTheme.titleMedium),
              ),
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  onToggle();
                },
                child: AnimatedContainer(
                  duration: PulseDurations.fast,
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: completed ? PulseColors.success : Colors.transparent,
                    border: Border.all(
                      color: completed ? PulseColors.success : Theme.of(context).dividerColor,
                      width: 2,
                    ),
                  ),
                  child: completed ? const Icon(Icons.check, size: 18, color: Colors.white) : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
