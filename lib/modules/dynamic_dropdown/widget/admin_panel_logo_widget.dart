import 'package:flutter/material.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';

class AdminPanelSettingsLogoWidget extends StatelessWidget {
  const AdminPanelSettingsLogoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.admin_panel_settings,
            color: PColors.white, size: 18),
        SizedBox(width: 6),
        Text(
          'Admin',
          style: TextStyle(
            color: PColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}