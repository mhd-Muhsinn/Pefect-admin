import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';
import 'package:perfect_super_admin/core/utils/responsive_config.dart';
import 'package:perfect_super_admin/core/utils/snackbar_helper.dart';
import 'package:perfect_super_admin/core/widgets/common/custom_button.dart';
import 'package:perfect_super_admin/features/manage/presentation/blocs/bloc/course_bloc.dart';
import 'package:perfect_super_admin/features/manage/presentation/cubits/course_form_cubit.dart';
import 'package:perfect_super_admin/features/manage/presentation/cubits/course_thumbnail_cubit.dart';
import 'package:perfect_super_admin/features/manage/presentation/cubits/course_video_cubit.dart';
import 'package:perfect_super_admin/features/manage/presentation/cubits/cubit/course_selection_state_cubit.dart';
import 'package:perfect_super_admin/features/manage/presentation/widgets/course_details_videos_tabbar.dart';
import 'package:perfect_super_admin/features/manage/presentation/widgets/gradient_container.dart';
import 'package:perfect_super_admin/features/manage/presentation/widgets/video_card.dart';
import 'package:perfect_super_admin/modules/custom_text_field/widget/text_field.dart';
import 'package:perfect_super_admin/modules/dynamic_dropdown/widget/dynamic_dropdown.dart';

class EditCoursePage extends StatelessWidget {
  final String courseId;
  final String oldThumbnailPublicId;
  final String initialName;
  final String initialDescription;
  final String initialPrice;
  final String category;
  final String subCAtegory;
  final String subSubCategory;
  final String language;
  final String courseType;
  final String initialThumbnailUrl;

  final List<Map<String, dynamic>> initialVideos;

  const EditCoursePage({
    super.key,
    required this.courseId,
    required this.oldThumbnailPublicId,
    required this.initialName,
    required this.initialDescription,
    required this.initialPrice,
    required this.initialThumbnailUrl,
    required this.initialVideos,
    required this.category,
    required this.subCAtegory,
    required this.subSubCategory,
    required this.language,
    required this.courseType,
  });

  @override
  Widget build(BuildContext context) {
    final videoItems = initialVideos.map((v) => VideoItem.fromMap(v)).toList();
    // Initialize videos in cubit
    context.read<CourseVideosCubit>().initializeWith(videoItems);
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          context.read<CourseThumbnailCubit>().clearThumbnail();
          context.read<CourseVideosCubit>().clearAll();
        }
      },
      child: BlocProvider(
        create: (_) => CourseFormCubit(
          initialName: initialName,
          initialDescription: initialDescription,
          initialPrice: initialPrice,
        ),
        child: _EditCourseView(
          courseId: courseId,
          oldThumbnailPublicId: oldThumbnailPublicId,
          initialThumbnailUrl: initialThumbnailUrl, category: category,subCAtegory: subCAtegory,subSubCategory: subSubCategory,
          language: language,courseType: courseType,
        ),
      ),
    );
  }
}

class _EditCourseView extends StatelessWidget {
  final String courseId;
  final String oldThumbnailPublicId;
  final String initialThumbnailUrl;
    final String category;
  final String subCAtegory;
  final String subSubCategory;
  final String language;
  final String courseType;

  const _EditCourseView({
    required this.courseId,
    required this.oldThumbnailPublicId,
    required this.initialThumbnailUrl, required this.category, required this.subCAtegory, required this.subSubCategory, required this.language, required this.courseType,
  });

