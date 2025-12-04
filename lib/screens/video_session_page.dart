import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../providers/notes_provider.dart';
import '../utils/permissions_helper.dart';
import 'session_notes_page.dart';

class VideoSessionPage extends StatefulWidget {
  const VideoSessionPage({super.key});

  @override
  State<VideoSessionPage> createState() => _VideoSessionPageState();
}

class _VideoSessionPageState extends State<VideoSessionPage> {
  String _sessionState = 'code-entry'; // code-entry, connecting, active
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
    // Pre-check permissions when page loads
    _checkPermissionsOnLoad();
  }

  Future<void> _checkPermissionsOnLoad() async {
    final hasPermissions = await PermissionsHelper.hasVideoCallPermissions();
    
    if (!hasPermissions && mounted) {
      // Show a gentle reminder that permissions will be needed
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
    // Check and request permissions before starting session
    final hasPermissions = await PermissionsHelper.hasVideoCallPermissions();
    
    if (!hasPermissions && mounted) {
      // Show permission rationale
      final shouldRequest = await PermissionsHelper.showPermissionRationale(context);
      
      if (!shouldRequest) {
        // User declined permission request
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
      
      // Request permissions
      final granted = await PermissionsHelper.requestVideoCallPermissions(context);
      
      if (!granted) {
        // Permissions denied
        return;
      }
    }
    
    // Permissions granted, proceed with connection
    setState(() => _sessionState = 'connecting');
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _sessionState = 'active';
          _showChat = true; // Automatically show AI chat
        });
        print('✅ Session active, _showChat = $_showChat');
        _startTimer();
      }
    });
  }

  void _startTimer() {
    print('🚀 Starting timer and AI chat messages');
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() => _sessionTime++);
      }
    });
    
    // Start AI chat messages
    _startAIChatMessages();
  }

  void _startAIChatMessages() {
    print('💬 Starting AI chat messages');
    final aiMessages = [
      {'time': 2, 'message': '👋 Hi! I\'m your AI assistant. I\'ll be taking notes automatically during this session.'},
      {'time': 8, 'message': '✨ I\'m listening to the conversation and capturing key points for you.'},
      {'time': 15, 'message': '📝 I\'ve started documenting important topics and action items.'},
      {'time': 25, 'message': '🎯 I\'m tracking the main discussion points and creating a summary.'},
      {'time': 35, 'message': '💡 All insights and recommendations are being recorded.'},
      {'time': 50, 'message': '📊 I\'m organizing the notes by topic and timestamp for easy review later.'},
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
            print('📨 AI message added. Total messages: ${_aiChatMessages.length}');
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
    
    // Simulate AI generating notes from conversation every 15 seconds
    final conversationSamples = [
      {'speaker': 'Dr. Sarah Johnson', 'message': 'Let\'s discuss your current business metrics and KPIs.'},
      {'speaker': 'You', 'message': 'Our revenue growth has been steady at 15% quarter-over-quarter.'},
      {'speaker': 'Dr. Sarah Johnson', 'message': 'That\'s solid. Have you analyzed your customer acquisition costs?'},
      {'speaker': 'You', 'message': 'Yes, CAC is around \$120, with an LTV of \$480.'},
      {'speaker': 'Dr. Sarah Johnson', 'message': 'Excellent ratio. Let\'s explore strategies to reduce CAC further.'},
      {'speaker': 'You', 'message': 'We\'re considering content marketing and SEO optimization.'},
      {'speaker': 'Dr. Sarah Johnson', 'message': 'Great approach. I recommend allocating 30% of marketing budget there.'},
      {'speaker': 'You', 'message': 'What about our competitive positioning in the market?'},
      {'speaker': 'Dr. Sarah Johnson', 'message': 'Your differentiation is strong, but pricing could be optimized.'},
      {'speaker': 'You', 'message': 'Should we consider a freemium model?'},
      {'speaker': 'Dr. Sarah Johnson', 'message': 'That could work well for your product. Let\'s create a strategic roadmap.'},
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
      // Save session notes
      final savedSession = notesProvider.saveSession(
        expertName: _expertName,
        expertTitle: _expertTitle,
        duration: _sessionTime,
      );

      // Show session summary
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
    return Scaffold(
      body: Container(
        color: const Color(0xFFF5F5F5),
        child: _buildCurrentView(),
      ),
    );
  }

  Widget _buildCurrentView() {
    switch (_sessionState) {
      case 'code-entry':
        return _buildCodeEntryView();
      case 'connecting':
        return _buildConnectingView();
      case 'active':
        return _buildActiveSessionView();
      default:
        return Container();
    }
  }

  Widget _buildCodeEntryView() {
    return Column(
      children: [
        // Header with curved bottom
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF5B9FF3), Color(0xFF7DB6F7)],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          padding: const EdgeInsets.only(top: 40, bottom: 80, left: 24, right: 24),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    'MY SESSIONS',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 6,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),

        // Floating Icon
        Transform.translate(
          offset: const Offset(0, -48),
          child: Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.videocam,
              size: 48,
              color: Color(0xFF5B9FF3),
            ),
          ),
        ),

        // Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Text(
                  'Enter Confirmation Code',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please enter the 5-digit code sent to your email',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF7F8C8D),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Code Input
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
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
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF5B9FF3), width: 2),
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

                // Expert Info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
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
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                          Text(
                            _expertTitle,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF7F8C8D),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Resend Code
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Didn't receive the code? Resend",
                    style: TextStyle(color: Color(0xFF5B9FF3)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConnectingView() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
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
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Setting up your video session with $_expertName',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveSessionView() {
    return Column(
      children: [
        // Header
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF5B9FF3), Color(0xFF7DB6F7)],
            ),
          ),
          padding: const EdgeInsets.only(top: 40, bottom: 16, left: 16, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: _endSession,
              ),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.access_time, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    _formatTime(_sessionTime),
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
              Row(
                children: [
                  // AI Notes Button with Badge
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: _isNotesEnabled 
                              ? Colors.amber 
                              : Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: _isNotesEnabled ? [
                            BoxShadow(
                              color: Colors.amber.withOpacity(0.5),
                              blurRadius: 8,
                              spreadRadius: 2,
                            )
                          ] : null,
                        ),
                        child: IconButton(
                          icon: Icon(
                            _isNotesEnabled ? Icons.edit_note : Icons.edit_note_outlined,
                            color: _isNotesEnabled ? Colors.black87 : Colors.white,
                            size: 26,
                          ),
                          onPressed: _toggleAINotes,
                          tooltip: _isNotesEnabled ? 'AI Notes Active' : 'Enable AI Notes',
                        ),
                      ),
                      // Recording badge
                      if (_isNotesEnabled)
                        Positioned(
                          top: 6,
                          right: 2,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 1.5),
                            ),
                          ),
                        ),
                    ],
                  ),
                  // Chat Button with Badge
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        icon: Icon(
                          _showChat ? Icons.chat_bubble : Icons.chat_bubble_outline,
                          color: Colors.white,
                        ),
                        onPressed: () => setState(() => _showChat = !_showChat),
                        tooltip: 'AI Assistant Chat',
                      ),
                      // New message badge
                      if (_aiChatMessages.isNotEmpty && !_showChat)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Center(
                              child: Text(
                                '${_aiChatMessages.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        // Video Container with Notes Overlay
        Expanded(
          child: Stack(
            children: [
              // Video Container
              Container(
                color: Colors.black,
                child: Stack(
                  children: [
                    // Expert Video (placeholder)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF5B9FF3), Color(0xFF7DB6F7)],
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Text(
                                'SJ',
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _expertName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            _expertTitle,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // User Video (PiP)
                    if (_isVideoOn)
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Container(
                          width: 100,
                          height: 130,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2C3E50),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white24, width: 2),
                          ),
                          child: const Center(
                            child: Icon(Icons.person, color: Colors.white54, size: 40),
                          ),
                        ),
                      ),

                    // AI Notes Indicator with Animated Icon
                    if (_isNotesEnabled)
                      Positioned(
                        top: 16,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.amber.withOpacity(0.4),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Animated pulsing AI icon
                              TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0.8, end: 1.2),
                                duration: const Duration(milliseconds: 1000),
                                repeat: true,
                                builder: (context, scale, child) {
                                  return Transform.scale(
                                    scale: scale,
                                    child: const Icon(
                                      Icons.auto_awesome,
                                      color: Colors.black87,
                                      size: 18,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'AI Taking Notes',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Floating AI Icon (bottom center) - More Prominent
                    if (_isNotesEnabled)
                      Positioned(
                        bottom: 80,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 1500),
                            repeat: true,
                            builder: (context, value, child) {
                              return Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.amber.withOpacity(0.3 + value * 0.4),
                                      Colors.orange.withOpacity(0.3 + value * 0.4),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.amber.withOpacity(value * 0.5),
                                      blurRadius: 20 + value * 10,
                                      spreadRadius: 5 + value * 5,
                                    ),
                                  ],
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [Colors.amber, Colors.orange],
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.auto_awesome,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                    // Status
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.mic, color: Colors.white, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              '$_expertName is speaking...',
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // AI Chat Panel - Opens when you click the chat icon
              if (_showChat)
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(-5, 0),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Header
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF5B9FF3), Color(0xFF7DB6F7)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.smart_toy, color: Colors.white, size: 24),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'AI Assistant',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Taking notes...',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.white),
                                onPressed: () => setState(() => _showChat = false),
                              ),
                            ],
                          ),
                        ),
                        // Messages
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.all(16),
                            children: [
                              _buildAIChatMessage(
                                '👋 Hi! I\'m your AI assistant. I\'m automatically taking notes during this session.',
                                '00:00',
                              ),
                              _buildAIChatMessage(
                                '📝 Session started with ${_expertName}',
                                '00:02',
                              ),
                              _buildAIChatMessage(
                                '✅ Recording conversation and generating summary...',
                                '00:05',
                              ),
                              _buildAIChatMessage(
                                '💡 Key points will be captured automatically',
                                '00:08',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Notes Panel
              if (_showNotes && _isNotesEnabled)
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: _buildNotesPanel(),
                ),
            ],
          ),
        ),

        // Controls
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildControlButton(
                icon: _isMuted ? Icons.mic_off : Icons.mic,
                color: _isMuted ? Colors.red : const Color(0xFF2C3E50),
                onPressed: () => setState(() => _isMuted = !_isMuted),
              ),
              _buildControlButton(
                icon: _isVideoOn ? Icons.videocam : Icons.videocam_off,
                color: !_isVideoOn ? Colors.red : const Color(0xFF2C3E50),
                onPressed: () => setState(() => _isVideoOn = !_isVideoOn),
              ),
              _buildControlButton(
                icon: Icons.call_end,
                color: Colors.red,
                size: 56,
                onPressed: _endSession,
              ),
              _buildControlButton(
                icon: _isNotesEnabled 
                    ? (_showNotes ? Icons.note : Icons.note_add)
                    : Icons.note_outlined,
                color: _isNotesEnabled ? Colors.amber : const Color(0xFF2C3E50),
                onPressed: () {
                  if (_isNotesEnabled) {
                    setState(() => _showNotes = !_showNotes);
                  } else {
                    // If notes not enabled, enable them
                    _toggleAINotes();
                  }
                },
                showBadge: _isNotesEnabled,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotesPanel() {
    return Consumer<NotesProvider>(
      builder: (context, notesProvider, child) {
        return Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF5B9FF3), Color(0xFF7DB6F7)],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'AI Notes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => setState(() => _showNotes = false),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: notesProvider.currentSessionNotes.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.notes, size: 48, color: Color(0xFFE0E0E0)),
                            SizedBox(height: 16),
                            Text(
                              'AI is listening...\nNotes will appear here',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Color(0xFF7F8C8D)),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: notesProvider.currentSessionNotes.length,
                        itemBuilder: (context, index) {
                          final note = notesProvider.currentSessionNotes[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFFE0E0E0)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF5B9FF3),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        note.timestamp,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        note.speaker,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF2C3E50),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  note.content,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF2C3E50),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.auto_awesome,
                                        size: 14,
                                        color: Colors.amber,
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          note.aiInsight,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Color(0xFF7F8C8D),
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAIChatPanel() {
    print('🎨 Building AI chat panel. Messages: ${_aiChatMessages.length}');
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF5B9FF3), Color(0xFF7DB6F7)],
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.smart_toy,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Assistant',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Auto Note-Taking',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => setState(() => _showChat = false),
                ),
              ],
            ),
          ),

          // Messages
          Expanded(
            child: _aiChatMessages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.8, end: 1.0),
                          duration: const Duration(milliseconds: 1000),
                          repeat: true,
                          builder: (context, scale, child) {
                            return Transform.scale(
                              scale: scale,
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF5B9FF3), Color(0xFF7DB6F7)],
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.auto_awesome,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'AI Assistant Ready',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            'Starting automatic note-taking...',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF7F8C8D),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _aiChatMessages.length,
                    itemBuilder: (context, index) {
                      final message = _aiChatMessages[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xFF5B9FF3), Color(0xFF7DB6F7)],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.auto_awesome,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        'AI Assistant',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Color(0xFF2C3E50),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        message['timestamp'],
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF7F8C8D),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF0F7FF),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(0xFF5B9FF3).withOpacity(0.2),
                                      ),
                                    ),
                                    child: Text(
                                      message['message'],
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF2C3E50),
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          // Footer
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              border: Border(
                top: BorderSide(color: const Color(0xFFE0E0E0)),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'AI is actively listening',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF7F8C8D),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIChatMessage(String message, String timestamp) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF5B9FF3), Color(0xFF7DB6F7)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.smart_toy, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'AI Assistant',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      timestamp,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF7F8C8D),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F7FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF5B9FF3).withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    message,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    double size = 48,
    bool showBadge = false,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: showBadge ? [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 8,
                spreadRadius: 2,
              )
            ] : null,
          ),
          child: IconButton(
            icon: Icon(icon, color: Colors.white),
            onPressed: onPressed,
          ),
        ),
        // Recording badge
        if (showBadge)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
      ],
    );
  }
}
