import '../../../data/models/sales_report_model.dart';

/// Sales Report State
class SalesReportState {
  final bool loading;
  final List<SalesReport> sales;
  final String? error;

  SalesReportState({
    this.loading = false,
    this.sales = const [],
    this.error,
  });

  SalesReportState copyWith({
    bool? loading,
    List<SalesReport>? sales,
    String? error,
  }) {
    return SalesReportState(
      loading: loading ?? this.loading,
      sales: sales ?? this.sales,
      error: error,
    );
  }
}


