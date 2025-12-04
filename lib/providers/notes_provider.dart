import 'package:flutter/foundation.dart';

class SessionNote {
  final String id;
  final String expertName;
  final String expertTitle;
  final DateTime sessionDate;
  final int duration;
  final List<NoteEntry> notes;
  final String summary;

  SessionNote({
    required this.id,
    required this.expertName,
    required this.expertTitle,
    required this.sessionDate,
    required this.duration,
    required this.notes,
    required this.summary,
  });
}

class NoteEntry {
  final String timestamp;
  final String speaker;
  final String content;
  final String aiInsight;

  NoteEntry({
    required this.timestamp,
    required this.speaker,
    required this.content,
    required this.aiInsight,
  });
}

class NotesProvider with ChangeNotifier {
  final List<SessionNote> _sessionNotes = [];
  List<NoteEntry> _currentSessionNotes = [];
  bool _isRecording = false;

  List<SessionNote> get sessionNotes => _sessionNotes;
  List<NoteEntry> get currentSessionNotes => _currentSessionNotes;
  bool get isRecording => _isRecording;

  void startRecording() {
    _isRecording = true;
    _currentSessionNotes = [];
    notifyListeners();
  }

  void stopRecording() {
    _isRecording = false;
    notifyListeners();
  }

  void addNoteEntry(NoteEntry entry) {
    _currentSessionNotes.add(entry);
    notifyListeners();
  }

  SessionNote saveSession({
    required String expertName,
    required String expertTitle,
    required int duration,
  }) {
    final summary = _generateSummary();
    
    final session = SessionNote(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      expertName: expertName,
      expertTitle: expertTitle,
      sessionDate: DateTime.now(),
      duration: duration,
      notes: List.from(_currentSessionNotes),
      summary: summary,
    );

    _sessionNotes.insert(0, session);
    _currentSessionNotes = [];
    _isRecording = false;
    notifyListeners();

    return session;
  }

  String _generateSummary() {
    if (_currentSessionNotes.isEmpty) {
      return 'No discussion recorded in this session.';
    }

    // Simulate AI-generated summary
    return '''
Key Discussion Points:
• Strategic business growth opportunities identified
• Market analysis and competitive positioning discussed
• Implementation roadmap for Q1-Q2 2025
• Risk mitigation strategies outlined
• Action items and next steps defined

Recommended Follow-ups:
• Schedule follow-up session in 2 weeks
• Review market research findings
• Prepare financial projections
''';
  }

  void deleteSession(String id) {
    _sessionNotes.removeWhere((note) => note.id == id);
    notifyListeners();
  }

  SessionNote? getSessionById(String id) {
    try {
      return _sessionNotes.firstWhere((note) => note.id == id);
    } catch (e) {
      return null;
    }
  }

  // Simulated AI note generation based on conversation
  void simulateAINoteGeneration(String speaker, String message) {
    if (!_isRecording) return;

    final timestamp = _formatTimestamp(_currentSessionNotes.length);
    final aiInsight = _generateAIInsight(message);

    final entry = NoteEntry(
      timestamp: timestamp,
      speaker: speaker,
      content: message,
      aiInsight: aiInsight,
    );

    addNoteEntry(entry);
  }

  String _formatTimestamp(int index) {
    final minutes = (index * 15) ~/ 60;
    final seconds = (index * 15) % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String _generateAIInsight(String message) {
    // Simulate AI analysis of the message
    final insights = [
      '📊 Data-driven insight identified',
      '💡 Strategic recommendation noted',
      '✅ Action item identified',
      '⚠️ Risk factor mentioned',
      '🎯 Goal alignment confirmed',
      '📈 Growth opportunity highlighted',
      '🔍 Further analysis needed',
    ];

    return insights[message.length % insights.length];
  }
}
