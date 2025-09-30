import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

// State
class SalesReportState extends Equatable {
  final List<Map<String, dynamic>> sales;
  final bool loading;
  final String? error;

  const SalesReportState({
    this.sales = const [],
    this.loading = false,
    this.error,
  });

  SalesReportState copyWith({
    List<Map<String, dynamic>>? sales,
    bool? loading,
    String? error,
  }) {
    return SalesReportState(
      sales: sales ?? this.sales,
      loading: loading ?? this.loading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [sales, loading, error];
}


