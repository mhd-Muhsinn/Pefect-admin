import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseCubit extends Cubit<List<DocumentSnapshot>> {
  final FirebaseFirestore _firestore;

  CourseCubit(this._firestore) : super([]) {
    _loadCourses();
  }

  void _loadCourses() {
    _firestore
        .collection('courses')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      emit(snapshot.docs);
    });
  }
}

