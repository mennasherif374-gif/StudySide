import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:study_side/model/task_store.dart';
import 'package:study_side/theme/app_theme.dart';

class MyTasksView extends StatefulWidget {
  const MyTasksView({super.key});

  @override
  State<MyTasksView> createState() => _MyTasksViewState();
}

class _MyTasksViewState extends State<MyTasksView>
    with SingleTickerProviderStateMixin {
  List<_Task> _todayTasks = [];
  List<_Task> _completedTasks = [];

  bool _showMotivation = false;
  bool _showBottomMotivation = false;

  String _motivationTitle = 'Keep going! 💪';
  String _motivationSubtitle =
      'Small steps every day lead to big results.';
  String _motivationEmoji = '🌱';

  late AnimationController _celebrationController;

  late Animation<double> _celebrationScale;
  late Animation<double> _celebrationRotation;
  late Animation<double> _celebrationOpacity;
  late Animation<Offset> _celebrationSlide;

  @override
  void initState() {
    super.initState();

    _loadTasks();

    // =====================================================
    // CELEBRATION CONTROLLER
    // =====================================================

    _celebrationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    // =====================================================
    // SCALE
    // =====================================================

    _celebrationScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.15,
          end: 1.15,
        ).chain(
          CurveTween(
            curve: Curves.easeOutBack,
          ),
        ),
        weight: 28,
      ),

      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.15,
          end: 0.92,
        ).chain(
          CurveTween(
            curve: Curves.easeInOut,
          ),
        ),
        weight: 17,
      ),

      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.92,
          end: 1.0,
        ).chain(
          CurveTween(
            curve: Curves.elasticOut,
          ),
        ),
        weight: 20,
      ),

      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 0.72,
        ).chain(
          CurveTween(
            curve: Curves.easeInBack,
          ),
        ),
        weight: 35,
      ),
    ]).animate(_celebrationController);

    // =====================================================
    // ROTATION
    // =====================================================

    _celebrationRotation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: -0.25,
          end: 0.25,
        ),
        weight: 20,
      ),

      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.25,
          end: -0.18,
        ),
        weight: 20,
      ),

      TweenSequenceItem(
        tween: Tween<double>(
          begin: -0.18,
          end: 0.12,
        ),
        weight: 20,
      ),

      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.12,
          end: 0.0,
        ),
        weight: 40,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _celebrationController,
        curve: Curves.easeInOut,
      ),
    );

    // =====================================================
    // SLIDE
    // =====================================================

    _celebrationSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _celebrationController,
        curve: Curves.easeOutBack,
      ),
    );


    // =====================================================
    // OPACITY
    // =====================================================

    _celebrationOpacity = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).chain(
          CurveTween(
            curve: Curves.easeOut,
          ),
        ),
        weight: 15,
      ),

      TweenSequenceItem(
        tween: ConstantTween<double>(1.0),
        weight: 65,
      ),

      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).chain(
          CurveTween(
            curve: Curves.easeIn,
          ),
        ),
        weight: 20,
      ),
    ]).animate(_celebrationController);
  }

  @override
  void dispose() {
    _celebrationController.dispose();
    super.dispose();
  }

  // ======================================================
  // LOAD TASKS
  // ======================================================

  void _loadTasks() {
    final tasks = TaskStore.currentRoomTasks;

    _todayTasks = tasks
        .where((task) => !task.completed)
        .map(
          (task) => _Task(
        id: task.id,
        title: task.title,
        completed: false,
      ),
    )
        .toList();

    _completedTasks = tasks
        .where((task) => task.completed)
        .map(
          (task) => _Task(
        id: task.id,
        title: task.title,
        completed: true,
      ),
    )
        .toList();
  }

  // ======================================================
  // PROGRESS
  // ======================================================

  int get _totalTasks => TaskStore.totalTasks;

  int get _completedCount => TaskStore.completedTasks;

  int get _percentage => TaskStore.completedPercentage;

  double get _progress => TaskStore.taskProgress;

  // ======================================================
  // COMPLETE TASK
  // ======================================================

  void _toggleTask(int index) {
    if (index < 0 || index >= _todayTasks.length) {
      return;
    }

    final task = _todayTasks[index];

    TaskStore.completeTask(task.id);

    setState(() {
      _todayTasks.removeAt(index);

      _completedTasks.insert(
        0,
        _Task(
          id: task.id,
          title: task.title,
          completed: true,
        ),
      );
    });

    _showMotivationMessage();
  }

  // ======================================================
  // MOTIVATION
  // ======================================================

  void _showMotivationMessage() {
    final completed = _completedCount;
    final total = _totalTasks;

    // ==========================================
    // DIFFERENT EMOJI FOR EVERY COMPLETED TASK
    // ==========================================

    const emojis = [
      '🎉',
      '🔥',
      '⭐',
      '🚀',
      '💪',
      '🏆',
      '🥳',
      '✨',
      '🌟',
      '💯',
    ];

    _motivationEmoji =
    emojis[(completed - 1) % emojis.length];

    // ==========================================
    // MOTIVATION TEXT
    // ==========================================

    if (completed == 1) {
      _motivationTitle = 'Great job! 🎉';
      _motivationSubtitle =
      'You completed your first task!\nKeep going! 💪';
    } else if (completed == 2) {
      _motivationTitle = 'Nice work! 🔥';
      _motivationSubtitle =
      'Two tasks done!\nYou are building momentum.';
    } else if (completed == 3) {
      _motivationTitle = 'Amazing! ⭐';
      _motivationSubtitle =
      'Three tasks completed!\nYou are doing great.';
    } else if (completed == total && total > 0) {
      _motivationTitle = 'You did it! 🏆';
      _motivationSubtitle =
      'All your tasks are completed!\nAmazing work!';
    } else {
      _motivationTitle = 'Keep going! 🚀';
      _motivationSubtitle =
      'Another task completed!\nYou are getting closer.';
    }

    // ==========================================
    // SHOW CELEBRATION
    // ==========================================

    setState(() {
      _showMotivation = true;
      _showBottomMotivation = false;
    });

    // Start animation
    _celebrationController.forward(from: 0);

    // ==========================================
    // WAIT BEFORE HIDING
    // ==========================================

    Future.delayed(
      const Duration(milliseconds: 3500),
          () {
        if (!mounted) return;

        setState(() {
          _showMotivation = false;
          _showBottomMotivation = true;
        });
      },
    );
  }

  // ======================================================
  // ADD TASK
  // ======================================================

  Future<void> _showAddTaskDialog() async {
    final taskName = await showDialog<String>(
      context: context,
      builder: (_) => const _AddTaskDialog(),
    );

    if (taskName == null || taskName.trim().isEmpty) {
      return;
    }

    final newTask = TaskStore.addTask(taskName);

    if (newTask == null) {
      return;
    }

    setState(() {
      _todayTasks.add(
        _Task(
          id: newTask.id,
          title: newTask.title,
          completed: false,
        ),
      );
    });
  }

  // ======================================================
  // EDIT TASK
  // ======================================================

  Future<void> _editTask(_Task task) async {
    final newName = await showDialog<String>(
      context: context,
      builder: (_) => _EditTaskDialog(
        initialName: task.title,
      ),
    );

    if (newName == null || newName.trim().isEmpty) {
      return;
    }

    final success = TaskStore.editTask(
      task.id,
      newName,
    );

    if (!success) {
      return;
    }

    setState(() {
      task.title = newName.trim();
    });
  }

  // ======================================================
  // DELETE TASK
  // ======================================================

  Future<void> _deleteTask(_Task task) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Delete Task',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          content: const Text(
            'Are you sure you want to delete this task?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: AppColors.error,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    TaskStore.deleteTask(task.id);

    setState(() {
      _todayTasks.removeWhere(
            (item) => item.id == task.id,
      );

      _completedTasks.removeWhere(
            (item) => item.id == task.id,
      );
    });
  }

  // ======================================================
  // UI
  // ======================================================

  // ======================================================
