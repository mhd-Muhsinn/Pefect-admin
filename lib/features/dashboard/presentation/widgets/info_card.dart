import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';
import 'package:perfect_super_admin/core/utils/responsive_config.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final ResponsiveConfig size;
  final Color? borderColor;

  const InfoCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.size,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.percentWidth(0.42),
      padding: EdgeInsets.all(size.percentWidth(0.04)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color
        )
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(title,style: GoogleFonts.lato(),),
          SizedBox(height: size.percentHeight(0.003)),
          Text(value, style: TextStyle(fontSize: size.percentWidth(0.04), fontWeight: FontWeight.bold)),
          ],),
          SizedBox(width: size.percentWidth(0.03)),
          Icon(icon, size: size.percentHeight(0.04), color: color),
        ],
      ),
    );
  }
}
