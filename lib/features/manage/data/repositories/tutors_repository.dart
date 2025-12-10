// tutors_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';

// lib/features/manage/data/repositories/tutor_request_repository.dart

class TutorRequestRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getPendingRequests() {
    return _firestore
        .collection('tutor_requests')
        .where('status', isEqualTo: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          "id": doc.id,
          ...data,
        };
      }).toList();
    });
  }

Future<void> acceptRequest(String docId) async {
  final requestDoc =
      await _firestore.collection('tutor_requests').doc(docId).get();

  if (!requestDoc.exists) return;

  final requestData = requestDoc.data() as Map<String, dynamic>;
  final uid = docId; // tutor's uid is the same as docId
  final selectedCourses = List<Map<String, dynamic>>.from(requestData['selectedCourses'] ?? []);

  // 1. Mark tutor request as accepted
  await _firestore.collection('tutor_requests').doc(docId).update({
    "status": true,
  });

  // 2. Add tutor id to each selected course’s course_tutors field
  final batch = _firestore.batch();

  for (final course in selectedCourses) {
    final courseId = course['id']; // make sure you stored {"id": docId, "name": courseName}
    if (courseId != null) {
      final courseRef = _firestore.collection('courses').doc(courseId);
      batch.update(courseRef, {
        "course_tutors": FieldValue.arrayUnion([uid]),
      });
    }
  }

  await batch.commit();
}


  Future<void> rejectRequest(String docId) async {
    await _firestore.collection('tutor_requests').doc(docId).delete();
  }
}
