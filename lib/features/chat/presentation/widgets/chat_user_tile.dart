import 'package:flutter/material.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';
import 'package:perfect_super_admin/core/utils/responsive_config.dart';

class ChatUserTile extends StatelessWidget {
  final String nameUT;
  final String uidUT;
  void Function()? onTap;
  ChatUserTile(
      {super.key,
      required this.nameUT,
      required this.uidUT,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    ResponsiveConfig size = ResponsiveConfig(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: PColors.backgrndPrimary,
        

        ),
   
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //profile icon
            Icon(Icons.person_2_rounded),
            SizedBox(width: size.percentWidth(0.02)),
            //name and email
            Text(nameUT),
            //audio and video call icons
            SizedBox(width: size.percentWidth(0.02)),
            Icon(Icons.call),
            Icon(Icons.video_camera_front_rounded)
          ],
        ),
      ),
    );
  }
}
