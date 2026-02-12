import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:perfect_super_admin/features/communication/data/models/message.dart';

class ChatService {
  //instance of firestore or auth
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //get all users
  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection("users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  //get all Trainers
  Stream<List<Map<String, dynamic>>> getTrainersStream() {
    return _firestore.collection("tutors").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        user["uid"] = doc.id;
        return user;
      }).toList();
    });
  }

  //Send Messages
  Future<void> sendMessage(String receiverId, String message) async {
    final String adminId = _auth.currentUser!.uid;
    final Timestamp timestamp = Timestamp.now();

    List<String> ids = [adminId, receiverId];
    ids.sort();
    String chatRoomID = ids.join('_');

    final newMessage = {
      'senderID': adminId,
      'receiverID': receiverId,
      'message': message,
      'timestamp': timestamp,
    };

    // 1️Add message
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .add(newMessage);

    // Update last message metadata
    await _firestore.collection('chat_rooms').doc(chatRoomID).set({
      'users': ids,
      'lastMessage': message,
      'lastMessageAt': timestamp,
      'lastSenderId': adminId,
    }, SetOptions(merge: true));
  }

  Stream<Map<String, dynamic>?> getLastMessageForUser(String otherUserId) {
    final String adminId = _auth.currentUser!.uid;

    List<String> ids = [adminId, otherUserId];
    ids.sort();
    final chatRoomID = ids.join('_');

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .snapshots()
        .map((doc) => doc.data());
  }

  //get messages
  Stream<QuerySnapshot> getMessages(otherUserID) {
    final String adminId = _auth.currentUser!.uid;
    List<String> ids = [adminId, otherUserID];
    ids.sort();

    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
