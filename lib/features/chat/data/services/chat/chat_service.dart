import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:perfect_super_admin/features/chat/data/models/message.dart';

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
        return user;
      }).toList();
    });
  }

  //Send Messages
  Future<void> sendMessage(String receiverId, message) async {
    final String adminId = _auth.currentUser!.uid;
    final Timestamp timestamp = Timestamp.now();

    //new message
    Message newMessage = Message(
        senderID: adminId,
        receiverID: receiverId,
        message: message,
        timestamp: timestamp);

    //construsting chat room id for the two users(sorted to ensure uniqueness)
    List<String> ids = [adminId, receiverId];
    ids.sort();
    String chatRoomID = ids.join('_');

    //new message to database
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
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
