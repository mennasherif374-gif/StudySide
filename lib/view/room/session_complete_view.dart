import 'package:flutter/material.dart';
import 'package:study_side/model/task_store.dart';
import 'package:study_side/theme/app_theme.dart';
import 'package:study_side/view/room/my_tasks_view.dart';

class SessionCompleteView extends StatelessWidget {
  final int completedTasks;
  final int totalTasks;
  final int durationMinutes;

  const SessionCompleteView({
    super.key,
    required this.completedTasks,
    required this.totalTasks,
    required this.durationMinutes,
  });

  @override
  Widget build(BuildContext context) {
    final bool allTasksCompleted =
        totalTasks > 0 &&
            completedTasks >= totalTasks;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FF),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 20,
            ),
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(
                maxWidth: 400,
              ),
              padding: const EdgeInsets.fromLTRB(
                16,
                18,
                16,
                20,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 18,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),

              child: Column(
                children: [
                  // ==================================================
                  // CELEBRATION
                  // ==================================================

                  SizedBox(
                    height: 150,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Soft circle
                        Container(
                          width: 105,
                          height: 105,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1E8FF),
                            shape: BoxShape.circle,
                          ),
                        ),

                        // Smaller circle
                        Positioned(
                          left: 92,
                          top: 45,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE8D9FF),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),

                        Positioned(
                          right: 82,
                          top: 38,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              color: Color(0xFFEDE1FF),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),

                        // Trophy
                        Container(
                          width: 76,
                          height: 76,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF1CF),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.12),
                                blurRadius: 15,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.emoji_events_rounded,
                            size: 58,
                            color: Color(0xFFFFB52E),
                          ),
                        ),

                        // Confetti
                        const Positioned(
                          left: 48,
                          top: 18,
                          child: _Confetti(
                            color: Color(0xFFFFC857),
                            angle: -0.6,
                          ),
                        ),

                        const Positioned(
                          left: 76,
                          top: 3,
                          child: _Confetti(
                            color: Color(0xFF8794F0),
                            angle: 0.6,
                          ),
                        ),

                        const Positioned(
                          right: 55,
                          top: 17,
                          child: _Confetti(
                            color: Color(0xFFFF6B75),
                            angle: 0.5,
                          ),
                        ),

                        const Positioned(
                          right: 30,
                          top: 55,
                          child: _Confetti(
                            color: Color(0xFF7C8CE8),
                            angle: -0.7,
                          ),
                        ),

                        const Positioned(
                          left: 32,
                          top: 70,
                          child: _Confetti(
                            color: Color(0xFF7C8CE8),
                            angle: 0.8,
                          ),
                        ),

                        const Positioned(
                          right: 30,
                          top: 88,
                          child: _Confetti(
                            color: Color(0xFFFF6B75),
                            angle: -0.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ==================================================
                  // TITLE
                  // ==================================================

                  Text(
                    allTasksCompleted
                        ? 'Session Complete!'
                        : 'Great Session!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF18245C),
                    ),
                  ),

                  const SizedBox(height: 7),

                  const Text(
                    'You focused for',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF7B819C),
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    '$durationMinutes minutes',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF25316B),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ==================================================
                  // STATS CARD
                  // ==================================================

                  Container(
                    width: double.infinity,
                    height: 67,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCFCFF),
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(
                        color: const Color(0xFFE6E8F2),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Tasks completed
                        Expanded(
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEAF9F5),
                                  borderRadius:
                                  BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.verified_outlined,
                                  color: Color(0xFF39A98A),
                                  size: 21,
                                ),
                              ),

                              const SizedBox(width: 9),

                              Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Tasks Completed',
                                    style: TextStyle(
                                      fontSize: 9.5,
                                      color: Color(0xFF7B819C),
                                    ),
                                  ),

                                  const SizedBox(height: 3),

                                  Text(
                                    '$completedTasks / $totalTasks',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF26336F),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        Container(
                          width: 1,
                          height: 42,
                          color: const Color(0xFFE5E7F0),
                        ),

                        // Streak
                        Expanded(
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF3DC),
                                  borderRadius:
                                  BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: Text(
                                    '🔥',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 9),

                              Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Room Streak',
                                    style: TextStyle(
                                      fontSize: 9.5,
                                      color: Color(0xFF7B819C),
                                    ),
                                  ),

                                  SizedBox(height: 3),

                                  Text(
                                    '2 days',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF26336F),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 17),

                  // ==================================================
                  // VIEW PROGRESS
                  // ==================================================

                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MyTasksView(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(11),
                        ),
                      ),
                      child: const Text(
                        'View Progress',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 11),

                  // ==================================================
                  // BACK TO HOME
                  // ==================================================

                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).popUntil(
                              (route) => route.isFirst,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(
                          color: Color(0xFFD6DAF2),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(11),
                        ),
                      ),
                      child: const Text(
                        'Back to Home',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// CONFETTI
// ============================================================================

class _Confetti extends StatelessWidget {
  final Color color;
  final double angle;

  const _Confetti({
    required this.color,
    required this.angle,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        width: 5,
        height: 9,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}