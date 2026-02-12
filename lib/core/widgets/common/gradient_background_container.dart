import 'package:flutter/material.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';

class GradientBackgroundContaier extends StatelessWidget {
  final Widget child;
  const GradientBackgroundContaier({super.key,required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [PColors.gradient1, PColors.gradient2, PColors.gradient3],
    )),
    child: child,
    
    );
  }
}
