import 'package:flutter/material.dart';
import 'package:study_side/theme/app_theme.dart';

class PeopleInRoomView extends StatelessWidget {
  const PeopleInRoomView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            10,
            16,
            10,
            20,
          ),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: const Color(0xFFE0E3F5),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // ==========================================
                // HEADER
                // ==========================================
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    18,
                    24,
                    18,
                    18,
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'People in this room',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),

                      const Spacer(),

                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.close_rounded,
                          size: 23,
                          color: Color(0xFF252A4A),
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(
                  height: 1,
                  color: Color(0xFFE8EAF2),
                ),

                // ==========================================
                // PEOPLE LIST
                // ==========================================
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                    ),
                    children: const [
                      _PersonItem(
                        name: 'Ahmed',
                        status: 'Focusing',
                        statusColor: Color(0xFF4CB89A),
                        time: '42 min',
                        icon: Icons.info_outline_rounded,
                        avatarColor: Color(0xFFD8B19B),
                      ),

                      _PersonItem(
                        name: 'Sara',
                        status: 'On break',
                        statusColor: Color(0xFF6976B9),
                        time: '12 min',
                        icon: Icons.coffee_rounded,
                        avatarColor: Color(0xFFE7B7AA),
                      ),

                      _PersonItem(
                        name: 'Omar',
                        status: 'Focusing',
                        statusColor: Color(0xFF4CB89A),
                        time: '38 min',
                        icon: Icons.info_outline_rounded,
                        avatarColor: Color(0xFFB98D72),
                      ),

                      _PersonItem(
                        name: 'Lina',
                        status: 'Paused',
                        statusColor: Color(0xFF727CB9),
                        time: '5 min',
                        icon: Icons.pause,
                        avatarColor: Color(0xFFD9958D),
                      ),

                      _PersonItem(
                        name: 'You',
                        status: 'Focusing',
                        statusColor: Color(0xFF4CB89A),
                        time: '20 min',
                        icon: Icons.info_outline_rounded,
                        avatarColor: Color(0xFFB5C8E8),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================================
// PERSON ITEM
// ==========================================================

class _PersonItem extends StatelessWidget {
  final String name;
  final String status;
  final Color statusColor;
  final String time;
  final IconData icon;
  final Color avatarColor;

  const _PersonItem({
    required this.name,
    required this.status,
    required this.statusColor,
    required this.time,
    required this.icon,
    required this.avatarColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE9EAF1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // ================================================
          // AVATAR
          // ================================================
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: avatarColor,
            ),
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 25,
            ),
          ),

          const SizedBox(width: 13),

          // ================================================
          // NAME + STATUS
          // ================================================
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),

                const SizedBox(height: 5),

                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: statusColor,
                      ),
                    ),

                    const SizedBox(width: 5),

                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w400,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ================================================
          // TIME
          // ================================================
          Text(
            time,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              color: Color(0xFF5D6382),
            ),
          ),

          const SizedBox(width: 10),

          // ================================================
          // STATUS ICON
          // ================================================
          Container(
            width: 23,
            height: 23,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F3FF),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Icon(
              icon,
              size: 13,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }
}