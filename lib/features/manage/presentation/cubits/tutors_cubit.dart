// tutors_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TutorsCubit extends Cubit<List<DocumentSnapshot>> {
  final FirebaseFirestore _firestore;

  TutorsCubit(this._firestore) : super([]) {
    _loadTutors();
  }

  Future<void> _loadTutors() async {
    try {
      _firestore
          .collection('tutors')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen((snapshot) {
        emit(snapshot.docs);
      });
    } catch (e) {
      emit([]); // Or handle error appropriately
    }
  }
}