import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:async';

class ChatScreen extends StatefulWidget {
  final String chatTitle;
  final String contactImage;

  const ChatScreen({
    super.key,
    required this.chatTitle,
    this.contactImage = '',
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isAtBottom = true;

  // Variables for profile and status
  String _userStatus = 'online';
  // String? _profileImageUrl;
  Timer? _statusTimer;
  Timer? _typingTimer;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _updateUserStatus();
    // Add some sample messages
    _addSampleMessages();

    // Listen to scroll events to track if user is at bottom
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      _isAtBottom = (maxScroll - currentScroll) < 100; // 100px threshold
    }
  }

  void _updateUserStatus() {
    // Simulate dynamic status updates
    final statuses = [
      'online',
      'last seen recently',
      'last seen today at 2:30 PM',
      'typing...',
    ];

    _statusTimer = Timer.periodic(Duration(seconds: 15), (timer) {
      if (mounted) {
        setState(() {
          _userStatus = statuses[DateTime.now().second % statuses.length];
        });
      }
    });
  }

  void _addSampleMessages() {
    setState(() {
      _messages.addAll([
        ChatMessage(
          id: '1',
          message: 'Hello! How are you doing?',
          isSentByMe: false,
          timestamp: DateTime.now().subtract(Duration(minutes: 30)),
        ),
        ChatMessage(
          id: '2',
          message: 'I\'m doing great! Thanks for asking. How about you?',
          isSentByMe: true,
          timestamp: DateTime.now().subtract(Duration(minutes: 28)),
        ),
        ChatMessage(
          id: '3',
          message: 'I\'m good too! Want to meet up later?',
          isSentByMe: false,
          timestamp: DateTime.now().subtract(Duration(minutes: 25)),
        ),
        ChatMessage(
          id: '4',
          message: 'Sure! What time works for you?',
          isSentByMe: true,
          timestamp: DateTime.now().subtract(Duration(minutes: 20)),
        ),
      ]);
    });

    // Auto scroll to bottom after adding messages
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      final newMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: _messageController.text.trim(),
        isSentByMe: true,
        timestamp: DateTime.now(),
      );

      setState(() {
        _messages.add(newMessage);
      });

      _messageController.clear();

      // Auto scroll to bottom for new messages
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });

      // Simulate receiving a reply after 2 seconds
      Future.delayed(Duration(seconds: 2), () {
        _simulateReceivedMessage();
      });
    }
  }

  void _simulateReceivedMessage() {
    final replies = [
      'That sounds great!',
      'I agree with you',
      'Thanks for the message',
      'Let me think about it',
      'Absolutely!',
      'I\'ll get back to you on that',
    ];

    final randomReply = replies[DateTime.now().millisecond % replies.length];

    final receivedMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: randomReply,
      isSentByMe: false,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(receivedMessage);
    });

    // Auto scroll to bottom for received messages only if user is at bottom
    if (_isAtBottom) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight + 20),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF075E54),
              Color(0xFF128C7E),
            ],
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),

                // Profile Picture
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: widget.contactImage.isNotEmpty
                        ? Image.network(
                      widget.contactImage,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 20,
                      ),
                    )
                        : const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Title and Status
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.chatTitle,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _isTyping ? 'typing...' : _userStatus,
                        style: TextStyle(
                          fontSize: 12,
                          color: _isTyping
                              ? Colors.green[200]
                              : Colors.white.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                // Action Buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.videocam, color: Colors.white),
                      padding: EdgeInsets.all(8),
                      constraints: BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.call, color: Colors.white),
                      padding: EdgeInsets.all(8),
                      constraints: BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      padding: EdgeInsets.all(8),
                      constraints: BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTypingChanged(String text) {
    if (text.isNotEmpty && !_isTyping) {
      setState(() {
        _isTyping = true;
      });
    } else if (text.isEmpty && _isTyping) {
      setState(() {
        _isTyping = false;
      });
    }

    // Reset typing timer
    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(milliseconds: 500), () {
      if (_isTyping) {
        setState(() {
          _isTyping = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _statusTimer?.cancel();
    _typingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFECE5DD),
        ),
        child: Column(
          children: [
            // Messages List
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification notification) {
                  _scrollListener();
                  return false;
                },
                child: ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return MessageBubble(message: _messages[index]);
                  },
                ),
              ),
            ),

            // Message Input Area
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              color: Colors.white,
              child: Row(
                children: [
                  // Text Input
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF2F2F2),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.emoji_emotions_outlined),
                            onPressed: () {},
                            color: Colors.grey[600],
                          ),
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              decoration: InputDecoration(
                                hintText: 'Type a message',
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.grey[600]),
                              ),
                              maxLines: null,
                              onSubmitted: (_) => _sendMessage(),
                              onChanged: _onTypingChanged,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.attach_file),
                            onPressed: () {},
                            color: Colors.grey[600],
                          ),
                          IconButton(
                            icon: Icon(Icons.camera_alt),
                            onPressed: () {},
                            color: Colors.grey[600],
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(width: 8.0),

                  // Send Button
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF075E54),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: _sendMessage,
                      color: Colors.white,
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
}

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: message.isSentByMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!message.isSentByMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, size: 16, color: Colors.grey[600]),
            ),
            SizedBox(width: 8),
          ],

          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: message.isSentByMe ? Color(0xFFDCF8C6) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomLeft: message.isSentByMe
                      ? Radius.circular(18)
                      : Radius.circular(4),
                  bottomRight: message.isSentByMe
                      ? Radius.circular(4)
                      : Radius.circular(18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.message,
                    style: TextStyle(fontSize: 16.0, color: Colors.black87),
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        _formatTime(message.timestamp),
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (message.isSentByMe) ...[
                        SizedBox(width: 4),
                        Icon(
                          Icons.done_all,
                          size: 16,
                          color: Colors.blue,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),

          if (message.isSentByMe) ...[
            SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.green[300],
              child: Icon(Icons.person, size: 16, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }
}

class ChatMessage {
  final String id;
  final String message;
  final bool isSentByMe;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.message,
    required this.isSentByMe,
    required this.timestamp,
  });
}
