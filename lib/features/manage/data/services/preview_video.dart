import 'dart:io';

import 'package:flutter/material.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';
import 'package:perfect_super_admin/features/manage/presentation/widgets/video_player_widget.dart';

void showPreviewVideo(BuildContext context, File? file, String? videoUrl) {

  
  showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.black,
          insetPadding: EdgeInsets.zero,
          child: VideoPlayerContainer(file: file,videoUrl: videoUrl,),
        );
      });
}
