import 'package:flutter/material.dart';
import 'package:perfect_super_admin/core/constants/sizes.dart';

class PDeviceUtils {

  static double getAppBarHeight() {
    return kToolbarHeight;
  }
  static bool isDesktopScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= PSizes.desktopScreenSize;
  }

  static bool isTabletScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= PSizes.mobileScreenSize &&
        MediaQuery.of(context).size.width < PSizes.desktopScreenSize;
  }

  static bool isMobileScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < PSizes.tabletScreenSize;
  }
}
