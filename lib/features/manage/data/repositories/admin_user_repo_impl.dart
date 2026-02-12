import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/repositories/admin_user_repository.dart';
import '../models/admin_user_model.dart';

class AdminUserRepositoryImpl implements AdminUserRepository {
  final FirebaseFirestore firestore;

  AdminUserRepositoryImpl(this.firestore);

  @override
  Stream<List<AdminUserModel>> fetchUsers() {
    return firestore
        .collection('users')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map(AdminUserModel.fromDoc).toList(),
        );
  }

  @override
  Future<void> blockUser(String userId) {
    return firestore
        .collection('users')
        .doc(userId)
        .update({'status': 'blocked'});
  }

  @override
  Future<void> unblockUser(String userId) {
    return firestore
        .collection('users')
        .doc(userId)
        .update({'status': 'active'});
  }
}
