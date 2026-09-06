import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_side/services/firestore_services.dart';
import 'package:study_side/theme/app_theme.dart';
import 'package:study_side/view_model/progress/progress_view_model.dart';
import 'package:study_side/widgets/app_bottom_nav.dart';
import 'package:study_side/model/task_store.dart';


class ProgressView extends StatelessWidget {
  const ProgressView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProgressViewModel(
        firestoreService: FirestoreService(),
      )..startListening(),
      child: const _ProgressBody(),
    );
  }
}

class _ProgressBody extends StatelessWidget {
  const _ProgressBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProgressViewModel>();
    final progress = viewModel.progress;

return ValueListenableBuilder<int>(
valueListenable: TaskStore.version,
builder: (context, value, child) {
  final totalTasks = TaskStore.totalTasks;
  final completedTasks = TaskStore.completedTasks;
  final taskProgress = TaskStore.taskProgress;
  final percentage = TaskStore.completedPercentage;

  return Scaffold(
    backgroundColor: const Color(0xffF9F8FE),

    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          20,
          20,
          20,
          30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ================= HEADER =================

            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [

                const Text(
                  'Your Progress',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),

                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.circular(14),
                    boxShadow: cardShadow,
                  ),
                  child: IconButton(
                    onPressed: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                        initialDate: viewModel.selectedDate,
                      );

                      if (selectedDate != null) {
                        viewModel.selectDate(selectedDate);
                      }
                    },
                    icon: const Icon(
                      Icons.calendar_month_outlined,
                      color: AppColors.primary,
                      size: 25,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 22),

            // ================= STREAK CARD =================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xff7447D9),
                    Color(0xff6840D1),
                  ],
                ),
                borderRadius:
                BorderRadius.circular(20),
              ),
              child: Row(
                children: [

                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        '🔥',
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        Text(
                          '${progress.currentStreak} Days Streak',
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight:
                            FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 5),

                        const Text(
                          'Keep it up! You\'re doing great.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                    size: 30,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ================= TOTAL STUDY TIME =================

            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    const Text(
                      'Total Study Time',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight:
                        FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Text(
                      viewModel.formatTime(
                        progress.totalStudyMinutes,
                      ),
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight:
                        FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),

                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: const Text('This Week'),
                                onTap: () {
                                  viewModel.selectWeek('This Week');
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                title: const Text('Previous Week'),
                                onTap: () {
                                  viewModel.selectWeek('Previous Week');
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: cardShadow,
                    ),
                    child: Row(
                      children: [
                        Text(
                          viewModel.selectedWeek,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textGrey,
                          ),
                        ),
                        const SizedBox(width: 7),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          size: 20,
                          color: AppColors.textGrey,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // ================= WEEKLY CHART =================

            _WeeklyChart(
              weeklyData: viewModel.selectedWeekData,
            ),

            const SizedBox(height: 30),

            // ================= CATEGORIES =================

            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [

                const Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),

                TextButton(
                  onPressed: () {
                    final categories = viewModel.categoryMinutes;

                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Text(
                                    'All Categories',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                if (categories.isEmpty)
                                  const Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Text(
                                      'No study sessions yet.',
                                    ),
                                  )
                                else
                                  ...categories.entries.map(
                                        (entry) {
                                      return ListTile(
                                        title: Text(entry.key),
                                        trailing: Text(
                                          viewModel.formatTime(
                                            entry.value,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: const Text(
                    'See all',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 5),

            _CategoryCard(
              icon: Icons.code,
              iconColor: const Color(0xff53C99B),
              backgroundColor:
              const Color(0xffE5F8F0),
              title: 'Programming',
              time: viewModel.formatTime(
                progress.programmingMinutes,
              ),
              percentage:
              progress.totalStudyMinutes == 0
                  ? 0
                  : progress.programmingMinutes /
                  progress.totalStudyMinutes,
            ),

            const SizedBox(height: 12),

            _CategoryCard(
              icon: Icons.calculate_outlined,
              iconColor: const Color(0xff7350D8),
              backgroundColor:
              const Color(0xffEEE9FC),
              title: 'Math',
              time: viewModel.formatTime(
                progress.mathMinutes,
              ),
              percentage:
              progress.totalStudyMinutes == 0
                  ? 0
                  : progress.mathMinutes /
                  progress.totalStudyMinutes,
            ),

            const SizedBox(height: 12),

            _CategoryCard(
              icon: Icons.translate,
              iconColor: const Color(0xffE26C85),
              backgroundColor:
              const Color(0xffffe8ee),
              title: 'Languages',
              time: viewModel.formatTime(
                progress.languageMinutes,
              ),
              percentage:
              progress.totalStudyMinutes == 0
                  ? 0
                  : progress.languageMinutes /
                  progress.totalStudyMinutes,
            ),

            const SizedBox(height: 28),

            // ================= SESSION SUMMARY =================

            const Text(
              'Session Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding:
              const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.circular(18),
                boxShadow: cardShadow,
              ),
              child: Column(
                children: [

                  _SummaryRow(
                    icon: Icons.access_time,
                    iconColor:
                    const Color(0xff7651D6),
                    title: 'Focus Time',
                    value:
                    viewModel.formatTime(
                      progress.focusMinutes,
                    ),
                  ),

                  const Divider(height: 1),

                  _SummaryRow(
                    icon: Icons.coffee,
                    iconColor:
                    const Color(0xff65B7C1),
                    title: 'Break Time',
                    value:
                    viewModel.formatTime(
                      progress.breakMinutes,
                    ),
                  ),

                  const Divider(height: 1),

                  _SummaryRow(
                    icon: Icons.timer_outlined,
                    iconColor:
                    const Color(0xffE8B847),
                    title: 'Total Time',
                    value:
                    viewModel.formatTime(
                      progress.focusMinutes +
                          progress.breakMinutes,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // ================= CURRENT STREAK =================

            Container(
              width: double.infinity,
              padding:
              const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.circular(18),
                boxShadow: cardShadow,
              ),
              child: Row(
                children: [

                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xffffeeee),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        '🔥',
                        style: TextStyle(
                          fontSize: 23,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  const Expanded(
                    child: Text(
                      'Current Streak',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                        FontWeight.bold,
                        color:
                        AppColors.textDark,
                      ),
                    ),
                  ),

                  Text(
                    '${progress.currentStreak} days',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight:
                      FontWeight.bold,
                      color:
                      AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    bottomNavigationBar: const AppBottomNav(
      currentIndex: 2,
    ),
  );
},
    );
  }


}

// ======================================================
// WEEKLY CHART
// ======================================================

class _WeeklyChart extends StatelessWidget {
  final Map<String, int> weeklyData;

  const _WeeklyChart({
    required this.weeklyData,
  });

  @override
  Widget build(BuildContext context) {
    const days = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];

    int maxMinutes = 0;

    for (final day in days) {
      final value = weeklyData[day] ?? 0;

      if (value > maxMinutes) {
        maxMinutes = value;
      }
    }

    if (maxMinutes == 0) {
      maxMinutes = 60;
    }

    return SizedBox(
      height: 210,
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.end,
        mainAxisAlignment:
        MainAxisAlignment.spaceAround,
        children: days.map((day) {

          final minutes =
              weeklyData[day] ?? 0;

          final height =
              (minutes / maxMinutes) * 135;

          return Column(
            mainAxisAlignment:
            MainAxisAlignment.end,
            children: [

              Text(
                minutes == 0
                    ? ''
                    : _formatShortTime(minutes),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textGrey,
                ),
              ),

              const SizedBox(height: 6),

              Container(
                width: 32,
                height: height < 8
                    ? 8
                    : height,
                decoration: BoxDecoration(
                  gradient:
                  const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xff9670E8),
                      Color(0xff7046D9),
                    ],
                  ),
                  borderRadius:
                  BorderRadius.circular(7),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                day,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textGrey,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  String _formatShortTime(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;

    if (hours > 0 && mins > 0) {
      return '${hours}h ${mins}m';
    }

    if (hours > 0) {
      return '${hours}h';
    }

    return '${mins}m';
  }
}

// ======================================================
// CATEGORY CARD
// ======================================================

class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final String title;
  final String time;
  final double percentage;

  const _CategoryCard({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.title,
    required this.time,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(16),
        boxShadow: cardShadow,
      ),
      child: Row(
        children: [

          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius:
              BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [

                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight:
                        FontWeight.bold,
                        color:
                        AppColors.textDark,
                      ),
                    ),

                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 13,
                        color:
                        AppColors.textGrey,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                LinearProgressIndicator(
                  value: percentage > 1
                      ? 1
                      : percentage,
                  minHeight: 7,
                  backgroundColor:
                  const Color(0xffEEEEF2),
                  valueColor:
                  AlwaysStoppedAnimation<Color>(
                    AppColors.primary,
                  ),
                  borderRadius:
                  BorderRadius.circular(10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================
// SUMMARY ROW
// ======================================================

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;

  const _SummaryRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(
        vertical: 14,
      ),
      child: Row(
        children: [

          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textGrey,
              ),
            ),
          ),

          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}