import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_super_admin/features/dashboard/presentation/blocs/revenue%20cubit/revenue_cubit.dart';

import '../../../../core/constants/colors.dart';

class FilterSection extends StatelessWidget {
  const FilterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RevenueCubit>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _FilterChip(
              label: 'Week',
              icon: Icons.calendar_view_week_rounded,
              onTap: () => cubit.applyFilter('week'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _FilterChip(
              label: 'Month',
              icon: Icons.calendar_month_rounded,
              onTap: () => cubit.applyFilter('month'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _FilterChip(
              label: 'Custom',
              icon: Icons.tune_rounded,
              onTap: () => _showCustomDatePicker(context, cubit),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showCustomDatePicker(BuildContext context, RevenueCubit cubit) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF667EEA),
              onPrimary: PColors.white,
              surface: PColors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && context.mounted) {
      cubit.fetchSales(picked.start, picked.end, "Custom Range");
    }
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}