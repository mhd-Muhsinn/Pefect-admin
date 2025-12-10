import '../models/sale_model.dart';
import '../services/revenue_service.dart';

class RevenueRepository {
  final RevenueService _service;

  RevenueRepository({RevenueService? service}) 
      : _service = service ?? RevenueService();

  Future<List<SaleModel>> getSalesHistory(DateTime start, DateTime end) async {
    return await _service.fetchSalesByDateRange(start, end);
  }
}