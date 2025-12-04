import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/notes_provider.dart';
import 'session_notes_page.dart';

class NotesHistoryPage extends StatelessWidget {
  const NotesHistoryPage({super.key});

  String _formatDuration(int seconds) {
    final mins = seconds ~/ 60;
    return '${mins}min';
  }

  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context);

    return Scaffold(
      body: Container(
        color: const Color(0xFFF5F5F5),
        child: Column(
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
              padding: const EdgeInsets.only(top: 40, bottom: 16, left: 24, right: 24),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'NOTES HISTORY',
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

            // Content
            Expanded(
              child: notesProvider.sessionNotes.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Icon(
                              Icons.note_alt_outlined,
                              size: 60,
                              color: Color(0xFFE0E0E0),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'No Session Notes Yet',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 48),
                            child: Text(
                              'Enable AI Notes during your next expert session to automatically capture insights',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF7F8C8D),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(24),
                      itemCount: notesProvider.sessionNotes.length,
                      itemBuilder: (context, index) {
                        final session = notesProvider.sessionNotes[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SessionNotesPage(
                                      sessionId: session.id,
                                    ),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Container(
                                              width: 56,
                                              height: 56,
                                              decoration: const BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Color(0xFF5B9FF3),
                                                    Color(0xFF7DB6F7),
                                                  ],
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  session.expertName
                                                      .substring(0, 2)
                                                      .toUpperCase(),
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // AI Notes Badge
                                            Positioned(
                                              bottom: -2,
                                              right: -2,
                                              child: Container(
                                                padding: const EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  gradient: const LinearGradient(
                                                    colors: [
                                                      Color(0xFFFFA726),
                                                      Color(0xFFFFB74D),
                                                    ],
                                                  ),
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: Colors.white,
                                                    width: 2,
                                                  ),
                                                ),
                                                child: const Icon(
                                                  Icons.auto_awesome,
                                                  size: 12,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      session.expertName,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                        color: Color(0xFF2C3E50),
                                                      ),
                                                    ),
                                                  ),
                                                  // AI Notes Indicator
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.amber.withOpacity(0.2),
                                                      borderRadius: BorderRadius.circular(6),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: const [
                                                        Icon(
                                                          Icons.edit_note,
                                                          size: 14,
                                                          color: Colors.amber,
                                                        ),
                                                        SizedBox(width: 4),
                                                        Text(
                                                          'AI Notes',
                                                          style: TextStyle(
                                                            fontSize: 10,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.amber,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                session.expertTitle,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Color(0xFF7F8C8D),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        PopupMenuButton(
                                          icon: const Icon(
                                            Icons.more_vert,
                                            color: Color(0xFF7F8C8D),
                                          ),
                                          itemBuilder: (context) => [
                                            const PopupMenuItem(
                                              value: 'share',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.share, size: 20),
                                                  SizedBox(width: 12),
                                                  Text('Share'),
                                                ],
                                              ),
                                            ),
                                            const PopupMenuItem(
                                              value: 'download',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.download, size: 20),
                                                  SizedBox(width: 12),
                                                  Text('Download'),
                                                ],
                                              ),
                                            ),
                                            const PopupMenuItem(
                                              value: 'delete',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.delete,
                                                      size: 20, color: Colors.red),
                                                  SizedBox(width: 12),
                                                  Text('Delete',
                                                      style:
                                                          TextStyle(color: Colors.red)),
                                                ],
                                              ),
                                            ),
                                          ],
                                          onSelected: (value) {
                                            if (value == 'delete') {
                                              _showDeleteDialog(
                                                  context, notesProvider, session.id);
                                            } else if (value == 'share') {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text('Sharing notes...')),
                                              );
                                            } else if (value == 'download') {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content:
                                                        Text('Downloading notes...')),
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    const Divider(),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        _buildInfoChip(
                                          Icons.calendar_today,
                                          DateFormat('MMM dd, yyyy')
                                              .format(session.sessionDate),
                                        ),
                                        const SizedBox(width: 8),
                                        _buildInfoChip(
                                          Icons.access_time,
                                          _formatDuration(session.duration),
                                        ),
                                        const SizedBox(width: 8),
                                        _buildInfoChip(
                                          Icons.note,
                                          '${session.notes.length}',
                                        ),
                                        const SizedBox(width: 8),
                                        // AI Notes Badge
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 6),
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFFFFA726),
                                                Color(0xFFFFB74D),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: const [
                                              Icon(
                                                Icons.auto_awesome,
                                                size: 14,
                                                color: Colors.white,
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                'AI',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.amber.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.auto_awesome,
                                            size: 16,
                                            color: Colors.amber,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              session.summary.split('\n').first,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF7F8C8D),
                                                fontStyle: FontStyle.italic,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF5B9FF3)),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF2C3E50),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(
      BuildContext context, NotesProvider provider, String sessionId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Session Notes?'),
        content: const Text(
          'This will permanently delete all notes from this session. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.deleteSession(sessionId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Session notes deleted')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
