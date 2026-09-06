import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // ================= USER =================

  Future<Map<String, dynamic>?> getUser(String uid) async {
    final doc = await _firestore
        .collection('users')
        .doc(uid)
        .get();

    return doc.data();
  }

  Future<void> updateUser(
      String uid,
      Map<String, dynamic> data,
      ) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .set(
      data,
      SetOptions(merge: true),
    );
  }

  // ================= PROGRESS =================

  Future<Map<String, dynamic>?> getProgress(
      String uid,
      ) async {
    final doc = await _firestore
        .collection('users')
        .doc(uid)
        .collection('progress')
        .doc('statistics')
        .get();

    return doc.data();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>>
  progressStream(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('progress')
        .doc('statistics')
        .snapshots();
  }

  Future<void> updateProgress(
      String uid,
      Map<String, dynamic> data,
      ) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('progress')
        .doc('statistics')
        .set(
      data,
      SetOptions(merge: true),
    );
  }

  // ================= STUDY SESSIONS =================

  // ================= STUDY SESSIONS =================

  Future<void> addStudySession({
    required String uid,
    required DateTime date,
    required int duration,
    required String type,
    required String category,
  }) async {
    final statisticsRef = _firestore
        .collection('users/$uid/progress')
        .doc('statistics');

    final sessionRef = _firestore
        .collection('users/$uid/progress/statistics/sessions')
        .doc();
    await _firestore.runTransaction((transaction) async {
      final statisticsSnapshot =
      await transaction.get(statisticsRef);

      final data =
          statisticsSnapshot.data() ?? <String, dynamic>{};

      // ================= CURRENT VALUES =================

      final currentTotal =
      (data['totalStudyMinutes'] ?? 0) as num;

      final currentSessions =
      (data['sessions'] ?? 0) as num;

      final currentFocus =
      (data['focusMinutes'] ?? 0) as num;

      final currentBreak =
      (data['breakMinutes'] ?? 0) as num;

      // ================= WEEKLY DATA =================

      final weeklyData = Map<String, dynamic>.from(
        data['weeklyStudyMinutes'] ?? {},
      );

      const days = [
        'Mon',
        'Tue',
        'Wed',
        'Thu',
        'Fri',
        'Sat',
        'Sun',
      ];

      final dayName = days[date.weekday - 1];

      weeklyData[dayName] =
          ((weeklyData[dayName] ?? 0) as num) + duration;

      // ================= CATEGORY =================
      // Study Rooms are created with names like 'Computer Science' or
      // 'Mathematics' (see create_room_view.dart), so we match loosely
      // instead of requiring an exact 'programming' / 'math' string.

      String? categoryKey;

      final categoryLower = category.toLowerCase();

      if (categoryLower.contains('program') ||
          categoryLower.contains('computer')) {
        categoryKey = 'programmingMinutes';
      } else if (categoryLower.contains('math')) {
        categoryKey = 'mathMinutes';
      } else if (categoryLower.contains('language')) {
        categoryKey = 'languageMinutes';
      }

      final updatedStatistics = <String, dynamic>{
        'totalStudyMinutes':
        currentTotal.toInt() + duration,

        'sessions':
        currentSessions.toInt() + 1,

        'focusMinutes':
        type.toLowerCase() == 'focus'
            ? currentFocus.toInt() + duration
            : currentFocus.toInt(),

        'breakMinutes':
        type.toLowerCase() == 'break'
            ? currentBreak.toInt() + duration
            : currentBreak,

        'weeklyStudyMinutes': weeklyData,
      };

      // ================= CATEGORY MINUTES =================

      if (categoryKey != null) {
        final currentCategory =
        (data[categoryKey] ?? 0) as num;

        updatedStatistics[categoryKey] =
            currentCategory.toInt() + duration;
      }

      // ================= STREAK =================

      int currentStreak =
      (data['currentStreak'] ?? 0) as int;

      final lastStudyDate =
      data['lastStudyDate'];

      final today = DateTime(
        date.year,
        date.month,
        date.day,
      );

      if (lastStudyDate is Timestamp) {
        final lastDate = lastStudyDate.toDate();

        final lastDay = DateTime(
          lastDate.year,
          lastDate.month,
          lastDate.day,
        );

        final difference =
            today.difference(lastDay).inDays;

        if (difference == 1) {
          currentStreak++;
        } else if (difference > 1) {
          currentStreak = 1;
        }
      } else {
        currentStreak = 1;
      }

      updatedStatistics['currentStreak'] =
          currentStreak;

      updatedStatistics['lastStudyDate'] =
          Timestamp.fromDate(today);

      // ================= SAVE STATISTICS =================

      transaction.set(
        statisticsRef,
        updatedStatistics,
        SetOptions(merge: true),
      );

      // ================= SAVE SESSION =================

      transaction.set(
        sessionRef,
        {
          'date': Timestamp.fromDate(date),
          'duration': duration,
          'type': type,
          'category': category,
        },
      );
    });
  }

// ================= SESSIONS STREAM =================

  Stream<QuerySnapshot<Map<String, dynamic>>> sessionsStream(
      String uid,
      ) {
    return _firestore
        .collection('users/$uid/progress/statistics/sessions')
        .orderBy('date', descending: true)
        .snapshots();
  }
}