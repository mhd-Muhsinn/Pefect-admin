import 'package:cloud_firestore/cloud_firestore.dart';

class AdminUserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final List<String> myCourses;
  final String status;

  AdminUserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.myCourses,
    required this.status,
  });

  factory AdminUserModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AdminUserModel(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      myCourses: List<String>.from(data['myCourses'] ?? []),
      status: data['status'] ?? 'active',
    );
  }
}
