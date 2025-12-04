import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/glowing_pill_3d.dart';
import 'profile_page.dart';
import 'trends_page.dart';
import 'settings_page.dart';
import 'help_page.dart';
import 'expert_session_page.dart';
import 'pricing_page.dart';
import 'video_session_page.dart';
import 'ai_assistant_page.dart';
import 'explore_page.dart';
import 'notes_history_page.dart';
import 'what_is_intellix_page.dart';
import 'notification_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  String _currentPage = 'home';
  final TextEditingController _chatController = TextEditingController();

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          _currentPage = 'home';
          break;
        case 1:
          _currentPage = 'explore';
          break;
        case 2:
          // Plus button - Show options
          _showQuickActionsDialog();
          break;
        case 3:
          _currentPage = 'ai';
          break;
        case 4:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfilePage()),
          );
          break;
      }
    });
  }

  void _showQuickActionsDialog() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF132F4C) : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF1E4976) : const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : const Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 24),
            _buildQuickAction(
              icon: Icons.video_call,
              title: 'Book Expert Session',
              subtitle: 'Schedule a video call with an expert',
              isDarkMode: isDarkMode,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ExpertSessionPage()),
                );
              },
            ),
            _buildQuickAction(
              icon: Icons.note_add,
              title: 'Start AI Notes',
              subtitle: 'Create notes with AI assistance',
              isDarkMode: isDarkMode,
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedIndex = 3;
                  _currentPage = 'ai';
                });
              },
            ),
            _buildQuickAction(
              icon: Icons.explore,
              title: 'Explore Content',
              subtitle: 'Discover trending topics and experts',
              isDarkMode: isDarkMode,
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedIndex = 1;
                  _currentPage = 'explore';
                });
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDarkMode,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          gradient: isDarkMode
              ? const LinearGradient(
                  colors: [Color(0xFF0369A1), Color(0xFF0EA5E9)],
                )
              : const LinearGradient(
                  colors: [Color(0xFF0284C7), Color(0xFF06B6D4)],
                ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.white : const Color(0xFF2C3E50),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF7F8C8D),
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    Widget currentWidget;
    switch (_currentPage) {
      case 'ai':
        currentWidget = const AIAssistantPage();
        break;
      case 'explore':
        currentWidget = const ExplorePage();
        break;
      case 'notifications':
        currentWidget = const NotificationPage();
        break;
      default:
        currentWidget = _buildHomeContent(isDarkMode);
    }

    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(authProvider, themeProvider),
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
            // App Bar with curved bottom
            if (_currentPage != 'notifications')
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
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white, size: 24),
                      onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                    ),
                    const Text(
                      'INTELLIX',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 6,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications, color: Colors.white, size: 24),
                      onPressed: () {
                        setState(() => _currentPage = 'notifications');
                      },
                    ),
                  ],
                ),
              ),

            // Main Content
            Expanded(child: currentWidget),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(isDarkMode),
    );
  }

  Widget _buildHomeContent(bool isDarkMode) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userName = authProvider.user?.displayName ?? 'User';

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Text with Gradient
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: isDarkMode
                      ? [const Color(0xFF0EA5E9), const Color(0xFF06B6D4)]
                      : [const Color(0xFF0369A1), const Color(0xFF0EA5E9)],
                ).createShader(bounds),
                child: Text(
                  'Welcome $userName',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your intelligent assistant is ready to help you.',
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? const Color(0xFF60A5FA) : const Color(0xFF01426A),
                ),
              ),
              const SizedBox(height: 48),

              // 3D Glowing Pill Mascot
              Center(
                child: Container(
                  height: 200,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: GlowingPill3D(isDarkMode: isDarkMode),
                ),
              ),
              const SizedBox(height: 32),

              // Feature Cards
              _buildFeatureCard(
                icon: Icons.trending_up,
                title: 'View Trends',
                subtitle: 'Analyze your data insights',
                gradient: isDarkMode
                    ? const [Color(0xFF0369A1), Color(0xFF0EA5E9)]
                    : const [Color(0xFF0284C7), Color(0xFF06B6D4)],
                isDarkMode: isDarkMode,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TrendsPage()),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildFeatureCard(
                icon: Icons.video_call,
                title: 'Expert Sessions',
                subtitle: 'Connect with professionals',
                gradient: isDarkMode
                    ? const [Color(0xFF0EA5E9), Color(0xFF06B6D4)]
                    : const [Color(0xFF06B6D4), Color(0xFF0EA5E9)],
                isDarkMode: isDarkMode,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ExpertSessionPage()),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildFeatureCard(
                icon: Icons.info_outline,
                title: 'What is Intellix?',
                subtitle: 'Learn about our AI platform',
                gradient: isDarkMode
                    ? const [Color(0xFF0284C7), Color(0xFF0369A1)]
                    : const [Color(0xFF0369A1), Color(0xFF0284C7)],
                isDarkMode: isDarkMode,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WhatIsIntellixPage()),
                  );
                },
              ),
            ],
          ),
        ),

        // AI Chat Input Bar - Floating at bottom
        Positioned(
          left: 16,
          right: 16,
          bottom: 100,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: isDarkMode
                      ? const Color(0xFF0EA5E9).withOpacity(0.3)
                      : const Color(0xFF0284C7).withOpacity(0.25),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: isDarkMode
                      ? const Color(0xFF06B6D4).withOpacity(0.2)
                      : const Color(0xFF06B6D4).withOpacity(0.15),
                  blurRadius: 40,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: isDarkMode
                    ? const LinearGradient(
                        colors: [Color(0xFF132F4C), Color(0xFF0A1929)],
                      )
                    : null,
                color: isDarkMode ? null : Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: isDarkMode ? const Color(0xFF1E4976) : const Color(0xFFE0F2FE),
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _chatController,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : const Color(0xFF374151),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Ask anything...',
                        hintStyle: TextStyle(
                          color: isDarkMode
                              ? const Color(0xFF6B7280)
                              : const Color(0xFF9CA3AF),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.mic,
                      color: isDarkMode ? const Color(0xFF0EA5E9) : const Color(0xFF0284C7),
                    ),
                    onPressed: () {
                      // Handle voice input
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: isDarkMode
                          ? const LinearGradient(
                              colors: [Color(0xFF0284C7), Color(0xFF06B6D4)],
                            )
                          : const LinearGradient(
                              colors: [Color(0xFF0369A1), Color(0xFF0EA5E9)],
                            ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0EA5E9).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white, size: 20),
                      onPressed: () {
                        // Handle send message
                        if (_chatController.text.isNotEmpty) {
                          // Navigate to AI Assistant
                          setState(() {
                            _selectedIndex = 3;
                            _currentPage = 'ai';
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradient,
    required bool isDarkMode,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF132F4C) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDarkMode ? const Color(0xFF1E4976) : const Color(0xFFE0F2FE),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradient),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: gradient[0].withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : const Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF7F8C8D),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isDarkMode ? const Color(0xFF6B7280) : const Color(0xFFBDBDBD),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF132F4C) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDarkMode ? const Color(0xFF1E4976) : const Color(0xFFBAE6FD),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(
                icon: Icons.home,
                label: 'Home',
                index: 0,
                isDarkMode: isDarkMode,
              ),
              _buildNavItem(
                icon: Icons.search,
                label: 'Explore',
                index: 1,
                isDarkMode: isDarkMode,
              ),
              // Center Plus Button
              GestureDetector(
                onTap: () => _onItemTapped(2),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: isDarkMode
                        ? const LinearGradient(
                            colors: [Color(0xFF0369A1), Color(0xFF0EA5E9)],
                          )
                        : const LinearGradient(
                            colors: [Color(0xFF0284C7), Color(0xFF06B6D4)],
                          ),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDarkMode ? const Color(0xFF132F4C) : Colors.white,
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0EA5E9).withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 28),
                ),
              ),
              _buildNavItem(
                icon: Icons.smart_toy,
                label: 'AI Chat',
                index: 3,
                isDarkMode: isDarkMode,
              ),
              _buildNavItem(
                icon: Icons.person,
                label: 'Profile',
                index: 4,
                isDarkMode: isDarkMode,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isDarkMode,
  }) {
    final isActive = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isActive)
            Container(
              width: 32,
              height: 2,
              decoration: BoxDecoration(
                gradient: isDarkMode
                    ? const LinearGradient(
                        colors: [Color(0xFF0EA5E9), Color(0xFF06B6D4)],
                      )
                    : const LinearGradient(
                        colors: [Color(0xFF0284C7), Color(0xFF06B6D4)],
                      ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          const SizedBox(height: 8),
          Icon(
            icon,
            size: 24,
            color: isActive
                ? (isDarkMode ? const Color(0xFF0EA5E9) : const Color(0xFF0284C7))
                : (isDarkMode ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF)),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              color: isActive
                  ? (isDarkMode ? const Color(0xFF0EA5E9) : const Color(0xFF0284C7))
                  : (isDarkMode ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(AuthProvider authProvider, ThemeProvider themeProvider) {
    final isDarkMode = themeProvider.isDarkMode;

    return Drawer(
      backgroundColor: isDarkMode ? const Color(0xFF0A1929) : Colors.white,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: isDarkMode
                  ? const LinearGradient(
                      colors: [Color(0xFF0369A1), Color(0xFF0EA5E9)],
                    )
                  : const LinearGradient(
                      colors: [Color(0xFF0284C7), Color(0xFF06B6D4)],
                    ),
            ),
            padding: const EdgeInsets.only(top: 60, bottom: 32, left: 24, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: isDarkMode ? const Color(0xFF0EA5E9) : const Color(0xFF0284C7),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  authProvider.user?.displayName ?? 'User',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  authProvider.user?.email ?? 'user@intellix.com',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  icon: Icons.home,
                  title: 'Home',
                  isDarkMode: isDarkMode,
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _selectedIndex = 0;
                      _currentPage = 'home';
                    });
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.person,
                  title: 'Profile',
                  isDarkMode: isDarkMode,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ProfilePage()),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.trending_up,
                  title: 'Trends',
                  isDarkMode: isDarkMode,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TrendsPage()),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.settings,
                  title: 'Settings',
                  isDarkMode: isDarkMode,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SettingsPage()),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.help,
                  title: 'Help Center',
                  isDarkMode: isDarkMode,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HelpPage()),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.video_call,
                  title: 'Expert Sessions',
                  isDarkMode: isDarkMode,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ExpertSessionPage()),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.credit_card,
                  title: 'Pricing',
                  isDarkMode: isDarkMode,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PricingPage()),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.info,
                  title: 'What is Intellix',
                  isDarkMode: isDarkMode,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const WhatIsIntellixPage()),
                    );
                  },
                ),
                Divider(
                  color: isDarkMode ? const Color(0xFF1E4976) : const Color(0xFFE0E0E0),
                ),
                ListTile(
                  leading: Icon(
                    isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    color: isDarkMode ? const Color(0xFF0EA5E9) : const Color(0xFF0284C7),
                  ),
                  title: Text(
                    isDarkMode ? 'Light Mode' : 'Dark Mode',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : const Color(0xFF2C3E50),
                    ),
                  ),
                  onTap: () {
                    themeProvider.toggleTheme();
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.logout,
                  title: 'Logout',
                  isDarkMode: isDarkMode,
                  onTap: () {
                    authProvider.logout();
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required bool isDarkMode,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDarkMode ? const Color(0xFF0EA5E9) : const Color(0xFF0284C7),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDarkMode ? Colors.white : const Color(0xFF2C3E50),
        ),
      ),
      onTap: onTap,
    );
  }
}
