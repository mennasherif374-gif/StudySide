import 'package:flutter/material.dart';
import 'package:study_side/theme/app_theme.dart';
import 'package:study_side/widgets/app_bottom_nav.dart';
import 'package:study_side/model/study_room.dart';
import 'package:study_side/view/room/room_details_view.dart';

class StudyRoomsView extends StatefulWidget {
  const StudyRoomsView({super.key});

  @override
  State<StudyRoomsView> createState() =>
      _StudyRoomsViewState();
}

class _StudyRoomsViewState extends State<StudyRoomsView> {

  // ==========================================================
  // ROOMS
  // ==========================================================

  final List<StudyRoom> allRooms = const [
    StudyRoom(
      name: 'Data Structures',
      iconColor: Colors.redAccent,
      studyingCount: 6,
      maxCapacity: 8,
      status: 'High',
      statusColor: AppColors.warning,
      category: 'CS',
      description:
      'Focus together on Data Structures and problem solving.',
      createdBy: 'Sara',
      createdAgo: '2 hours ago',
    ),

    StudyRoom(
      name: 'Flutter',
      iconColor: Colors.blueAccent,
      studyingCount: 4,
      maxCapacity: 8,
      status: 'Good',
      statusColor: AppColors.success,
      category: 'Programming',
      description:
      'Learn and practice Flutter development together.',
      createdBy: 'Ahmed',
      createdAgo: '1 hour ago',
    ),

    StudyRoom(
      name: 'Math3',
      iconColor: Colors.redAccent,
      studyingCount: 3,
      maxCapacity: 8,
      status: 'Low',
      statusColor: AppColors.warning,
      category: 'CS',
      description:
      'A quiet room for studying Math 3.',
      createdBy: 'Omar',
      createdAgo: '3 hours ago',
    ),

    StudyRoom(
      name: 'Programming',
      iconColor: Colors.blueAccent,
      studyingCount: 8,
      maxCapacity: 8,
      status: 'Good',
      statusColor: AppColors.success,
      category: 'Programming',
      description:
      'Practice programming and solve problems together.',
      createdBy: 'Lina',
      createdAgo: '30 minutes ago',
    ),
  ];

  // ==========================================================
  // FILTERS
  // ==========================================================

  final List<String> filters = const [
    'All',
    'Programming',
    'CS',
    'Design',
  ];

  String selectedFilter = 'All';
  String searchText = '';

  @override
  Widget build(BuildContext context) {

    // ==========================================================
    // FILTER ROOMS
    // ==========================================================

    final filteredRooms = allRooms.where((room) {
      final matchesFilter =
          selectedFilter == 'All' ||
              room.category == selectedFilter;

      final matchesSearch =
      room.name
          .toLowerCase()
          .contains(searchText.toLowerCase());

      return matchesFilter && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Rooms'),
      ),

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                20,
                4,
                20,
                12,
              ),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [
                  // ==================================================
                  // SEARCH
                  // ==================================================

                  TextField(
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    },

                    decoration: const InputDecoration(
                      prefixIcon:
                      Icon(Icons.search),
                      hintText:
                      'Search Rooms',
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ==================================================
                  // FILTER CHIPS
                  // ==================================================

                  SizedBox(
                    height: 40,

                    child: ListView.separated(
                      scrollDirection:
                      Axis.horizontal,

                      itemCount:
                      filters.length,

                      separatorBuilder:
                          (context, index) =>
                      const SizedBox(
                        width: 10,
                      ),

                      itemBuilder:
                          (context, index) {
                        final filter =
                        filters[index];

                        final isSelected =
                            filter ==
                                selectedFilter;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedFilter =
                                  filter;
                            });
                          },

                          child: Container(
                            padding:
                            const EdgeInsets
                                .symmetric(
                              horizontal: 18,
                            ),

                            alignment:
                            Alignment.center,

                            decoration:
                            BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.white,

                              borderRadius:
                              BorderRadius
                                  .circular(30),

                              border:
                              Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.border,
                              ),
                            ),

                            child: Text(
                              filter,

                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textDark,

                                fontWeight:
                                FontWeight.w500,

                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ==================================================
                  // TITLE
                  // ==================================================

                  const Text(
                    'Recommended Rooms',

                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                      FontWeight.bold,
                      color:
                      AppColors.textDark,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ==================================================
                  // ROOM CARDS
                  // ==================================================

                  for (final room
                  in filteredRooms) ...[
                    _RoomCard(
                      room: room,
                    ),

                    const SizedBox(
                      height: 14,
                    ),
                  ],

                  // ==================================================
                  // EMPTY
                  // ==================================================

                  if (filteredRooms.isEmpty)
                    Padding(
                      padding:
                      const EdgeInsets.only(
                        top: 40,
                      ),

                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons
                                  .search_off_rounded,

                              color: AppColors
                                  .textGrey
                                  .withOpacity(
                                0.6,
                              ),

                              size: 40,
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            const Text(
                              'No rooms found',

                              style: TextStyle(
                                color:
                                AppColors
                                    .textGrey,
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

          const AppBottomNav(
            currentIndex: 1,
          ),
        ],
      ),
    );
  }
}

// =====================================================
// ROOM CARD
// =====================================================

class _RoomCard extends StatelessWidget {
  final StudyRoom room;

  const _RoomCard({
    required this.room,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(16),
        boxShadow: cardShadow,
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          // ==================================================
          // ROOM NAME
          // ==================================================

          Row(
            children: [
              Icon(
                Icons.layers_rounded,
                color: room.iconColor,
              ),

              const SizedBox(width: 10),

              Text(
                room.name,

                style: const TextStyle(
                  fontSize: 16,
                  fontWeight:
                  FontWeight.bold,
                  color:
                  AppColors.textDark,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ==================================================
          // ROOM INFO
          // ==================================================

          Row(
            children: [
              const Icon(
                Icons.groups_rounded,
                color:
                Color(0xFF8C6DE0),
                size: 18,
              ),

              const SizedBox(width: 6),

              Text(
                '${room.studyingCount}  Studying',

                style: const TextStyle(
                  fontSize: 13,
                  color:
                  AppColors.textDark,
                ),
              ),

              const SizedBox(width: 20),

              room.status == 'High'
                  ? const Text(
                '🔥',
                style: TextStyle(
                  fontSize: 14,
                ),
              )
                  : Container(
                width: 10,
                height: 10,

                decoration:
                BoxDecoration(
                  color:
                  room.statusColor,
                  shape:
                  BoxShape.circle,
                ),
              ),

              const SizedBox(width: 6),

              Text(
                room.status,

                style: TextStyle(
                  fontSize: 13,

                  color:
                  room.status == 'High'
                      ? AppColors.warning
                      : AppColors.textDark,
                ),
              ),

              const Spacer(),

              // ==================================================
              // JOIN
              // ==================================================

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder: (_) =>
                          RoomDetailsView(
                            room: room,
                          ),
                    ),
                  );
                },

                style:
                TextButton.styleFrom(
                  padding:
                  EdgeInsets.zero,
                ),

                child:
                const Text('Join'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}