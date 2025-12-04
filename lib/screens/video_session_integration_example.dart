// EXAMPLE: How to integrate the new Camera Permission Dialog
// Apply these changes to your /lib/screens/video_session_page.dart

import 'package:flutter/material.dart';
import '../widgets/camera_permission_dialog.dart';
import '../utils/permissions_helper_updated.dart';

// In your VideoSessionPage class, replace the _verifyCode method:

class VideoSessionPageExample extends StatefulWidget {
  const VideoSessionPageExample({super.key});

  @override
  State<VideoSessionPageExample> createState() => _VideoSessionPageExampleState();
}

class _VideoSessionPageExampleState extends State<VideoSessionPageExample> {
  String _sessionState = 'code-entry';
  bool _useDemoMode = false;

  // UPDATED: New _verifyCode method with beautiful dialog
  Future<void> _verifyCode() async {
    // Show the beautiful permission dialog
    final result = await PermissionsHelper.showPermissionDialog(context);

    if (!mounted) return;

    // Handle the result
    switch (result) {
      case PermissionDialogResult.allowed:
        // User granted permissions - start session normally
        setState(() {
          _useDemoMode = false;
          _sessionState = 'connecting';
        });
        _startSession();
        break;

      case PermissionDialogResult.demoMode:
        // User chose demo mode - start session in demo mode
        setState(() {
          _useDemoMode = true;
          _sessionState = 'connecting';
        });
        _startSession();
        break;

      case PermissionDialogResult.denied:
      case PermissionDialogResult.cancelled:
        // User denied or cancelled - stay on code entry
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Permissions are required to join video sessions'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        break;
    }
  }

  void _startSession() {
    // Simulate connecting delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _sessionState = 'active';
        });
        // Start timer, AI notes, etc.
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Your existing build code
      ),
    );
  }
}

// ALTERNATIVE: Direct usage without helper
// You can also call the dialog directly:

Future<void> _verifyCodeDirect() async {
  await showCameraPermissionDialog(
    context: context,
    onAllow: () async {
      // Handle permission grant
      final granted = await PermissionsHelper.requestVideoCallPermissions(context);
      if (granted && mounted) {
        setState(() {
          _useDemoMode = false;
          _sessionState = 'connecting';
        });
        _startSession();
      }
    },
    onDemoMode: () {
      // Handle demo mode
      setState(() {
        _useDemoMode = true;
        _sessionState = 'connecting';
      });
      _startSession();
    },
    onCancel: () {
      // Handle cancel
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Video session cancelled'),
        ),
      );
    },
  );
}
