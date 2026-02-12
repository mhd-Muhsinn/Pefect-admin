import 'package:flutter/material.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';
import 'package:perfect_super_admin/core/constants/gradients.dart';
import 'package:perfect_super_admin/core/utils/responsive_config.dart';
import 'package:perfect_super_admin/features/manage/presentation/pages/admin_user_page.dart';
import 'package:perfect_super_admin/features/manage/presentation/widgets/primary_card.dart';
import 'package:perfect_super_admin/features/manage/presentation/widgets/stats_card.dart';
import 'package:perfect_super_admin/modules/dynamic_dropdown/widget/admin_panel_logo_widget.dart';

import '../../../../core/widgets/common/gradient_background_container.dart';

class ManageScreen extends StatelessWidget {
  const ManageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = ResponsiveConfig(context);

    return Scaffold(
      body: GradientBackgroundContaier(
        child: Column(
          children: [
            HeaderSection(size: size),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: PColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(size.percentWidth(0.05)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      /// QUICK ACTIONS SECTION
                      QuickActionsSection(size: size),
                      SizedBox(height: size.percentHeight(0.03)),

                      /// MAIN ACTIONS SECTION
                      MainActionsSection(size: size),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {   //HeaderSection
  const HeaderSection({super.key, required this.size});
  final ResponsiveConfig size;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(size.percentWidth(0.05)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: PColors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.dashboard_rounded,
                  color: PColors.white,
                  size: 28,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: PColors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: AdminPanelSettingsLogoWidget(),
              ),
            ],
          ),
          SizedBox(height: size.percentHeight(0.03)),
          const Text(
            'Management',
            style: TextStyle(
              color: PColors.white,
              fontSize: 36,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Control your e-learning platform',
            style: TextStyle(
              color: PColors.white.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class QuickActionsSection extends StatelessWidget {  //Quick Action with statsCard
  final ResponsiveConfig size;
  const QuickActionsSection({super.key, required this.size});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1F36),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: StatsCard(
                context: context,
                title: 'New Trainers Requests',
                icon: Icons.person_add_rounded,
                color: const Color(0xFFEF4444),
                stat: '5',
                onTap: () => Navigator.pushNamed(context, '/trainersrequests'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatsCard(
                context: context,
                title: 'Manage Users',
                icon: Icons.people_rounded,
                color: const Color(0xFF3B82F6),
                stat: '342',
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminUsersPage())),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class MainActionsSection extends StatelessWidget {   //Main Actions w
  final ResponsiveConfig size;
  const MainActionsSection({
    super.key,
    required this.size,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Manage Platform',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1F36),
          ),
        ),
        const SizedBox(height: 16),
        PrimaryCard(
          context: context,
          title: 'Manage Trainers',
          subtitle: 'View and manage all trainers',
          icon: Icons.school_rounded,
          gradient: AppGradients.purple,
          onTap: () => Navigator.pushNamed(context, '/tutorall'),
        ),
        SizedBox(height: size.percentHeight(0.02)),
        PrimaryCard(
          context: context,
          title: 'All Courses',
          subtitle: 'Browse and edit courses',
          icon: Icons.library_books_rounded,
          gradient: AppGradients.purpleAlt,
          onTap: () => Navigator.pushNamed(context, '/allcourses'),
        ),
        SizedBox(height: size.percentHeight(0.02)),
        PrimaryCard(
          context: context,
          title: 'Create New Course',
          subtitle: 'Add a new course to platform',
          icon: Icons.add_circle_rounded,
          gradient: AppGradients.green,
          onTap: () => Navigator.pushNamed(context, '/addcoursePage'),
        ),
      ],
    );
  }
}
