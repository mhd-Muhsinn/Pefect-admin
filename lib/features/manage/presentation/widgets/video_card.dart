import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';
import 'package:perfect_super_admin/core/utils/responsive_config.dart';
import 'package:perfect_super_admin/core/utils/snackbar_helper.dart';
import 'package:perfect_super_admin/features/manage/data/services/course_helper_service.dart';
import 'package:perfect_super_admin/features/manage/presentation/blocs/bloc/course_bloc.dart';
import 'package:perfect_super_admin/features/manage/presentation/cubits/course_cubit.dart';
import 'package:perfect_super_admin/features/manage/presentation/cubits/course_video_cubit.dart';

class VideoCard extends StatelessWidget {
  final MapEntry<int, VideoItem> entry;
  final String? courseId;

  const VideoCard({super.key, required this.entry, this.courseId});

  @override
  Widget build(BuildContext context) {
    final size = ResponsiveConfig(context);
    return Card(
      color: PColors.backgrndPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 8,
      child: ListTile(
        leading: ColoredBox(
          color: PColors.iconbackground,
          child: Icon(
            Icons.play_arrow,
            size: 50,
            color: PColors.primary,
          ),
        ),
        contentPadding: const EdgeInsets.all(12),
        title: Text(entry.value.title,
            style: const TextStyle(
                color: PColors.textPrimary, fontWeight: FontWeight.bold)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: PColors.iconPrimary),
              onPressed: () {
                showAddVideoDialog(context,
                    isEdit: true, index: entry.key, existing: entry.value);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                final shouldDelete = await showRemoeVideoDialog(context);

                if (shouldDelete == true) {
                  // Remove from local cubit state
                  context.read<CourseVideosCubit>().removeVideo(entry.key);

                  if (courseId != null && entry.value.documentId != null) {
                    context.read<CourseBloc>().add(CourseVideoRemove(
                        entry.value.publicId!,
                        courseId: courseId!,
                        courseVideoId: entry.value.documentId!));
                  }
                  showCustomSnackbar(
                    context: context,
                    message: "Video Removed",
                    size: size,
                    backgroundColor: PColors.success
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
