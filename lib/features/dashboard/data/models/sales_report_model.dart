import 'package:cloud_firestore/cloud_firestore.dart';


/// Sales Report Model
class SalesReport {
  final String id;
  final String courseName;
  final String customerName;
  final String amount;
  final DateTime timestamp;

  SalesReport({
    required this.id,
    required this.courseName,
    required this.customerName,
    required this.amount,
    required this.timestamp,
  });

  /// Create from Firestore document
  factory SalesReport.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    

    
    return SalesReport(
      id: doc.id,
      courseName: data['name']  ?? '',
      customerName: data['Customer']  ?? '',
      amount: data['amount'],
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'courseName': courseName,
      'customerName': customerName,
      'amount': amount,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

}