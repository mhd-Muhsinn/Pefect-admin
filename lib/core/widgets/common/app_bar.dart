import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';
import 'package:perfect_super_admin/core/constants/sizes.dart';
import 'package:perfect_super_admin/core/device/device_utility.dart';

class PAppbar extends StatelessWidget implements PreferredSizeWidget {
  const PAppbar({
    super.key,
     this.scaffoldkey,
  });
  final GlobalKey<ScaffoldState>? scaffoldkey;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: PColors.white,
          border: Border(bottom: BorderSide(color: PColors.grey, width: 0.5))),
      padding: EdgeInsets.symmetric(horizontal: PSizes.md, vertical: PSizes.sm),
      child: AppBar(
        backgroundColor: PColors.white,
        leading: !PDeviceUtils.isDesktopScreen(context)
            ? IconButton(
                onPressed: () {
                  scaffoldkey?.currentState?.openDrawer();
                },
                icon: const Icon(Iconsax.menu))
            : null,
        title: PDeviceUtils.isDesktopScreen(context)
            ? SizedBox(
                width: 300,
                child: TextFormField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Iconsax.search_normal),
                      hintText: "Search anything..."),
                ),
              )
            : null,
        actions: [
          if (!PDeviceUtils.isDesktopScreen(context))
            IconButton(onPressed: () {}, icon: Icon(Iconsax.search_normal)),
          IconButton(onPressed: () {}, icon: Icon(Iconsax.notification)),
          SizedBox(width: PSizes.spaceBtwItems / 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Iconsax.personalcard),
              const SizedBox(width: PSizes.sm),
              if (!PDeviceUtils.isMobileScreen(context))
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Super Admin',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('admin@gmail.com',
                        style: Theme.of(context).textTheme.labelMedium)
                  ],
                )
            ],
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize =>
      Size.fromHeight(PDeviceUtils.getAppBarHeight() + 15);
}
