import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_super_admin/features/communication/presentation/pages/call_page.dart';
import '../../data/models/call_model.dart';
import '../blocs/call_action/call_action_bloc.dart';
import '../blocs/call_action/call_action_event.dart';
import '../blocs/call_action/call_action_state.dart';

/// Dialog that shows when receiving an incoming call
class IncomingCallDialog extends StatelessWidget {
  final CallModel call;
  final String callerName;
  final String currentUserName;

  const IncomingCallDialog({
    super.key,
    required this.call,
    required this.callerName,
    required this.currentUserName,
  });

  /// Show this dialog
  static void show(
    BuildContext context,
    CallModel call,
    String callerName,
    String currentUserName,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => IncomingCallDialog(
        call: call,
        callerName: callerName,
        currentUserName: currentUserName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CallActionBloc, CallActionState>(
      listener: (context, state) {
        if (state is CallAccepted) {
          // Navigate to call page
          Navigator.of(context).pop(); // Close dialog
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ZegoCallPage(
                call: call,
                userName: currentUserName,
                isVideoCall: call.callType == 'video',
              ),
            ),
          );
        } else if (state is CallRejected) {
          Navigator.of(context).pop(); // Close dialog
        } else if (state is CallActionError) {
          Navigator.of(context).pop(); // Close dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Column(
          children: [
            Icon(
              call.callType == 'video' ? Icons.videocam : Icons.call,
              size: 60,
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            Text(
              'Incoming ${call.callType == 'video' ? 'Video' : 'Audio'} Call',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              callerName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'is calling you...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        actions: [
          // Reject Button
          ElevatedButton.icon(
            onPressed: () {
              context.read<CallActionBloc>().add(RejectCallEvent(call));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            icon: const Icon(Icons.call_end),
            label: const Text('Reject'),
          ),
          
          // Accept Button
          ElevatedButton.icon(
            onPressed: () {
              context.read<CallActionBloc>().add(AcceptCallEvent(call));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            icon: const Icon(Icons.call),
            label: const Text('Accept'),
          ),
        ],
      ),
    );
  }
}