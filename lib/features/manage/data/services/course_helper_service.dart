import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';
import 'package:perfect_super_admin/core/widgets/common/custom_button.dart';
import 'package:perfect_super_admin/features/manage/data/services/preview_video.dart';
import 'package:perfect_super_admin/features/manage/presentation/cubits/course_video_cubit.dart';
import 'package:perfect_super_admin/modules/custom_text_field/widget/text_field.dart';

Future<void> showAddVideoDialog(
  BuildContext context, {
  bool isEdit = false,
  int? index,
  VideoItem? existing,
}) async {
  final titleController = TextEditingController(text: existing?.title ?? '');

  final descController =
      TextEditingController(text: existing?.description ?? '');
  File? selectedVideo = existing?.file;
  String? url = existing?.videoUrl;

  await showDialog(
    context: context,
    builder: (_) => StatefulBuilder(builder: (context, setstate) {
      return Dialog(
        insetPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: PColors.white,
        child: Container(
          padding: const EdgeInsets.all(13.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEdit ? "Edit Video" : "Add Video",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: PColors.textPrimary),
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  controller: titleController,
                  hintText: "Video Title",
                  prefixIcon: Icons.book,
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  controller: descController,
                  hintText: 'Video Description',
                  prefixIcon: Icons.note,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (isEdit)
                      Expanded(
                        child: CustomButton(
                            onPressed: () async {
                              showPreviewVideo(context, null, url);
                            },
                            text: 'Current Video',
                            color: PColors.primary),
                      ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomButton(
                        onPressed: () async {
                          final picked = await ImagePicker()
                              .pickVideo(source: ImageSource.gallery);
                          if (picked != null) {
                            setstate(() {
                              selectedVideo = File(picked.path);
                            });
                          }
                        },
                        text: !isEdit ? (selectedVideo==null ?  'Add Video':'change Video' ): 'Update Video',
                        color: PColors.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(width: 5),
                    if (selectedVideo != null)
                      Expanded(
                        child: CustomButton(
                          onPressed: () {
                            showPreviewVideo(context, selectedVideo, null);
                          },
                          text: !isEdit ? 'Added Video': 'Updated Video',
                          color: PColors.primary,
                        ),
                      ),
                    SizedBox(width: 5),
                    if (selectedVideo != null)
                      Expanded(
                        child: CustomButton(
                          onPressed: () {
                            setstate(() {
                              selectedVideo = null;
                            });
                          },
                          text: 'remove',
                          color: PColors.error,
                        ),
                      )
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      onPressed: () => Navigator.pop(context),
                      text: "Cancel",
                      color: PColors.error,
                    ),
                    CustomButton(
                      onPressed: () {
                        if (titleController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please enter a title")),
                          );
                          return;
                        }

                        if (!isEdit && selectedVideo == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please select a video")),
                          );
                          return;
                        }

                        if (isEdit && index != null) {
                          context.read<CourseVideosCubit>().updateVideo(
                                index,
                                VideoItem(
                                  title: titleController.text,
                                  description: descController.text,
                                  file: selectedVideo ?? existing?.file,
                                  videoUrl: existing?.videoUrl,
                                  publicId: existing?.publicId,
                                  isUpdated: selectedVideo != null ||
                                      titleController.text != existing?.title ||
                                      descController.text !=
                                          existing?.description,
                                  // only true if video changed
                                  isNew: existing?.isNew ?? false,
                                ),
                              );
                        } else {
                          context.read<CourseVideosCubit>().addVideo(
                                title: titleController.text,
                                description: descController.text,
                                file: selectedVideo!,
                                
                              );
                        }

                        Navigator.pop(context);
                      },
                      text: isEdit ? 'Update Video' : 'Add Video',
                      color: PColors.success,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }),
  );
}

Future showRemoeVideoDialog(
  BuildContext context,
) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: PColors.backgrndPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          "Delete Video?",
          style: TextStyle(
              color: PColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Are you sure you want to delete this video?",
          style: TextStyle(color: PColors.textPrimary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              "Cancel",
              style: TextStyle(color: PColors.textPrimary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: PColors.error),
            onPressed: () => Navigator.pop(context, true), // ✅ Delete
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}