// UI
// ======================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text(
          'My Tasks',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        child: ValueListenableBuilder<int>(
          valueListenable: TaskStore.version,

          builder: (context, _, child) {
            return Stack(
              children: [

                // ==================================================
                // SCROLLABLE CONTENT
                // ==================================================

                SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),

                  padding: const EdgeInsets.fromLTRB(
                    16,
                    10,
                    16,
                    100,
                  ),

                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      // =====================
                      // PROGRESS CARD
                      // =====================

                      _ProgressSummaryCard(
                        percentage: _percentage,
                        progress: _progress,
                        completed: _completedCount,
                        total: _totalTasks,
                      ),

                      const SizedBox(height: 28),

                      // =====================
                      // TODAY HEADER
                      // =====================

                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,

                        children: [
                          const Text(
                            'Today',

                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textDark,
                            ),
                          ),

                          Text(
                            '$_completedCount / $_totalTasks',

                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // =====================
                      // TODAY TASKS
                      // =====================

                      if (_todayTasks.isEmpty)
                        const _EmptyTasksCard()
                      else
                        ...List.generate(
                          _todayTasks.length,
                              (index) {
                            final task = _todayTasks[index];

                            return Padding(
                              padding:
                              const EdgeInsets.only(
                                bottom: 10,
                              ),

                              child: _TaskCard(
                                task: task,

                                onCheck: () {
                                  _toggleTask(index);
                                },

                                onEdit: () {
                                  _editTask(task);
                                },

                                onDelete: () {
                                  _deleteTask(task);
                                },
                              ),
                            );
                          },
                        ),

                      const SizedBox(height: 6),

                      // =====================
                      // ADD TASK
                      // =====================

                      SizedBox(
                        width: double.infinity,
                        height: 58,

                        child: OutlinedButton.icon(
                          onPressed: _showAddTaskDialog,

                          icon: const Icon(
                            Icons.add_circle_outline_rounded,
                          ),

                          label: const Text(
                            'Add Task',

                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          style: OutlinedButton.styleFrom(
                            foregroundColor:
                            AppColors.primary,

                            side: BorderSide(
                              color:
                              AppColors.primary
                                  .withOpacity(.45),
                              width: 1.4,
                            ),

                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(18),
                            ),
                          ),
                        ),
                      ),

                      // =====================
                      // COMPLETED
                      // =====================

                      if (_completedTasks.isNotEmpty) ...[
                        const SizedBox(height: 20),

                        Container(
                          width: double.infinity,

                          decoration: BoxDecoration(
                            color: Colors.white,

                            borderRadius:
                            BorderRadius.circular(20),

                            boxShadow: cardShadow,
                          ),

                          child: Theme(
                            data:
                            Theme.of(context).copyWith(
                              dividerColor:
                              Colors.transparent,
                            ),

                            child: ExpansionTile(
                              initiallyExpanded: true,

                              tilePadding:
                              const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 5,
                              ),

                              childrenPadding:
                              const EdgeInsets.fromLTRB(
                                12,
                                0,
                                12,
                                12,
                              ),

                              leading: Container(
                                width: 44,
                                height: 44,

                                decoration:
                                BoxDecoration(
                                  color: AppColors
                                      .success
                                      .withOpacity(.12),

                                  shape: BoxShape.circle,
                                ),

                                child: const Icon(
                                  Icons
                                      .check_circle_rounded,

                                  color:
                                  AppColors.success,
                                ),
                              ),

                              title: const Text(
                                'Completed',

                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight:
                                  FontWeight.w800,
                                  color:
                                  AppColors.textDark,
                                ),
                              ),

                              subtitle: Text(
                                '${_completedTasks.length} completed task${_completedTasks.length == 1 ? '' : 's'}',

                                style: const TextStyle(
                                  fontSize: 12,
                                  color:
                                  AppColors.textGrey,
                                ),
                              ),

                              // =================================
                              // COMPLETED TASKS
                              // =================================

                              children: [
                                ...List.generate(
                                  _completedTasks.length,
                                      (index) {
                                    final task =
                                    _completedTasks[index];

                                    return Padding(
                                      padding:
                                      const EdgeInsets
                                          .only(
                                        bottom: 8,
                                      ),

                                      child:
                                      _CompletedTaskCard(
                                        task: task,

                                        onDelete: () {
                                          _deleteTask(task);
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 20),

                      // =====================
                      // MOTIVATIONAL CARD
                      // =====================

                      _GreatJobCard(
                        title: _motivationTitle,
                        subtitle: _motivationSubtitle,
                        emoji: _motivationEmoji,
                      ),

                      // مساحة إضافية عشان آخر عنصر
                      // يفضل ظاهر بالكامل عند الـscroll

                      const SizedBox(height: 40),
                    ],
                  ),
                ),

                // ==================================================
                // CELEBRATION OVERLAY
                // ==================================================

                if (_showMotivation)
                  Positioned.fill(
                    child: _CelebrationOverlay(
                      controller: _celebrationController,
                      scaleAnimation: _celebrationScale,
                      rotationAnimation: _celebrationRotation,
                      slideAnimation: _celebrationSlide,
                      opacityAnimation: _celebrationOpacity,
                      title: _motivationTitle,
                      subtitle: _motivationSubtitle,
                      emoji: _motivationEmoji,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ======================================================
// TASK MODEL
// ======================================================

class _Task {
  final String id;
  String title;
  bool completed;

  _Task({
    required this.id,
    required this.title,
    this.completed = false,
  });
}

// ======================================================
// PROGRESS CARD
// ======================================================

class _ProgressSummaryCard
    extends StatelessWidget {
  final int percentage;
  final double progress;
  final int completed;
  final int total;

  const _ProgressSummaryCard({
    required this.percentage,
    required this.progress,
    required this.completed,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primaryLight,
          ],

          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        borderRadius:
        BorderRadius.circular(22),

        boxShadow: [
          BoxShadow(
            color:
            AppColors.primary.withOpacity(.22),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,

                decoration: BoxDecoration(
                  color:
                  Colors.white.withOpacity(.18),
                  borderRadius:
                  BorderRadius.circular(14),
                ),

                child: const Icon(
                  Icons
                      .insert_chart_outlined_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),

              const SizedBox(width: 14),

              const Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [
                    Text(
                      'Your Progress',

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight:
                        FontWeight.w800,
                      ),
                    ),

                    SizedBox(height: 4),

                    Text(
                      'Keep moving forward!',

                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                '$percentage%',

                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          ClipRRect(
            borderRadius:
            BorderRadius.circular(20),

            child:
            LinearProgressIndicator(
              value: progress,
              minHeight: 9,

              backgroundColor:
              Colors.white.withOpacity(.25),

              valueColor:
              const AlwaysStoppedAnimation(
                Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            '$completed of $total tasks completed',

            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================
// TASK CARD
// ======================================================

class _TaskCard extends StatelessWidget {
  final _Task task;
  final VoidCallback onCheck;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _TaskCard({
    required this.task,
    required this.onCheck,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(17),
        boxShadow: cardShadow,
      ),

      child: Row(
        children: [
          GestureDetector(
            onTap: onCheck,

            child: Container(
              width: 34,
              height: 34,

              decoration: BoxDecoration(
                shape: BoxShape.circle,

                border: Border.all(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),

              child: const Icon(
                Icons.check_rounded,
                color: AppColors.primary,
                size: 20,
              ),
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Text(
              task.title,

              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ),

          IconButton(
            onPressed: onEdit,

            icon: const Icon(
              Icons.edit_outlined,
              color: AppColors.textGrey,
              size: 21,
            ),
          ),

          IconButton(
            onPressed: onDelete,

            icon: const Icon(
              Icons.delete_outline_rounded,
              color: AppColors.error,
              size: 21,
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================
// COMPLETED TASK CARD
// ======================================================

class _CompletedTaskCard
    extends StatelessWidget {
  final _Task task;
  final VoidCallback onDelete;

  const _CompletedTaskCard({
    required this.task,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),

      decoration: BoxDecoration(
        color:
        AppColors.success.withOpacity(.055),
        borderRadius:
        BorderRadius.circular(14),
      ),

      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              border: Border.all(
                color: AppColors.success,
                width: 1.7,
              ),
            ),

            child: const Icon(
              Icons.check_rounded,
              color: AppColors.success,
              size: 18,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              task.title,

              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textGrey,
                decoration:
                TextDecoration.lineThrough,
              ),
            ),
          ),

          const Text(
            'Done',

            style: TextStyle(
              color: AppColors.success,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),

          IconButton(
            onPressed: onDelete,

            icon: const Icon(
              Icons.delete_outline_rounded,
              color: AppColors.error,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================
// EMPTY TASKS
// ======================================================

class _EmptyTasksCard
    extends StatelessWidget {
  const _EmptyTasksCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.symmetric(
        vertical: 35,
        horizontal: 20,
      ),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(18),
        boxShadow: cardShadow,
      ),

      child: const Column(
        children: [
          Icon(
            Icons.task_alt_rounded,
            color: AppColors.primary,
            size: 48,
          ),

          SizedBox(height: 12),

          Text(
            'No tasks for today',

            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),

          SizedBox(height: 5),

          Text(
            'Add a task and start making progress.',

            textAlign: TextAlign.center,

            style: TextStyle(
              fontSize: 12,
              color: AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================
// NORMAL MOTIVATION CARD
// ======================================================

class _NormalMotivationCard
    extends StatelessWidget {
  const _NormalMotivationCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color:
        AppColors.primary.withOpacity(.06),
        borderRadius:
        BorderRadius.circular(20),
      ),

      child: const Row(
        children: [
          Text(
            '🌱',

            style: TextStyle(
              fontSize: 40,
            ),
          ),

          SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                Text(
                  'Keep going! 💪',

                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                    FontWeight.w800,
                    color:
                    AppColors.textDark,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  'Small steps every day lead to big results.',

                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color:
                    AppColors.textGrey,
                  ),
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
// BOTTOM MOTIVATION CARD
// ======================================================

class _GreatJobCard
    extends StatelessWidget {
  final String title;
  final String subtitle;
  final String emoji;

  const _GreatJobCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 17,
      ),

      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary
                .withOpacity(.10),
            AppColors.primaryLight
                .withOpacity(.16),
          ],

          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        borderRadius:
        BorderRadius.circular(20),

        border: Border.all(
          color:
          AppColors.primary.withOpacity(.18),
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 68,
            height: 68,

            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,

              boxShadow: [
                BoxShadow(
                  color: AppColors.primary
                      .withOpacity(.18),
                  blurRadius: 15,
                  spreadRadius: 1,
                  offset:
                  const Offset(0, 5),
                ),
              ],
            ),

            child: Center(
              child: Text(
                emoji,

                style: const TextStyle(
                  fontSize: 36,
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
                  title,

                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight:
                    FontWeight.w900,
                    color:
                    AppColors.textDark,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  subtitle,

                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.5,
                    color:
                    AppColors.textGrey,
                  ),
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
// CELEBRATION OVERLAY
// ======================================================

class _CelebrationOverlay
    extends StatelessWidget {
  final AnimationController controller;

  final Animation<double> scaleAnimation;
  final Animation<double> rotationAnimation;
  final Animation<double> opacityAnimation;
  final Animation<Offset> slideAnimation;

  final String title;
  final String subtitle;
  final String emoji;

  const _CelebrationOverlay({
    required this.controller,
    required this.scaleAnimation,
    required this.rotationAnimation,
    required this.opacityAnimation,
    required this.slideAnimation,
    required this.title,
    required this.subtitle,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,

      builder: (context, child) {
        return Stack(
          children: [
            // =================================================
            // BLUR BACKGROUND
            // =================================================

            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 5,
                  sigmaY: 5,
                ),

                child: Container(
                  color:
                  Colors.black.withOpacity(.12),
                ),
              ),
            ),

            // =================================================
            // CELEBRATION
            // =================================================

            Center(
              child: FractionalTranslation(
                translation:
                slideAnimation.value,

                child: Opacity(
                  opacity:
                  opacityAnimation.value,

                  child: Transform.rotate(
                    angle:
                    rotationAnimation.value,

                    child: Transform.scale(
                      scale:
                      scaleAnimation.value,

                      child: Container(
                        width: 285,

                        padding:
                        const EdgeInsets
                            .symmetric(
                          horizontal: 24,
                          vertical: 28,
                        ),

                        decoration:
                        BoxDecoration(
                          color: Colors.white,

                          borderRadius:
                          BorderRadius
                              .circular(28),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(.18),
                              blurRadius: 30,
                              spreadRadius: 5,
                              offset:
                              const Offset(
                                0,
                                12,
                              ),
                            ),
                          ],
                        ),

                        child: Column(
                          mainAxisSize:
                          MainAxisSize.min,

                          children: [
                            // =================================
                            // EMOJI
                            // =================================

                            Container(
                              width: 105,
                              height: 105,

                              decoration:
                              BoxDecoration(
                                color: AppColors
                                    .primary
                                    .withOpacity(
                                    .08),
                                shape:
                                BoxShape.circle,
                              ),

                              child: Center(
                                child: Text(
                                  emoji,

                                  style:
                                  const TextStyle(
                                    fontSize: 62,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 20,
                            ),

                            // =================================
                            // TITLE
                            // =================================

                            Text(
                              title,

                              textAlign:
                              TextAlign.center,

                              style:
                              const TextStyle(
                                fontSize: 24,
                                fontWeight:
                                FontWeight.w900,
                                color:
                                AppColors.textDark,
                              ),
                            ),

                            const SizedBox(
                              height: 9,
                            ),

                            // =================================
                            // SUBTITLE
                            // =================================

                            Text(
                              subtitle,

                              textAlign:
                              TextAlign.center,

                              style:
                              const TextStyle(
                                fontSize: 13,
                                height: 1.5,
                                color:
                                AppColors.textGrey,
                              ),
                            ),

                            const SizedBox(
                              height: 18,
                            ),

                            // =================================
                            // COMPLETED BADGE
                            // =================================

                            Container(
                              padding:
                              const EdgeInsets
                                  .symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),

                              decoration:
                              BoxDecoration(
                                color: AppColors
                                    .success
                                    .withOpacity(
                                    .10),

                                borderRadius:
                                BorderRadius
                                    .circular(
                                  30,
                                ),
                              ),

                              child: const Row(
                                mainAxisSize:
                                MainAxisSize.min,

                                children: [
                                  Icon(
                                    Icons
                                        .check_circle_rounded,
                                    color: AppColors
                                        .success,
                                    size: 19,
                                  ),

                                  SizedBox(
                                    width: 6,
                                  ),

                                  Text(
                                    'Task completed!',

                                    style:
                                    TextStyle(
                                      color: AppColors
                                          .success,
                                      fontSize: 12,
                                      fontWeight:
                                      FontWeight
                                          .w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ======================================================
// ADD TASK DIALOG
// ======================================================

class _AddTaskDialog
    extends StatefulWidget {
  const _AddTaskDialog();

  @override
  State<_AddTaskDialog> createState() =>
      _AddTaskDialogState();
}

class _AddTaskDialogState
    extends State<_AddTaskDialog> {
  final TextEditingController controller =
  TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Add Task',

        style: TextStyle(
          fontWeight: FontWeight.w800,
        ),
      ),

      content: TextField(
        controller: controller,
        autofocus: true,

        textInputAction:
        TextInputAction.done,

        decoration:
        const InputDecoration(
          hintText: 'Enter your task',
        ),

        onSubmitted: (value) {
          if (value.trim().isNotEmpty) {
            Navigator.pop(
              context,
              value.trim(),
            );
          }
        },
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },

          child: const Text('Cancel'),
        ),

        ElevatedButton(
          onPressed: () {
            if (controller.text
                .trim()
                .isEmpty) {
              return;
            }

            Navigator.pop(
              context,
              controller.text.trim(),
            );
          },

          child: const Text('Add'),
        ),
      ],
    );
  }
}

// ======================================================
// EDIT TASK DIALOG
// ======================================================

class _EditTaskDialog
    extends StatefulWidget {
  final String initialName;

  const _EditTaskDialog({
    required this.initialName,
  });

  @override
  State<_EditTaskDialog> createState() =>
      _EditTaskDialogState();
}

class _EditTaskDialogState
    extends State<_EditTaskDialog> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller =
        TextEditingController(
          text: widget.initialName,
        );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Edit Task',

        style: TextStyle(
          fontWeight: FontWeight.w800,
        ),
      ),

      content: TextField(
        controller: controller,
        autofocus: true,

        decoration:
        const InputDecoration(
          hintText: 'Task name',
        ),
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },

          child: const Text('Cancel'),
        ),

        ElevatedButton(
          onPressed: () {
            final value =
            controller.text.trim();

            if (value.isEmpty) {
              return;
            }

            Navigator.pop(
              context,
              value,
            );
          },

          child: const Text('Save'),
        ),
      ],
    );
  }
}