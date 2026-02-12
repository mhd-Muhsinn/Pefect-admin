import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_super_admin/features/dashboard/presentation/blocs/stats_cubit/stats_state.dart';

import '../../../data/services/stats_service.dart';

/// Statistics Cubit
class StatisticsCubit extends Cubit<StatisticsState> {
  final DashboardService _service;
  StreamSubscription? _subscription;

  StatisticsCubit(this._service) : super(StatisticsState(loading: true));

  /// Start listening to statistics stream
  void startListening() {
    emit(state.copyWith(loading: true, error: null));

    _subscription = _service.getStatistics().listen(
      (statistics) {
        emit(StatisticsState(
          loading: false,
          statistics: statistics,
        ));
      },
      onError: (error) {
        emit(StatisticsState(
          loading: false,
          error: error.toString(),
        ));
      },
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}