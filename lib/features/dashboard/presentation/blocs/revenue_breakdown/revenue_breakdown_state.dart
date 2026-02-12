import '../../../data/models/revenue_data_model.dart';

/// Revenue Breakdown State
class RevenueBreakdownState {
  final bool loading;
  final List<RevenueData> revenueData;
  final String? error;

  RevenueBreakdownState({
    this.loading = false,
    this.revenueData = const [],
    this.error,
  });

  RevenueBreakdownState copyWith({
    bool? loading,
    List<RevenueData>? revenueData,
    String? error,
  }) {
    return RevenueBreakdownState(
      loading: loading ?? this.loading,
      revenueData: revenueData ?? this.revenueData,
      error: error,
    );
  }
}
