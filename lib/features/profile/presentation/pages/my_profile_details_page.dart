import 'package:flutter/material.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';

class MyProfileDetailsPage extends StatelessWidget {
  const MyProfileDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PColors.backgrndPrimary,
      appBar: AppBar(
        backgroundColor: PColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: PColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: PColors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            
            // Profile Avatar Section
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFFFB800),
                      width: 3,
                    ),
                  ),
                  child: const CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(
                      'https://ui-avatars.com/api/?name=Admin+User&background=random&size=200',
                    ),
                  ),
                ),
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.black,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Name
            const Text(
              'Admin User',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Profile Information Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildProfileInfoCard(
                    icon: Icons.person_outline,
                    text: 'Admin User',
                    isEditable: true,
                    onTap: () {
                      // Navigate to edit name
                    },
                  ),
                  const SizedBox(height: 12),
                  
                  _buildProfileInfoCard(
                    icon: Icons.email_outlined,
                    text: 'admin@elearning.com',
                    isEditable: true,
                    onTap: () {
                      // Navigate to edit email
                    },
                  ),
                  const SizedBox(height: 12),
                  
                  _buildProfileInfoCard(
                    icon: Icons.lock_outline,
                    text: '••••••••',
                    isEditable: true,
                    onTap: () {
                      // Navigate to change password
                    },
                  ),
                  const SizedBox(height: 12),
                  
                  _buildProfileInfoCard(
                    icon: Icons.location_on_outlined,
                    text: 'Kollam, Kerala, India',
                    isEditable: true,
                    onTap: () {
                      // Navigate to edit location
                    },
                  ),
                  const SizedBox(height: 12),
                  
                  _buildProfileInfoCard(
                    icon: Icons.phone_outlined,
                    text: '+91 98765 43210',
                    isEditable: true,
                    onTap: () {
                      // Navigate to edit phone
                    },
                  ),
                  const SizedBox(height: 12),
                  
                  _buildProfileInfoCard(
                    icon: Icons.support_agent_outlined,
                    text: 'Support',
                    isEditable: false,
                    hasArrow: true,
                    onTap: () {
                      // Navigate to support
                    },
                  ),
                  const SizedBox(height: 12),
                  
                  _buildProfileInfoCard(
                    icon: Icons.logout_outlined,
                    text: 'Log Out',
                    isEditable: false,
                    hasArrow: false,
                    iconColor: Colors.red,
                    textColor: Colors.red,
                    onTap: () {
                      _showLogoutDialog(context);
                    },
                  ),
                  
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfoCard({
    required IconData icon,
    required String text,
    required bool isEditable,
    bool hasArrow = false,
    Color? iconColor,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (iconColor ?? Colors.grey).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: iconColor ?? Colors.grey[700],
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: textColor ?? Colors.black87,
                ),
              ),
            ),
            if (isEditable)
              Icon(
                Icons.edit_outlined,
                color: Colors.grey[600],
                size: 20,
              ),
            if (hasArrow)
              Icon(
                Icons.chevron_right,
                color: Colors.grey[600],
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Log Out',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: const Text(
            'Are you sure you want to log out?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // Handle logout logic
                Navigator.pop(context);
                // Navigate to login screen
              },
              child: const Text(
                'Log Out',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}