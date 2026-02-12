import 'package:flutter/material.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';
import 'package:perfect_super_admin/core/utils/responsive_config.dart';

class RevenueSummaryCard extends StatelessWidget {
  final double total;
  final String period;

  const RevenueSummaryCard({
    super.key,
    required this.total,
    required this.period,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
    
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
        PColors.gradient1,
        PColors.gradient3
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Icon and Period Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.trending_up_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  period,
                  style: const TextStyle(
                    color: PColors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Label
          Text(
            'Total Revenue',
            style: TextStyle(
              color: PColors.white.withOpacity(0.9),
              fontSize: 15,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  '₹',
                  style: TextStyle(
                    color: PColors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                _formatAmount(total),
                style: const TextStyle(
                  color: PColors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                  height: 1.1,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
       
        ],
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 10000000) {
      // 1 Crore or more
      return '${(amount / 10000000).toStringAsFixed(2)}Cr';
    } else if (amount >= 100000) {
      // 1 Lakh or more
      return '${(amount / 100000).toStringAsFixed(2)}L';
    } else if (amount >= 1000) {
      // 1 Thousand or more
      return '${(amount / 1000).toStringAsFixed(2)}K';
    } else {
      return amount.toStringAsFixed(2);
    }
  }
}