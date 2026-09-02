import 'package:flutter/material.dart';
import 'package:study_side/theme/app_theme.dart';
import 'package:study_side/view/home_view.dart';
import 'package:study_side/view/study_rooms_view.dart';
import 'package:study_side/view/placeholder_view.dart';

// The same bottom navigation bar is used on every main screen.
// Having it here once means every screen looks and behaves the same way.
class AppBottomNav extends StatelessWidget {

  // Which tab is currently active: 0 = Home, 1 = Room, 2 = Progress, 3 = Profile
  final int currentIndex;

  const AppBottomNav({super.key, required this.currentIndex});

  void _onTabTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeView()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const StudyRoomsView()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PlaceholderView(title: 'Progress')),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PlaceholderView(title: 'Profile')),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                isActive: currentIndex == 0,
                onTap: () => _onTabTapped(context, 0),
              ),
              _NavItem(
                icon: Icons.headset_rounded,
                label: 'Room',
                isActive: currentIndex == 1,
                onTap: () => _onTabTapped(context, 1),
              ),
              _NavItem(
                icon: Icons.bar_chart_rounded,
                label: 'Progress',
                isActive: currentIndex == 2,
                onTap: () => _onTabTapped(context, 2),
              ),
              _NavItem(
                icon: Icons.person_rounded,
                label: 'Profile',
                isActive: currentIndex == 3,
                onTap: () => _onTabTapped(context, 3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primary : AppColors.textGrey;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}