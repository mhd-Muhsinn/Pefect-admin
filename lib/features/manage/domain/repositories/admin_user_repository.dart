import '../../data/models/admin_user_model.dart';

abstract class AdminUserRepository {
  Stream<List<AdminUserModel>> fetchUsers();
  Future<void> blockUser(String userId);
  Future<void> unblockUser(String userId);
}
