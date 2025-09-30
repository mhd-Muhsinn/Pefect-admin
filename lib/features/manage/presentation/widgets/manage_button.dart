import 'package:flutter/material.dart';
import 'package:perfect_super_admin/core/utils/responsive_config.dart';

class ManageButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onTap;
  final bool isSmall;

  const ManageButton({
    Key? key,
    required this.label,
    required this.onTap,
    this.icon,
    this.isSmall = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = ResponsiveConfig(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        width: isSmall ? size.percentWidth(0.28) : double.infinity,
        height: isSmall ? size.percentHeight(0.12) : size.percentHeight(0.10),
        padding: const EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(vertical: size.percentHeight(0.01)),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xff2196F3), Color(0xff0D47A1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Icon(icon, color: Colors.white, size: isSmall ? 24 : 30),
            if (icon != null) const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: isSmall ? 12 : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
