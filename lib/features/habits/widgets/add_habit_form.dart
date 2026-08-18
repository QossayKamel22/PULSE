import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/habits_controller.dart';
import '../models/habit_model.dart';
import '../../../core/theme/pulse_spacing.dart';
import '../../../core/responsive/responsive_layout.dart';

/// Shared form body used by both the mobile bottom sheet and the
/// desktop/web dialog — one implementation, two entry points.
class AddHabitForm extends StatefulWidget {
  const AddHabitForm({super.key});

  @override
  State<AddHabitForm> createState() => _AddHabitFormState();

  static Future<void> show(BuildContext context) {
    if (context.isMobile) {
      return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => const Padding(
          padding: EdgeInsets.only(bottom: PulseSpacing.lg),
          child: SingleChildScrollView(child: AddHabitForm()),
        ),
      );
    }
    return showDialog(
      context: context,
      builder: (_) => Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: const AddHabitForm(),
        ),
      ),
    );
  }
}

class _AddHabitFormState extends State<AddHabitForm> {
  final _nameController = TextEditingController();
  HabitFrequency _frequency = HabitFrequency.daily;
  TimeOfDay _reminder = const TimeOfDay(hour: 8, minute: 0);
  IconData _icon = Icons.check_circle_outline;

  static const _iconChoices = [
    Icons.check_circle_outline,
    Icons.fitness_center,
    Icons.menu_book,
    Icons.code,
    Icons.self_improvement,
    Icons.water_drop_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(PulseSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('New Habit', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: PulseSpacing.lg),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          const SizedBox(height: PulseSpacing.md),
          DropdownButtonFormField<HabitFrequency>(
            initialValue: _frequency,
            decoration: const InputDecoration(labelText: 'Frequency'),
            items: HabitFrequency.values
                .map((f) => DropdownMenuItem(value: f, child: Text(f.label)))
                .toList(),
            onChanged: (v) => setState(() => _frequency = v ?? _frequency),
          ),
          const SizedBox(height: PulseSpacing.md),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Reminder'),
            trailing: Text(_reminder.format(context)),
            onTap: () async {
              final picked = await showTimePicker(context: context, initialTime: _reminder);
              if (picked != null) setState(() => _reminder = picked);
            },
          ),
          const SizedBox(height: PulseSpacing.md),
          Wrap(
            spacing: PulseSpacing.sm,
            children: _iconChoices.map((icon) {
              final selected = icon == _icon;
              return ChoiceChip(
                label: Icon(icon, size: 18),
                selected: selected,
                onSelected: (_) => setState(() => _icon = icon),
              );
            }).toList(),
          ),
          const SizedBox(height: PulseSpacing.lg),
          ElevatedButton(
            onPressed: _submit,
            child: const Text('Create Habit'),
          ),
        ],
      ),
    );
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    final habit = HabitModel(
      id: '',
      name: name,
      frequency: _frequency,
      reminderTime: _reminder,
      icon: _icon,
      createdAt: DateTime.now(),
    );
    Get.find<HabitsController>().createHabit(habit);
    Navigator.of(context).pop();
  }
}
