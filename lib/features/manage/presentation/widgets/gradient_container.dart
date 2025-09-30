import 'package:flutter/material.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';
import 'package:perfect_super_admin/core/utils/responsive_config.dart';

class GradientContainer extends StatelessWidget {
  final ResponsiveConfig size;
  const GradientContainer({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.percentHeight(0.4),
      decoration: BoxDecoration(gradient: LinearGradient(colors: [
       Color(0xff2196F3), Color(0xff0D47A1)
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter
      )),
    );
  }
}
