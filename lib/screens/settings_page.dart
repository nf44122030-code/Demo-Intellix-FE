import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _autoSave = true;
  String _language = 'English';

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final isDarkMode = themeProvider.isDarkMode;
        final iconColor = isDarkMode ? const Color(0xFF0EA5E9) : const Color(0xFF0284C7);
        final cardBg = isDarkMode ? const Color(0xFF132F4C) : Colors.white;
        final cardBorder = isDarkMode ? const Color(0xFF1E4976) : const Color(0xFFBAE6FD);
        final borderColor = isDarkMode ? const Color(0xFF1E4976) : const Color(0xFFE0F2FE);

        return Scaffold(
          backgroundColor: isDarkMode
              ? const Color(0xFF0A1929)
              : const Color(0xFFF0F9FF),
          body: Stack(
            children: [
              Column(
                children: [
                  // ===== CURVED APP BAR =====
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
                              colors: [
                                Color(0xFF0284C7),
                                Color(0xFF0EA5E9),
                                Color(0xFF06B6D4),
                              ],
                            ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.only(
                      top: 40,
                      bottom: 96, // Extra space for icon overlay
                      left: 24,
                      right: 24,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Text(
                          'SETTINGS',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 4.8,
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),

                  // ===== SCROLLABLE CONTENT =====
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(
                        top: 80, // Space for icon overlay
                        left: 24,
                        right: 24,
                        bottom: 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ===== ACCOUNT SECTION =====
                          _buildSectionHeader('ACCOUNT', isDarkMode),
                          const SizedBox(height: 12),
                          _buildCard(
                            isDarkMode: isDarkMode,
                            cardBg: cardBg,
                            cardBorder: cardBorder,
                            borderColor: borderColor,
                            children: [
                              _buildSettingsItem(
                                icon: Icons.person,
                                label: 'Edit Profile',
                                iconColor: iconColor,
                                isDarkMode: isDarkMode,
                                showBorder: true,
                                borderColor: borderColor,
                                onTap: () {},
                              ),
                              _buildSettingsItem(
                                icon: Icons.email,
                                label: 'Change Email',
                                iconColor: iconColor,
                                isDarkMode: isDarkMode,
                                showBorder: true,
                                borderColor: borderColor,
                                onTap: () {},
                              ),
                              _buildSettingsItem(
                                icon: Icons.lock,
                                label: 'Change Password',
                                iconColor: iconColor,
                                isDarkMode: isDarkMode,
                                showBorder: false,
                                borderColor: borderColor,
                                onTap: () {},
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // ===== NOTIFICATIONS SECTION =====
                          _buildSectionHeader('NOTIFICATIONS', isDarkMode),
                          const SizedBox(height: 12),
                          _buildCard(
                            isDarkMode: isDarkMode,
                            cardBg: cardBg,
                            cardBorder: cardBorder,
                            borderColor: borderColor,
                            children: [
                              _buildToggleItem(
                                icon: Icons.notifications,
                                label: 'All Notifications',
                                value: _notificationsEnabled,
                                iconColor: iconColor,
                                isDarkMode: isDarkMode,
                                showBorder: true,
                                borderColor: borderColor,
                                onChanged: (value) {
                                  setState(() => _notificationsEnabled = value);
                                },
                              ),
                              _buildToggleItem(
                                icon: Icons.email,
                                label: 'Email Notifications',
                                value: _emailNotifications,
                                iconColor: iconColor,
                                isDarkMode: isDarkMode,
                                showBorder: true,
                                borderColor: borderColor,
                                onChanged: (value) {
                                  setState(() => _emailNotifications = value);
                                },
                              ),
                              _buildToggleItem(
                                icon: Icons.phone_android,
                                label: 'Push Notifications',
                                value: _pushNotifications,
                                iconColor: iconColor,
                                isDarkMode: isDarkMode,
                                showBorder: false,
                                borderColor: borderColor,
                                onChanged: (value) {
                                  setState(() => _pushNotifications = value);
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // ===== APPEARANCE SECTION =====
                          _buildSectionHeader('APPEARANCE', isDarkMode),
                          const SizedBox(height: 12),
                          _buildCard(
                            isDarkMode: isDarkMode,
                            cardBg: cardBg,
                            cardBorder: cardBorder,
                            borderColor: borderColor,
                            children: [
                              _buildToggleItem(
                                icon: isDarkMode
                                    ? Icons.dark_mode
                                    : Icons.light_mode,
                                label: 'Dark Mode',
                                value: isDarkMode,
                                iconColor: iconColor,
                                isDarkMode: isDarkMode,
                                showBorder: true,
                                borderColor: borderColor,
                                onChanged: (value) {
                                  themeProvider.toggleTheme();
                                },
                              ),
                              _buildSelectItem(
                                icon: Icons.language,
                                label: 'Language',
                                value: _language,
                                iconColor: iconColor,
                                isDarkMode: isDarkMode,
                                showBorder: false,
                                borderColor: borderColor,
                                onTap: () {
                                  // Show language picker
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // ===== PREFERENCES SECTION =====
                          _buildSectionHeader('PREFERENCES', isDarkMode),
                          const SizedBox(height: 12),
                          _buildCard(
                            isDarkMode: isDarkMode,
                            cardBg: cardBg,
                            cardBorder: cardBorder,
                            borderColor: borderColor,
                            children: [
                              _buildToggleItem(
                                icon: Icons.download,
                                label: 'Auto-Save Data',
                                value: _autoSave,
                                iconColor: iconColor,
                                isDarkMode: isDarkMode,
                                showBorder: false,
                                borderColor: borderColor,
                                onChanged: (value) {
                                  setState(() => _autoSave = value);
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // ===== PRIVACY & SECURITY SECTION =====
                          _buildSectionHeader('PRIVACY & SECURITY', isDarkMode),
                          const SizedBox(height: 12),
                          _buildCard(
                            isDarkMode: isDarkMode,
                            cardBg: cardBg,
                            cardBorder: cardBorder,
                            borderColor: borderColor,
                            children: [
                              _buildSettingsItem(
                                icon: Icons.shield,
                                label: 'Privacy Policy',
                                iconColor: iconColor,
                                isDarkMode: isDarkMode,
                                showBorder: true,
                                borderColor: borderColor,
                                onTap: () {},
                              ),
                              _buildSettingsItem(
                                icon: Icons.description,
                                label: 'Terms & Conditions',
                                iconColor: iconColor,
                                isDarkMode: isDarkMode,
                                showBorder: true,
                                borderColor: borderColor,
                                onTap: () {},
                              ),
                              _buildSettingsItem(
                                icon: Icons.lock,
                                label: 'Security Settings',
                                iconColor: iconColor,
                                isDarkMode: isDarkMode,
                                showBorder: false,
                                borderColor: borderColor,
                                onTap: () {},
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // ===== SUPPORT SECTION =====
                          _buildSectionHeader('SUPPORT', isDarkMode),
                          const SizedBox(height: 12),
                          _buildCard(
                            isDarkMode: isDarkMode,
                            cardBg: cardBg,
                            cardBorder: cardBorder,
                            borderColor: borderColor,
                            children: [
                              _buildSettingsItem(
                                icon: Icons.help_outline,
                                label: 'Help Center',
                                iconColor: iconColor,
                                isDarkMode: isDarkMode,
                                showBorder: true,
                                borderColor: borderColor,
                                onTap: () {},
                              ),
                              _buildSettingsItem(
                                icon: Icons.email,
                                label: 'Contact Support',
                                iconColor: iconColor,
                                isDarkMode: isDarkMode,
                                showBorder: false,
                                borderColor: borderColor,
                                onTap: () {},
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // ===== DANGER ZONE =====
                          _buildSectionHeader('DANGER ZONE', isDarkMode),
                          const SizedBox(height: 12),
                          _buildCard(
                            isDarkMode: isDarkMode,
                            cardBg: cardBg,
                            cardBorder: cardBorder,
                            borderColor: borderColor,
                            children: [
                              InkWell(
                                onTap: () {
                                  // Show delete confirmation dialog
                                  _showDeleteAccountDialog(context, isDarkMode);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.delete_outline,
                                        size: 20,
                                        color: Colors.red[600],
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Delete Account',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.red[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),

                          // ===== APP VERSION FOOTER =====
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  'Intellix v1.0.0',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isDarkMode
                                        ? const Color(0xFF6B7280)
                                        : const Color(0xFF9CA3AF),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '© 2025 All rights reserved',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDarkMode
                                        ? const Color(0xFF6B7280)
                                        : const Color(0xFF9CA3AF),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // ===== ICON OVERLAY (128px) =====
              Positioned(
                top: 120,
                left: MediaQuery.of(context).size.width / 2 - 64,
                child: Container(
                  width: 128,
                  height: 128,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.settings,
                    size: 64,
                    color: iconColor,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isDarkMode
              ? const Color(0xFF6B7280)
              : const Color(0xFF6B7280),
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildCard({
    required bool isDarkMode,
    required Color cardBg,
    required Color cardBorder,
    required Color borderColor,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String label,
    required Color iconColor,
    required bool isDarkMode,
    required bool showBorder,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: showBorder
              ? Border(bottom: BorderSide(color: borderColor))
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: iconColor),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode
                        ? const Color(0xFFD1D5DB)
                        : const Color(0xFF374151),
                  ),
                ),
              ],
            ),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: isDarkMode
                  ? const Color(0xFF6B7280)
                  : const Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleItem({
    required IconData icon,
    required String label,
    required bool value,
    required Color iconColor,
    required bool isDarkMode,
    required bool showBorder,
    required Color borderColor,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: showBorder
            ? Border(bottom: BorderSide(color: borderColor))
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: iconColor),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode
                      ? const Color(0xFFD1D5DB)
                      : const Color(0xFF374151),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => onChanged(!value),
            child: Container(
              width: 48,
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: value
                    ? (isDarkMode
                        ? const Color(0xFF0EA5E9)
                        : const Color(0xFF0284C7))
                    : (isDarkMode
                        ? const Color(0xFF1E4976)
                        : const Color(0xFFBAE6FD)),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectItem({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
    required bool isDarkMode,
    required bool showBorder,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: showBorder
              ? Border(bottom: BorderSide(color: borderColor))
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: iconColor),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode
                        ? const Color(0xFFD1D5DB)
                        : const Color(0xFF374151),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode
                        ? const Color(0xFF6B7280)
                        : const Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: isDarkMode
                      ? const Color(0xFF6B7280)
                      : const Color(0xFF9CA3AF),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? const Color(0xFF132F4C) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Delete Account?',
          style: TextStyle(
            color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'This action is permanent and cannot be undone. All your data will be permanently deleted.',
          style: TextStyle(
            color: isDarkMode
                ? const Color(0xFF9CA3AF)
                : const Color(0xFF6B7280),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isDarkMode
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFF6B7280),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle account deletion
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
