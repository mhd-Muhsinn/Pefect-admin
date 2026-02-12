// Cubit
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_super_admin/features/dashboard/presentation/blocs/salesreport_cubit/salesreport_state.dart';

import '../../../data/models/sales_report_model.dart';
import '../../../data/services/stats_service.dart';

/// Sales Report Cubit
class SalesReportCubit extends Cubit<SalesReportState> {
  final DashboardService _service;
  StreamSubscription? _subscription;

  SalesReportCubit(this._service) : super(SalesReportState(loading: true));

  /// Start listening to sales stream
  void startListening({int limit = 10}) {
    emit(state.copyWith(loading: true, error: null));

    _subscription = _service.getRecentSales(limit: limit).listen(
      (sales) {
        emit(SalesReportState(
          loading: false,
          sales: sales,
        ));
      },
      onError: (error) {
        emit(SalesReportState(
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