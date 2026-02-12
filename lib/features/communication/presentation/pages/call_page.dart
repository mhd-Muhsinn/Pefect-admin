import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import '../../data/repositories/call_repository.dart';
import '../../data/models/call_model.dart';

/// Configuration class for Zego
class ZegoConfig {
  // Get your AppID and AppSign from Zego Console
  // https://console.zegocloud.com/
  static const int appID = 599119680; // Replace with your App ID
  static const String appSign =
      '6913bd6f0bddcab25362915116f7e0c5e3978e0e77f03cf181eebfb213b2c2b7'; // Replace with your App Sign
}

/// Universal call page for both audio and video calls using Zego UIKit
class ZegoCallPage extends StatefulWidget {
  final CallModel call;
  final String userName;
  final bool isVideoCall;

  const ZegoCallPage({
    super.key,
    required this.call,
    required this.userName,
    required this.isVideoCall,
  });

  @override
  State<ZegoCallPage> createState() => _ZegoCallPageState();
}

class _ZegoCallPageState extends State<ZegoCallPage> {
  @override
  Widget build(BuildContext context) {
    final repo = context.read<CallRepository>();
    final currentUserId = repo.currentUserId;

    return ZegoUIKitPrebuiltCall(
      appID: ZegoConfig.appID,
      appSign: ZegoConfig.appSign,
      userID: currentUserId,
      userName: widget.userName,
      callID: widget.call.id,
      events: ZegoUIKitPrebuiltCallEvents(
        onCallEnd: (ZegoCallEndEvent event, VoidCallback defaultAction) {
          _handleCallEnd(repo);
          defaultAction();
        },
        onHangUpConfirmation: (
          ZegoCallHangUpConfirmationEvent event,
          Future<bool> Function() defaultAction,
        ) async {
          // Option 1: Show confirmation dialog
          final shouldHangUp = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('End Call'),
              content: const Text('Are you sure you want to end this call?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('End Call'),
                ),
              ],
            ),
          );

          // If user confirmed, call defaultAction to proceed with hang up
          if (shouldHangUp == true) {
            return await defaultAction();
          }

          // User cancelled, don't hang up
          return false;
        },
      ),
      config: widget.isVideoCall
          ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
          : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
        ..hangUpConfirmDialog = ZegoCallHangUpConfirmDialogConfig(
            info: ZegoCallHangUpConfirmDialogInfo())

        // Audio/Video view configuration
        ..audioVideoView = ZegoCallAudioVideoViewConfig(
          showSoundWavesInAudioMode: true,
          useVideoViewAspectFill: true,
        )
        // Top menu bar configuration
        ..topMenuBar = ZegoCallTopMenuBarConfig(
          isVisible: true,
          buttons: [
            ZegoCallMenuBarButtonName.minimizingButton,
            ZegoCallMenuBarButtonName.showMemberListButton,
          ],
        )
        // ✅ Bottom menu bar configuration
        ..bottomMenuBar = ZegoCallBottomMenuBarConfig(
          buttons: widget.isVideoCall
              ? [
                  ZegoCallMenuBarButtonName.toggleCameraButton,
                  ZegoCallMenuBarButtonName.toggleMicrophoneButton,
                  ZegoCallMenuBarButtonName.hangUpButton,
                  ZegoCallMenuBarButtonName.switchCameraButton,
                ]
              : [
                  ZegoCallMenuBarButtonName.toggleMicrophoneButton,
                  ZegoCallMenuBarButtonName.hangUpButton,
                  ZegoCallMenuBarButtonName.switchAudioOutputButton,
                ],
        )
        // ✅ Custom avatar (simplified version)
        ..avatarBuilder = (context, size, user, extraInfo) {
          final userName = user?.name ?? 'User';
          return Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
            child: Center(
              child: Text(
                userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                style: TextStyle(
                  fontSize: size.width * 0.3,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
    );
  }

  void _handleCallEnd(CallRepository repo) {
    // Update call status in Firestore
    repo.endCall(widget.call.id).then((_) {
      // Pop back to previous screen
      if (mounted) {
        Navigator.of(context).pop();
      }
    }).catchError((error) {
      debugPrint('Error ending call: $error');
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }
}
