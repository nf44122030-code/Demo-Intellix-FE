// DEMO MODE UPDATE - Complete Figma Match
// Apply these updates to your /lib/screens/video_session_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

// KEY DEMO MODE FEATURES TO ADD:
// 1. "Demo Mode Active" badge (top-left of video)
// 2. User PiP with gradient + icon + "Demo Mode" label
// 3. Theme-adaptive colors
// 4. Proper styling to match Figma

// =============================================================================
// STEP 1: Add _useDemoMode state variable (if not exists)
// =============================================================================

class VideoSessionPageUpdated extends StatefulWidget {
  const VideoSessionPageUpdated({super.key});

  @override
  State<VideoSessionPageUpdated> createState() => _VideoSessionPageUpdatedState();
}

class _VideoSessionPageUpdatedState extends State<VideoSessionPageUpdated> {
  // ... existing state variables ...
  
  bool _useDemoMode = false; // ADD THIS if not exists
  
  // ... rest of your code ...
}

// =============================================================================
// STEP 2: Update _buildActiveSessionView method
// =============================================================================

Widget _buildActiveSessionView(bool isDarkMode) {
  return Column(
    children: [
      // Header (keep your existing code)
      Container(
        decoration: BoxDecoration(
          gradient: isDarkMode
              ? const LinearGradient(
                  colors: [Color(0xFF0369A1), Color(0xFF0EA5E9)],
                )
              : const LinearGradient(
                  colors: [Color(0xFF5B9FF3), Color(0xFF7DB6F7)],
                ),
        ),
        padding: const EdgeInsets.only(top: 40, bottom: 16, left: 16, right: 16),
        // ... your existing header content ...
      ),

      // Video Container
      Expanded(
        child: Stack(
          children: [
            // Black background
            Container(
              color: Colors.black,
              child: Stack(
                children: [
                  // Expert Video (center) - Keep your existing code
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
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

                  // ===== NEW: User Video PiP with Demo Mode Support =====
                  if (_isVideoOn)
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        width: 96,  // 24 * 4 = 96px (matches Figma w-24)
                        height: 128, // 32 * 4 = 128px (matches Figma h-32)
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? const Color(0xFF1F2937)
                              : const Color(0xFF374151),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDarkMode
                                ? Colors.white.withOpacity(0.1)
                                : Colors.white.withOpacity(0.2),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: _useDemoMode
                              ? _buildDemoModePiP(isDarkMode)
                              : _buildRealVideoPiP(),
                        ),
                      ),
                    ),

                  // ===== NEW: Demo Mode Active Badge =====
                  if (_useDemoMode)
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? const Color(0xFF0EA5E9).withOpacity(0.9)
                              : const Color(0xFF3B82F6).withOpacity(0.9),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: (isDarkMode
                                      ? const Color(0xFF0EA5E9)
                                      : const Color(0xFF3B82F6))
                                  .withOpacity(0.4),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.videocam,
                              size: 16,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Demo Mode Active',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Expert speaking indicator (bottom) - Keep your existing code
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? const Color(0xFF0A1929).withOpacity(0.7)
                            : Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.mic,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$_expertName is speaking...',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Your existing overlays (AI notes indicator, etc.)
            // ... keep your existing overlay code ...
          ],
        ),
      ),

      // Controls (keep your existing code)
      // ... your existing controls code ...
    ],
  );
}

// =============================================================================
// STEP 3: Add helper methods for demo mode PiP
// =============================================================================

