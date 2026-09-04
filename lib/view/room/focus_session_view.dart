import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:study_side/theme/app_theme.dart';
import 'package:study_side/view/room/room_chat_view.dart';
import 'package:study_side/view/room/my_tasks_view.dart';
import 'package:study_side/view/room/session_complete_view.dart';

import '../../model/task_store.dart';

class FocusSessionView extends StatefulWidget {
  final String roomName;
  final String category;
  final String goal;
  final int durationMinutes;
  final bool isNewRoom;

  const FocusSessionView({
    super.key,
    required this.roomName,
    required this.category,
    required this.goal,
    required this.durationMinutes,
    this.isNewRoom = false,
  });

  @override
  State<FocusSessionView> createState() => _FocusSessionViewState();
}

class _FocusSessionViewState extends State<FocusSessionView> {
  late int remainingSeconds;
  late int totalSeconds;

  Timer? timer;
  bool isPaused = false;
  bool _sessionCompleted = false;

  @override
  void initState() {
    super.initState();

    totalSeconds = widget.durationMinutes * 60;
    remainingSeconds = totalSeconds;

    _startTimer();
  }

  // ============================================================
  // SESSION COMPLETE
  // ============================================================

  void _openSessionComplete() {
    if (_sessionCompleted) {
      return;
    }

    _sessionCompleted = true;

    timer?.cancel();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SessionCompleteView(
          completedTasks: TaskStore.completedTasks,
          totalTasks: TaskStore.totalTasks,
          durationMinutes: widget.durationMinutes,
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  // ============================================================
  // TIMER
  // ============================================================

  void _startTimer() {
    timer?.cancel();

    timer = Timer.periodic(
      const Duration(seconds: 1),
          (_) {
        if (!mounted) return;

        if (isPaused) {
          return;
        }

        if (remainingSeconds > 0) {
          setState(() {
            remainingSeconds--;
          });
        } else {
          timer?.cancel();
          _openSessionComplete();
        }
      },
    );
  }

  void _togglePause() {
    setState(() {
      isPaused = !isPaused;
    });
  }

  String get formattedTime {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  double get remainingProgress {
    if (totalSeconds == 0) {
      return 0;
    }

    return remainingSeconds / totalSeconds;
  }

  // ============================================================
  // EXIT
  // ============================================================

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Leave session?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: const Text(
            'Are you sure you want to leave this focus session?',
            style: TextStyle(
              fontSize: 14,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                timer?.cancel();

                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text(
                'Leave',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // OPTIONS
  // ============================================================

  void _showOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              22,
              14,
              22,
              22,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9DBE8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 22),

                const Text(
                  'Session Options',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),

                const SizedBox(height: 15),

                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.pause_circle_outline_rounded,
                    color: AppColors.primary,
                    size: 25,
                  ),
                  title: Text(
                    isPaused
                        ? 'Resume session'
                        : 'Pause session',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _togglePause();
                  },
                ),

                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.exit_to_app_rounded,
                    color: AppColors.error,
                    size: 25,
                  ),
                  title: const Text(
                    'Leave session',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showExitDialog();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // PEOPLE
  // ============================================================

  void _showPeopleBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.72,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 12),

                Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9DBE8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 22),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'People in this room',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.close_rounded,
                          size: 25,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                Expanded(
                  child: widget.isNewRoom
                      ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 35,
                      ),
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: AppColors.primary
                                  .withOpacity(0.08),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.groups_outlined,
                              color: AppColors.primary,
                              size: 34,
                            ),
                          ),

                          const SizedBox(height: 18),

                          const Text(
                            'You are the only one here',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                          ),

                          const SizedBox(height: 7),

                          const Text(
                            'Invite others to join your study room.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.4,
                              color: AppColors.textGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                      : ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    children: const [
                      _PersonRow(
                        name: 'Ahmed',
                        status: 'Focusing',
                        time: '42 min',
                        avatarColor: Color(0xFFB7D1F5),
                        statusColor: Color(0xFF4DB79A),
                        icon: Icons.pause_rounded,
                      ),

                      _PersonRow(
                        name: 'Sara',
                        status: 'On break',
                        time: '12 min',
                        avatarColor: Color(0xFFE8B6A6),
                        statusColor: Color(0xFF6D75B4),
                        icon: Icons.coffee_rounded,
                      ),

                      _PersonRow(
                        name: 'Omar',
                        status: 'Focusing',
                        time: '38 min',
                        avatarColor: Color(0xFFF2D08C),
                        statusColor: Color(0xFF4DB79A),
                        icon: Icons.pause_rounded,
                      ),

                      _PersonRow(
                        name: 'Lina',
                        status: 'Paused',
                        time: '5 min',
                        avatarColor: Color(0xFFB9D8C0),
                        statusColor: Color(0xFF777FB0),
                        icon: Icons.pause_rounded,
                      ),

                      _PersonRow(
                        name: 'You',
                        status: 'Focusing',
                        time: '20 min',
                        avatarColor: Color(0xFFD3B7E9),
                        statusColor: Color(0xFF4DB79A),
                        icon: Icons.pause_rounded,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  const Positioned(
                    left: 18,
                    top: 150,
                    child: _DropDecoration(
                      size: 18,
                    ),
                  ),

                  const Positioned(
                    right: 18,
                    top: 142,
                    child: _DropDecoration(
                      size: 24,
                    ),
                  ),

                  const Positioned(
                    left: 22,
                    top: 300,
                    child: _DiamondDecoration(),
                  ),

                  const Positioned(
                    right: 25,
                    top: 270,
                    child: _LeafDecoration(),
                  ),

                  const Positioned(
                    right: 17,
                    top: 315,
                    child: _LeafDecoration(
                      small: true,
                    ),
                  ),

                  ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                      18,
                      5,
                      18,
                      16,
                    ),
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: _showExitDialog,
                            child: const SizedBox(
                              width: 44,
                              height: 44,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  size: 20,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ),
                          ),

                          Expanded(
                            child: Text(
                              widget.roomName,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark,
                              ),
                            ),
                          ),

                          GestureDetector(
                            onTap: _showOptions,
                            child: const SizedBox(
                              width: 44,
                              height: 44,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  Icons.more_horiz_rounded,
                                  size: 24,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 3),

                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 17,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F2FF),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.timer_outlined,
                                size: 16,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 7),
                              Text(
                                widget.category,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF5360A0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 4),

                      SizedBox(
                        height: 270,
                        child: Center(
                          child: SizedBox(
                            width: 250,
                            height: 250,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CustomPaint(
                                  size: const Size(
                                    250,
                                    250,
                                  ),
                                  painter: _TimerPainter(
                                    progress: remainingProgress,
                                  ),
                                ),

                                Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      formattedTime,
                                      style: const TextStyle(
                                        fontSize: 38,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF17245D),
                                        letterSpacing: -1.2,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    const Text(
                                      'Time remaining',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF7A81A4),
                                      ),
                                    ),

                                    const SizedBox(height: 13),

                                    GestureDetector(
                                      onTap: _togglePause,
                                      child: Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.primary
                                                  .withOpacity(0.25),
                                              blurRadius: 12,
                                              offset:
                                              const Offset(0, 5),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          isPaused
                                              ? Icons.play_arrow_rounded
                                              : Icons.pause_rounded,
                                          color: Colors.white,
                                          size: 22,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const _ProgressSummaryCard(),

                      const SizedBox(height: 16),

                      _PeopleCard(
                        onTap: _showPeopleBottomSheet,
                        isNewRoom: widget.isNewRoom,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ============================================================
            // BOTTOM NAVIGATION
            // ============================================================

            Container(
              height: 70,
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Color(0xFFE5E7F0),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RoomChatView(
                            roomName: widget.roomName,
                            isNewRoom: widget.isNewRoom,
                          ),
                        ),
                      );
                    },
                    child: const _BottomItem(
                      icon: Icons.chat_bubble_outline_rounded,
                      label: 'Chat',
                    ),
                  ),

                  GestureDetector(
                    onTap: _togglePause,
                    child: Container(
                      width: 140,
                      height: 46,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          Icon(
                            isPaused
                                ? Icons.play_arrow_rounded
                                : Icons.pause_rounded,
                            color: Colors.white,
                            size: 19,
                          ),
                          const SizedBox(width: 7),
                          Text(
                            isPaused ? 'Resume' : 'Pause',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MyTasksView(),
                        ),
                      );

                      if (!mounted) return;

                      setState(() {});
                    },
                    child: const _BottomItem(
                      icon: Icons.task_alt_rounded,
                      label: 'Tasks',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// TIMER PAINTER
// ============================================================================

class _TimerPainter extends CustomPainter {
  final double progress;

  const _TimerPainter({
    required this.progress,
  });

  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius =
        math.min(
          size.width,
          size.height,
        ) /
            2 -
            8;

    final backgroundPaint = Paint()
      ..color = const Color(0xFFDCE1FA)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(
      center,
      radius,
      backgroundPaint,
    );

    final progressPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;

    const startAngle = -math.pi / 2;

    final sweepAngle = math.pi * 2 * progress;

    canvas.drawArc(
      Rect.fromCircle(
        center: center,
        radius: radius,
      ),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(
      covariant _TimerPainter oldDelegate,
      ) {
    return oldDelegate.progress != progress;
  }
}

// ============================================================================
// PROGRESS SUMMARY CARD
// ============================================================================

class _ProgressSummaryCard extends StatelessWidget {
  const _ProgressSummaryCard();

  @override
  Widget build(BuildContext context) {
    final int totalTasks = TaskStore.totalTasks;
    final int completedTasks = TaskStore.completedTasks;

    final double progress = totalTasks == 0
        ? 0
        : completedTasks / totalTasks;

    final int percentage = (progress * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primaryLight,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.20),
            blurRadius: 15,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.track_changes_rounded,
                  color: Colors.white,
                  size: 23,
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Progress',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Keep moving forward!',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                '$percentage%',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor:
              Colors.white.withOpacity(0.25),
              valueColor:
              const AlwaysStoppedAnimation<Color>(
                Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 9),

          Text(
            '$completedTasks of $totalTasks tasks completed',
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// PEOPLE CARD
// ============================================================================

class _PeopleCard extends StatelessWidget {
  final VoidCallback onTap;
  final bool isNewRoom;

  const _PeopleCard({
    required this.onTap,
    required this.isNewRoom,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 86,
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 11,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE3E5EF),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  const Text(
                    'People in the room',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF29366F),
                    ),
                  ),

                  const SizedBox(height: 7),

                  if (isNewRoom)
                    Row(
                      children: [
                        Container(
                          width: 29,
                          height: 29,
                          decoration:
                          const BoxDecoration(
                            color: Color(0xFFD3B7E9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),

                        const SizedBox(width: 8),

                        const Text(
                          'You',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF53609A),
                          ),
                        ),
                      ],
                    )
                  else
                    const SizedBox(
                      width: 110,
                      height: 30,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          _SmallAvatar(
                            left: 0,
                            color: Color(0xFFB7D1F5),
                          ),
                          _SmallAvatar(
                            left: 18,
                            color: Color(0xFFE8B6A6),
                          ),
                          _SmallAvatar(
                            left: 36,
                            color: Color(0xFFF2D08C),
                          ),
                          _SmallAvatar(
                            left: 54,
                            color: Color(0xFFB9D8C0),
                          ),
                          _SmallAvatar(
                            left: 72,
                            color: Color(0xFFD3B7E9),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(width: 4),

            Flexible(
              child: Text(
                isNewRoom
                    ? 'You are the only one here'
                    : '6 focusing  •  1 on break',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF7B819C),
                ),
              ),
            ),

            const SizedBox(width: 4),

            const Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// SMALL AVATAR
// ============================================================================

class _SmallAvatar extends StatelessWidget {
  final double left;
  final Color color;

  const _SmallAvatar({
    required this.left,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: 0,
      child: Container(
        width: 29,
        height: 29,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 1.5,
          ),
        ),
        child: const Icon(
          Icons.person,
          color: Colors.white,
          size: 16,
        ),
      ),
    );
  }
}

// ============================================================================
// PERSON ROW
// ============================================================================

class _PersonRow extends StatelessWidget {
  final String name;
  final String status;
  final String time;
  final Color avatarColor;
  final Color statusColor;
  final IconData icon;

  const _PersonRow({
    required this.name,
    required this.status,
    required this.time,
    required this.avatarColor,
    required this.statusColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFECEEF5),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: avatarColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 24,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF29366F),
                  ),
                ),

                const SizedBox(height: 5),

                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),

                    const SizedBox(width: 5),

                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 10.5,
                        color: statusColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Text(
            time,
            style: const TextStyle(
              fontSize: 10.5,
              color: Color(0xFF53609A),
            ),
          ),

          const SizedBox(width: 10),

          Container(
            width: 23,
            height: 23,
            decoration: const BoxDecoration(
              color: Color(0xFFF2F3FA),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 13,
              color: const Color(0xFF7A80A2),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// BOTTOM ITEM
// ============================================================================

class _BottomItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _BottomItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 21,
          color: AppColors.primary,
        ),

        const SizedBox(height: 3),

        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// BACKGROUND DROP
// ============================================================================

class _DropDecoration extends StatelessWidget {
  final double size;

  const _DropDecoration({
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: math.pi / 4,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: const Color(0xFFDCDFFC).withOpacity(0.85),
          borderRadius: BorderRadius.circular(size),
        ),
      ),
    );
  }
}

// ============================================================================
// DIAMOND
// ============================================================================

class _DiamondDecoration extends StatelessWidget {
  const _DiamondDecoration();

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.35,
      child: Container(
        width: 28,
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0xFFE0E3FA).withOpacity(0.85),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}

// ============================================================================
// LEAF
// ============================================================================

class _LeafDecoration extends StatelessWidget {
  final bool small;

  const _LeafDecoration({
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = small ? 30.0 : 44.0;

    return Transform.rotate(
      angle: -0.25,
      child: Icon(
        Icons.eco_outlined,
        size: size,
        color: const Color(0xFF9BC9C4).withOpacity(0.85),
      ),
    );
  }
}