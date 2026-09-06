import 'package:flutter/material.dart';
import 'package:study_side/model/study_room.dart';
import 'package:study_side/theme/app_theme.dart';
import 'package:study_side/view/room/set_goal_view.dart';
import 'package:study_side/view/room/people_in_room_view.dart';
import 'package:study_side/model/task_store.dart';

class RoomDetailsView extends StatelessWidget {
  final StudyRoom room;
  final bool isCreator;

  const RoomDetailsView({
    super.key,
    required this.room,
    this.isCreator = false,
  });

  // =====================================================
  // PEOPLE BOTTOM SHEET - CREATOR
  // =====================================================

  void _showPeopleBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.45),
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

                Expanded(
                  child: Center(
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
                              color:
                              AppColors.primary.withOpacity(0.08),
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
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: Stack(
        children: [
          // =====================================================
          // HEADER BACKGROUND
          // =====================================================

          Container(
            height: 310,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF8998F0),
                  Color(0xFF5969C9),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(35),
                bottomRight: Radius.circular(35),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: -30,
                  top: 125,
                  child: _BackgroundCircle(
                    size: 85,
                    opacity: 0.12,
                  ),
                ),

                Positioned(
                  right: -20,
                  top: 100,
                  child: _BackgroundCircle(
                    size: 100,
                    opacity: 0.09,
                  ),
                ),

                Positioned(
                  left: 55,
                  bottom: 20,
                  child: _BackgroundCircle(
                    size: 60,
                    opacity: 0.10,
                  ),
                ),

                Positioned(
                  left: 15,
                  bottom: 12,
                  child: Icon(
                    Icons.spa_outlined,
                    size: 52,
                    color: Colors.white.withOpacity(0.24),
                  ),
                ),

                Positioned(
                  right: 25,
                  bottom: 8,
                  child: Transform.rotate(
                    angle: -0.25,
                    child: Icon(
                      Icons.spa_outlined,
                      size: 60,
                      color: Colors.white.withOpacity(0.28),
                    ),
                  ),
                ),

                Positioned(
                  left: 20,
                  top: 110,
                  child: Icon(
                    Icons.water_drop_outlined,
                    size: 34,
                    color: Colors.white.withOpacity(0.25),
                  ),
                ),

                Positioned(
                  left: 80,
                  bottom: 45,
                  child: Icon(
                    Icons.water_drop_outlined,
                    size: 20,
                    color: Colors.white.withOpacity(0.20),
                  ),
                ),
              ],
            ),
          ),

          // =====================================================
          // CONTENT
          // =====================================================

          SafeArea(
            child: Stack(
              children: [
                // =================================================
                // TOP BAR
                // =================================================

                Positioned(
                  left: 18,
                  right: 18,
                  top: 10,
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 21,
                        ),
                      ),

                      const Icon(
                        Icons.more_vert_rounded,
                        color: Colors.white,
                        size: 25,
                      ),
                    ],
                  ),
                ),

                // =================================================
                // ROOM HEADER
                // =================================================

                Positioned(
                  top: 52,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Container(
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.92),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color:
                              Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.groups_rounded,
                          size: 38,
                          color: room.iconColor,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        isCreator
                            ? 'Your ${room.name}'
                            : '${room.name} Room',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 7),

                      Text(
                        isCreator
                            ? 'Your study room is ready! 🎉'
                            : 'Focus • Support • Grow',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                // =================================================
                // WHITE CARD
                // =================================================

                Positioned(
                  top: 205,
                  left: 5,
                  right: 5,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(
                      17,
                      17,
                      17,
                      22,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: const Color(0xFFE1E3F4),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                          Colors.black.withOpacity(0.08),
                          blurRadius: 18,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        // =================================================
                        // PEOPLE CARD
                        // =================================================

                        if (isCreator)
                          GestureDetector(
                            onTap: () {
                              _showPeopleBottomSheet(context);
                            },
                            child: Container(
                              width: double.infinity,
                              height: 84,
                              padding:
                              const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 11,
                              ),
                              decoration: BoxDecoration(
                                color:
                                const Color(0xFFFAFAFE),
                                borderRadius:
                                BorderRadius.circular(14),
                                border: Border.all(
                                  color:
                                  const Color(0xFFE5E7F2),
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
                                            fontWeight:
                                            FontWeight.w700,
                                            color:
                                            Color(0xFF29366F),
                                          ),
                                        ),

                                        const SizedBox(height: 7),

                                        Row(
                                          children: [
                                            Container(
                                              width: 29,
                                              height: 29,
                                              decoration:
                                              const BoxDecoration(
                                                color:
                                                Color(0xFFD3B7E9),
                                                shape:
                                                BoxShape.circle,
                                              ),
                                              child:
                                              const Icon(
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
                                                fontWeight:
                                                FontWeight.w600,
                                                color:
                                                Color(0xFF53609A),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  const Flexible(
                                    child: Text(
                                      'You are the only one here',
                                      maxLines: 2,
                                      overflow:
                                      TextOverflow.ellipsis,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color:
                                        Color(0xFF7B819C),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 5),

                                  const Icon(
                                    Icons.chevron_right_rounded,
                                    size: 20,
                                    color: AppColors.primary,
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          Container(
                            height: 70,
                            padding:
                            const EdgeInsets.symmetric(
                              horizontal: 14,
                            ),
                            decoration: BoxDecoration(
                              color:
                              const Color(0xFFFAFAFE),
                              borderRadius:
                              BorderRadius.circular(14),
                              border: Border.all(
                                color:
                                const Color(0xFFE5E7F2),
                              ),
                            ),
                            child: Row(
                              children: [
                                Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${room.studyingCount} / ${room.maxCapacity}',
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight:
                                        FontWeight.w700,
                                        color:
                                        AppColors.textDark,
                                      ),
                                    ),

                                    const SizedBox(height: 3),

                                    const Text(
                                      'people in this room',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color:
                                        Color(0xFF777B8A),
                                      ),
                                    ),
                                  ],
                                ),

                                const Spacer(),

                                SizedBox(
                                  width: 115,
                                  height: 40,
                                  child: Stack(
                                    children: [
                                      _Avatar(
                                        left: 0,
                                        color:
                                        const Color(0xFFB7D1F5),
                                      ),

                                      _Avatar(
                                        left: 21,
                                        color:
                                        const Color(0xFFE8B6A6),
                                      ),

                                      _Avatar(
                                        left: 42,
                                        color:
                                        const Color(0xFFF2D08C),
                                      ),

                                      _Avatar(
                                        left: 63,
                                        color:
                                        const Color(0xFFB9D8C0),
                                      ),

                                      _Avatar(
                                        left: 84,
                                        color:
                                        const Color(0xFFD3B7E9),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 2),

                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                        const PeopleInRoomView(),
                                      ),
                                    );
                                  },
                                  child: const Icon(
                                    Icons.chevron_right_rounded,
                                    color:
                                    AppColors.primary,
                                    size: 22,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 17),

                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color(0xFFE4E6EF),
                        ),

                        const SizedBox(height: 19),

                        const Text(
                          'Room Details',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),

                        const SizedBox(height: 18),

                        const _DetailItem(
                          icon: Icons.timer_outlined,
                          title: 'Focus Mode',
                          subtitle:
                          'Keep the chat quiet while focusing',
                        ),

                        const SizedBox(height: 19),

                        const _DetailItem(
                          icon:
                          Icons.videocam_off_outlined,
                          title: 'No Video / Audio',
                          subtitle: 'Text chat only',
                        ),

                        const SizedBox(height: 19),

                        _DetailItem(
                          icon:
                          Icons.person_outline_rounded,
                          title:
                          'Created by ${room.createdBy}',
                          subtitle: room.createdAgo,
                        ),

                        const Spacer(),

                        // =================================================
                        // START / JOIN BUTTON
                        // =================================================

                        SizedBox(
                          width: double.infinity,
                          height: 51,
                          child: ElevatedButton(
                            onPressed: () {
                              // Set current room
                              TaskStore.startNewRoom(
                                room.name,
                              );

                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor:
                                Colors.transparent,
                                barrierColor:
                                Colors.black.withOpacity(
                                  0.45,
                                ),
                                builder:
                                    (bottomSheetContext) {
                                  return SetGoalView(
                                    roomName: room.name,
                                    category: room.category,

                                    // IMPORTANT
                                    // Creator = new room
                                    // Joined room = existing room
                                    isNewRoom: isCreator,
                                  );
                                },
                              );
                            },
                            style:
                            ElevatedButton.styleFrom(
                              backgroundColor:
                              AppColors.primary,
                              foregroundColor:
                              Colors.white,
                              elevation: 0,
                              padding: EdgeInsets.zero,
                              shape:
                              RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(
                                  13,
                                ),
                              ),
                            ),
                            child: Text(
                              isCreator
                                  ? 'Start Studying'
                                  : 'Join Room',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight:
                                FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
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
}

// =====================================================
// BACKGROUND CIRCLE
// =====================================================

class _BackgroundCircle extends StatelessWidget {
  final double size;
  final double opacity;

  const _BackgroundCircle({
    required this.size,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(opacity),
        shape: BoxShape.circle,
      ),
    );
  }
}

// =====================================================
// DETAIL ITEM
// =====================================================

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _DetailItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 43,
          height: 43,
          decoration: const BoxDecoration(
            color: Color(0xFFF0F2FF),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 21,
          ),
        ),

        const SizedBox(width: 13),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF777B8A),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =====================================================
// AVATAR
// =====================================================

class _Avatar extends StatelessWidget {
  final double left;
  final Color color;

  const _Avatar({
    required this.left,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: 1,
      child: Container(
        width: 37,
        height: 37,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
        ),
        child: const Icon(
          Icons.person,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}