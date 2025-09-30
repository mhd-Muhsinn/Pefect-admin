import 'package:flutter/material.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';
import 'package:perfect_super_admin/core/utils/responsive_config.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final double? fontsize;
  const CustomButton(
      {super.key,
      required this.onPressed,
      required this.text,
      this.fontsize =17,
      required this.color});

  @override
  Widget build(BuildContext context) {
    final size = ResponsiveConfig(context);
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(7),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Text(
          text,
          style: TextStyle(
              fontWeight: FontWeight.w600, fontSize: fontsize, color: PColors.white),
        ),
      ),
    );
  }
}
