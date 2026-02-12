import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_super_admin/features/communication/presentation/pages/call_page.dart';
import '../../data/repositories/call_repository.dart';
import '../../data/models/call_model.dart';

class OutgoingCallPage extends StatelessWidget {
  final String callId;
  final String currentUserName; // Add this - needed for Zego UI
  
  const OutgoingCallPage({
    super.key,
    required this.callId,
    required this.currentUserName,
  });

  @override
  Widget build(BuildContext context) {
    final repo = context.read<CallRepository>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('calls')
            .doc(callId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>?;
          
          // Handle case where call document doesn't exist or was deleted
          if (data == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pop(context);
            });
            return const SizedBox.shrink();
          }

          final status = data['status'];
          final callType = data['callType'];

          // ✅ Receiver accepted - Navigate to Zego call page
          if (status == 'accepted') {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // Create CallModel from the data
              final call = CallModel.fromDoc(snapshot.data!);
              
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => ZegoCallPage(
                    call: call,
                    userName: currentUserName,
                    isVideoCall: callType == 'video',
                  ),
                ),
              );
            });
          }

          // ❌ Rejected or ended - Go back
          if (status == 'rejected' || status == 'ended') {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pop(context);
              
              // Optional: Show a message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    status == 'rejected' 
                        ? 'Call was rejected' 
                        : 'Call ended',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            });
          }

          // 📞 Ringing UI (while waiting for receiver to accept)
          return SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Call type icon
                Icon(
                  callType == 'video' ? Icons.videocam : Icons.call,
                  size: 80,
                  color: Colors.green,
                ),
                
                const SizedBox(height: 30),
                
                // Calling status
                const Text(
                  'Calling...',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 10),
                
                // Call type text
                Text(
                  callType == 'video' ? 'Video Call' : 'Audio Call',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Animated ringing indicator
                const SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ),
                
                const SizedBox(height: 60),
                
                // Cancel button
                ElevatedButton.icon(
                  onPressed: () async {
                    await repo.endCall(callId);
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  icon: const Icon(Icons.call_end),
                  label: const Text(
                    'Cancel Call',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}