Widget _buildDemoModePiP(bool isDarkMode) {
  return Stack(
    children: [
      // Gradient background
      Container(
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
        ),
        child: Center(
          child: Icon(
            Icons.person,
            size: 48,
            color: Colors.white,
          ),
        ),
      ),

      // "Demo Mode" label at bottom
      Positioned(
        bottom: 4,
        left: 4,
        right: 4,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: isDarkMode
                ? const Color(0xFF0A1929).withOpacity(0.7)
                : Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'Demo Mode',
            style: TextStyle(
              fontSize: 10,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ],
  );
}

Widget _buildRealVideoPiP() {
  // Placeholder for real video (camera access granted)
  return Container(
    color: const Color(0xFF1F2937),
    child: Center(
      child: Icon(
        Icons.person,
        size: 40,
        color: Colors.white.withOpacity(0.5),
      ),
    ),
  );
}

// =============================================================================
// COMPLETE EXAMPLE: Full Active Session View with Demo Mode
// =============================================================================

Widget buildCompleteActiveSessionView() {
  return Consumer<ThemeProvider>(
    builder: (context, themeProvider, _) {
      final isDarkMode = themeProvider.isDarkMode;

      return Column(
        children: [
          // ===== HEADER =====
          Container(
            decoration: BoxDecoration(
              gradient: isDarkMode
                  ? const LinearGradient(
                      colors: [Color(0xFF0369A1), Color(0xFF0EA5E9)],
                    )
                  : const LinearGradient(
                      colors: [Color(0xFF5B9FF3), Color(0xFF7DB6F7)],
                    ),
            ),
            padding: const EdgeInsets.only(
              top: 40,
              bottom: 16,
              left: 16,
              right: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back button
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),

                // Timer
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
                      '05:23', // _formatTime(_sessionTime)
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),

                // Action buttons (notes, chat)
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_note, color: Colors.white),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.chat_bubble, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ===== VIDEO CONTAINER =====
          Expanded(
            child: Container(
              color: Colors.black,
              child: Stack(
                children: [
                  // Expert video (center)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
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
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Dr. Sarah Johnson',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          'Business Strategy Consultant',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ===== USER VIDEO PiP (TOP-RIGHT) =====
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      width: 96,
                      height: 128,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDarkMode
                              ? Colors.white.withOpacity(0.1)
                              : Colors.white.withOpacity(0.2),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: _useDemoMode
                            ? Stack(
                                children: [
                                  // Gradient background
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: isDarkMode
                                          ? const LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Color(0xFF0369A1),
                                                Color(0xFF0EA5E9)
                                              ],
                                            )
                                          : const LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Color(0xFF5B9FF3),
                                                Color(0xFF7DB6F7)
                                              ],
                                            ),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.person,
                                        size: 48,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  // "Demo Mode" label
                                  Positioned(
                                    bottom: 4,
                                    left: 4,
                                    right: 4,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isDarkMode
                                            ? const Color(0xFF0A1929)
                                                .withOpacity(0.7)
                                            : Colors.black.withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        'Demo Mode',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container(
                                color: const Color(0xFF1F2937),
                                child: Center(
                                  child: Icon(
                                    Icons.person,
                                    size: 40,
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),

                  // ===== DEMO MODE BADGE (TOP-LEFT) =====
                  if (_useDemoMode)
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? const Color(0xFF0EA5E9).withOpacity(0.9)
                              : const Color(0xFF3B82F6).withOpacity(0.9),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: (isDarkMode
                                      ? const Color(0xFF0EA5E9)
                                      : const Color(0xFF3B82F6))
                                  .withOpacity(0.4),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.videocam,
                              size: 16,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Demo Mode Active',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // ===== EXPERT SPEAKING INDICATOR (BOTTOM) =====
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? const Color(0xFF0A1929).withOpacity(0.7)
                            : Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.mic,
                            size: 16,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Dr. Sarah Johnson is speaking...',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ===== CONTROLS (BOTTOM) =====
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? const Color(0xFF132F4C)
                  : Colors.white,
              border: Border(
                top: BorderSide(
                  color: isDarkMode
                      ? const Color(0xFF1E4976)
                      : const Color(0xFFE5E7EB),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Mic button
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF374151),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.mic,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),

                // Video button
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF374151),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.videocam,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),

                // End call button
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                  child: Transform.rotate(
                    angle: 2.35619, // 135 degrees in radians
                    child: const Icon(
                      Icons.phone,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Fullscreen button
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF374151),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.fullscreen,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
