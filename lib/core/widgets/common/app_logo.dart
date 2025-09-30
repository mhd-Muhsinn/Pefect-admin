import 'package:flutter/material.dart';
import 'package:perfect_super_admin/core/constants/image_strings.dart';

class AppLogo extends StatelessWidget {
  final double? height;
  final double? width;
   AppLogo({super.key,  this.height,  this.width});

  @override
  Widget build(BuildContext context) {
    return Image.asset(PImages.applogo, width: width, height: height);
  }
}