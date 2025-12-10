import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
// Keep your existing imports
import 'package:perfect_super_admin/core/constants/colors.dart';
import 'package:perfect_super_admin/core/constants/sizes.dart';
import 'package:perfect_super_admin/core/utils/responsive_config.dart';
import 'package:perfect_super_admin/features/dashboard/presentation/pages/revenue_page.dart';
import 'package:perfect_super_admin/features/dashboard/presentation/widgets/info_card.dart'; // Ensure this widget is styled well too, or see my inline suggestion
import 'package:perfect_super_admin/features/dashboard/presentation/widgets/piechart_widget.dart';
import 'package:perfect_super_admin/features/dashboard/presentation/widgets/recent_report_sheet.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = ResponsiveConfig(context);
    final theme = Theme.of(context);

    return Scaffold(
      // Use a slightly off-white background for contrast against white cards
      backgroundColor: PColors.backgrndPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: size.percentWidth(0.05), vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Bar
              const ProfileBar(),
              
              SizedBox(height: size.percentHeight(0.03)),

              // 2. Welcome/Stats Header
              Text(
                "Overview",
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              
              // 3. Info Cards (Refined Layout)
              DashboardCards(size: size),
              
              SizedBox(height: size.percentHeight(0.03)),

              // 4. Chart Section (Modernized)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ChartReport(size: size),
              ),

              SizedBox(height: size.percentHeight(0.03)),

              //  Recent Reports Header with Action
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recent Transactions",
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const RevenuePage())
                    ),
                    child: const Text("View All"),
                  ),
                ],
              ),
              
              const SizedBox(height: 10),

              // 6. Recent Report Widget (Container styled)
              Container(
                 decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: RecentReportSheet(size: size),
              ),
              
              // Bottom spacing
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileBar extends StatelessWidget {
  const ProfileBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Avatar
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue.shade100,
            image: const DecorationImage(
              // Placeholder image, replace with user url
              image: NetworkImage("https://i.pravatar.cc/150?img=11"), 
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 12),
        
        // Greeting
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome back,",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
              const Text(
                "Super Admin",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),

        // Notification Icon
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: IconButton(
            onPressed: () {},
            icon: Badge(
              label: const Text('3'),
              backgroundColor: PColors.error,
              child: const Icon(Iconsax.notification, color: Colors.black87),
            ),
          ),
        )
      ],
    );
  }
}

class DashboardCards extends StatelessWidget {
  const DashboardCards({super.key, required this.size});

  final ResponsiveConfig size;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildModernInfoCard(
            title: "Total Users",
            value: "2,403",
            icon: Iconsax.people,
            color: const Color(0xFF6B4EFF), // Purple accent
            bgColor: const Color(0xFFF2F0FF),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildModernInfoCard(
            title: "Total Sales",
            value: "₹ 1.2Cr",
            icon: Iconsax.money,
            color: const Color(0xFF00C853), // Green accent
            bgColor: const Color(0xFFE8F5E9),
          ),
        ),
      ],
    );
  }

  Widget _buildModernInfoCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 20),
              ),
              // Optional: % growth indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20)
                ),
                child: const Text("+12%", style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class ChartReport extends StatelessWidget {
  final ResponsiveConfig size;
  const ChartReport({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header within the chart card
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Monthly Revenue",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  "Aug - Sep 2024",
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                ),
              ],
            ),
            IconButton(
              onPressed: (){}, 
              icon: const Icon(Icons.more_horiz, color: Colors.grey)
            )
          ],
        ),
        const SizedBox(height: 20),
        
        // Chart + Legend Row
        Row(
          children: [
            // The Pie Chart
            SizedBox(
              height: 180,
              width: 180,
              child: Stack(
                children: [
                   const PieChartWidget(),
                   // Center Text for Donut feel
                   Center(
                     child: Text("78%", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: PColors.primary)),
                   )
                ],
              ),
            ),
            const SizedBox(width: 20),
            
            // Custom Legend
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _legendItem(color: Colors.blue, label: "Courses", value: "45%"),
                  const SizedBox(height: 12),
                  _legendItem(color: Colors.purple, label: "Mentoring", value: "30%"),
                  const SizedBox(height: 12),
                  _legendItem(color: Colors.orange, label: "E-Books", value: "25%"),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _legendItem({required Color color, required String label, required String value}) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
        const Spacer(),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
      ],
    );
  }
}