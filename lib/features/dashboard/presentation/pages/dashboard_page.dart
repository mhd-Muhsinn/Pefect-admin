import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';
import 'package:perfect_super_admin/core/constants/sizes.dart';
import 'package:perfect_super_admin/core/utils/responsive_config.dart';
import 'package:perfect_super_admin/features/dashboard/presentation/widgets/info_card.dart';
import 'package:perfect_super_admin/features/dashboard/presentation/widgets/piechart_widget.dart';
import 'package:perfect_super_admin/features/dashboard/presentation/widgets/recent_report_sheet.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = ResponsiveConfig(context);
    return Scaffold(
      backgroundColor: PColors.backgrndPrimary,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildProfileSection(),
            SizedBox(height: size.percentHeight(0.03)),
            _buildCardSection(size),
            SizedBox(height: size.percentHeight(0.05)),
            RecentReportSheet(size: size,),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(size.percentWidth(0.05)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: _BuildChartReport(size),
            )
          ],
        ),
      ),
    );
  }

  Widget _BuildChartReport(
    ResponsiveConfig size,
  ) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: PColors.primary,
          ),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: size.spacingSmall,
          ),
          Text(
            "Monthly Report",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(
            height: size.spacingSmall,
          ),
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(),
            child: PieChartWidget(),
          ),
          SizedBox(
            height: size.spacingSmall,
          ),
        ],
      ),
    );
  }

  Widget _buildCardSection(ResponsiveConfig size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.percentWidth(0.05)),
      child: Row(
        
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InfoCard(title: "Total Users", value: '2000343', icon: Icons.person_4_outlined, color: PColors.containerBackground, size: size),
          InfoCard(title: "Total Sales", value: '108098098', icon: Icons.currency_rupee_outlined, color: PColors.success, size: size),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Icon(Icons.person, size: PSizes.iconLg),
        Text(
          "Admin Panel",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        IconButton(
            onPressed: () {},
            icon: Badge.count(
                count: 3,
                backgroundColor: PColors.error,
                child: Icon(
                  Icons.notifications,
                  size: PSizes.iconLg,
                  color: PColors.containerBackground,
            )))
      ],
    );
  }
}
