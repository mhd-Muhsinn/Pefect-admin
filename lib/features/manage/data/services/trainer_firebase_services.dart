import 'package:cloud_firestore/cloud_firestore.dart';

class TrainerFirebaseServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
   Future<void> handleAccept(String docId) async {
    await _firestore
        .collection('tutor_requests')
        .doc(docId)
        .update({'status': true});
  }

  Future<void> handleReject(String docId) async {
    await _firestore
        .collection('tutor_requests')
        .doc(docId)
        .delete();
  }
}
