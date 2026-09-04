import 'package:flutter/material.dart';
import 'package:study_side/theme/app_theme.dart';
import 'package:study_side/model/study_room.dart';
import 'package:study_side/view/room/room_details_view.dart';

class RoomCreatedView extends StatelessWidget {
  final String roomName;
  final String category;
  final String goal;
  final int duration;
  final int maxParticipants;
  final bool isPublic;

  const RoomCreatedView({
    super.key,
    required this.roomName,
    required this.category,
    required this.goal,
    required this.duration,
    required this.maxParticipants,
    required this.isPublic,
  });

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
            size: 19,
            color: AppColors.textDark,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'Room Created',
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
            14,
            15,
            14,
            25,
          ),

          child: Column(
            children: [
              // ==================================================
              // SUCCESS ICON
              // ==================================================

              Container(
                width: 118,
                height: 118,

                decoration: BoxDecoration(
                  color: const Color(0xFFF1F0FF),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.08),
                    width: 1,
                  ),
                ),

                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Text(
                      '🎉',
                      style: TextStyle(
                        fontSize: 62,
                      ),
                    ),

                    Positioned(
                      right: 2,
                      bottom: 5,

                      child: Container(
                        width: 31,
                        height: 31,

                        decoration: const BoxDecoration(
                          color: Color(0xFF20B486),
                          shape: BoxShape.circle,
                        ),

                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 21,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ==================================================
              // TITLE
              // ==================================================

              const Text(
                'Room Created!',
                textAlign: TextAlign.center,

                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'Your study room is ready.',
                textAlign: TextAlign.center,

                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textGrey,
                ),
              ),

              const SizedBox(height: 18),

              // ==================================================
              // ROOM INFO CARD
              // ==================================================

              Container(
                width: double.infinity,

                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: cardShadow,
                ),

                child: Column(
                  children: [
                    // Room Name
                    _buildInfoRow(
                      icon: Icons.school_rounded,
                      value: roomName,
                      isTitle: true,
                    ),

                    const SizedBox(height: 12),

                    // Category
                    _buildCategoryRow(),

                    const SizedBox(height: 11),

                    // Goal
                    _buildInfoRow(
                      icon: Icons.track_changes_rounded,
                      value: 'Goal: $goal',
                    ),

                    const SizedBox(height: 11),

                    // Duration
                    _buildInfoRow(
                      icon: Icons.access_time_rounded,
                      value: 'Duration: $duration minutes',
                    ),

                    const SizedBox(height: 11),

                    // Participants
                    _buildInfoRow(
                      icon: Icons.groups_rounded,
                      value:
                      'Max Participants: $maxParticipants',
                    ),

                    const SizedBox(height: 11),

                    // Visibility
                    _buildInfoRow(
                      icon: isPublic
                          ? Icons.public_rounded
                          : Icons.lock_outline_rounded,
                      value:
                      'Visibility: ${isPublic ? 'Public' : 'Private'}',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ==================================================
              // VIEW ROOM BUTTON
              // ==================================================

              SizedBox(
                width: double.infinity,
                height: 48,

                child: ElevatedButton(
                  onPressed: () {
                    final room = StudyRoom(
                      name: roomName,
                      iconColor: AppColors.primary,
                      studyingCount: 1,
                      maxCapacity: maxParticipants,
                      status: 'Just Created',
                      statusColor: AppColors.success,
                      category: category,
                      description: goal,
                      createdBy: 'You',
                      createdAgo: 'Just now',
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RoomDetailsView(
                          room: room,
                          isCreator: true,
                        ),
                      ),
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),

                  child: const Text(
                    'View Room',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ==================================================
              // SHARE ROOM LINK
              // ==================================================

              TextButton.icon(
                onPressed: () {
                  _showMessage(
                    context,
                    'Room link copied!',
                  );
                },

                icon: const Icon(
                  Icons.link_rounded,
                  size: 17,
                  color: AppColors.primary,
                ),

                label: const Text(
                  'Share Room Link',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
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
  // INFO ROW
  // ==========================================================

  Widget _buildInfoRow({
    required IconData icon,
    required String value,
    bool isTitle = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 25,
          height: 25,

          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(7),
          ),

          child: Icon(
            icon,
            color: AppColors.primary,
            size: 15,
          ),
        ),

        const SizedBox(width: 9),

        Expanded(
          child: Text(
            value,

            maxLines: isTitle ? 1 : 2,
            overflow: TextOverflow.ellipsis,

            style: TextStyle(
              fontSize: isTitle ? 12.5 : 10.5,
              fontWeight:
              isTitle ? FontWeight.w700 : FontWeight.w500,
              color: AppColors.textDark,
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // CATEGORY ROW
  // ==========================================================

  Widget _buildCategoryRow() {
    return Row(
      children: [
        Container(
          width: 25,
          height: 25,

          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(7),
          ),

          child: const Icon(
            Icons.grid_view_rounded,
            color: AppColors.primary,
            size: 15,
          ),
        ),

        const SizedBox(width: 9),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),

          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(6),
          ),

          child: Text(
            category,

            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // MESSAGE
  // ==========================================================

  void _showMessage(
      BuildContext context,
      String message,
      ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}