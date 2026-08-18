import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/features/habits/models/habit_model.dart';

void main() {
  test('HabitModel round-trips through toMap/fromMap', () {
    final habit = HabitModel(
      id: 'abc',
      name: 'Read',
      frequency: HabitFrequency.daily,
      reminderTime: const TimeOfDay(hour: 8, minute: 30),
      icon: Icons.menu_book,
      createdAt: DateTime(2026, 1, 1),
    );

    final map = habit.toMap();
    // Simulate Firestore round trip by keeping the Timestamp as-is.
    final restored = HabitModel.fromMap('abc', map);

    expect(restored.name, 'Read');
    expect(restored.frequency, HabitFrequency.daily);
    expect(restored.reminderTime, const TimeOfDay(hour: 8, minute: 30));
    expect(restored.isActive, true);
  });

  test('fromMap defaults gracefully on missing fields', () {
    final restored = HabitModel.fromMap('x', {'name': 'Workout'});
    expect(restored.name, 'Workout');
    expect(restored.frequency, HabitFrequency.daily);
    expect(restored.reminderTime, isNull);
  });
}
