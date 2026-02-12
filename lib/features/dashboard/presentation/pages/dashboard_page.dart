import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';
import 'package:perfect_super_admin/core/services/permission_service.dart';
import 'package:perfect_super_admin/core/utils/responsive_config.dart';
import 'package:perfect_super_admin/features/dashboard/presentation/widgets/recent_report_sheet.dart';

import '../../../../main.dart';
import '../../data/repositories/stats_repository.dart';
import '../../data/services/stats_service.dart';
import '../blocs/revenue_breakdown/revenue_breakdown_cubit.dart';
import '../blocs/salesreport_cubit/salesreport_cubit.dart';
import '../blocs/stats_cubit/stats_cubit.dart';
import '../blocs/stats_cubit/stats_state.dart';
import '../widgets/piechart_widget.dart';
import 'revenue_page.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = ResponsiveConfig(context);

    // Create repository and service
    final repository = DashboardRepository();
    final service = DashboardService(repository);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => StatisticsCubit(service)..startListening(),
        ),
        BlocProvider(
          create: (context) =>
              SalesReportCubit(service)..startListening(limit: 8),
        ),
        BlocProvider(
          create: (context) => RevenueBreakdownCubit(service)..startListening(),
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FE),
        body: CustomScrollView(
          slivers: [
            // App Bar with Gradient
            SliverAppBar(
              expandedHeight: 180,
              floating: false,
              pinned: true,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        PColors.primary,
                        PColors.primary.withOpacity(0.8),
                        PColors.gradient3
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.percentWidth(0.05),
                        vertical: 20,
                      ),
                      child: const ModernProfileBar(),
                    ),
                  ),
                ),
              ),
            ),

            // Content
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: size.percentWidth(0.05),
                vertical: 20,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Stats Cards
                  const ModernStatsCards(),

                  const SizedBox(height: 24),

                
                  // const ModernChartSection(),

                  const SizedBox(height: 24),

                  // Recent Transactions Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: PColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Iconsax.chart_square,
                              color: PColors.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            "Recent Transactions",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RevenuePage()));
                        },
                        icon: const Text("View All"),
                        label: const Icon(Icons.arrow_forward_ios, size: 14),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Sales Table
                  const ModernSalesTable(),

                  const SizedBox(height: 40),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ModernProfileBar extends StatefulWidget {
  const ModernProfileBar({super.key});

  @override
  State<ModernProfileBar> createState() => _ModernProfileBarState();
}

class _ModernProfileBarState extends State<ModernProfileBar> {
  @override
  void initState() {
    super.initState();
    PermissionService().requestStorage();
    PermissionService().requestNotificationPermission(notifications);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateStr = DateFormat('EEEE, MMM d').format(now);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Top Row with Avatar and Notification
        Row(
          children: [
            // Avatar with online indicator
            Stack(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    image: const DecorationImage(
                      image: NetworkImage("https://i.pravatar.cc/150?img=11"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00E676),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),

            const Spacer(),

            // Notification Button
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: IconButton(
                onPressed: () {},
                icon: Badge(
                  label: const Text('3'),
                  backgroundColor: PColors.error,
                  textColor: Colors.white,
                  child: const Icon(
                    Iconsax.notification,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Greeting Text
        Text(
          "Welcome back, Admin! 👋",
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 4),

        // Date
        Text(
          dateStr,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class ModernStatsCards extends StatelessWidget {
  const ModernStatsCards({super.key});

  @override
  Widget build(BuildContext context) {
    final size = ResponsiveConfig(context);

    return BlocBuilder<StatisticsCubit, StatisticsState>(
      builder: (context, state) {
        if (state.loading) {
          return _buildLoadingSkeleton(size);
        }

        if (state.error != null) {
          return Center(
            child: Text(
              'Error loading statistics',
              style: TextStyle(color: Colors.red.shade400),
            ),
          );
        }

        if (state.statistics != null) {
          final stats = state.statistics!;

          return Column(
            children: [
              // First Row - Main Stats
              Row(
                children: [
                  Expanded(
                    child: _buildGlassCard(
                      title: "Total Users",
                      value: _formatNumber(stats.totalUsers),
                      icon: Iconsax.people,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                      ),
                      trend: "+12.5%",
                      trendUp: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildGlassCard(
                      title: "Total Revenue",
                      value: "₹${_formatCurrency(stats.totalIncome)}",
                      icon: Iconsax.money_4,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
                      ),
                      trend: "+8.3%",
                      trendUp: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Second Row - Secondary Stats
              Row(
                children: [
                  Expanded(
                    child: _buildGlassCard(
                      title: "Total Courses",
                      value: _formatNumber(stats.totalCourses),
                      icon: Iconsax.book_1,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFA709A), Color(0xFFFEE140)],
                      ),
                      trend: "+3",
                      trendUp: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildGlassCard(
                      title: "Total Tutors",
                      value: _formatNumber(stats.totalTutors),
                      icon: Iconsax.teacher,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4776E6), Color(0xFF8E54E9)],
                      ),
                      trend: "+2",
                      trendUp: true,
                    ),
                  ),
                ],
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildGlassCard({
    required String title,
    required String value,
    required IconData icon,
    required Gradient gradient,
    String? trend,
    bool trendUp = true,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: gradient.colors.first.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              if (trend != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: trendUp
                        ? const Color(0xFFE8F5E9)
                        : const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        trendUp ? Icons.trending_up : Icons.trending_down,
                        size: 14,
                        color: trendUp
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFFF44336),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        trend,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: trendUp
                              ? const Color(0xFF4CAF50)
                              : const Color(0xFFF44336),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingSkeleton(ResponsiveConfig size) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildSkeletonCard()),
            const SizedBox(width: 16),
            Expanded(child: _buildSkeletonCard()),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildSkeletonCard()),
            const SizedBox(width: 16),
            Expanded(child: _buildSkeletonCard()),
          ],
        ),
      ],
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      return "${(number / 1000).toStringAsFixed(1)}K";
    }
    return number.toString();
  }

  String _formatCurrency(double amount) {
    if (amount >= 10000000) {
      return "${(amount / 10000000).toStringAsFixed(2)}Cr";
    } else if (amount >= 100000) {
      return "${(amount / 100000).toStringAsFixed(2)}L";
    }
    return amount.toStringAsFixed(0);
  }
}
