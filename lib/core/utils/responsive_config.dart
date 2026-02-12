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
  double get blocksizeveritical => screenHeight / 100;

  /// Scalable Font Size
  double sp(double percent) {
    return (screenWidth + screenHeight) / 2 * percent / 100;
  }

  double get keyboardHeight => MediaQuery.of(context).viewInsets.bottom;

  /// Optional safe height when keyboard opens
  double get availableHeight => screenHeight - keyboardHeight;
}
