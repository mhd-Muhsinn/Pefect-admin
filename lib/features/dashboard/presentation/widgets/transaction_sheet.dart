import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';
import 'package:perfect_super_admin/core/services/file_service.dart';
import 'package:perfect_super_admin/core/utils/responsive_config.dart';
import 'package:perfect_super_admin/features/dashboard/presentation/blocs/transaction_cubit/transaction_cubit.dart';
import 'package:perfect_super_admin/features/dashboard/presentation/factories/revenue_export_cubit_factory.dart';
import '../../../../core/constants/colors.dart';
import '../../data/models/sale_model.dart';
import '../blocs/revenue_export/revenueexport_cubit.dart';
import '../blocs/revenue_export/revenueexport_state.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/sort_chips_widget.dart';
import 'transaction_list_iitem.dart';

class TransactionSheet extends StatelessWidget {
  final List<SaleModel> sales;
  const TransactionSheet({super.key, required this.sales});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<TransactionsCubit>(
        create: (_) => TransactionsCubit(sales: sales),
      ),
      BlocProvider<RevenueExportCubit>(
          create: (_) => RevenueExportCubitFactory.create()),
    ], child: TransactionSheetView());
  }
}

class TransactionSheetView extends StatelessWidget {
  const TransactionSheetView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var size = ResponsiveConfig(context);
    return BlocListener<RevenueExportCubit, RevenueExportState>(
      listener: (context, state) {
        if (state is RevenueExportLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Downloading revenue sheet...'),
              duration: Duration(days: 1),
            ),
          );
        }

        if (state is RevenueExportSuccess) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Revenue sheet downloaded'),
              action: SnackBarAction(
                label: 'OPEN',
                onPressed: () {
                  OpenFilex.open(state.filePath);
                },
              ),
            ),
          );
        }

        if (state is RevenueExportFailure) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: SizedBox(
        height: size.availableHeight * 0.75,
        child: Container(
          decoration: BoxDecoration(
            color: PColors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle Bar
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: PColors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // Header with count
              const _TransactionHeader(),

              // Search and Sort Controls
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SearchBarWidget(),
                    SizedBox(height: 12),
                    SortChipsWidget(),
                    SizedBox(height: 12),
                  ],
                ),
              ),

              Divider(height: 1, color: PColors.grey.shade200),

              // Transaction List - FIXED: Proper scrolling
              Expanded(
                child: BlocBuilder<TransactionsCubit, TransactionsState>(
                  builder: (context, state) {
                    final rows = state.filteredSales ?? state.allSales;

                    if (rows.isEmpty) {
                      return _buildEmptyState();
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      physics: const BouncingScrollPhysics(),
                      itemCount: rows.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) => TransactionListItem(
                        transaction: rows[index],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "No transactions found",
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Try adjusting your filters",
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

// Transaction Header
class _TransactionHeader extends StatelessWidget {
  const _TransactionHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Transactions',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1F36),
            ),
          ),
          BlocBuilder<TransactionsCubit, TransactionsState>(
            builder: (context, state) {
              final sales = state.filteredSales ?? state.allSales;
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF667EEA).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: GestureDetector(
                  onTap: () {
                    context
                        .read<RevenueExportCubit>()
                        .exportToExcel(sales as List<SaleModel>);
                  },
                  child: Text(
                    '${sales.length} Dowload Report',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
