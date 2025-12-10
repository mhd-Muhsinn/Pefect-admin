import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/sale_model.dart';

class RevenueService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<SaleModel>> fetchSalesByDateRange(DateTime start, DateTime end) async {
    try {
      final snapshot = await _firestore
          .collection('course_sales_report')
          .doc('sales_history')
          .collection('individual_sale')
          .where('timestamp', isGreaterThanOrEqualTo: start)
          .where('timestamp', isLessThanOrEqualTo: end)
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs.map((doc) => SaleModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Firebase Error: $e');
    }
  }
}