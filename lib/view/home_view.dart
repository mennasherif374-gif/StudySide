import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_side/model/study_room.dart';
import 'package:study_side/theme/app_theme.dart';
import 'package:study_side/view/room/room_details_view.dart';
import 'package:study_side/view/study_rooms_view.dart';
import 'package:study_side/widgets/app_bottom_nav.dart';
import 'package:study_side/view/room/create_room_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  // Gets the user's first name only from their Firebase display name
  String get _firstName {
    final displayName = FirebaseAuth.instance.currentUser?.displayName;
    if (displayName == null || displayName.trim().isEmpty) {
      return 'there';
    }
    return displayName.trim().split(RegExp(r'\s+')).first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

          // Header
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text('👋', style: TextStyle(fontSize: 20)),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  'Good evening, $_firstName',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Ready to focus?',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(
                          Icons.notifications_none_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.error,
                              shape: BoxShape.circle,
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

          // Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Start studying card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: cardShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.headset_rounded, color: AppColors.primary),
                            SizedBox(width: 10),
                            Text(
                              'Start studying',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Join a room and focus',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textGrey,
                          ),
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const CreateRoomView(),
                                ),
                              );
                            },
                            child: const Text('Start Session'),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Your Progress',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Progress cards
                  const Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          emoji: '🔥',
                          label: 'Current Streak',
                          value: '5 Days',
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.timer_outlined,
                          label: 'Focus Time',
                          value: '3h 40m This Week',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recommended Rooms',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StudyRoomsView(),
                            ),
                          );
                        },
                        child: const Row(
                          children: [
                            Text(
                              'See all',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textGrey,
                              ),
                            ),
                            Icon(Icons.chevron_right, color: AppColors.textGrey, size: 18),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  const _RoomPreviewCard(
                    room: StudyRoom(
                      name: 'Data Structures',
                      iconColor: Colors.redAccent,
                      studyingCount: 6,
                      maxCapacity: 8,
                      status: 'High',
                      statusColor: AppColors.warning,
                      category: 'CS',
                      description: 'Focus on Data Structures and solve problems together.',
                      createdBy: 'Sara',
                      createdAgo: '2 hours ago',
                    ),
                  ),

                  const SizedBox(height: 14),

                  const _RoomPreviewCard(
                    room: StudyRoom(
                      name: 'Flutter',
                      iconColor: Colors.blueAccent,
                      studyingCount: 4,
                      maxCapacity: 8,
                      status: 'Good',
                      statusColor: AppColors.success,
                      category: 'Programming',
                      description: 'Learn Flutter and build apps together.',
                      createdBy: 'Ahmed',
                      createdAgo: '1 hour ago',
                    ),
                  ),

                ],
              ),
            ),
          ),

          const AppBottomNav(currentIndex: 0),

        ],
      ),
    );
  }
}

// One of the two small stat cards under "Your Progress".
class _StatCard extends StatelessWidget {
  final String? emoji;
  final IconData? icon;
  final String label;
  final String value;

  const _StatCard({
    this.emoji,
    this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (emoji != null) Text(emoji!, style: const TextStyle(fontSize: 15)),
              if (icon != null) Icon(icon, color: AppColors.textGrey, size: 16),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 13, color: AppColors.textGrey),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
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

// One room card shown in the "Recommended Rooms" preview on the Home screen.
class _RoomPreviewCard extends StatelessWidget {
  final StudyRoom room;

  const _RoomPreviewCard({
    super.key,
    required this.room,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.layers_rounded, color: room.iconColor),
              const SizedBox(width: 10),
              Text(
                room.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.groups_rounded, color: Color(0xFF8C6DE0), size: 18),
              const SizedBox(width: 6),

              Text('${room.studyingCount} studying',
                style: const TextStyle(fontSize: 13, color: AppColors.textDark),
              ),
              const SizedBox(width: 20),
              room.status == 'High'
                  ? const Text('🔥', style: TextStyle(fontSize: 14))
                  : Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(color: room.statusColor, shape: BoxShape.circle),
                    ),
              const SizedBox(width: 6),
              Text(
                room.status,
                style: TextStyle(
                  fontSize: 13,
                  color: room.status == 'High' ? AppColors.warning : AppColors.textDark,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RoomDetailsView(
                        room: room,
                      ),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                child: const Text('Join'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}