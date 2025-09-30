import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:perfect_super_admin/features/manage/data/services/trainer_firebase_services.dart';

class TutorRequestCubit extends Cubit<void> {
  final _firestore = TrainerFirebaseServices();

  TutorRequestCubit() : super(null);

  Future<void> acceptRequest(String docId) async {
    try {
      await _firestore.handleAccept(docId);
    } catch (e) {
      print('Accept failed: $e');
    }
  }

  Future<void> rejectRequest(String docId) async {
    try {
      await _firestore.handleReject(docId);
    } catch (e) {
      print('Reject failed: $e');
    }
  }
}
