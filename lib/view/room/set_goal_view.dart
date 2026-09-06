import 'package:flutter/material.dart';
import 'package:study_side/theme/app_theme.dart';
import 'package:study_side/view/room/focus_session_view.dart';
import 'package:study_side/model/task_store.dart';

class SetGoalView extends StatefulWidget {
  final String roomName;
  final String category;
  final bool isNewRoom;

  const SetGoalView({
    super.key,
    required this.roomName,
    required this.category,
    this.isNewRoom = false,
  });

  @override
  State<SetGoalView> createState() => _SetGoalViewState();
}

class _SetGoalViewState extends State<SetGoalView> {
  int selectedDuration = 45;
  int? customDuration;

  final TextEditingController goalController =
  TextEditingController();

  @override
  void dispose() {
    goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            22,
            10,
            22,
            18,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // =====================================================
                // TOP HANDLE
                // =====================================================

                Center(
                  child: Container(
                    width: 27,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE1E3F3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // =====================================================
                // CLOSE BUTTON
                // =====================================================

                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.close_rounded,
                      size: 23,
                      color: Color(0xFF252A4A),
                    ),
                  ),
                ),

                const SizedBox(height: 1),

                // =====================================================
                // TITLE
                // =====================================================

                const Text(
                  'Ready to focus? 🎯',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),

                const SizedBox(height: 7),

                // =====================================================
                // DESCRIPTION
                // =====================================================

                const Text(
                  'What do you want to accomplish\n'
                      'in this session?',
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.45,
                    color: Color(0xFF6670A0),
                  ),
                ),

                const SizedBox(height: 14),

                // =====================================================
                // GOAL TEXT FIELD
                // =====================================================

                Container(
                  height: 43,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFE0E3F4),
                    ),
                  ),
                  child: TextField(
                    controller: goalController,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textDark,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'e.g. Finish Chapter 3',
                      hintStyle: TextStyle(
                        fontSize: 11,
                        color: Color(0xFFA0A4B8),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 11,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 23),

                // =====================================================
                // DURATION TITLE
                // =====================================================

                const Text(
                  'Choose your duration',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),

                const SizedBox(height: 13),

                // =====================================================
                // DURATION OPTIONS
                // =====================================================

                Row(
                  children: [
                    Expanded(
                      child: _DurationButton(
                        title: '25 min',
                        value: 25,
                        selected:
                        selectedDuration == 25 &&
                            customDuration == null,
                        onTap: () {
                          setState(() {
                            selectedDuration = 25;
                            customDuration = null;
                          });
                        },
                      ),
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: _DurationButton(
                        title: '45 min',
                        value: 45,
                        selected:
                        selectedDuration == 45 &&
                            customDuration == null,
                        onTap: () {
                          setState(() {
                            selectedDuration = 45;
                            customDuration = null;
                          });
                        },
                      ),
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: _DurationButton(
                        title: '60 min',
                        value: 60,
                        selected:
                        selectedDuration == 60 &&
                            customDuration == null,
                        onTap: () {
                          setState(() {
                            selectedDuration = 60;
                            customDuration = null;
                          });
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // =====================================================
                // CUSTOM DURATION
                // =====================================================

                Container(
                  width: double.infinity,
                  height: 48,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(
                      color: customDuration != null
                          ? AppColors.primary
                          : const Color(0xFFE0E3F4),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.alarm_outlined,
                        size: 20,
                        color: AppColors.primary,
                      ),

                      const SizedBox(width: 11),

                      if (customDuration == null) ...[
                        const Expanded(
                          child: Text(
                            'Custom',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4E567D),
                            ),
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            _showCustomDurationDialog(
                              context,
                            );
                          },
                          child: const Icon(
                            Icons.chevron_right_rounded,
                            size: 21,
                            color: AppColors.primary,
                          ),
                        ),
                      ] else ...[
                        Expanded(
                          child: Text(
                            '${customDuration!} min',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            _showCustomDurationDialog(
                              context,
                              initialValue: customDuration,
                            );
                          },
                          child: const Text(
                            'Edit',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),

                        const SizedBox(width: 14),

                        GestureDetector(
                          onTap: () {
                            setState(() {
                              customDuration = null;
                              selectedDuration = 45;
                            });
                          },
                          child: const Icon(
                            Icons.delete_outline_rounded,
                            size: 19,
                            color: Color(0xFF7A7F98),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // =====================================================
                // START FOCUSING
                // =====================================================

                SizedBox(
                  width: double.infinity,
                  height: 47,
                  child: ElevatedButton(
                    onPressed: () {
                      final String goal =
                      goalController.text.trim();

                      final int duration =
                          customDuration ?? selectedDuration;

                      if (goal.isEmpty) {
                        ScaffoldMessenger.of(context)
                            .hideCurrentSnackBar();

                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Please enter your goal first.',
                            ),
                            behavior:
                            SnackBarBehavior.floating,
                          ),
                        );

                        return;
                      }

                      TaskStore.setTask(goal);

                      Navigator.pop(context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FocusSessionView(
                            roomName: widget.roomName,
                            category: widget.category,
                            goal: goal,
                            durationMinutes: duration,
                            isNewRoom: widget.isNewRoom,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Start Focusing 🚀',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 13),

                // =====================================================
                // CANCEL
                // =====================================================

                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // CUSTOM DURATION DIALOG
  // ==========================================================

  void _showCustomDurationDialog(
      BuildContext context, {
        int? initialValue,
      }) {
    final TextEditingController controller =
    TextEditingController(
      text: initialValue?.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Custom duration',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Enter minutes',
              suffixText: 'min',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () {
                final int? value =
                int.tryParse(controller.text.trim());

                if (value == null || value <= 0) {
                  return;
                }

                setState(() {
                  customDuration = value;
                  selectedDuration = value;
                });

                Navigator.pop(dialogContext);
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    ).then((_) {
      controller.dispose();
    });
  }
}

// ==========================================================
// DURATION BUTTON
// ==========================================================

class _DurationButton extends StatelessWidget {
  final String title;
  final int value;
  final bool selected;
  final VoidCallback onTap;

  const _DurationButton({
    required this.title,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 43,
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : const Color(0xFFE0E3F4),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: selected
                  ? Colors.white
                  : const Color(0xFF303758),
            ),
          ),
        ),
      ),
    );
  }
}