import 'package:get/get.dart';
import '../../../services/firestore/firestore_service.dart';
import '../../auth/controllers/auth_controller.dart';
import '../models/habit_model.dart';
import '../models/completion_stats.dart';

/// Owns the live list of habits plus today's completion state, so Home /
/// Insights / Habit Details all read from one source of truth.
class HabitsController extends GetxController {
  final FirestoreService _firestore = FirestoreService();
  final AuthController _auth = Get.find<AuthController>();

  final habits = <HabitModel>[].obs;
  final completedTodayIds = <String>{}.obs;
  final isLoading = true.obs;

  String? get _uid => _auth.uid;

  @override
  void onInit() {
    super.onInit();
    _bindHabits();
  }

  void _bindHabits() {
    final uid = _uid;
    if (uid == null) return;
    isLoading.value = true;
    _firestore.habitsStream(uid).listen((list) async {
      habits.assignAll(list);
      final completed = <String>{};
      for (final h in list) {
        if (await _firestore.isCompletedToday(uid, h.id)) completed.add(h.id);
      }
      completedTodayIds.assignAll(completed);
      isLoading.value = false;
    });
  }

  int get completedTodayCount => completedTodayIds.length;
  int get totalTodayCount => habits.length;
  int get dailyRhythmScore =>
      CompletionStats.dailyRhythmScore(completedToday: completedTodayCount, totalToday: totalTodayCount);

  Future<void> toggleCompletion(HabitModel habit) async {
    final uid = _uid;
    if (uid == null) return;
    final isDone = completedTodayIds.contains(habit.id);
    await _firestore.setCompletion(uid, habit.id, DateTime.now(), !isDone);
    if (isDone) {
      completedTodayIds.remove(habit.id);
    } else {
      completedTodayIds.add(habit.id);
    }
  }

  Future<void> createHabit(HabitModel habit) async {
    final uid = _uid;
    if (uid == null) return;
    await _firestore.createHabit(uid, habit);
  }

  Future<void> updateHabit(HabitModel habit) async {
    final uid = _uid;
    if (uid == null) return;
    await _firestore.updateHabit(uid, habit);
  }

  Future<void> deleteHabit(String habitId) async {
    final uid = _uid;
    if (uid == null) return;
    await _firestore.deleteHabit(uid, habitId);
  }

  Stream<Set<DateTime>> completionsStream(String habitId) {
    final uid = _uid;
    if (uid == null) return const Stream.empty();
    return _firestore.completionsStream(uid, habitId);
  }
}
