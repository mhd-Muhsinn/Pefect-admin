import 'package:cloud_firestore/cloud_firestore.dart';

class SaleModel {
  final String id;
  final String courseName;
  final String customerName;
  final double amount;
  final DateTime date;

  SaleModel({
    required this.id,
    required this.courseName,
    required this.customerName,
    required this.amount,
    required this.date,
  });

  factory SaleModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
     final Timestamp ts = data['timestamp'] as Timestamp;
    return SaleModel(
      id: doc.id,
      courseName: data['name'] ?? 'Unknown Course',
      customerName: data['Customer'] ?? 'Unknown Customer',
      amount:  double.tryParse(data['amount'].toString()) ?? 0.0,
      date: ts.toDate(), 
    );
  }
}