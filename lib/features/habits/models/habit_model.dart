import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum HabitFrequency { daily, weekdays, custom }

extension HabitFrequencyX on HabitFrequency {
  String get label => switch (this) {
        HabitFrequency.daily => 'Every day',
        HabitFrequency.weekdays => 'Weekdays',
        HabitFrequency.custom => 'Custom',
      };
}

/// habits/{habitId} document. Completions live in the
/// habits/{habitId}/completions/{yyyy-MM-dd} subcollection — see
/// FirestoreService — so this document never grows unbounded.
class HabitModel {
  final String id;
  final String name;
  final HabitFrequency frequency;
  final TimeOfDay? reminderTime;
  final IconData icon;
  final DateTime createdAt;
  final bool isActive;

  const HabitModel({
    required this.id,
    required this.name,
    required this.frequency,
    required this.icon,
    required this.createdAt,
    this.reminderTime,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'frequency': frequency.name,
      'reminderTime': reminderTime == null ? null : '${reminderTime!.hour}:${reminderTime!.minute}',
      'icon': icon.codePoint,
      'createdAt': Timestamp.fromDate(createdAt),
      'isActive': isActive,
    };
  }

  factory HabitModel.fromMap(String id, Map<String, dynamic> map) {
    TimeOfDay? reminder;
    final reminderRaw = map['reminderTime'] as String?;
    if (reminderRaw != null && reminderRaw.contains(':')) {
      final parts = reminderRaw.split(':');
      reminder = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }
    return HabitModel(
      id: id,
      name: map['name'] as String? ?? '',
      frequency: HabitFrequency.values.firstWhere(
        (f) => f.name == map['frequency'],
        orElse: () => HabitFrequency.daily,
      ),
      reminderTime: reminder,
      icon: map['icon'] is int
          // ignore: non_const_argument_for_const_parameter
          ? IconData(map['icon'] as int, fontFamily: 'MaterialIcons')
          : Icons.check_circle_outline,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isActive: map['isActive'] as bool? ?? true,
    );
  }

  HabitModel copyWith({
    String? name,
    HabitFrequency? frequency,
    TimeOfDay? reminderTime,
    IconData? icon,
    bool? isActive,
  }) {
    return HabitModel(
      id: id,
      name: name ?? this.name,
      frequency: frequency ?? this.frequency,
      reminderTime: reminderTime ?? this.reminderTime,
      icon: icon ?? this.icon,
      createdAt: createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
