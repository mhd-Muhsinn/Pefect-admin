// tutors_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class TutorsRepository {
  final FirebaseFirestore _firestore;

  TutorsRepository(this._firestore);

  Stream<QuerySnapshot> getTutorsStream() {
    return _firestore
        .collection('tutors')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}