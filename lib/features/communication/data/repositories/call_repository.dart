import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/call_model.dart';

class CallRepository {
  final _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get currentUserId => _auth.currentUser!.uid;

  // Listen incoming calls
  Stream<List<CallModel>> listenIncoming() {
    return _db
        .collection('calls')
        .where('receiverId', isEqualTo: currentUserId)
        .where('status', isEqualTo: 'ringing')
        .snapshots()
        .map((s) => s.docs.map(CallModel.fromDoc).toList());
  }


  Future<CallModel> startCall({
    required String receiverId,
    required String callType,
    required String callerName, 
  }) async {
    final callId = 'call_${currentUserId}_${receiverId}_${DateTime.now().millisecondsSinceEpoch}';

    final docRef = _db.collection('calls').doc(callId);
    
    await docRef.set({
      'callerId': currentUserId,
      'receiverId': receiverId,
      'callType': callType,
      'callerName': callerName,
      'callId': callId, // Used as Zego channel ID
      'status': 'ringing',
      'createdAt': FieldValue.serverTimestamp(),
    });

    final doc = await docRef.get();
    return CallModel.fromDoc(doc);
  }

  // Accept call
  Future<void> acceptCall(CallModel call) async {
    await _db.runTransaction((tx) async {
      // Check if user is already in another active call
      final active = await _db
          .collection('calls')
          .where('receiverId', isEqualTo: call.receiverId)
          .where('status', isEqualTo: 'accepted')
          .get();

      if (active.docs.isNotEmpty) {
        throw Exception('User is already in another call');
      }

      // Update this call to accepted
      tx.update(
        _db.collection('calls').doc(call.id),
        {
          'status': 'accepted',
          'acceptedAt': FieldValue.serverTimestamp(),
        },
      );
    });

    // Auto-reject other incoming calls
    final others = await _db
        .collection('calls')
        .where('receiverId', isEqualTo: call.receiverId)
        .where('status', isEqualTo: 'ringing')
        .get();

    for (final d in others.docs) {
      if (d.id != call.id) {
        await d.reference.update({
          'status': 'rejected',
          'rejectedAt': FieldValue.serverTimestamp(),
        });
      }
    }
  }

  // Reject call
  Future<void> rejectCall(String callId) async {
    await _db.collection('calls').doc(callId).update({
      'status': 'rejected',
      'rejectedAt': FieldValue.serverTimestamp(),
    });
  }

  // End call
  Future<void> endCall(String callId) async {
    await _db.collection('calls').doc(callId).update({
      'status': 'ended',
      'endedAt': FieldValue.serverTimestamp(),
    });
  }

  // Get call by ID
  Future<CallModel?> getCall(String callId) async {
    final doc = await _db.collection('calls').doc(callId).get();
    if (!doc.exists) return null;
    return CallModel.fromDoc(doc);
  }

  // Listen to specific call status changes
  Stream<CallModel?> listenToCall(String callId) {
    return _db
        .collection('calls')
        .doc(callId)
        .snapshots()
        .map((doc) => doc.exists ? CallModel.fromDoc(doc) : null);
  }
}