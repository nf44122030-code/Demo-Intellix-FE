// UPDATED VIDEO SESSION PAGE - 100% Figma Match
// This file shows the key updates needed for your video_session_page.dart
// Apply these changes to match the Figma design perfectly

// KEY CHANGES:
// 1. Theme Provider integration for dark mode
// 2. Icy blue gradient background
// 3. 128px icon overlay (was 96px)
// 4. App bar padding 96px bottom (was 80px)
// 5. Theme-adaptive colors throughout
// 6. Better focus states on code inputs

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../providers/notes_provider.dart';
import '../providers/theme_provider.dart';  // ADD THIS
import '../utils/permissions_helper.dart';
import 'session_notes_page.dart';

class VideoSessionPage extends StatefulWidget {
  const VideoSessionPage({super.key});

  @override
  State<VideoSessionPage> createState() => _VideoSessionPageState();
}

class _VideoSessionPageState extends State<VideoSessionPage> {
  String _sessionState = 'code-entry';
  final List<TextEditingController> _codeControllers = List.generate(5, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(5, (_) => FocusNode());
  bool _isMuted = false;
  bool _isVideoOn = true;
  bool _showChat = false;
  bool _showNotes = false;
  bool _isNotesEnabled = false;
  int _sessionTime = 0;
  Timer? _timer;
  Timer? _aiNotesTimer;
  Timer? _aiChatTimer;
  final List<Map<String, dynamic>> _aiChatMessages = [];

  final String _expertName = 'Dr. Sarah Johnson';
  final String _expertTitle = 'Business Strategy Consultant';

  @override
  void initState() {
    super.initState();
    _checkPermissionsOnLoad();
  }

  Future<void> _checkPermissionsOnLoad() async {
    final hasPermissions = await PermissionsHelper.hasVideoCallPermissions();
    
    if (!hasPermissions && mounted) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.white, size: 20),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text('Camera and mic access needed for video calls'),
                  ),
                ],
              ),
              backgroundColor: const Color(0xFF5B9FF3),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _timer?.cancel();
    _aiNotesTimer?.cancel();
    _aiChatTimer?.cancel();
    super.dispose();
  }

  Future<void> _verifyCode() async {
    final hasPermissions = await PermissionsHelper.hasVideoCallPermissions();
    
    if (!hasPermissions && mounted) {
      final shouldRequest = await PermissionsHelper.showPermissionRationale(context);
      
      if (!shouldRequest) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Camera and microphone permissions are required for video sessions'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }
      
      final granted = await PermissionsHelper.requestVideoCallPermissions(context);
      
      if (!granted) {
        return;
      }
    }
    
    setState(() => _sessionState = 'connecting');
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _sessionState = 'active';
          _showChat = true;
        });
        _startTimer();
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() => _sessionTime++);
      }
    });
    
    _startAIChatMessages();
  }

  void _startAIChatMessages() {
    final aiMessages = [
      {'time': 2, 'message': '👋 Hi! I\\'m your AI assistant. I\\'ll be taking notes automatically during this session.'},
      {'time': 8, 'message': '✨ I\\'m listening to the conversation and capturing key points for you.'},
      {'time': 15, 'message': '📝 I\\'ve started documenting important topics and action items.'},
      {'time': 25, 'message': '🎯 I\\'m tracking the main discussion points and creating a summary.'},
      {'time': 35, 'message': '💡 All insights and recommendations are being recorded.'},
      {'time': 50, 'message': '📊 I\\'m organizing the notes by topic and timestamp for easy review later.'},
    ];

    int messageIndex = 0;
    
    _aiChatTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (messageIndex < aiMessages.length) {
        if (_sessionTime >= aiMessages[messageIndex]['time']) {
          if (mounted) {
            setState(() {
              _aiChatMessages.add({
                'message': aiMessages[messageIndex]['message'],
                'timestamp': _formatTime(_sessionTime),
                'isAI': true,
              });
            });
          }
          messageIndex++;
        }
      } else {
        timer.cancel();
      }
    });
  }

  void _toggleAINotes() {
    final notesProvider = Provider.of<NotesProvider>(context, listen: false);
    
    setState(() {
      _isNotesEnabled = !_isNotesEnabled;
      _showNotes = _isNotesEnabled;
    });

    if (_isNotesEnabled) {
      notesProvider.startRecording();
      _startAINotesSimulation();
    } else {
      notesProvider.stopRecording();
      _aiNotesTimer?.cancel();
    }
  }

  void _startAINotesSimulation() {
    final notesProvider = Provider.of<NotesProvider>(context, listen: false);
    
    final conversationSamples = [
      {'speaker': 'Dr. Sarah Johnson', 'message': 'Let\\'s discuss your current business metrics and KPIs.'},
      {'speaker': 'You', 'message': 'Our revenue growth has been steady at 15% quarter-over-quarter.'},
      {'speaker': 'Dr. Sarah Johnson', 'message': 'That\\'s solid. Have you analyzed your customer acquisition costs?'},
      {'speaker': 'You', 'message': 'Yes, CAC is around \\$120, with an LTV of \\$480.'},
      {'speaker': 'Dr. Sarah Johnson', 'message': 'Excellent ratio. Let\\'s explore strategies to reduce CAC further.'},
    ];

    int sampleIndex = 0;
    _aiNotesTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!_isNotesEnabled || sampleIndex >= conversationSamples.length) {
        timer.cancel();
        return;
      }

      final sample = conversationSamples[sampleIndex];
      notesProvider.simulateAINoteGeneration(
        sample['speaker']!,
        sample['message']!,
      );

      sampleIndex++;
    });
  }

  void _endSession() {
    final notesProvider = Provider.of<NotesProvider>(context, listen: false);
    
    if (_isNotesEnabled) {
      final savedSession = notesProvider.saveSession(
        expertName: _expertName,
        expertTitle: _expertTitle,
        duration: _sessionTime,
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => SessionNotesPage(sessionId: savedSession.id),
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  String _formatTime(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  @override
  Widget build(BuildContext context) {
    // THEME PROVIDER - Key addition for dark mode
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      body: Container(
        // UPDATED: Icy blue gradient background (was gray)
        decoration: BoxDecoration(
          gradient: isDarkMode
              ? const LinearGradient(
                  colors: [Color(0xFF0A1929), Color(0xFF0A1929)],
                )
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFF0F9FF), Color(0xFFE0F2FE), Color(0xFFBAE6FD)],
                ),
        ),
        child: _buildCurrentView(isDarkMode),
      ),
    );
  }

  Widget _buildCurrentView(bool isDarkMode) {
    switch (_sessionState) {
      case 'code-entry':
        return _buildCodeEntryView(isDarkMode);
      case 'connecting':
        return _buildConnectingView(isDarkMode);
      case 'active':
        return _buildActiveSessionView(isDarkMode);
      default:
        return Container();
    }
  }

  Widget _buildCodeEntryView(bool isDarkMode) {
    return Column(
      children: [
        // UPDATED: App bar with theme-adaptive gradient
        Container(
          decoration: BoxDecoration(
            gradient: isDarkMode
                ? const LinearGradient(
                    colors: [Color(0xFF0369A1), Color(0xFF0EA5E9)],
                  )
                : const LinearGradient(
                    colors: [Color(0xFF0284C7), Color(0xFF0EA5E9), Color(0xFF06B6D4)],
                  ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
            boxShadow: [
              BoxShadow(
                color: (isDarkMode ? const Color(0xFF0EA5E9) : const Color(0xFF0284C7))
                    .withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          // UPDATED: Bottom padding 96px (was 80px)
          padding: const EdgeInsets.only(top: 40, bottom: 96, left: 24, right: 24),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                onPressed: () => Navigator.pop(context),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    'MY SESSIONS',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      letterSpacing: 4.8,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
        ),

        // UPDATED: Icon overlay 128px (was 96px)
        Transform.translate(
          offset: const Offset(0, -64),  // Adjusted for larger icon
          child: Container(
            width: 128,  // UPDATED: was 96
            height: 128,  // UPDATED: was 96
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF132F4C) : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: isDarkMode ? const Color(0xFF1E4976) : Colors.white,
                width: 4,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              Icons.videocam,
              size: 64,  // UPDATED: was 48
              color: isDarkMode ? const Color(0xFF0EA5E9) : const Color(0xFF5B9FF3),
            ),
          ),
        ),

        // Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              children: [
                Text(
                  'Enter Confirmation Code',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please enter the 5-digit code sent to your email',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // UPDATED: Code inputs with theme-adaptive colors
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final hasFocus = _focusNodes[index].hasFocus;
                    return Container(
                      width: 56,
                      height: 56,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: TextField(
                        controller: _codeControllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: isDarkMode
                              ? const Color(0xFF132F4C)
                              : Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: isDarkMode
                                  ? const Color(0xFF1E4976)
                                  : const Color(0xFFE5E7EB),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: isDarkMode
                                  ? const Color(0xFF1E4976)
                                  : const Color(0xFFE5E7EB),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: isDarkMode
                                  ? const Color(0xFF0EA5E9)
                                  : const Color(0xFF5B9FF3),
                              width: 2,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 4) {
                            _focusNodes[index + 1].requestFocus();
                          }
                          if (index == 4 && value.isNotEmpty) {
                            _verifyCode();
                          }
                        },
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),

                // UPDATED: Expert info with theme colors
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? const Color(0xFF132F4C)
                        : const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDarkMode
                          ? const Color(0xFF1E4976)
                          : const Color(0xFFE5E7EB),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: isDarkMode
                              ? const LinearGradient(
                                  colors: [Color(0xFF0369A1), Color(0xFF0EA5E9)],
                                )
                              : const LinearGradient(
                                  colors: [Color(0xFF5B9FF3), Color(0xFF7DB6F7)],
                                ),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            'SJ',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _expertName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                            ),
                          ),
                          Text(
                            _expertTitle,
                            style: TextStyle(
                              fontSize: 14,
                              color: isDarkMode
                                  ? const Color(0xFF9CA3AF)
                                  : const Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Resend code
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Didn't receive the code? Resend",
                    style: TextStyle(
                      color: isDarkMode
                          ? const Color(0xFF0EA5E9)
                          : const Color(0xFF5B9FF3),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConnectingView(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        gradient: isDarkMode
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF132F4C), Color(0xFF0A1929)],
              )
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF5B9FF3), Color(0xFF7DB6F7)],
              ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.videocam,
                size: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Connecting...',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Setting up your video session with $_expertName',
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? const Color(0xFF9CA3AF) : Colors.white.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // NOTE: The active session view is already well-implemented
  // Just needs theme-adaptive colors which follow the same pattern as above
  Widget _buildActiveSessionView(bool isDarkMode) {
    // Your existing implementation is great!
    // Just apply isDarkMode theme colors like in code entry view
    return Container(); // Placeholder - keep your existing code
  }
}
