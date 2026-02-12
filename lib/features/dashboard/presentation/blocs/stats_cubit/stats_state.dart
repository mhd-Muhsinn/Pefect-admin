import '../../../data/models/statistics_model.dart';

/// Statistics State
class StatisticsState {
  final bool loading;
  final Statistics? statistics;
  final String? error;

  StatisticsState({
    this.loading = false,
    this.statistics,
    this.error,
  });

  StatisticsState copyWith({
    bool? loading,
    Statistics? statistics,
    String? error,
  }) {
    return StatisticsState(
      loading: loading ?? this.loading,
      statistics: statistics ?? this.statistics,
      error: error,
    );
  }
}
