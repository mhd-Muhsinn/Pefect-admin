import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/revenue_data_model.dart';
import '../models/sales_report_model.dart';
import '../models/statistics_model.dart';


/// Dashboard Repository
/// Handles all Firestore operations for dashboard data
class DashboardRepository {
  final FirebaseFirestore _firestore;

  DashboardRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Stream statistics data from Firestore
  Stream<Statistics> getStatisticsStream() {
    return _firestore
        .collection('statistics')
        .doc('global')
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) {
        return Statistics(
          totalUsers: 0,
          totalCourses: 0,
          totalTutors: 0,
          totalIncome: 0.0,
        );
      }
      return Statistics.fromFirestore(snapshot);
    });
  }

  /// Stream recent sales from Firestore
  Stream<List<SalesReport>> getRecentSalesStream({int limit = 10}) {
    return _firestore
        .collection('course_sales_report')
        .doc('sales_history')
        .collection('individual_sale')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => SalesReport.fromFirestore(doc))
          .toList();
    });
  }

  /// Stream top selling courses for chart
  /// Path: statistics/individual_course_sold_count
  Stream<List<RevenueData>> getRevenueBreakdownStream() {
    return _firestore
        .collection('statistics')
        .doc('individual_course_sold_count')
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) {
        return <RevenueData>[];
      }

      final data = snapshot.data()!;
      
      // Parse course sales counts (stored as strings)
      Map<String, int> courseSales = {};
      int totalSales = 0;

      data.forEach((courseName, value) {
        int count = 0;
        if (value is String) {
          count = int.tryParse(value) ?? 0;
        } else if (value is num) {
          count = value.toInt();
        }
        
        if (count > 0) {
          courseSales[courseName] = count;
          totalSales += count;
        }
      });

      // Sort by count and take top 5
      var sortedCourses = courseSales.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      
      var top5 = sortedCourses.take(5).toList();

      // Calculate percentages
      return top5.map((entry) {
        final percentage = totalSales > 0 
            ? (entry.value / totalSales) * 100 
            : 0.0;

        return RevenueData(
          courseName: entry.key,
          salesCount: entry.value,
          percentage: percentage,
        );
      }).toList();
    });
  }

  /// Get sales by date range
  // Future<List<SalesReport>> getSalesByDateRange({
  //   required DateTime startDate,
  //   required DateTime endDate,
  // }) async {
  //   final snapshot = await _firestore
  //       .collection('course_sales_report')
  //         .doc('sales_history')
  //         .collection('individual_sale')
  //       .where('timestamp',
  //           isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
  //       .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
  //       .orderBy('timestamp', descending: true)
  //       .get();
  //   return snapshot.docs.map((doc) => SalesReport.fromFirestore(doc)).toList();
  // }

  /// Update statistics (helper method)
  Future<void> updateStatistics({
    int? totalUsers,
    int? totalCourses,
    int? totalTutors,
    double? totalIncome,
  }) async {
    final updates = <String, dynamic>{};
    if (totalUsers != null) updates['totalUsers'] = totalUsers;
    if (totalCourses != null) updates['totalCourses'] = totalCourses;
    if (totalTutors != null) updates['totalTutors'] = totalTutors;
    if (totalIncome != null) updates['totalIncome'] = totalIncome;

    await _firestore.collection('statistics').doc('global').update(updates);
  }

  /// Increment statistics field
  Future<void> incrementStatistic(String field, num value) async {
    await _firestore
        .collection('statistics')
        .doc('global')
        .update({field: FieldValue.increment(value)});
  }

  /// Add new sale
  Future<void> addSale(SalesReport sale) async {
    await _firestore.collection('sales').add(sale.toFirestore());
    
    // Auto-increment total income
    await incrementStatistic('totalIncome', sale as num);
  }
}