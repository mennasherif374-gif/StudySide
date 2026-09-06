class ProgressModel {
  final int currentStreak;
  final int sessions;
  final int goalsCompleted;

  final int totalStudyMinutes;

  final int programmingMinutes;
  final int mathMinutes;
  final int languageMinutes;

  final int focusMinutes;
  final int breakMinutes;

  final Map<String, int> weeklyStudyMinutes;

  ProgressModel({
    this.currentStreak = 0,
    this.sessions = 0,
    this.goalsCompleted = 0,
    this.totalStudyMinutes = 0,
    this.programmingMinutes = 0,
    this.mathMinutes = 0,
    this.languageMinutes = 0,
    this.focusMinutes = 0,
    this.breakMinutes = 0,
    this.weeklyStudyMinutes = const {},
  });

  factory ProgressModel.fromMap(Map<String, dynamic> map) {
    return ProgressModel(
      currentStreak: (map['currentStreak'] ?? 0) as int,
      sessions: (map['sessions'] ?? 0) as int,
      goalsCompleted: (map['goalsCompleted'] ?? 0) as int,
      totalStudyMinutes: (map['totalStudyMinutes'] ?? 0) as int,
      programmingMinutes: (map['programmingMinutes'] ?? 0) as int,
      mathMinutes: (map['mathMinutes'] ?? 0) as int,
      languageMinutes: (map['languageMinutes'] ?? 0) as int,
      focusMinutes: (map['focusMinutes'] ?? 0) as int,
      breakMinutes: (map['breakMinutes'] ?? 0) as int,
      weeklyStudyMinutes:
      Map<String, int>.from(map['weeklyStudyMinutes'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'currentStreak': currentStreak,
      'sessions': sessions,
      'goalsCompleted': goalsCompleted,
      'totalStudyMinutes': totalStudyMinutes,
      'programmingMinutes': programmingMinutes,
      'mathMinutes': mathMinutes,
      'languageMinutes': languageMinutes,
      'focusMinutes': focusMinutes,
      'breakMinutes': breakMinutes,
      'weeklyStudyMinutes': weeklyStudyMinutes,
    };
  }
}