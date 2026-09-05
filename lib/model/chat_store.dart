class ChatMessage {
  final String text;
  final bool isMe;

  ChatMessage({
    required this.text,
    required this.isMe,
  });
}

class ChatStore {
  static final Map<String, List<ChatMessage>> _roomMessages = {};

  static List<ChatMessage> messagesFor(String roomName) {
    return _roomMessages.putIfAbsent(roomName, () => []);
  }

  static void addMessage(
      String roomName,
      String text,
      ) {
    final cleanText = text.trim();

    if (cleanText.isEmpty) return;

    messagesFor(roomName).add(
      ChatMessage(
        text: cleanText,
        isMe: true,
      ),
    );
  }

  static void clearMessages(String roomName) {
    _roomMessages.remove(roomName);
  }

  static void initializeRoomChat(
      String roomName, {
        required bool isNewRoom,
      }) {
    // لو الروم جديدة، خلي الشات فاضي
    if (isNewRoom) {
      _roomMessages[roomName] = [];
      return;
    }

    // لو روم موجودة ولسه مفيش شات متخزن ليها
    if (!_roomMessages.containsKey(roomName)) {
      _roomMessages[roomName] = [
        ChatMessage(
          text: 'Hey everyone! 👋',
          isMe: false,
        ),
        ChatMessage(
          text: 'Good luck with your study session! 📚',
          isMe: false,
        ),
        ChatMessage(
          text: 'Let’s stay focused together 💪',
          isMe: false,
        ),
      ];
    }
  }
}