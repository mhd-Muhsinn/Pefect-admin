import 'package:flutter_bloc/flutter_bloc.dart';
import 'revenue_state.dart';
import '../../../data/repositories/revenue_repository.dart';

class RevenueCubit extends Cubit<RevenueState> {
  final RevenueRepository _repository;

  RevenueCubit(this._repository) : super(RevenueInitial());

  // Logic: Load default view (Last 7 days)
  void loadDefaultView() {
    final now = DateTime.now();
    final start = now.subtract(const Duration(days: 7));
    fetchSales(start, now, "Last 7 Days");
  }

  // Logic: Fetch specific range
  Future<void> fetchSales(DateTime start, DateTime end, String label) async {
    emit(RevenueLoading());
    try {
      final sales = await _repository.getSalesHistory(start, end);
      
      // Logic: Calculate total revenue here, NOT in the UI
      double total = sales.fold(0, (sum, item) => sum + item.amount);
      
      emit(RevenueLoaded(
        sales: sales, 
        totalRevenue: total, 
        filterLabel: label
      ));
    } catch (e) {
      emit(RevenueError("Failed to load sales data"));
    }
  }

  // Logic: Handle predefined filters
  void applyFilter(String filterType) {
    final now = DateTime.now();
    if (filterType == 'week') {
      fetchSales(now.subtract(const Duration(days: 7)), now, "Last 7 Days");
    } else if (filterType == 'month') {
      fetchSales(now.subtract(const Duration(days: 30)), now, "Last 30 Days");
    }
  }
}