import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';
import 'package:perfect_super_admin/core/utils/responsive_config.dart';

void showCustomSnackbar({
  required BuildContext context,
  required String message,
  Color backgroundColor = Colors.transparent,
  Color textColor = Colors.white,
  Duration duration = const Duration(seconds: 3),
  IconData icon = Icons.error,
  required ResponsiveConfig size,
}) {
  final snackBar = SnackBar(
    content: Row(
      children: [
        Icon(icon,color: PColors.backgrndPrimary,),
        SizedBox(width:size.spacingSmall ),
        Text(
          message,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
        ),
      ],
    ),
    backgroundColor: backgroundColor,
    duration: duration,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    margin: EdgeInsets.symmetric(
      horizontal: size.percentWidth(0.05),
      vertical: size.spacingSmall,
    ),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
