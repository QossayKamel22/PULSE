import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../features/habits/models/habit_model.dart';

/// All Firestore reads/writes for PULSE live here — screens and
/// controllers never call cloud_firestore directly. Structure:
///
///   users/{userId}                                (profile fields)
///   users/{userId}/habits/{habitId}                (habit docs)
///   users/{userId}/habits/{habitId}/completions/{yyyy-MM-dd}
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final DateFormat _dateKey = DateFormat('yyyy-MM-dd');

  CollectionReference<Map<String, dynamic>> _habits(String uid) =>
      _db.collection('users').doc(uid).collection('habits');

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) => _db.collection('users').doc(uid);

  // --- Profile ---
  Future<void> ensureUserProfile(String uid, {required String email, String? name}) async {
    final doc = _userDoc(uid);
    final snap = await doc.get();
    if (!snap.exists) {
      await doc.set({
        'email': email,
        'name': name ?? email.split('@').first,
        'photoUrl': null,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Stream<Map<String, dynamic>?> profileStream(String uid) => _userDoc(uid).snapshots().map((s) => s.data());

  Future<void> updateProfile(String uid, Map<String, dynamic> data) => _userDoc(uid).update(data);

  // --- Habits ---
  Stream<List<HabitModel>> habitsStream(String uid) {
    return _habits(uid)
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt')
        .snapshots()
        .map((s) => s.docs.map((d) => HabitModel.fromMap(d.id, d.data())).toList());
  }

  Future<String> createHabit(String uid, HabitModel habit) async {
    final ref = await _habits(uid).add(habit.toMap());
    return ref.id;
  }

  Future<void> updateHabit(String uid, HabitModel habit) => _habits(uid).doc(habit.id).update(habit.toMap());

  /// Soft delete — keeps history/completions intact for streak math.
  Future<void> deleteHabit(String uid, String habitId) =>
      _habits(uid).doc(habitId).update({'isActive': false});

  // --- Completions ---
  Future<void> setCompletion(String uid, String habitId, DateTime date, bool completed) {
    final key = _dateKey.format(date);
    final ref = _habits(uid).doc(habitId).collection('completions').doc(key);
    if (completed) {
      return ref.set({'completed': true, 'completedAt': FieldValue.serverTimestamp()});
    }
    return ref.delete();
  }

  Stream<Set<DateTime>> completionsStream(String uid, String habitId, {int lastNDays = 60}) {
    final since = DateTime.now().subtract(Duration(days: lastNDays));
    return _habits(uid)
        .doc(habitId)
        .collection('completions')
        .where('completedAt', isGreaterThanOrEqualTo: Timestamp.fromDate(since))
        .snapshots()
        .map((s) => s.docs.map((d) => _dateKey.parse(d.id)).toSet());
  }

  Future<bool> isCompletedToday(String uid, String habitId) async {
    final key = _dateKey.format(DateTime.now());
    final doc = await _habits(uid).doc(habitId).collection('completions').doc(key).get();
    return doc.exists;
  }
}
