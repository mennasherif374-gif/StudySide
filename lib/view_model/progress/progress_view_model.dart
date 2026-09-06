import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:study_side/services/firestore_services.dart';

import '../../model/progress_model.dart';

class ProgressViewModel extends ChangeNotifier {
  final FirestoreService firestoreService;

  ProgressViewModel({
    required this.firestoreService,
  });

  ProgressModel _progress = ProgressModel();

  ProgressModel get progress => _progress;

  bool isLoading = true;

  StreamSubscription? _progressSubscription;
  StreamSubscription? _sessionsSubscription;

  final List<Map<String, dynamic>> _sessions = [];

  // ======================================================
  // SELECTED DATE
  // ======================================================

  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  // ======================================================
  // SELECTED WEEK
  // ======================================================

  String _selectedWeek = 'This Week';

  String get selectedWeek => _selectedWeek;

  void selectWeek(String week) {
    _selectedWeek = week;
    notifyListeners();
  }

  // ======================================================
  // WEEK REFERENCE DATE
  // ======================================================

  DateTime get _weekReferenceDate {
    if (_selectedWeek == 'Previous Week') {
      return _selectedDate.subtract(
        const Duration(days: 7),
      );
    }

    return _selectedDate;
  }

  // ======================================================
  // WEEK RANGE
  // ======================================================

  DateTime get _startOfWeek {
    final date = DateTime(
      _weekReferenceDate.year,
      _weekReferenceDate.month,
      _weekReferenceDate.day,
    );

    final difference =
        date.weekday - DateTime.monday;

    return date.subtract(
      Duration(days: difference),
    );
  }

  DateTime get _endOfWeek {
    return _startOfWeek.add(
      const Duration(days: 6),
    );
  }

  // ======================================================
  // START LISTENING
  // ======================================================

  void startListening() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      isLoading = false;
      notifyListeners();
      return;
    }

    _progressSubscription?.cancel();
    _sessionsSubscription?.cancel();

    // ================= STATISTICS =================

    _progressSubscription =
        firestoreService.progressStream(user.uid).listen(
              (snapshot) {
            final data = snapshot.data();

            if (data != null) {
              _progress = ProgressModel.fromMap(data);
            }

            isLoading = false;
            notifyListeners();
          },
          onError: (error) {
            debugPrint(
              'Progress stream error: $error',
            );

            isLoading = false;
            notifyListeners();
          },
        );

    // ================= SESSIONS =================

    _sessionsSubscription =
        firestoreService.sessionsStream(user.uid).listen(
              (snapshot) {
            _sessions.clear();

            for (final document in snapshot.docs) {
              final data = document.data();

              _sessions.add({
                'date': data['date'],
                'duration': data['duration'] ?? 0,
                'type': data['type'] ?? 'focus',
                'category': data['category'] ?? 'Other',
              });
            }

            notifyListeners();
          },
          onError: (error) {
            debugPrint(
              'Sessions stream error: $error',
            );
          },
        );
  }

  // ======================================================
  // SELECT DATE
  // ======================================================

  void selectDate(DateTime date) {
    _selectedDate = DateTime(
      date.year,
      date.month,
      date.day,
    );

    notifyListeners();
  }

  // ======================================================
  // WEEKLY DATA
  // ======================================================

  Map<String, int> get selectedWeekData {
    const days = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];

    final result = <String, int>{
      for (final day in days) day: 0,
    };

    for (final session in _sessions) {
      final timestamp = session['date'];

      if (timestamp is! Timestamp) {
        continue;
      }

      final date = timestamp.toDate();

      final dateOnly = DateTime(
        date.year,
        date.month,
        date.day,
      );

      if (dateOnly.isBefore(_startOfWeek) ||
          dateOnly.isAfter(_endOfWeek)) {
        continue;
      }

      final dayName = days[date.weekday - 1];

      final duration =
      (session['duration'] as num).toInt();

      result[dayName] =
          result[dayName]! + duration;
    }

    return result;
  }

  // ======================================================
  // CATEGORY DATA
  // ======================================================

  Map<String, int> get categoryMinutes {
    final result = <String, int>{};

    for (final session in _sessions) {
      final timestamp = session['date'];

      if (timestamp is! Timestamp) {
        continue;
      }

      final date = timestamp.toDate();

      final dateOnly = DateTime(
        date.year,
        date.month,
        date.day,
      );

      if (dateOnly.isBefore(_startOfWeek) ||
          dateOnly.isAfter(_endOfWeek)) {
        continue;
      }

      final category =
      session['category'] as String;

      final duration =
      (session['duration'] as num).toInt();

      result[category] =
          (result[category] ?? 0) + duration;
    }

    return result;
  }

  // ======================================================
  // SELECTED DAY SESSIONS
  // ======================================================

  List<Map<String, dynamic>> get selectedDaySessions {
    return _sessions.where((session) {
      final timestamp = session['date'];

      if (timestamp is! Timestamp) {
        return false;
      }

      final date = timestamp.toDate();

      return date.year == _selectedDate.year &&
          date.month == _selectedDate.month &&
          date.day == _selectedDate.day;
    }).toList();
  }

  // ======================================================
  // SELECTED DAY MINUTES
  // ======================================================

  int get selectedDayMinutes {
    return selectedDaySessions.fold(
      0,
          (total, session) =>
      total +
          (session['duration'] as num).toInt(),
    );
  }

  // ======================================================
  // WEEKLY FOCUS MINUTES (focus sessions only, current week)
  // ======================================================
  // Used by the Home screen's "Focus Time" card, so Home reads from the
  // exact same sessions data as this screen instead of a separate source.

  int get weeklyFocusMinutes {
    int total = 0;

    for (final session in _sessions) {
      final timestamp = session['date'];

      if (timestamp is! Timestamp) {
        continue;
      }

      if (session['type'] != 'focus') {
        continue;
      }

      final date = timestamp.toDate();

      final dateOnly = DateTime(
        date.year,
        date.month,
        date.day,
      );

      if (dateOnly.isBefore(_startOfWeek) ||
          dateOnly.isAfter(_endOfWeek)) {
        continue;
      }

      total += (session['duration'] as num).toInt();
    }

    return total;
  }

  // ======================================================
  // FORMAT TIME
  // ======================================================

  String formatTime(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;

    if (hours == 0) {
      return '${mins}m';
    }

    if (mins == 0) {
      return '${hours}h';
    }

    return '${hours}h ${mins}m';
  }

  // ======================================================
  // DISPOSE
  // ======================================================

  @override
  void dispose() {
    _progressSubscription?.cancel();
    _sessionsSubscription?.cancel();

    super.dispose();
  }
}