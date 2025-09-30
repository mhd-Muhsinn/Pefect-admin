import 'dart:io';
import 'package:flutter/material.dart';
import 'package:perfect_super_admin/core/constants/sizes.dart';

class IllustationImage extends StatelessWidget {
  const IllustationImage({
    super.key,
    this.width = 56,
    this.height = 56,
    this.overlayColor,
    this.backgroundColor,
    this.image,
    this.fit = BoxFit.cover,
    this.padding = PSizes.sm,
    this.file,
  });

  final BoxFit? fit;
  final String? image;
  final File? file;
  final Color? overlayColor;
  final Color? backgroundColor;
  final double width, height, padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color:  Colors.transparent,
        borderRadius: BorderRadius.circular(width >= height ? width : height),
      ),
      child: _buildAssetImage(),
    );
  }



  // Function to build the asset image widget
  Widget _buildAssetImage() {
    if (image != null) {
      // Display image from assets using Image widget
      return ClipRRect(
        borderRadius: BorderRadius.circular(width >=height ?width :height),
        child: Image(fit: fit, image: AssetImage(image!), color: overlayColor));
    } else {
      // Return an empty container if no image is provided
      return Container();
    }
  }
}