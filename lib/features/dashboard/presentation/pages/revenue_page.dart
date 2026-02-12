// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';
import 'package:perfect_super_admin/core/utils/responsive_config.dart';
import 'package:perfect_super_admin/features/dashboard/data/repositories/revenue_repository.dart';
import 'package:perfect_super_admin/features/dashboard/presentation/blocs/revenue_export/revenueexport_cubit.dart';

import '../../../../core/widgets/common/gradient_background_container.dart';
import '../blocs/revenue cubit/revenue_cubit.dart';
import '../blocs/revenue cubit/revenue_state.dart';
import '../blocs/revenue_export/revenueexport_state.dart';
import '../widgets/filter_section.dart';
import '../widgets/revenue_summary_card.dart';
import '../widgets/transaction_sheet.dart';

class RevenuePage extends StatelessWidget {
  const RevenuePage({super.key});

  @override
  Widget build(BuildContext context) {
    var size = ResponsiveConfig(context);
    context.read<RevenueCubit>().loadDefaultView();
    return  Scaffold(
        resizeToAvoidBottomInset: true,
        body: GradientBackgroundContaier(
          child: Column(
            children: [
              // Modern Header
              const Header(),
              SizedBox(height: size.percentHeight(0.02)),

              // Filter Section
              const FilterSection(),
              SizedBox(height: size.percentHeight(0.02)),

              // Main Content
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: PColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: BlocBuilder<RevenueCubit, RevenueState>(
                    builder: (context, state) {
                      if (state is RevenueLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation(Color(0xFF667EEA)),
                          ),
                        );
                      }
                      if (state is RevenueError) {
                        return _buildErrorState(state.message);
                      }
                      if (state is RevenueLoaded) {
                        final pageController = PageController();
                        return Column(
                          children: [
                            // PageView for horizontal drag
                            Expanded(
                              flex: 1,
                              child: PageView(
                                controller: pageController,
                                scrollDirection: Axis.horizontal,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 35, vertical: 40),
                                        child: RevenueSummaryCard(
                                          total: state.totalRevenue,
                                          period: state.filterLabel,
                                        ),
                                      ),

                                      // Quick Stats Grid
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 35),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: _buildStatCard(
                                                'Total Sales',
                                                '${state.sales.length}',
                                                Icons.receipt_long,
                                                Colors.blue,
                                              ),
                                            ),
                                            SizedBox(width: 16),
                                            Expanded(
                                              child: _buildStatCard(
                                                'Avg. Sale',
                                                '₹${(state.totalRevenue / (state.sales.isEmpty ? 1 : state.sales.length)).toStringAsFixed(0)}',
                                                Icons.trending_up,
                                                Colors.green,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(height: 20),

                                      Spacer(),

                                      // Swipe indicator
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Swipe for transactions',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Icon(Icons.arrow_forward_ios,
                                                size: 12, color: Colors.grey),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  TransactionSheet(sales: state.sales),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
            ],
          ),)
        );

  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.shade400,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Oops! Something went wrong',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

//  Header Widget
class Header extends StatelessWidget {
  const Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: PColors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.account_balance_wallet_rounded,
              color: PColors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Revenue Dashboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Track your earnings',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: PColors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: PColors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildStatCard(String label, String value, IconData icon, Color color) {
  return Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      children: [
        Icon(icon, color: color, size: 24),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    ),
  );
}
