import 'package:flutter/material.dart';
import 'package:study_side/theme/app_theme.dart';
import 'package:study_side/model/chat_store.dart';

class RoomChatView extends StatefulWidget {
  final String roomName;
  final bool isNewRoom;

  const RoomChatView({
    super.key,
    required this.roomName,
    this.isNewRoom = false,
  });

  @override
  State<RoomChatView> createState() => _RoomChatViewState();
}

class _RoomChatViewState extends State<RoomChatView> {


  final TextEditingController _messageController =
  TextEditingController();

  final ScrollController _scrollController =
  ScrollController();

  // ============================================================
  // CHAT MESSAGES
  // ============================================================


  // ============================================================
  // QUICK REACTIONS
  // ============================================================

  final List<String> _quickReactions = [
    '🔥',
    '💪',
    '☕',
    '🎉',
    '😊',
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ============================================================
  // SEND MESSAGE
  // ============================================================

  void _sendMessage() {
    final text = _messageController.text.trim();

    if (text.isEmpty) return;

    ChatStore.addMessage(
      widget.roomName,
      text,
    );

    setState(() {
      _messageController.clear();
    });

    _scrollToBottom();
  }

  // ============================================================
  // QUICK REACTION
  // ============================================================

  void _sendReaction(String reaction) {
    ChatStore.addMessage(
      widget.roomName,
      reaction,
    );

    setState(() {});

    _scrollToBottom();
  }

  // ============================================================
  // CURRENT TIME
  // ============================================================

  String _currentTime() {
    final now = TimeOfDay.now();

    final hour = now.hourOfPeriod == 0
        ? 12
        : now.hourOfPeriod;

    final minute =
    now.minute.toString().padLeft(2, '0');

    final period =
    now.period == DayPeriod.am ? 'AM' : 'PM';

    return '$hour:$minute $period';
  }

  @override
  void initState() {
    super.initState();

    ChatStore.initializeRoomChat(
      widget.roomName,
      isNewRoom: widget.isNewRoom,
    );
  }

  // ============================================================
  // SCROLL TO BOTTOM
  // ============================================================

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: SafeArea(
        child: Column(
          children: [
            // ======================================================
            // HEADER
            // ======================================================

            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFFF7F8FC),
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFFE7E8F1),
                  ),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const SizedBox(
                      width: 40,
                      height: 40,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 20,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Text(
                      'Room Chat',
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF202C61),
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      _showChatOptions(context);
                    },
                    child: const Icon(
                      Icons.more_vert_rounded,
                      size: 22,
                      color: Color(0xFF202C61),
                    ),
                  ),
                ],
              ),
            ),

            // ======================================================
            // CHAT AREA
            // ======================================================

            Expanded(
              child: ListView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  20,
                  18,
                  20,
                  10,
                ),
                children: [
                  // =================================================
                  // MESSAGES
                  // =================================================

                  ...ChatStore.messagesFor(widget.roomName).map(
                        (message) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: 18,
                      ),
                      child: _MessageBubble(
                        message: message,
                      ),
                    ),
                  ),

                  const SizedBox(height: 4),

                  // =================================================
                  // QUICK REACTIONS TITLE
                  // =================================================

                  const Text(
                    'Quick Reactions',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF26346E),
                    ),
                  ),

                  const SizedBox(height: 9),

                  // =================================================
                  // QUICK REACTIONS
                  // =================================================

                  SizedBox(
                    height: 48,
                    child: Row(
                      children: [
                        for (int i = 0;
                        i < _quickReactions.length;
                        i++)
                          Padding(
                            padding: EdgeInsets.only(
                              right: i ==
                                  _quickReactions.length - 1
                                  ? 0
                                  : 7,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                _sendReaction(
                                  _quickReactions[i],
                                );
                              },
                              child: Container(
                                width: 43,
                                height: 43,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color:
                                    const Color(0xFFE2E5F2),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withOpacity(0.025),
                                      blurRadius: 5,
                                      offset:
                                      const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  _quickReactions[i],
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ======================================================
            // MESSAGE INPUT
            // ======================================================

            Container(
              padding: const EdgeInsets.fromLTRB(
                20,
                10,
                20,
                14,
              ),
              color: const Color(0xFFF7F8FC),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(24),
                        border: Border.all(
                          color: const Color(0xFFE1E4F0),
                        ),
                      ),
                      child: TextField(
                        controller: _messageController,
                        textInputAction:
                        TextInputAction.send,
                        onSubmitted: (_) {
                          _sendMessage();
                        },
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textDark,
                        ),
                        decoration: const InputDecoration(
                          hintText:
                          'Type a message...',
                          hintStyle: TextStyle(
                            fontSize: 11,
                            color: Color(0xFFA5A9BA),
                          ),
                          border: InputBorder.none,
                          contentPadding:
                          EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 13,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 9),

                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 21,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CHAT OPTIONS
  // ============================================================

  void _showChatOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              22,
              12,
              22,
              25,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9DBE7),
                    borderRadius:
                    BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Chat Options',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),

                const SizedBox(height: 12),

                ListTile(
                  leading: const Icon(
                    Icons.notifications_off_outlined,
                    color: AppColors.primary,
                  ),
                  title: const Text(
                    'Mute notifications',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),

                ListTile(
                  leading: const Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.error,
                  ),
                  title: const Text(
                    'Clear chat',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  onTap: () {
                    ChatStore.clearMessages(widget.roomName);

                    setState(() {});

                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ============================================================================
// CHAT MESSAGE MODEL
// ============================================================================



// ============================================================================
// MESSAGE BUBBLE
// ============================================================================

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const _MessageBubble({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    if (message.isMe) {
      return Align(
        alignment: Alignment.centerRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'You',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF68708F),
                  ),
                ),

                const SizedBox(width: 8),

                Text(
                  _currentTime(),
                  style: const TextStyle(
                    fontSize: 9,
                    color: Color(0xFF9BA0B3),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 5),

            Container(
              constraints: BoxConstraints(
                maxWidth:
                MediaQuery.of(context).size.width * 0.66,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 11,
              ),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(4),
                ),
              ),
              child: Text(
                message.text,
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.35,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFFB7D1F5),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
          child: const Icon(
            Icons.person,
            color: Colors.white,
            size: 21,
          ),
        ),

        const SizedBox(width: 10),

        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'User',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF344170),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Text(
                    _currentTime(),
                    style: const TextStyle(
                      fontSize: 9,
                      color: Color(0xFF9BA0B3),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 5),

              Container(
                constraints: BoxConstraints(
                  maxWidth:
                  MediaQuery.of(context).size.width * 0.67,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  border: Border.all(
                    color: const Color(0xFFE4E6F0),
                  ),
                ),
                child: Text(
                  message.text,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.35,
                    color: Color(0xFF4C5578),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _currentTime() {
    final now = TimeOfDay.now();

    final hour = now.hourOfPeriod == 0
        ? 12
        : now.hourOfPeriod;

    final minute =
    now.minute.toString().padLeft(2, '0');

    final period =
    now.period == DayPeriod.am ? 'AM' : 'PM';

    return '$hour:$minute $period';
  }
}