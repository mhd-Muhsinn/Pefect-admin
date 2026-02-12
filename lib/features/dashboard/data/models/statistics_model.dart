import 'package:cloud_firestore/cloud_firestore.dart';

/// Statistics Model
/// Represents global app statistics
class Statistics {
  final int totalUsers;
  final int totalCourses;
  final int totalTutors;
  final double totalIncome;

  Statistics({
    required this.totalUsers,
    required this.totalCourses,
    required this.totalTutors,
    required this.totalIncome,
  });

  /// Create from Firestore document
  factory Statistics.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Statistics(
      totalUsers: (data['totalUsers'] as num?)?.toInt() ?? 0,
      totalCourses: (data['totalCourses'] as num?)?.toInt() ?? 0,
      totalTutors: (data['totalTutors'] as num?)?.toInt() ?? 0,
      totalIncome: (data['totalIncome'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'totalUsers': totalUsers,
      'totalCourses': totalCourses,
      'totalTutors': totalTutors,
      'totalIncome': totalIncome,
    };
  }
}