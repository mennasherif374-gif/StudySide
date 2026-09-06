import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:study_side/firebase/auth/firebase_auth_service.dart';
import 'package:study_side/services/firestore_services.dart';
import 'package:study_side/view/profile/premium_view.dart';
import 'package:study_side/view/auth/welcome_view.dart';
import 'package:study_side/widgets/app_bottom_nav.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final FirestoreService _firestoreService = FirestoreService();

  User? get _user => FirebaseAuth.instance.currentUser;

  String _name = 'StudySide User';
  String _email = 'No email';

  bool _notifications = true;
  bool _reminders = true;

  String _theme = 'Light';
  String _language = 'English';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // ============================================================
  // LOAD PROFILE
  // ============================================================

  Future<void> _loadProfile() async {
    final user = _user;

    if (user == null) return;

    final authName = user.displayName?.trim();

    setState(() {
      _name = authName != null && authName.isNotEmpty
          ? authName
          : 'StudySide User';

      _email = user.email ?? 'No email';
    });

    try {
      final data = await _firestoreService.getUser(user.uid);

      if (data == null || !mounted) return;

      setState(() {
        _notifications = data['notifications'] ?? true;
        _reminders = data['reminders'] ?? true;
      });
    } catch (e) {
      debugPrint('Profile load error: $e');
    }
  }

  // ============================================================
  // SAVE PROFILE DATA
  // ============================================================

  Future<void> _saveUserData(
      Map<String, dynamic> data,
      ) async {
    final user = _user;

    if (user == null) return;

    try {
      await _firestoreService.updateUser(
        user.uid,
        data,
      );
    } catch (e) {
      debugPrint('Profile update error: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving data: $e'),
        ),
      );
    }
  }

  // ============================================================
  // EDIT PROFILE
  // ============================================================

  Future<void> _editProfile() async {
    final controller = TextEditingController(
      text: _name,
    );

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
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
              onPressed: () async {
                final newName = controller.text.trim();

                if (newName.isEmpty) return;

                final user = _user;

                if (user == null) return;

                try {
                  await user.updateDisplayName(newName);

                  await _saveUserData({
                    'name': newName,
                  });

                  if (!mounted) return;

                  setState(() {
                    _name = newName;
                  });

                  Navigator.pop(dialogContext);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Profile updated successfully',
                      ),
                    ),
                  );
                } catch (e) {
                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Error updating profile: $e',
                      ),
                    ),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    controller.dispose();
  }

  // ============================================================
  // STUDY GOALS
  // ============================================================

  Future<void> _showStudyGoals() async {
    final controller = TextEditingController();

    final user = _user;

    if (user != null) {
      try {
        final data = await _firestoreService.getUser(user.uid);

        final currentGoal = data?['dailyGoalMinutes'];

        if (currentGoal != null) {
          controller.text = currentGoal.toString();
        }
      } catch (_) {}
    }

    if (!mounted) return;

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Study Goals'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Daily study goal (minutes)',
              border: OutlineInputBorder(),
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
              onPressed: () async {
                final goal =
                int.tryParse(controller.text.trim());

                if (goal == null || goal <= 0) return;

                await _saveUserData({
                  'dailyGoalMinutes': goal,
                });

                if (!mounted) return;

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Study goal saved',
                    ),
                  ),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    controller.dispose();
  }

  // ============================================================
  // NOTIFICATIONS
  // ============================================================

  Future<void> _changeNotifications() async {
    final value = !_notifications;

    setState(() {
      _notifications = value;
    });

    await _saveUserData({
      'notifications': value,
    });
  }

  // ============================================================
  // REMINDERS
  // ============================================================

  Future<void> _changeReminders() async {
    final value = !_reminders;

    setState(() {
      _reminders = value;
    });

    await _saveUserData({
      'reminders': value,
    });
  }

  // ============================================================
  // THEME
  // ============================================================

  Future<void> _chooseTheme() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListTile(
                title: Text(
                  'Choose Theme',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                title: const Text('Light'),
                trailing: _theme == 'Light'
                    ? const Icon(Icons.check)
                    : null,
                onTap: () {
                  Navigator.pop(context, 'Light');
                },
              ),
              ListTile(
                title: const Text('Dark'),
                trailing: _theme == 'Dark'
                    ? const Icon(Icons.check)
                    : null,
                onTap: () {
                  Navigator.pop(context, 'Dark');
                },
              ),
            ],
          ),
        );
      },
    );

    if (selected == null) return;

    setState(() {
      _theme = selected;
    });
  }

  // ============================================================
  // LANGUAGE
  // ============================================================

  Future<void> _chooseLanguage() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListTile(
                title: Text(
                  'Choose Language',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                title: const Text('English'),
                trailing: _language == 'English'
                    ? const Icon(Icons.check)
                    : null,
                onTap: () {
                  Navigator.pop(context, 'English');
                },
              ),
              ListTile(
                title: const Text('Arabic'),
                trailing: _language == 'Arabic'
                    ? const Icon(Icons.check)
                    : null,
                onTap: () {
                  Navigator.pop(context, 'Arabic');
                },
              ),
            ],
          ),
        );
      },
    );

    if (selected == null) return;

    setState(() {
      _language = selected;
    });
  }

  // ============================================================
  // HELP
  // ============================================================

  void _showHelp() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Help & Support'),
          content: const Text(
            'If you need help with StudySide, '
                'please contact the support team.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // ABOUT
  // ============================================================

  void _showAbout() {
    showAboutDialog(
      context: context,
      applicationName: 'StudySide',
      applicationVersion: '1.0.0',
      applicationLegalese: 'StudySide',
      children: const [
        Text(
          'StudySide helps students organize their study '
              'sessions, goals and progress.',
        ),
      ],
    );
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text(
            'Are you sure you want to log out?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      await FirebaseAuthService().signOut();

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const WelcomeView(),
        ),
            (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Logout error: $e',
          ),
        ),
      );
    }
  }

  // ============================================================
  // FORMAT TIME
  // ============================================================

  String _formatTime(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;

    if (hours == 0) {
      return '${mins}m';
    }

    if (mins == 0) {
      return '${hours}h';
    }

    return '${hours}h ${mins}m';
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final user = _user;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('No user logged in'),
        ),
      );
    }

    return StreamBuilder<
        DocumentSnapshot<Map<String, dynamic>>>(
      stream: _firestoreService.progressStream(
        user.uid,
      ),
      builder: (context, snapshot) {
        final data = snapshot.data?.data();

        final totalStudyMinutes =
        (data?['totalStudyMinutes'] ?? 0) as num;

        final currentStreak =
        (data?['currentStreak'] ?? 0) as num;

        final sessions =
        (data?['sessions'] ?? 0) as num;

        final goalsCompleted =
        (data?['goalsCompleted'] ?? 0) as num;

        return Scaffold(
          backgroundColor: const Color(0xffF9F8FE),

          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                18,
                20,
                18,
                30,
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  // ========================================================
                  // HEADER
                  // ========================================================

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Profile',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff17245D),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Manage your account and settings',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff7A81A4),
                            ),
                          ),
                        ],
                      ),

                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.circular(15),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x12000000),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: () {
                            _chooseTheme();
                          },
                          icon: const Icon(
                            Icons.settings_outlined,
                            color: Color(0xff7350D8),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  // ========================================================
                  // PROFILE CARD
                  // ========================================================

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x10000000),
                          blurRadius: 15,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 43,
                          backgroundColor:
                          const Color(0xffEDE7FF),
                          child: const Icon(
                            Icons.person,
                            size: 48,
                            color: Color(0xff7350D8),
                          ),
                        ),

                        const SizedBox(width: 18),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                _name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight:
                                  FontWeight.bold,
                                  color:
                                  Color(0xff17245D),
                                ),
                              ),

                              const SizedBox(height: 7),

                              Text(
                                _email,
                                overflow:
                                TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color:
                                  Color(0xff7A81A4),
                                ),
                              ),

                              const SizedBox(height: 8),

                              Container(
                                padding:
                                const EdgeInsets
                                    .symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                  const Color(0xffEEE9FC),
                                  borderRadius:
                                  BorderRadius.circular(
                                    10,
                                  ),
                                ),
                                child: const Text(
                                  '✦  Student',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight:
                                    FontWeight.w600,
                                    color:
                                    Color(0xff7350D8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        IconButton(
                          onPressed: _editProfile,
                          icon: const Icon(
                            Icons.edit_outlined,
                            color: Color(0xff7350D8),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  // ========================================================
                  // STATISTICS
                  // ========================================================

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x10000000),
                          blurRadius: 15,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        _statItem(
                          icon: Icons.access_time,
                          iconColor:
                          const Color(0xff7350D8),
                          value: _formatTime(
                            totalStudyMinutes.toInt(),
                          ),
                          title: 'Total Study Time',
                        ),

                        _divider(),

                        _statItem(
                          icon: Icons.local_fire_department,
                          iconColor:
                          const Color(0xffF18B55),
                          value:
                          currentStreak.toString(),
                          title: 'Current Streak',
                        ),

                        _divider(),

                        _statItem(
                          icon: Icons.check_circle,
                          iconColor:
                          const Color(0xff35B985),
                          value: sessions.toString(),
                          title: 'Sessions',
                        ),

                        _divider(),

                        _statItem(
                          icon: Icons.emoji_events,
                          iconColor:
                          const Color(0xff7350D8),
                          value:
                          '${goalsCompleted.toInt()}/10',
                          title: 'Goals Completed',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ========================================================
                  // FREE PLAN
                  // ========================================================

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(17),
                    decoration: BoxDecoration(
                      color: const Color(0xffF0EBFF),
                      borderRadius:
                      BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: Color(0xff7350D8),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.workspace_premium,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(width: 12),

                        const Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                "You're on Free Plan",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight:
                                  FontWeight.bold,
                                  color:
                                  Color(0xff17245D),
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Upgrade to Premium for more features '
                                    'and a better experience',
                                style: TextStyle(
                                  fontSize: 11,
                                  color:
                                  Color(0xff7A81A4),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          width: 130,
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const PremiumView(),
                                ),
                              );
                            },
                            child: const Text(
                              'Upgrade Now',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ========================================================
                  // SETTINGS
                  // ========================================================

                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x10000000),
                          blurRadius: 15,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _settingItem(
                          icon: Icons.person_outline,
                          title: 'Edit Profile',
                          onTap: _editProfile,
                        ),

                        _settingItem(
                          icon: Icons.track_changes_outlined,
                          title: 'Study Goals',
                          onTap: _showStudyGoals,
                        ),

                        _settingItem(
                          icon: Icons.notifications_none,
                          title: 'Notifications',
                          trailing:
                          _notifications
                              ? 'On'
                              : 'Off',
                          onTap:
                          _changeNotifications,
                        ),

                        _settingItem(
                          icon: Icons.access_time,
                          title: 'Study Reminders',
                          trailing:
                          _reminders
                              ? 'On'
                              : 'Off',
                          onTap:
                          _changeReminders,
                        ),

                        _settingItem(
                          icon: Icons.palette_outlined,
                          title: 'Theme',
                          trailing: _theme,
                          onTap: _chooseTheme,
                        ),

                        _settingItem(
                          icon: Icons.language,
                          title: 'Language',
                          trailing: _language,
                          onTap: _chooseLanguage,
                        ),

                        _settingItem(
                          icon: Icons.help_outline,
                          title: 'Help & Support',
                          onTap: _showHelp,
                        ),

                        _settingItem(
                          icon: Icons.info_outline,
                          title: 'About StudySide',
                          onTap: _showAbout,
                        ),

                        _settingItem(
                          icon: Icons.logout,
                          title: 'Log Out',
                          isLogout: true,
                          onTap: _logout,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ================================================================
          // BOTTOM NAV
          // ================================================================

          bottomNavigationBar: const AppBottomNav(
            currentIndex: 3,
          ),
        );
      },
    );
  }

  // ============================================================
  // STAT ITEM
  // ============================================================

  Widget _statItem({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String title,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 26,
          ),

          const SizedBox(height: 8),

          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xff17245D),
            ),
          ),

          const SizedBox(height: 4),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 9,
              color: Color(0xff7A81A4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 55,
      color: const Color(0xffEEEEF5),
    );
  }

  // ============================================================
  // SETTING ITEM
  // ============================================================

  Widget _settingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    String? trailing,
    bool isLogout = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isLogout
                    ? const Color(0xffffedf0)
                    : const Color(0xffF3F0FC),
                borderRadius:
                BorderRadius.circular(11),
              ),
              child: Icon(
                icon,
                size: 20,
                color: isLogout
                    ? const Color(0xffD95870)
                    : const Color(0xff7350D8),
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isLogout
                      ? const Color(0xffD95870)
                      : const Color(0xff17245D),
                ),
              ),
            ),

            if (trailing != null)
              Container(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xffF1EEFA),
                  borderRadius:
                  BorderRadius.circular(10),
                ),
                child: Text(
                  trailing,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xff7350D8),
                  ),
                ),
              ),

            const SizedBox(width: 8),

            Icon(
              Icons.chevron_right,
              size: 21,
              color: isLogout
                  ? const Color(0xffD95870)
                  : const Color(0xff8A90AC),
            ),
          ],
        ),
      ),
    );
  }
}