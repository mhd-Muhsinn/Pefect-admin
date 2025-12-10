import 'package:flutter/material.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';

class RevenueSummaryCard extends StatelessWidget {
  final double total;
  final String period;

  const RevenueSummaryCard({super.key, required this.total, required this.period});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: PColors.containerBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
     
        children: [
          Text("Total Revenue ($period)", 
              style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          Text("₹${total.toStringAsFixed(2)}",
              style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}