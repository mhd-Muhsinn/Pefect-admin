

import '../models/revenue_data_model.dart';
import '../models/sales_report_model.dart';
import '../models/statistics_model.dart';
import '../repositories/stats_repository.dart';

/// Dashboard Service
/// Contains business logic for dashboard operations
class DashboardService {
  final DashboardRepository _repository;

  DashboardService(this._repository);

  /// Get statistics stream
  Stream<Statistics> getStatistics() {
    return _repository.getStatisticsStream();
  }

  /// Get recent sales
  Stream<List<SalesReport>> getRecentSales({int limit = 10}) {
    return _repository.getRecentSalesStream(limit: limit);
  }

  /// Get revenue breakdown for charts
  Stream<List<RevenueData>> getRevenueBreakdown() {
    return _repository.getRevenueBreakdownStream();
  }

  /// Get sales within date range
  // Future<List<SalesReport>> getSalesInRange({
  //   required DateTime startDate,
  //   required DateTime endDate,
  // }) {
  //   return _repository.getSalesByDateRange(
  //     startDate: startDate,
  //     endDate: endDate,
  //   );
  // }

  /// Add new user and update statistics
  Future<void> addNewUser() async {
    await _repository.incrementStatistic('totalUsers', 1);
  }

  /// Add new course and update statistics
  Future<void> addNewCourse() async {
    await _repository.incrementStatistic('totalCourses', 1);
  }

  /// Add new tutor and update statistics
  Future<void> addNewTutor() async {
    await _repository.incrementStatistic('totalTutors', 1);
  }

  /// Process new sale
  Future<void> processSale(SalesReport sale) async {
    await _repository.addSale(sale);
  }
}