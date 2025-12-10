// transactions_state.dart
part of 'transaction_cubit.dart';

class TransactionsState extends Equatable {
  final List<dynamic> allSales;
  final List<dynamic>? filteredSales;
  final String search;
  final String sortColumn; // 'date' or 'amount'
  final bool sortAsc;

  const TransactionsState({
    required this.allSales,
    this.filteredSales,
    this.search = '',
    this.sortColumn = 'date',
    this.sortAsc = false,
  });

  TransactionsState copyWith({
    List<dynamic>? allSales,
    List<dynamic>? filteredSales,
    String? search,
    String? sortColumn,
    bool? sortAsc,
  }) {
    return TransactionsState(
      allSales: allSales ?? this.allSales,
      filteredSales: filteredSales ?? this.filteredSales,
      search: search ?? this.search,
      sortColumn: sortColumn ?? this.sortColumn,
      sortAsc: sortAsc ?? this.sortAsc,
    );
  }

  @override
  List<Object?> get props => [allSales, filteredSales, search, sortColumn, sortAsc];
}
