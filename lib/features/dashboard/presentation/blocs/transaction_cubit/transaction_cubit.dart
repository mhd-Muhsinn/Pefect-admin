// transactions_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'transaction_state.dart';

class TransactionsCubit extends Cubit<TransactionsState> {
  TransactionsCubit({List<dynamic>? sales})
      : super(TransactionsState(
          allSales: sales ?? <dynamic>[],
        )) {
    _recompute();
  }

  void loadSales(List<dynamic> sales) {
    emit(state.copyWith(allSales: sales));
    _recompute();
  }

  void setSearch(String search) {
    emit(state.copyWith(search: search));
    _recompute();
  }

  void clearFilters() {
    emit(TransactionsState(allSales: state.allSales));
    _recompute();
  }

  void sortByColumn(String column, {required bool asc}) {
    emit(state.copyWith(sortColumn: column, sortAsc: asc));
    _recompute();
  }

  void _recompute() {
    final query = state.search.toLowerCase().trim();

    final filtered = state.allSales.where((s) {
      final course = _getStringProperty(s, 'courseName').toLowerCase();
      final customer = _getStringProperty(s, 'customerName').toLowerCase();

      if (query.isEmpty) return true;
      return course.contains(query) || customer.contains(query);
    }).toList();

    filtered.sort((a, b) {
      if (state.sortColumn == 'amount') {
        final av = _getNumProperty(a, 'amount');
        final bv = _getNumProperty(b, 'amount');
        return state.sortAsc ? av.compareTo(bv) : bv.compareTo(av);
      } else {
        final ad = _getDateProperty(a, 'date');
        final bd = _getDateProperty(b, 'date');
        return state.sortAsc ? ad.compareTo(bd) : bd.compareTo(ad);
      }
    });

    emit(state.copyWith(filteredSales: filtered));
  }

  // Helpers to  read dynamic sale objects 
  String _getStringProperty(dynamic s, String key) {
    try {
      final v = (s as dynamic).toJson != null ? (s as dynamic).toJson()[key] : (s as dynamic).$__getProperty__(key);
      // above is speculative - fallback below
    } catch (_) {}
    try {
      if (s is Map) return (s[key] ?? '').toString();
    } catch (_) {}
    try {
      final val = (s as dynamic).courseName;
      if (val != null) return val.toString();
    } catch (_) {}
    try {
      final val = (s as dynamic)[key];
      if (val != null) return val.toString();
    } catch (_) {}
    return '';
  }

  num _getNumProperty(dynamic s, String key) {
    try {
      if (s is Map) return (s[key] ?? 0) as num;
    } catch (_) {}
    try {
      final val = (s as dynamic).amount;
      if (val is num) return val;
      if (val != null) return num.parse(val.toString());
    } catch (_) {}
    return 0;
  }

  DateTime _getDateProperty(dynamic s, String key) {
    try {
      if (s is Map) {
        final v = s[key];
        if (v is DateTime) return v;
        if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
        if (v is String) return DateTime.parse(v);
      }
    } catch (_) {}
    try {
      final v = (s as dynamic).date;
      if (v is DateTime) return v;
      if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
      if (v is String) return DateTime.parse(v);
    } catch (_) {}
    return DateTime.fromMillisecondsSinceEpoch(0);
  }
}
