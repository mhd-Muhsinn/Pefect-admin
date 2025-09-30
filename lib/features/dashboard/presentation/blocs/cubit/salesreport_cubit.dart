// Cubit
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_super_admin/features/dashboard/presentation/blocs/cubit/salesreport_state.dart';

class SalesReportCubit extends Cubit<SalesReportState> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  StreamSubscription? _sub;

  SalesReportCubit() : super(const SalesReportState());

  void startListening() {
    emit(state.copyWith(loading: true));
    _sub = firestore
        .collection('course_sales_report')
        .doc('sales_history')
        .collection('individual_sale').limit(6)
        .snapshots()
        .listen(
      (snapshot) {
        final sales = snapshot.docs
            .map((doc) => doc.data())
            .toList();
        emit(state.copyWith(sales: sales, loading: false, error: null));
      },
      onError: (error) {
        emit(state.copyWith(error: error.toString(), loading: false));
      },
    );
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}