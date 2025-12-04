import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'package:intl/intl.dart';

class Message {
  final int id;
  final String type; // 'ai' or 'user'
  final String text;
  final String time;

  Message({
    required this.id,
    required this.type,
    required this.text,
    required this.time,
  });
}

class AIAssistantPage extends StatefulWidget {
  const AIAssistantPage({super.key});

  @override
  State<AIAssistantPage> createState() => _AIAssistantPageState();
}

class _AIAssistantPageState extends State<AIAssistantPage> with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Message> _messages = [];
  late AnimationController _glowController;

  final List<String> _suggestedQuestions = [
    'Analyze sales trends',
    'Generate revenue forecast',
    'Customer behavior insights',
    'Market analysis report',
  ];

  @override
  void initState() {
    super.initState();
    
    // Add initial AI greeting
    _messages.add(Message(
      id: 1,
      type: 'ai',
      text: "Hello! I'm your Intellix AI Assistant. How can I help you today?",
      time: _getCurrentTime(),
    ));

    // Animation controller for glowing effect
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  String _getCurrentTime() {
    return DateFormat('h:mm a').format(DateTime.now());
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final userMessage = Message(
      id: _messages.length + 1,
      type: 'user',
      text: _messageController.text,
      time: _getCurrentTime(),
    );

    setState(() {
      _messages.add(userMessage);
    });

    _messageController.clear();

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    // Simulate AI response
    Future.delayed(const Duration(seconds: 1), () {
      final aiMessage = Message(
        id: _messages.length + 1,
        type: 'ai',
        text: "I'm processing your request. This is a demo response to show how the chat works!",
        time: _getCurrentTime(),
      );

      setState(() {
        _messages.add(aiMessage);
      });

      // Scroll to bottom again
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  void _setSuggestedQuestion(String question) {
    setState(() {
      _messageController.text = question;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Stack(
      children: [
        // Chat Messages
        Positioned.fill(
          bottom: 176, // Space for suggested questions + input bar
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              return _buildMessageBubble(_messages[index], isDarkMode);
            },
          ),
        ),

        // Suggested Questions (above input bar)
        Positioned(
          bottom: 120,
          left: 16,
          right: 16,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _suggestedQuestions.map((question) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _buildSuggestedButton(question, isDarkMode),
                );
              }).toList(),
            ),
          ),
        ),

        // AI Chat Input Bar with Glow Effect
        Positioned(
          bottom: 24,
          left: 16,
          right: 16,
          child: _buildGlowingInputBar(isDarkMode),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(Message message, bool isDarkMode) {
    final isUser = message.type == 'user';

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              child: Column(
                crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: isUser
                          ? (isDarkMode
                              ? const LinearGradient(
                                  colors: [Color(0xFF7B96F5), Color(0xFF6A85D4)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : const LinearGradient(
                                  colors: [Color(0xFF5B9FF3), Color(0xFF7DB6F7)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ))
                          : null,
                      color: isUser
                          ? null
                          : (isDarkMode ? const Color(0xFF132F4C) : Colors.white),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(4),
                        bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(16),
                      ),
                      border: isUser
                          ? null
                          : Border.all(
                              color: isDarkMode ? const Color(0xFF1E4976) : const Color(0xFFE5E7EB),
                            ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(
                        color: isUser
                            ? Colors.white
                            : (isDarkMode ? Colors.white : const Color(0xFF1F2937)),
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message.time,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
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

  Widget _buildSuggestedButton(String question, bool isDarkMode) {
    return OutlinedButton.icon(
      onPressed: () => _setSuggestedQuestion(question),
      style: OutlinedButton.styleFrom(
        backgroundColor: isDarkMode ? const Color(0xFF132F4C) : Colors.white,
        side: BorderSide(
          color: isDarkMode ? const Color(0xFF1E4976) : const Color(0xFFE5E7EB),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      icon: Icon(
        Icons.auto_awesome,
        size: 14,
        color: isDarkMode ? const Color(0xFF7B96F5) : const Color(0xFF5B9FF3),
      ),
      label: Text(
        question,
        style: TextStyle(
          fontSize: 13,
          color: isDarkMode ? const Color(0xFFD1D5DB) : const Color(0xFF374151),
        ),
      ),
    );
  }

  Widget _buildGlowingInputBar(bool isDarkMode) {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return Stack(
          children: [
            // Outer glow layer
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: (isDarkMode ? const Color(0xFF0EA5E9) : const Color(0xFF0284C7))
                          .withOpacity(0.15 + (_glowController.value * 0.1)),
                      blurRadius: 40,
                      spreadRadius: -4,
                    ),
                  ],
                ),
              ),
            ),
            // Inner glow layer
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: (isDarkMode ? const Color(0xFF06B6D4) : const Color(0xFF0EA5E9))
                          .withOpacity(0.2 + (_glowController.value * 0.15)),
                      blurRadius: 24,
                      spreadRadius: -2,
                    ),
                  ],
                ),
              ),
            ),
            // Main input bar
            child!,
          ],
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: isDarkMode
              ? const LinearGradient(
                  colors: [Color(0xFF132F4C), Color(0xFF0A1929)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : const LinearGradient(
                  colors: [Colors.white, Colors.white],
                ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isDarkMode ? const Color(0xFF1E4976) : const Color(0xFFE0F2FE),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                onSubmitted: (_) => _sendMessage(),
                style: TextStyle(
                  color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  hintText: 'Ask anything...',
                  hintStyle: TextStyle(
                    color: isDarkMode ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ),
            // Microphone button
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.mic,
                color: isDarkMode ? const Color(0xFF0EA5E9) : const Color(0xFF0284C7),
              ),
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 4),
            // Send button with gradient
            Container(
              decoration: BoxDecoration(
                gradient: isDarkMode
                    ? const LinearGradient(
                        colors: [Color(0xFF0284C7), Color(0xFF06B6D4)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : const LinearGradient(
                        colors: [Color(0xFF0369A1), Color(0xFF0EA5E9)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: (isDarkMode ? const Color(0xFF0284C7) : const Color(0xFF0369A1))
                        .withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _sendMessage,
                  borderRadius: BorderRadius.circular(20),
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
