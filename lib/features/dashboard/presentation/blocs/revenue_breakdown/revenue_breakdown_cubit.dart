import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../data/services/stats_service.dart';
import 'revenue_breakdown_state.dart';

/// Revenue Breakdown Cubit
class RevenueBreakdownCubit extends Cubit<RevenueBreakdownState> {
  final DashboardService _service;
  StreamSubscription? _subscription;

  RevenueBreakdownCubit(this._service)
      : super(RevenueBreakdownState(loading: true));

  /// Start listening to revenue breakdown stream
  void startListening() {
    emit(state.copyWith(loading: true, error: null));

    _subscription = _service.getRevenueBreakdown().listen(
      (revenueData) {
        emit(RevenueBreakdownState(
          loading: false,
          revenueData: revenueData,
        ));
      },
      onError: (error) {
        emit(RevenueBreakdownState(
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
