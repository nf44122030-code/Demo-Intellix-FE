import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class CameraPermissionDialog extends StatefulWidget {
  final VoidCallback onAllow;
  final VoidCallback onDemoMode;
  final VoidCallback onCancel;

  const CameraPermissionDialog({
    super.key,
    required this.onAllow,
    required this.onDemoMode,
    required this.onCancel,
  });

  @override
  State<CameraPermissionDialog> createState() => _CameraPermissionDialogState();
}

class _CameraPermissionDialogState extends State<CameraPermissionDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          color: (isDarkMode ? const Color(0xFF0A1929) : Colors.black)
              .withOpacity(0.5 * _opacityAnimation.value),
          child: BackdropFilter(
            filter: ColorFilter.mode(
              Colors.transparent,
              BlendMode.srcOver,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Opacity(
                    opacity: _opacityAnimation.value,
                    child: _buildDialog(isDarkMode),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDialog(bool isDarkMode) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF132F4C) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with gradient
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: isDarkMode
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF0369A1), Color(0xFF0EA5E9)],
                    )
                  : const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF5B9FF3), Color(0xFF7DB6F7)],
                    ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(isDarkMode ? 0.1 : 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.videocam,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Camera & Microphone Access',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Choose how you'd like to join this video session',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF6B7280),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Camera feature card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? const Color(0xFF0EA5E9).withOpacity(0.1)
                        : const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDarkMode
                          ? const Color(0xFF0EA5E9).withOpacity(0.2)
                          : const Color(0xFFDEEAFF),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.videocam,
                        size: 20,
                        color: isDarkMode
                            ? const Color(0xFF0EA5E9)
                            : const Color(0xFF5B9FF3),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Camera',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isDarkMode
                                    ? Colors.white
                                    : const Color(0xFF1F2937),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'For video communication with the expert',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDarkMode
                                    ? const Color(0xFF9CA3AF)
                                    : const Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Microphone feature card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? const Color(0xFF0EA5E9).withOpacity(0.1)
                        : const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDarkMode
                          ? const Color(0xFF0EA5E9).withOpacity(0.2)
                          : const Color(0xFFDEEAFF),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.mic,
                        size: 20,
                        color: isDarkMode
                            ? const Color(0xFF0EA5E9)
                            : const Color(0xFF5B9FF3),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Microphone',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isDarkMode
                                    ? Colors.white
                                    : const Color(0xFF1F2937),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'To speak and ask questions during the session',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDarkMode
                                    ? const Color(0xFF9CA3AF)
                                    : const Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Demo mode info card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? const Color(0xFF06B6D4).withOpacity(0.1)
                        : const Color(0xFFCFFAFE),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDarkMode
                          ? const Color(0xFF06B6D4).withOpacity(0.3)
                          : const Color(0xFF67E8F9),
                    ),
                  ),
                  child: Text(
                    '💡 Don't have a camera? Use Demo Mode to explore the interface',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode
                          ? const Color(0xFF22D3EE)
                          : const Color(0xFF0E7490),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 12),

                // Privacy info card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? const Color(0xFFF59E0B).withOpacity(0.1)
                        : const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDarkMode
                          ? const Color(0xFFF59E0B).withOpacity(0.3)
                          : const Color(0xFFFDE68A),
                    ),
                  ),
                  child: Text(
                    '🔒 Your privacy is protected. We never record or store your video without permission.',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode
                          ? const Color(0xFFFBBF24)
                          : const Color(0xFF92400E),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),

                // Action buttons
                Column(
                  children: [
                    // Allow access button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: widget.onAllow,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: isDarkMode
                                ? const LinearGradient(
                                    colors: [Color(0xFF0369A1), Color(0xFF0EA5E9)],
                                  )
                                : const LinearGradient(
                                    colors: [Color(0xFF5B9FF3), Color(0xFF7DB6F7)],
                                  ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            alignment: Alignment.center,
                            child: const Text(
                              'Allow Access & Continue',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Demo mode button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: widget.onDemoMode,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(
                            color: isDarkMode
                                ? const Color(0xFF1E4976)
                                : const Color(0xFFD1D5DB),
                            width: 2,
                          ),
                          backgroundColor: isDarkMode
                              ? const Color(0xFF0A1929)
                              : const Color(0xFFF3F4F6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Continue in Demo Mode',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isDarkMode
                                ? const Color(0xFFD1D5DB)
                                : const Color(0xFF374151),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Cancel button
                    TextButton(
                      onPressed: widget.onCancel,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode
                              ? const Color(0xFF9CA3AF)
                              : const Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Helper function to show the dialog
Future<void> showCameraPermissionDialog({
  required BuildContext context,
  required VoidCallback onAllow,
  required VoidCallback onDemoMode,
  required VoidCallback onCancel,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (context) => CameraPermissionDialog(
      onAllow: () {
        Navigator.of(context).pop();
        onAllow();
      },
      onDemoMode: () {
        Navigator.of(context).pop();
        onDemoMode();
      },
      onCancel: () {
        Navigator.of(context).pop();
        onCancel();
      },
    ),
  );
}
