import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_super_admin/features/dashboard/data/models/revenue_data_model.dart';

import '../../../../core/constants/colors.dart';
import '../blocs/revenue_breakdown/revenue_breakdown_cubit.dart';
import '../blocs/revenue_breakdown/revenue_breakdown_state.dart';


class ModernChartSection extends StatelessWidget {
  const ModernChartSection({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: PColors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Top Selling Courses",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Top 5 Most Sold",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F4FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "All Time",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5B4DFF),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Chart Content
          BlocBuilder<RevenueBreakdownCubit, RevenueBreakdownState>(
            builder: (context, state) {
              if (state.loading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (state.error != null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Text(
                      'Error loading chart data',
                      style: TextStyle(color: PColors.error.shade400),
                    ),
                  ),
                );
              }

              final revenueData = state.revenueData;

              if (revenueData.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        Icon(
                          Icons.insert_chart_outlined,
                          size: 64,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No sales data available',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Row(
                children: [
                  // Pie Chart
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: Stack(
                      children: [
                        PieChart(
                          PieChartData(
                            sectionsSpace: 4,
                            centerSpaceRadius: 60,
                            sections: _buildPieChartSections(revenueData),
                            borderData: FlBorderData(show: false),
                          ),
                        ),
                        // Center Total
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "${_calculateTotalSales(revenueData)}",
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -1,
                                ),
                              ),
                              Text(
                                "Sales",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 32),

                  // Legend
                  Expanded(
                    child: Column(
                      children: revenueData.asMap().entries.map((entry) {
                        final index = entry.key;
                        final data = entry.value;
                        final color = _getColorForIndex(index);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildLegendItem(
                            color: color,
                            label: data.courseName,
                            value: "${data.salesCount} sales",
                            percentage: data.percentage,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections(List revenueData) {
    return revenueData.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final color = _getColorForIndex(index);

      return PieChartSectionData(
        value: data.percentage,
        color: color,
        radius: 40,
        title: '',
        badgeWidget: null,
      );
    }).toList();
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
    required String value,
    required double percentage,
  }) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        Text(
          "${percentage.toStringAsFixed(1)}%",
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Color _getColorForIndex(int index) {
    const colors = [
      Color(0xFF667EEA), // Purple
      Color(0xFF11998E), // Teal
      Color(0xFFFA709A), // Pink
      Color(0xFFFEE140), // Yellow
      Color(0xFF4776E6), // Blue
    ];
    return colors[index % colors.length];
  }

  int _calculateTotalSales(List<RevenueData> revenueData) {
    return revenueData.fold(0, (sum, data) => sum + data.salesCount);
  }
}