import '../../../../dashboard/data/models/sale_model.dart';

abstract class RevenueState {}

class RevenueInitial extends RevenueState {}
class RevenueLoading extends RevenueState {}

class RevenueLoaded extends RevenueState {
  final List<SaleModel> sales;
  final double totalRevenue;
  final String filterLabel;

  RevenueLoaded({
    required this.sales, 
    required this.totalRevenue, 
    required this.filterLabel
  });
}

class RevenueError extends RevenueState {
  final String message;
  RevenueError(this.message);
}