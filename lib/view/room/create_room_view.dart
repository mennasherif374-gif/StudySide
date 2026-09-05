import 'package:flutter/material.dart';
import 'package:study_side/theme/app_theme.dart';
import 'package:study_side/view/room/room_created_view.dart';

class CreateRoomView extends StatefulWidget {
  const CreateRoomView({super.key});

  @override
  State<CreateRoomView> createState() => _CreateRoomViewState();
}

class _CreateRoomViewState extends State<CreateRoomView> {
  // ==========================================================
  // CONTROLLERS
  // ==========================================================

  final TextEditingController roomNameController =
  TextEditingController();

  final TextEditingController goalController =
  TextEditingController();

  // ==========================================================
  // VALUES
  // ==========================================================

  String selectedCategory = 'Programming';

  int selectedDuration = 45;

  int? customDuration;

  int maxParticipants = 5;

  bool roomIsPublic = true;

  // ==========================================================
  // CATEGORIES
  // ==========================================================

  final List<String> categories = [
    'Programming',
    'Computer Science',
    'Mathematics',
    'Physics',
    'Reading',
    'Other',
  ];

  // ==========================================================
  // DISPOSE
  // ==========================================================

  @override
  void dispose() {
    roomNameController.dispose();
    goalController.dispose();
    super.dispose();
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: AppColors.textDark,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Create Session',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            12,
            4,
            12,
            24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBanner(),

              const SizedBox(height: 13),

              _buildInputCard(
                icon: Icons.groups_rounded,
                label: 'Room Name',
                hint: 'e.g. Flutter Study Group',
                controller: roomNameController,
              ),

              const SizedBox(height: 11),

              _buildCategoryCard(),

              const SizedBox(height: 11),

              _buildInputCard(
                icon: Icons.track_changes_rounded,
                label: 'Your Goal',
                hint: 'What do you want to accomplish?',
                controller: goalController,
              ),

              const SizedBox(height: 14),

              _buildSectionLabel('Session Duration'),

              const SizedBox(height: 8),

              _buildDurationSelector(),

              const SizedBox(height: 14),

              _buildSectionLabel('Maximum Participants'),

              const SizedBox(height: 8),

              _buildParticipantsCard(),

              const SizedBox(height: 14),

              _buildVisibilityCard(),

              const SizedBox(height: 18),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _createRoom,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_circle_outline_rounded,
                        size: 21,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Create Room',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // BANNER
  // ==========================================================

  Widget _buildBanner() {
    return Container(
      width: double.infinity,
      height: 82,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primaryLight,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.18),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          const Positioned(
            right: 75,
            top: 8,
            child: Text(
              '✨',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),

          const Positioned(
            right: 48,
            top: 31,
            child: Text(
              '✦',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white70,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              top: 13,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create a Study Room',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  'Study together and\nachieve your goals.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            right: 9,
            bottom: 5,
            child: Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.16),
                borderRadius: BorderRadius.circular(19),
              ),
              child: const Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.laptop_mac_rounded,
                    color: Colors.white,
                    size: 30,
                  ),

                  Positioned(
                    top: 5,
                    right: 10,
                    child: Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 21,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // INPUT CARD
  // ==========================================================

  Widget _buildInputCard({
    required IconData icon,
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return Container(
      width: double.infinity,
      height: 70,
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: cardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 19,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),

                const SizedBox(height: 2),

                Expanded(
                  child: TextField(
                    controller: controller,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textDark,
                    ),
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textGrey,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // CATEGORY CARD
  // ==========================================================

  Widget _buildCategoryCard() {
    return Container(
      width: double.infinity,
      height: 70,
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: cardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.grid_view_rounded,
              color: AppColors.primary,
              size: 19,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Category',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  selectedCategory,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),

          PopupMenuButton<String>(
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 23,
              color: AppColors.textDark,
            ),
            onSelected: (value) {
              setState(() {
                selectedCategory = value;
              });
            },
            itemBuilder: (context) {
              return categories.map(
                    (category) {
                  return PopupMenuItem<String>(
                    value: category,
                    child: Text(
                      category,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  );
                },
              ).toList();
            },
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // SECTION LABEL
  // ==========================================================

  Widget _buildSectionLabel(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
      ),
    );
  }

  // ==========================================================
  // DURATION SELECTOR
  // ==========================================================

  Widget _buildDurationSelector() {
    return Row(
      children: [
        Expanded(
          child: _DurationButton(
            title: '25',
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

        const SizedBox(width: 7),

        Expanded(
          child: _DurationButton(
            title: '45',
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

        const SizedBox(width: 7),

        Expanded(
          child: _DurationButton(
            title: '60',
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

        const SizedBox(width: 7),

        Expanded(
          child: _DurationButton(
            title: '90',
            selected:
            selectedDuration == 90 &&
                customDuration == null,
            onTap: () {
              setState(() {
                selectedDuration = 90;
                customDuration = null;
              });
            },
          ),
        ),

        const SizedBox(width: 7),

        Expanded(
          child: GestureDetector(
            onTap: _showCustomDurationDialog,
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: customDuration != null
                    ? AppColors.primary
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: customDuration != null
                      ? AppColors.primary
                      : AppColors.border,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    customDuration != null
                        ? '$customDuration'
                        : 'Custom',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: customDuration != null
                          ? Colors.white
                          : AppColors.textDark,
                    ),
                  ),

                  const SizedBox(height: 1),

                  Text(
                    'min',
                    style: TextStyle(
                      fontSize: 11,
                      color: customDuration != null
                          ? Colors.white70
                          : AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // CUSTOM DURATION DIALOG
  // ==========================================================

  void _showCustomDurationDialog() {
    final TextEditingController controller =
    TextEditingController(
      text: customDuration?.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Custom Duration',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Enter minutes',
              suffixText: 'min',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please enter a valid duration.',
                      ),
                    ),
                  );
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

  // ==========================================================
  // PARTICIPANTS
  // ==========================================================

  Widget _buildParticipantsCard() {
    return Container(
      width: double.infinity,
      height: 62,
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: cardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.groups_rounded,
              color: AppColors.primary,
              size: 19,
            ),
          ),

          const Spacer(),

          GestureDetector(
            onTap: () {
              if (maxParticipants > 2) {
                setState(() {
                  maxParticipants--;
                });
              }
            },
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Color(0xFFF0F1FA),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.remove_rounded,
                size: 16,
                color: AppColors.primary,
              ),
            ),
          ),

          const SizedBox(width: 18),

          Text(
            '$maxParticipants',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),

          const SizedBox(width: 18),

          GestureDetector(
            onTap: () {
              if (maxParticipants < 20) {
                setState(() {
                  maxParticipants++;
                });
              }
            },
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_rounded,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // VISIBILITY
  // ==========================================================

  Widget _buildVisibilityCard() {
    return Container(
      width: double.infinity,
      height: 68,
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: cardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.public_rounded,
              color: AppColors.primary,
              size: 19,
            ),
          ),

          const SizedBox(width: 10),

          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Room Visibility',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),

                SizedBox(height: 4),

                Text(
                  'Anyone can join this room',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),

          Switch(
            value: roomIsPublic,
            activeColor: Colors.white,
            activeTrackColor: AppColors.primary,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Color(0xFFD5D7E3),
            onChanged: (value) {
              setState(() {
                roomIsPublic = value;
              });
            },
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // CREATE ROOM
  // ==========================================================

  void _createRoom() {
    final String roomName =
    roomNameController.text.trim();

    final String goal =
    goalController.text.trim();

    if (roomName.isEmpty) {
      _showMessage(
        'Please enter a room name.',
      );
      return;
    }

    if (goal.isEmpty) {
      _showMessage(
        'Please enter your goal.',
      );
      return;
    }

    final int duration = selectedDuration;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => RoomCreatedView(
          roomName: roomName,
          category: selectedCategory,
          goal: goal,
          duration: duration,
          maxParticipants: maxParticipants,
          isPublic: roomIsPublic,
        ),
      ),
    );
  }

  // ==========================================================
  // MESSAGE
  // ==========================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(
              fontSize: 13,
            ),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}

// ============================================================
// DURATION BUTTON
// ============================================================

class _DurationButton extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _DurationButton({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : AppColors.border,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: selected
                    ? Colors.white
                    : AppColors.textDark,
              ),
            ),

            const SizedBox(height: 1),

            Text(
              'min',
              style: TextStyle(
                fontSize: 11,
                color: selected
                    ? Colors.white70
                    : AppColors.textGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}