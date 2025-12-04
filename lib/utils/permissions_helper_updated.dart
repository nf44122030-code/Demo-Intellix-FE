// UPDATED PERMISSIONS HELPER - Matches Figma Design
// Replace the contents of /lib/utils/permissions_helper.dart with this code

import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import '../widgets/camera_permission_dialog.dart';

class PermissionsHelper {
  /// Show the beautiful permission dialog (Figma design)
  /// Returns true if user allowed permissions or chose demo mode
  static Future<PermissionDialogResult> showPermissionDialog(
    BuildContext context,
  ) async {
    PermissionDialogResult? result;

    await showCameraPermissionDialog(
      context: context,
      onAllow: () async {
        // Request permissions
        final granted = await _requestPermissions(context);
        result = granted
            ? PermissionDialogResult.allowed
            : PermissionDialogResult.denied;
      },
      onDemoMode: () {
        result = PermissionDialogResult.demoMode;
      },
      onCancel: () {
        result = PermissionDialogResult.cancelled;
      },
    );

    return result ?? PermissionDialogResult.cancelled;
  }

  /// Request camera and microphone permissions
  static Future<bool> _requestPermissions(BuildContext context) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    final cameraGranted = statuses[Permission.camera]?.isGranted ?? false;
    final microphoneGranted = statuses[Permission.microphone]?.isGranted ?? false;

    if (!cameraGranted || !microphoneGranted) {
      // Show settings dialog if permanently denied
      if (context.mounted) {
        final cameraPermanentlyDenied =
            statuses[Permission.camera]?.isPermanentlyDenied ?? false;
        final micPermanentlyDenied =
            statuses[Permission.microphone]?.isPermanentlyDenied ?? false;

        if (cameraPermanentlyDenied || micPermanentlyDenied) {
          await _showOpenSettingsDialog(context);
        }
      }
      return false;
    }

    return true;
  }

  /// Check if video call permissions are already granted
  static Future<bool> hasVideoCallPermissions() async {
    final cameraStatus = await Permission.camera.status;
    final microphoneStatus = await Permission.microphone.status;

    return cameraStatus.isGranted && microphoneStatus.isGranted;
  }

  /// Request video call permissions (for backward compatibility)
  static Future<bool> requestVideoCallPermissions(BuildContext context) async {
    return await _requestPermissions(context);
  }

  /// Show rationale before requesting (for backward compatibility)
  static Future<bool> showPermissionRationale(BuildContext context) async {
    final result = await showPermissionDialog(context);
    return result == PermissionDialogResult.allowed ||
        result == PermissionDialogResult.demoMode;
  }

  /// Show dialog to open app settings
  static Future<void> _showOpenSettingsDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Permissions Required'),
        content: const Text(
          'Camera and microphone access is required for video sessions.\n\n'
          'Please enable these permissions in your device settings.',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5B9FF3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Open Settings',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

/// Result from permission dialog
enum PermissionDialogResult {
  allowed,    // User granted permissions
  demoMode,   // User chose demo mode
  denied,     // User denied permissions
  cancelled,  // User cancelled the dialog
}
