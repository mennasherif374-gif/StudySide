// The different kinds of notifications the app can show.
// Each type gets its own icon and color in the Notifications screen.
enum NotificationType {
  study,
  social,
  achievement,
  system,
}

// A single notification shown in the Notifications screen.
// This is just UI dummy data for now — not connected to Firebase.
class AppNotification {
  final String id;
  final NotificationType type;
  final String message;
  final String time; // e.g. "10m", "1h", "1d"
  bool isRead;

  AppNotification({
    required this.id,
    required this.type,
    required this.message,
    required this.time,
    this.isRead = false,
  });
}