  @override
  Widget build(BuildContext context) {
    final size = ResponsiveConfig(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: PColors.backgrndPrimary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
      ),
      body: BlocConsumer<CourseBloc, CourseState>(
        listener: (context, state) {
          if (state is CourseSuccess) {
            showCustomSnackbar(
                context: context,
                message: "Course Updated",
                size: size,
                backgroundColor: PColors.success);
            Navigator.pop(context);
          }
          if (state is CourseError) {
            showCustomSnackbar(
                context: context,
                message: state.message,
                size: size,
                backgroundColor: PColors.error);
          }
          if (state is CourseVideoRemoveSuccess) {
            showCustomSnackbar(
                context: context,
                message: "Video Removed",
                size: size,
                backgroundColor: PColors.success);
          }
        },
        builder: (context, state) {
          final isLoading = state is CourseLoading;
          return Stack(
            children: [
              GradientContainer(size: size),
              Align(
                  alignment: Alignment.topCenter,
                  child: _buildThumbnailSection(context)),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildVideoSection(size, context)),
              if (isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.4),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: PColors.containerBackground,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildThumbnailSection(BuildContext context) {
    return BlocBuilder<CourseThumbnailCubit, File?>(
      builder: (context, file) => Container(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            InkWell(
              onTap: () => context.read<CourseThumbnailCubit>().pickThumbnail(),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: file != null
                    ? Image.file(file, fit: BoxFit.cover)
                    : Image.network(initialThumbnailUrl, fit: BoxFit.cover),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoSection(ResponsiveConfig size, BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 18.0, left: 10.0, right: 10.0),
      height: size.percentHeight(0.67),
      decoration: BoxDecoration(
        color: PColors.backgrndPrimary,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      child: DetailsAndVideosTabPages(
        tabBuilders: [
          // DETAILS TAB
          ListView(
            children: [
              BlocBuilder<CourseFormCubit, CourseFormState>(
                buildWhen: (p, c) => p.name != c.name,
                builder: (context, state) {
                  return CustomTextFormField(
                    initialValue: state.name,
                    hintText: "Course Name",
                    prefixIcon: Icons.book,
                    onchanged: (val) =>
                        context.read<CourseFormCubit>().updateName(val!),
                  );
                },
              ),
              const SizedBox(height: 16),
              BlocBuilder<CourseFormCubit, CourseFormState>(
                buildWhen: (p, c) => p.description != c.description,
                builder: (context, state) {
                  return CustomTextFormField(
                    initialValue: state.description,
                    hintText: "Description",
                    prefixIcon: Icons.description,
                    keyboardType: TextInputType.multiline,
                    onchanged: (val) =>
                        context.read<CourseFormCubit>().updateDescription(val!),
                  );
                },
              ),
              const SizedBox(height: 16),
              BlocBuilder<CourseFormCubit, CourseFormState>(
                buildWhen: (p, c) => p.price != c.price,
                builder: (context, state) {
                  return CustomTextFormField(
                    initialValue: state.price,
                    hintText: "Price",
                    prefixIcon: Icons.currency_rupee,
                    keyboardType: TextInputType.number,
                    onchanged: (val) =>
                        context.read<CourseFormCubit>().updatePrice(val!),
                  );
                },
              ),
              // BlocBuilder<CourseSelectionCubit, CourseSelectionState>(
              //   builder: (context, state) {
              //     return DynamicDropdown(
              //       title: 'Category',
              //       firestoreField: 'course_categories',
              //       currentValue: category,
              //       onChanged: (val) {
              //         context.read<CourseSelectionCubit>().selectCategory(val);
              //       },
              //     );
              //   },
              // ),
              // BlocBuilder<CourseSelectionCubit, CourseSelectionState>(
              //   builder: (context, state) {
              //     if (category == null) {
              //       // placeholder
              //       return DropdownButtonFormField<String>(
              //         decoration: InputDecoration(labelText: 'Sub Category'),
              //         items: [],
              //         onChanged: null,
              //         hint: Text('Select Category first'),
              //       );
              //     }
              //     return DynamicDropdown(
              //       key: ValueKey(state.category),
              //       title: 'Sub Category',
              //       firestoreField: 'course_subcategories',
              //       nestedKey: category, // pass selected category dynamically here
              //       currentValue: subCAtegory,
              //       onChanged: (val) {
              //         context
              //             .read<CourseSelectionCubit>()
              //             .selectSubCategory(val);
              //       },
              //     );
              //   },
              // ),
              // BlocBuilder<CourseSelectionCubit, CourseSelectionState>(
              //   builder: (context, state) {
              //     if (subCAtegory == null) {
              //       return DropdownButtonFormField<String>(
              //         decoration:
              //             InputDecoration(labelText: 'Sub sub Category'),
              //         items: [],
              //         onChanged: null,
              //         hint: Text('Select Sub Category first'),
              //       );
              //     }

              //     return DynamicDropdown(
              //       key: ValueKey(state.subCategory),
              //       title: 'Sub sub Category',
              //       firestoreField: 'course_sub_subcategories',
              //       nestedKey: subCAtegory,
              //       currentValue: subSubCategory,
              //       onChanged: (val) {
              //         context
              //             .read<CourseSelectionCubit>()
              //             .selectSubSubCategory(val);
              //       },
              //     );
              //   },
              // ),
              // BlocBuilder<CourseSelectionCubit, CourseSelectionState>(
              //   builder: (context, state) {
              //     return DynamicDropdown(
              //       title: 'Language',
              //       firestoreField: 'languages',
              //       currentValue: language,
              //       onChanged: (val) {
              //         context.read<CourseSelectionCubit>().selectLanguage(val);
              //       },
              //     );
              //   },
              // ),
              // BlocBuilder<CourseSelectionCubit, CourseSelectionState>(
              //   builder: (context, state) {
              //     return DynamicDropdown(
              //       title: 'Course Type',
              //       firestoreField: 'course_types',
              //       currentValue: courseType,
              //       onChanged: (val) {
              //         context
              //             .read<CourseSelectionCubit>()
              //             .selectCourseType(val);
              //       },
              //     );
              //   },
              // ),
              const SizedBox(height: 16),
              CustomButton(
                text: "Update Course",
                color: PColors.containerBackground,
                onPressed: () {
                  final formState = context.read<CourseFormCubit>().state;
                  final videosCubit = context.read<CourseVideosCubit>();
                  final newThumbnail =
                      context.read<CourseThumbnailCubit>().state;

                  context.read<CourseBloc>().add(
                        EditCourseEvent(
                          courseId: courseId,
                          name: formState.name.trim(),
                          description: formState.description.trim(),
                          price: formState.price.trim(),
                          videos:
                              videosCubit.state.map((v) => v.toMap()).toList(),
                          newThumbnail: newThumbnail,
                          oldThumbnailPublicId: oldThumbnailPublicId,
                        ),
                      );
                },
              ),
            ],
          ),

          // VIDEOS TAB
          BlocBuilder<CourseVideosCubit, List<VideoItem>>(
            builder: (context, videos) {
              if (videos.isEmpty) {
                return const Text("No videos added yet.");
              }
              return ListView.builder(
                itemCount: videos.length,
                itemBuilder: (context, index) {
                  return VideoCard(
                    entry: MapEntry(index, videos[index]),
                    courseId: courseId,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
