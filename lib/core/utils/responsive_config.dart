// responsive_config.dart
import 'package:flutter/widgets.dart';

class ResponsiveConfig {
  final BuildContext context;
  ResponsiveConfig(this.context);

  // Screen dimensions
  double get screenWidth => MediaQuery.of(context).size.width;
  double get screenHeight => MediaQuery.of(context).size.height;

  // Spacing system
  double get spacingSmall => percentHeight(0.015);
  double get spacingMedium => percentHeight(0.03);
  double get spacingLarge => percentHeight(0.05);

  // Form dimensions
  double get formFieldWidth => percentWidth(0.85);

  // Percentage calculations
  double percentWidth(double percent) => screenWidth * percent;
  double percentHeight(double percent) => screenHeight * percent;

  double get blocksizehorizontal => screenWidth / 100;
  double get blocksizeveritical=> screenHeight / 100;
  // Add to your ResponsiveConfig class
double get tutorCardAspectRatio {
  // Base ratio for mobile (adjust as needed)
  double baseRatio = 0.8;
  final heightFactor = screenHeight / 800; 
  return baseRatio * heightFactor.clamp(0.8, 1.2); 
}
}
