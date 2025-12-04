import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

enum NotificationType { session, message, update, achievement, reminder }

class NotificationModel {
  final int id;
  final NotificationType type;
  final String title;
  final String description;
  final String time;
  bool isRead;
  final IconData icon;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.time,
    required this.isRead,
    required this.icon,
  });
}

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> with SingleTickerProviderStateMixin {
  late List<NotificationModel> notifications;

  @override
  void initState() {
    super.initState();
    notifications = [
      NotificationModel(
        id: 1,
        type: NotificationType.session,
        title: 'Session Confirmed',
        description: 'Your expert session with Dr. Sarah Chen is confirmed for Dec 4 at 3:00 PM',
        time: '2 hours ago',
        isRead: false,
        icon: Icons.video_call,
      ),
      NotificationModel(
        id: 2,
        type: NotificationType.message,
        title: 'New Message',
        description: 'Dr. Michael Roberts sent you a message about your upcoming consultation',
        time: '5 hours ago',
        isRead: false,
        icon: Icons.message,
      ),
      NotificationModel(
        id: 3,
        type: NotificationType.update,
        title: 'AI Assistant Updated',
        description: 'New features added: Enhanced analysis and faster response times',
        time: 'Yesterday',
        isRead: true,
        icon: Icons.star,
      ),
      NotificationModel(
        id: 4,
        type: NotificationType.achievement,
        title: 'Milestone Reached',
        description: 'You\'ve completed 10 expert sessions! Keep up the great work',
        time: 'Yesterday',
        isRead: true,
        icon: Icons.trending_up,
      ),
      NotificationModel(
        id: 5,
        type: NotificationType.reminder,
        title: 'Session Reminder',
        description: 'Your session with Emma Wilson starts in 24 hours',
        time: '2 days ago',
        isRead: true,
        icon: Icons.calendar_today,
      ),
      NotificationModel(
        id: 6,
        type: NotificationType.update,
        title: 'Special Offer',
        description: 'Get 20% off on your next premium subscription renewal',
        time: '3 days ago',
        isRead: true,
        icon: Icons.card_giftcard,
      ),
    ];
  }

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  void markAsRead(int id) {
    setState(() {
      final index = notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        notifications[index].isRead = true;
      }
    });
  }

  void markAllAsRead() {
    setState(() {
      for (var notification in notifications) {
        notification.isRead = true;
      }
    });
  }

  void deleteNotification(int id) {
    setState(() {
      notifications.removeWhere((n) => n.id == id);
    });
  }

  void clearAll() {
    setState(() {
      notifications.clear();
    });
  }

  List<NotificationModel> get todayNotifications {
    return notifications.where((n) => n.time.contains('hour') || n.time.contains('minute')).toList();
  }

  List<NotificationModel> get yesterdayNotifications {
    return notifications.where((n) => n.time == 'Yesterday').toList();
  }

  List<NotificationModel> get earlierNotifications {
    return notifications.where((n) => n.time.contains('days ago')).toList();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDarkMode
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0A1929), Color(0xFF0A1929)],
                )
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFF0F9FF), Color(0xFFE0F2FE), Color(0xFFBAE6FD)],
                ),
        ),
        child: Column(
          children: [
            // Curved Header
            Container(
              decoration: BoxDecoration(
                gradient: isDarkMode
                    ? const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xFF0369A1), Color(0xFF0EA5E9)],
                      )
                    : const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xFF0284C7), Color(0xFF0EA5E9), Color(0xFF06B6D4)],
                      ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              padding: const EdgeInsets.only(top: 40, bottom: 16, left: 24, right: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.notifications, color: Colors.white, size: 24),
                      const SizedBox(width: 12),
                      const Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  if (unreadCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$unreadCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Actions Bar
            if (notifications.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isDarkMode ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (unreadCount > 0)
                      TextButton.icon(
                        onPressed: markAllAsRead,
                        icon: Icon(
                          Icons.done_all,
                          size: 16,
                          color: isDarkMode ? const Color(0xFF0EA5E9) : const Color(0xFF0284C7),
                        ),
                        label: Text(
                          'Mark all as read',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDarkMode ? const Color(0xFF0EA5E9) : const Color(0xFF0284C7),
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        ),
                      )
                    else
                      const SizedBox.shrink(),
                    TextButton.icon(
                      onPressed: clearAll,
                      icon: const Icon(
                        Icons.delete_outline,
                        size: 16,
                        color: Colors.red,
                      ),
                      label: const Text(
                        'Clear all',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      ),
                    ),
                  ],
                ),
              ),

            // Notifications List
            Expanded(
              child: notifications.isEmpty
                  ? _buildEmptyState(isDarkMode)
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        // TODAY Section
                        if (todayNotifications.isNotEmpty) ...[
                          _buildSectionHeader('TODAY', isDarkMode),
                          const SizedBox(height: 12),
                          ...todayNotifications.map((notification) => _buildNotificationItem(
                                notification,
                                isDarkMode,
                              )),
                          const SizedBox(height: 24),
                        ],

                        // YESTERDAY Section
                        if (yesterdayNotifications.isNotEmpty) ...[
                          _buildSectionHeader('YESTERDAY', isDarkMode),
                          const SizedBox(height: 12),
                          ...yesterdayNotifications.map((notification) => _buildNotificationItem(
                                notification,
                                isDarkMode,
                              )),
                          const SizedBox(height: 24),
                        ],

                        // EARLIER Section
                        if (earlierNotifications.isNotEmpty) ...[
                          _buildSectionHeader('EARLIER', isDarkMode),
                          const SizedBox(height: 12),
                          ...earlierNotifications.map((notification) => _buildNotificationItem(
                                notification,
                                isDarkMode,
                              )),
                        ],
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF1F2937) : Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_outlined,
              size: 48,
              color: isDarkMode ? const Color(0xFF4B5563) : const Color(0xFFD1D5DB),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? const Color(0xFFD1D5DB) : const Color(0xFF0A1929),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up! Check back later for updates',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? const Color(0xFF6B7280) : const Color(0xFF0284C7).withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          color: isDarkMode ? const Color(0xFF6B7280) : const Color(0xFF0284C7).withOpacity(0.7),
        ),
      ),
    );
  }

  Widget _buildNotificationItem(NotificationModel notification, bool isDarkMode) {
    final iconColor = _getIconColor(notification.type, isDarkMode);

    return Dismissible(
      key: Key(notification.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 8),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => deleteNotification(notification.id),
      child: GestureDetector(
        onTap: () {
          if (!notification.isRead) {
            markAsRead(notification.id);
          }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: EdgeInsets.only(
            left: notification.isRead ? 16 : 20,
            right: 16,
            top: 16,
            bottom: 16,
          ),
          decoration: BoxDecoration(
            color: notification.isRead
                ? (isDarkMode ? const Color(0xFF132F4C).withOpacity(0.3) : Colors.white.withOpacity(0.7))
                : (isDarkMode ? const Color(0xFF132F4C) : Colors.white),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: notification.isRead
                  ? (isDarkMode ? const Color(0xFF1E4976).withOpacity(0.5) : const Color(0xFFE5E7EB))
                  : (isDarkMode ? const Color(0xFF0EA5E9).withOpacity(0.3) : const Color(0xFF0284C7).withOpacity(0.3)),
              width: notification.isRead ? 1 : 2,
            ),
            boxShadow: notification.isRead
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Stack(
            children: [
              // Unread indicator dot
              if (!notification.isRead)
                Positioned(
                  left: -12,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isDarkMode ? const Color(0xFF0EA5E9) : const Color(0xFF0284C7),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isDarkMode ? const Color(0xFF1E4976).withOpacity(0.5) : const Color(0xFFE0F2FE),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      notification.icon,
                      size: 20,
                      color: iconColor,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isDarkMode ? Colors.white : const Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          notification.time,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDarkMode ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Delete button
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    color: isDarkMode ? const Color(0xFFEF4444) : Colors.red,
                    onPressed: () => deleteNotification(notification.id),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getIconColor(NotificationType type, bool isDarkMode) {
    if (isDarkMode) {
      switch (type) {
        case NotificationType.session:
          return const Color(0xFF0EA5E9);
        case NotificationType.message:
          return const Color(0xFF4ADE80);
        case NotificationType.update:
          return const Color(0xFFFBBF24);
        case NotificationType.achievement:
          return const Color(0xFFA78BFA);
        case NotificationType.reminder:
          return const Color(0xFFFB923C);
      }
    } else {
      switch (type) {
        case NotificationType.session:
          return const Color(0xFF0284C7);
        case NotificationType.message:
          return const Color(0xFF10B981);
        case NotificationType.update:
          return const Color(0xFFF59E0B);
        case NotificationType.achievement:
          return const Color(0xFF8B5CF6);
        case NotificationType.reminder:
          return const Color(0xFFF97316);
      }
    }
  }
}
