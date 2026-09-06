import 'package:flutter/material.dart';
import 'package:study_side/model/notification_model.dart';
import 'package:study_side/theme/app_theme.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  // ==========================================================
  // DUMMY DATA
  // ==========================================================
  // Just UI for now — no Firebase / Firestore connection yet.

  final List<AppNotification> _todayNotifications = [
    AppNotification(
      id: 't1',
      type: NotificationType.study,
      message: "Don't lose your 5-day streak!",
      time: '10m',
      isRead: false,
    ),
    AppNotification(
      id: 't2',
      type: NotificationType.social,
      message: 'Someone joined a room you are hosting.',
      time: '25m',
      isRead: false,
    ),
    AppNotification(
      id: 't3',
      type: NotificationType.achievement,
      message: 'You unlocked a new badge.',
      time: '1h',
      isRead: false,
    ),
    AppNotification(
      id: 't4',
      type: NotificationType.study,
      message: 'A study room you follow just started a session.',
      time: '2h',
      isRead: true,
    ),
    AppNotification(
      id: 't5',
      type: NotificationType.system,
      message: 'Welcome to StudySide!',
      time: '3h',
      isRead: true,
    ),
  ];

  final List<AppNotification> _earlierNotifications = [
    AppNotification(
      id: 'e1',
      type: NotificationType.study,
      message: 'Your study session ends in 5 minutes.',
      time: '1d',
      isRead: true,
    ),
    AppNotification(
      id: 'e2',
      type: NotificationType.social,
      message: 'A friend joined a room you follow.',
      time: '1d',
      isRead: true,
    ),
    AppNotification(
      id: 'e3',
      type: NotificationType.achievement,
      message: 'You reached a new study streak.',
      time: '2d',
      isRead: true,
    ),
    AppNotification(
      id: 'e4',
      type: NotificationType.achievement,
      message: 'You reached a focus-hours milestone.',
      time: '3d',
      isRead: true,
    ),
    AppNotification(
      id: 'e5',
      type: NotificationType.system,
      message: 'Important app updates.',
      time: '4d',
      isRead: true,
    ),
  ];

  // ==========================================================
  // MARK ALL AS READ
  // ==========================================================
  // Simple local UI state only — no backend logic here.

  void _markAllAsRead() {
    setState(() {
      for (final notification in _todayNotifications) {
        notification.isRead = true;
      }
      for (final notification in _earlierNotifications) {
        notification.isRead = true;
      }
    });
  }

  bool get _hasNotifications =>
      _todayNotifications.isNotEmpty || _earlierNotifications.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: _hasNotifications ? _markAllAsRead : null,
            child: const Text('Mark all as read'),
          ),
        ],
      ),
      body: _hasNotifications
          ? SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_todayNotifications.isNotEmpty) ...[
                    const _SectionTitle(title: 'Today'),
                    const SizedBox(height: 12),
                    for (final notification in _todayNotifications) ...[
                      _NotificationCard(notification: notification),
                      const SizedBox(height: 12),
                    ],
                    const SizedBox(height: 10),
                  ],
                  if (_earlierNotifications.isNotEmpty) ...[
                    const _SectionTitle(title: 'Earlier'),
                    const SizedBox(height: 12),
                    for (final notification in _earlierNotifications) ...[
                      _NotificationCard(notification: notification),
                      const SizedBox(height: 12),
                    ],
                  ],
                ],
              ),
            )
          : const _EmptyState(),
    );
  }
}

// ==========================================================
// SECTION TITLE ("Today" / "Earlier")
// ==========================================================

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      ),
    );
  }
}

// ==========================================================
// NOTIFICATION CARD
// ==========================================================

class _NotificationCard extends StatelessWidget {
  final AppNotification notification;

  const _NotificationCard({required this.notification});

  // Icon + colors used per notification type.
  IconData get _icon {
    switch (notification.type) {
      case NotificationType.study:
        return Icons.local_fire_department_rounded;
      case NotificationType.social:
        return Icons.groups_rounded;
      case NotificationType.achievement:
        return Icons.emoji_events_rounded;
      case NotificationType.system:
        return Icons.campaign_rounded;
    }
  }

  Color get _iconColor {
    switch (notification.type) {
      case NotificationType.study:
        return AppColors.warning;
      case NotificationType.social:
        return const Color(0xFF8C6DE0);
      case NotificationType.achievement:
        return const Color(0xFFF5A623);
      case NotificationType.system:
        return AppColors.primary;
    }
  }

  Color get _iconBackground {
    switch (notification.type) {
      case NotificationType.study:
        return const Color(0xFFFFEDE0);
      case NotificationType.social:
        return const Color(0xFFEDEFFB);
      case NotificationType.achievement:
        return const Color(0xFFFFF6DA);
      case NotificationType.system:
        return const Color(0xFFE8ECFB);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.isRead;

    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isUnread
                ? AppColors.primary.withOpacity(0.06)
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isUnread ? null : cardShadow,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _iconBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(_icon, color: _iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.message,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textDark,
                        fontWeight:
                            isUnread ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notification.time,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Small unread dot in the top-right corner of the card.
        if (isUnread)
          Positioned(
            top: 10,
            right: 10,
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
    );
  }
}

// ==========================================================
// EMPTY STATE
// ==========================================================

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 90,
            height: 90,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.primary,
              size: 42,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            "You're all caught up!",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
