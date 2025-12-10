import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:perfect_super_admin/core/constants/image_strings.dart';
import 'package:perfect_super_admin/features/dashboard/presentation/blocs/revenue%20cubit/revenue_cubit.dart';
import 'package:perfect_super_admin/features/dashboard/presentation/blocs/revenue%20cubit/revenue_state.dart';
import 'package:perfect_super_admin/features/dashboard/presentation/blocs/transaction_cubit/transaction_cubit.dart';

// Imports from your structure
import '../../data/repositories/revenue_repository.dart';
import '../widgets/revenue_summary_card.dart';

class RevenuePage extends StatelessWidget {
  const RevenuePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RevenueCubit(RevenueRepository())..loadDefaultView(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Revenue Dashboard")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const _FilterSection(),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<RevenueCubit, RevenueState>(
                  builder: (context, state) {
                    if (state is RevenueLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is RevenueError) {
                      return Center(child: Text(state.message));
                    } else if (state is RevenueLoaded) {
                      return Column(
                        children: [
                          RevenueSummaryCard(
                            total: state.totalRevenue,
                            period: state.filterLabel,
                          ),
                          const SizedBox(height: 16),
                          // Instead of direct list, show a compact preview and the sheet below
                          Expanded(child: TransactionSheet(sales: state.sales)),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Sub-widget for Filters (Keeps main build clean)
class _FilterSection extends StatelessWidget {
  const _FilterSection();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RevenueCubit>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ActionChip(
          label: const Text("Last 7 Days"),
          onPressed: () => cubit.applyFilter('week'),
        ),
        ActionChip(
          label: const Text("Last Month"),
          onPressed: () => cubit.applyFilter('month'),
        ),
        ActionChip(
          avatar: const Icon(Icons.calendar_today, size: 16),
          label: const Text("Custom"),
          onPressed: () async {
            final picked = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2023),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              if (context.mounted) {
                cubit.fetchSales(picked.start, picked.end, "Custom Range");
              }
            }
          },
        ),
      ],
    );
  }
}



class TransactionSheet extends StatefulWidget {
  final List<dynamic> sales;
  const TransactionSheet({Key? key, required this.sales}) : super(key: key);

  @override
  State<TransactionSheet> createState() => _TransactionSheetState();
}

class _TransactionSheetState extends State<TransactionSheet> {
  late final TextEditingController _searchController;
  final NumberFormat _currency = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Assuming PImages.noData is a string path you have. 
    // If not, replace the Lottie widget with a simple Icon in the build method below.
    
    return BlocProvider(
      create: (_) => TransactionsCubit(sales: widget.sales),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // --- Handle Bar ---
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            // --- Header & Stats ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Transactions',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  BlocBuilder<TransactionsCubit, TransactionsState>(
                    builder: (context, state) {
                      final count = state.filteredSales?.length ?? state.allSales.length;
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$count items',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.w600),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // --- Search & Sort Controls ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  // Search Bar
                  BlocBuilder<TransactionsCubit, TransactionsState>(
                    buildWhen: (prev, next) => prev.search != next.search,
                    builder: (context, state) {
                      if (_searchController.text != state.search) {
                         _searchController.text = state.search;
                         _searchController.selection = TextSelection.fromPosition(TextPosition(offset: _searchController.text.length));
                      }
                      
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (v) => context.read<TransactionsCubit>().setSearch(v),
                          decoration: InputDecoration(
                            hintText: 'Search course or customer...',
                            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                            prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                            suffixIcon: state.search.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 18),
                                    onPressed: () {
                                      context.read<TransactionsCubit>().clearFilters();
                                      _searchController.clear();
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  
                  // Sort Chips
                  BlocBuilder<TransactionsCubit, TransactionsState>(
                    builder: (context, state) {
                      return Row(
                        children: [
                          Text("Sort by:", style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                          const SizedBox(width: 8),
                          _SortChip(
                            label: 'Date',
                            isActive: state.sortColumn == 'date',
                            isAscending: state.sortAsc,
                            onTap: () => _toggleSort(context, state, 'date'),
                          ),
                          const SizedBox(width: 8),
                          _SortChip(
                            label: 'Amount',
                            isActive: state.sortColumn == 'amount',
                            isAscending: state.sortAsc,
                            onTap: () => _toggleSort(context, state, 'amount'),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            Divider(height: 1, color: Colors.grey.shade200),

            // --- List Body ---
            Expanded(
              child: BlocBuilder<TransactionsCubit, TransactionsState>(
                builder: (context, state) {
                  final rows = state.filteredSales ?? state.allSales;

                  if (rows.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.manage_search, size: 64, color: Colors.grey.shade300),
                          const SizedBox(height: 16),
                          Text(
                            "No transactions found",
                            style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.only(top: 8, bottom: 20),
                    itemCount: rows.length,
                    separatorBuilder: (_, __) => const Divider(height: 1, indent: 70),
                    itemBuilder: (context, index) {
                      final s = rows[index];
                      final date = _safeDate(s);
                      final course = _safeString(s, 'courseName');
                      final customer = _safeString(s, 'customerName');
                      final amount = _safeNum(s, 'amount');

                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        leading: CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.blue.shade50,
                          child: Text(
                            course.isNotEmpty ? course[0].toUpperCase() : '?',
                            style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(
                          course.isEmpty ? 'Unknown Course' : course,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Row(
                            children: [
                              Icon(Icons.person_outline, size: 14, color: Colors.grey.shade500),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  customer.isEmpty ? 'Unknown' : customer,
                                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              _currency.format(amount),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.green, // Financial apps often use green/red
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('MMM dd').format(date),
                              style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleSort(BuildContext context, TransactionsState state, String col) {
    final asc = (state.sortColumn == col) ? !state.sortAsc : false;
    context.read<TransactionsCubit>().sortByColumn(col, asc: asc);
  }

  // --- Helper Functions (Preserved) ---
  String _safeString(dynamic s, String key) {
    try {
      if (s is Map) return (s[key] ?? '').toString();
    } catch (_) {}
    try {
      final v = (s as dynamic).courseName;
      if (v != null) return v.toString();
    } catch (_) {}
    try {
      final v = (s as dynamic)[key];
      if (v != null) return v.toString();
    } catch (_) {}
    return '';
  }

  num _safeNum(dynamic s, String key) {
    try {
      if (s is Map) return (s[key] ?? 0) as num;
    } catch (_) {}
    try {
      final v = (s as dynamic).amount;
      if (v is num) return v;
      if (v != null) return num.parse(v.toString());
    } catch (_) {}
    return 0;
  }

  DateTime _safeDate(dynamic s) {
    try {
      if (s is Map) {
        final v = s['date'];
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

// --- Local Widgets for cleaner code ---
class _SortChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final bool isAscending;
  final VoidCallback onTap;

  const _SortChip({
    Key? key,
    required this.label,
    required this.isActive,
    required this.isAscending,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? Colors.black87 : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isActive ? Colors.black87 : Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey.shade700,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (isActive) ...[
              const SizedBox(width: 4),
              Icon(
                isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                color: Colors.white,
                size: 14,
              )
            ]
          ],
        ),
      ),
    );
  }
}
