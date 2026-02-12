/// --- USER DATA HELPER ---
class UserDataHelper {
  static String name(Map<String, dynamic> user) =>
      (user['name'] ?? '').toString();

  static String nameLower(Map<String, dynamic> user) =>
      name(user).toLowerCase();

  static String email(Map<String, dynamic> user) =>
      (user['email'] ?? '').toString();

  static String emailLower(Map<String, dynamic> user) =>
      email(user).toLowerCase();

  static String? imageUrl(Map<String, dynamic> user) {
    final value = user['imageUrl'];
    if (value == null) return null;
    return value.toString();
  }

  static String uid(Map<String, dynamic> user) =>
      (user['uid'] ?? '').toString();
}
