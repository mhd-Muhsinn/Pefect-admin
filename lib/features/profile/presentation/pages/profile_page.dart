import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';
import 'package:perfect_super_admin/core/constants/image_strings.dart';
import 'package:perfect_super_admin/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:perfect_super_admin/features/profile/presentation/pages/my_profile_details_page.dart';

class AdminProfilePage extends StatelessWidget {
  AdminProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              PColors.primaryVariant,
              PColors.gradient2,
              PColors.gradient3
            ],
          ),
        ),
        child: Column(
          children: [
            // Header Section
            HeaderSection(),

            // Account Overview Card
            Expanded(
              child: OverviewSection(),
            ),
          ],
        ),
      ),
    );
  }
}

class OverviewSection extends StatelessWidget {
  const OverviewSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Account Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 20),

            // Menu Items
            MenuItem(
                icon: Icons.person_outline,
                title: 'My Profile',
                color: const Color(0xFF2196F3),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyProfileDetailsPage()));
                }),
            MenuItem(
                icon: Icons.dashboard_outlined,
                title: 'Dashboard',
                color: const Color(0xFF9C27B0),
                onTap: () {}),
            MenuItem(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                color: const Color(0xFFFF9800),
                onTap: () {}),
            MenuItem(
                icon: Icons.lock_outline,
                title: 'Change Password',
                color: const Color(0xFFE91E63),
                onTap: () {}),
            MenuItem(
                icon: Icons.settings_outlined,
                title: 'Settings',
                color: const Color(0xFF607D8B),
                onTap: () {}),
            MenuItem(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                color: const Color(0xFF00BCD4),
                onTap: () {}),
            MenuItem(
                icon: Icons.description_outlined,
                title: 'Terms & Conditions',
                color: const Color(0xFF4CAF50),
                onTap: () {}),
            MenuItem(
                icon: Icons.help_outline,
                title: 'Help & Support',
                color: const Color(0xFFFF5722),
                onTap: () {}),
            MenuItem(
                icon: Icons.info_outline,
                title: 'About',
                color: const Color(0xFF795548),
                onTap: () {}),

            const SizedBox(height: 20),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(LogOutEvent());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF44336),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // App Version
            Center(
              child: Text(
                'Version 1.0.0',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  const MenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF263238),
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Color(0xFFBDBDBD),
        ),
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Profile Avatar Section
        const SizedBox(height: 20),
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(AppImages.userPlaceholder)),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color(0xFFFF9800),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.admin_panel_settings,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Admin Name and Contact
        const Text(
          'Admin User',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'admin@elearning.com',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),

        const SizedBox(height: 30),
      ],
    );
  }
}


