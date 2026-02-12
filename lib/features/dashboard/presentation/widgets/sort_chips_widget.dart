import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_super_admin/features/dashboard/presentation/blocs/transaction_cubit/transaction_cubit.dart';

class SortChipsWidget extends StatelessWidget {
  const SortChipsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionsCubit, TransactionsState>(
      builder: (context, state) {
        return Row(
          children: [
            Text(
              "Sort by:",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 12),
            _SortChip(
              label: 'Date',
              icon: Icons.calendar_today_rounded,
              isActive: state.sortColumn == 'date',
              isAscending: state.sortAsc,
              onTap: () => _toggleSort(context, state, 'date'),
            ),
            const SizedBox(width: 8),
            _SortChip(
              label: 'Amount',
              icon: Icons.currency_rupee_rounded,
              isActive: state.sortColumn == 'amount',
              isAscending: state.sortAsc,
              onTap: () => _toggleSort(context, state, 'amount'),
            ),
          ],
        );
      },
    );
  }

  void _toggleSort(BuildContext context, TransactionsState state, String col) {
    final asc = (state.sortColumn == col) ? !state.sortAsc : false;
    context.read<TransactionsCubit>().sortByColumn(col, asc: asc);
  }
}

class _SortChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final bool isAscending;
  final VoidCallback onTap;

  const _SortChip({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.isAscending,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          gradient: isActive
              ? const LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                )
              : null,
          color: isActive ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? Colors.transparent : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isActive ? Colors.white : Colors.grey.shade600,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey.shade700,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (isActive) ...[
              const SizedBox(width: 4),
              Icon(
                isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                color: Colors.white,
                size: 12,
              ),
            ],
          ],
        ),
      ),
    );
  }
}