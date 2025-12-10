import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCourseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createCourse(
      {required String name,
      required String description,
      required String price,
      required String thumbnailUrl,
      required String category,
      required String subcategory,
      required String subSubCategory,
      required String language,
      required String courseType,
      required List<Map<String, dynamic>> videos,
      String? thumbnailId}) async {
    final courseRef = _firestore.collection('courses').doc();

    await _firestore.collection('courses').doc(courseRef.id).set(
      {
      'docId':courseRef.id,  
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'subcategory': subcategory,
      'sub_subcategories': subSubCategory,
      'language': language,
      'coureType': courseType,
      'thumbnailUrl': thumbnailUrl,
      'thumbnail_id': thumbnailId ?? '',
      'createdAt': FieldValue.serverTimestamp(),
    }
    );

    for (final video in videos) {
      final videoRef = courseRef.collection('videos').doc();
      await videoRef.set({
        ...video,
        'videoDocId': videoRef.id,
      });
    }
    await _firestore
        .collection('course_sales_report')
        .doc(courseRef.id)
        .set({'name': name});
  }

  Future<List<Map<String, dynamic>>> fetchVideos(String courseId) async {
    final snapshot = await _firestore
        .collection('courses')
        .doc(courseId)
        .collection('videos')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'title': data['title'],
        'description': data['description'],
        'duration': data['duration'],
        'format': data['format'],
        'public_id': data['public_id'],
        'video_url': data['video_url'],
        'created_at': data['created_at'],
        'videoDocId': doc['videoDocId']
      };
    }).toList();
  }

  Future<void> deletecourse(String uid) async {
    await _firestore.collection('courses').doc(uid).delete();
  }

  Future<void> deletecourseVideo(String videouid, String courseId) async {
    await _firestore
        .collection('courses')
        .doc(courseId)
        .collection('videos')
        .doc(videouid)
        .delete();
  }

  Future<void> updateCourse({
    required String courseId,
    required String name,
    required String description,
    required String price,
    String? thumbnailUrl,
    String? thumbnailId,
    required List<Map<String, dynamic>> videos,
  }) async {
    final docRef =
        FirebaseFirestore.instance.collection('courses').doc(courseId);

    final courseUpdate = {
      'name': name,
      'description': description,
      'price': double.tryParse(price) ?? 0,
    };

    if (thumbnailUrl != null && thumbnailId != null) {
      courseUpdate['thumbnailUrl'] = thumbnailUrl;
      courseUpdate['thumbnail_id'] = thumbnailId;
    }

    final snapshot = await docRef.get();
    if (!snapshot.exists) {
      throw Exception("❌ Course with ID $courseId does not exist.");
    }

    await docRef.update(courseUpdate);

    final videoCollection = docRef.collection('videos');

    for (final video in videos) {
      if (video.containsKey('videoDocId') && video['videoDocId'] != null) {
        // Existing video - update or set if missing
        final videoDoc = videoCollection.doc(video['videoDocId']);
        final vidSnap = await videoDoc.get();
        if (vidSnap.exists) {
          await videoDoc.update(video);
        } else {
          await videoDoc.set(video);
        }
      } else {
        // New video - add to Firestore and update the docId in map
        final addedDoc = await videoCollection.add(video);
        await addedDoc.update(
            {'videoDocId': addedDoc.id}); // store its own docId in the document
        video['videoDocId'] = addedDoc.id; // update in the passed map list
      }
    }
  }
}
