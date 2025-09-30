// imports omitted
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';
import 'package:perfect_super_admin/core/utils/form_validator.dart';
import 'package:perfect_super_admin/core/utils/responsive_config.dart';
import 'package:perfect_super_admin/core/utils/snackbar_helper.dart';
import 'package:perfect_super_admin/core/widgets/common/custom_button.dart';
import 'package:perfect_super_admin/features/manage/data/services/course_helper_service.dart';
import 'package:perfect_super_admin/features/manage/data/services/media/cloudinary_service.dart';
import 'package:perfect_super_admin/features/manage/presentation/blocs/bloc/course_bloc.dart';
import 'package:perfect_super_admin/features/manage/presentation/cubits/course_thumbnail_cubit.dart';
import 'package:perfect_super_admin/features/manage/presentation/cubits/course_video_cubit.dart';
import 'package:perfect_super_admin/features/manage/presentation/cubits/cubit/course_selection_state_cubit.dart';
import 'package:perfect_super_admin/features/manage/presentation/widgets/video_card.dart';
import 'package:perfect_super_admin/modules/custom_text_field/widget/text_field.dart';
import 'package:perfect_super_admin/modules/dynamic_dropdown/widget/dynamic_dropdown.dart';

class AddCoursePage extends StatelessWidget {
  AddCoursePage({super.key});

  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveConfig(context);
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {},
      child: Scaffold(
          appBar: AppBar(
            title: Text("Add New Course",
                style: TextStyle(color: PColors.textWhite)),
            backgroundColor: PColors.containerBackground,
            iconTheme: IconThemeData(color: PColors.textWhite),
          ),
          backgroundColor: PColors.backgrndPrimary,
          body: BlocConsumer<CourseBloc, CourseState>(
            listener: (context, state) {
              if (state is CourseSuccess) {
                showCustomSnackbar(
                    context: context,
                    message: 'COURSE ADDED',
                    size: responsive,
                    backgroundColor: PColors.success,
                    icon: Icons.import_contacts);
                context.read<CourseThumbnailCubit>().clearThumbnail();
                context.read<CourseVideosCubit>().clearAll();
                Navigator.pop(context);
              } else if (state is CourseError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              final isLoading = state is CourseLoading;
              return Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: responsive.spacingMedium),
                    child: ListView(
                      children: [
                        SizedBox(height: responsive.spacingMedium),
                        Align(
                            child:
                                _buildThumbnailSection(context, responsive)),
                        SizedBox(height: responsive.spacingMedium),
                        _buildInputFields(context, responsive),
                        SizedBox(height: responsive.spacingMedium),
                        _buildVideosSection(context, responsive),
                        SizedBox(height: responsive.spacingLarge),
                        _buildSubmitButton(context),
                        SizedBox(height: responsive.spacingLarge),
                      ],
                    ),
                  ),
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
          )),
    );
  }

  Widget _buildInputFields(BuildContext context, ResponsiveConfig responsive) {
    return Form(
      key: formkey,
      child: Column(
        children: [
          CustomTextFormField(
            controller: _nameController,
            hintText: "Course Name",
            prefixIcon: Icons.book,
            validator: (value) {
              return Validator.validateRequired(value,
                  fieldName: 'course name');
            },
          ),
          SizedBox(height: responsive.spacingMedium),
          CustomTextFormField(
            controller: _descController,
            hintText: "Description",
            prefixIcon: Icons.description,
            keyboardType: TextInputType.multiline,
            validator: (value) {
              return Validator.validateRequired(value,
                  fieldName: 'Description');
            },
          ),
          SizedBox(height: responsive.spacingMedium),
          CustomTextFormField(
            controller: _priceController,
            hintText: "Price",
            prefixIcon: Icons.currency_rupee,
            keyboardType: TextInputType.number,
            validator: (value) {
              return Validator.validateRequired(value, fieldName: 'Price');
            },
          ),
          BlocBuilder<CourseSelectionCubit, CourseSelectionState>(
            builder: (context, state) {
              return DynamicDropdown(
                title: 'Category',
                firestoreField: 'course_categories',
                currentValue:
                    state.category, // use state.category instead of String?
                onChanged: (val) {
                  context.read<CourseSelectionCubit>().selectCategory(val);
                },
              );
            },
          ),
          BlocBuilder<CourseSelectionCubit, CourseSelectionState>(
            builder: (context, state) {
              if (state.category == null) {
                // placeholder
                return DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Sub Category'),
                  items: [],
                  onChanged: null,
                  hint: Text('Select Category first'),
                );
              }
              return DynamicDropdown(
                key: ValueKey(state.category),
                title: 'Sub Category',
                firestoreField: 'course_subcategories',
                nestedKey:
                    state.category, // pass selected category dynamically here
                currentValue: state.subCategory,
                onChanged: (val) {
                  context.read<CourseSelectionCubit>().selectSubCategory(val);
                },
              );
            },
          ),
          BlocBuilder<CourseSelectionCubit, CourseSelectionState>(
            builder: (context, state) {
              if (state.subCategory == null) {
                return DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Sub sub Category'),
                  items: [],
                  onChanged: null,
                  hint: Text('Select Sub Category first'),
                );
              }

              return DynamicDropdown(
                key: ValueKey(state.subCategory),
                title: 'Sub sub Category',
                firestoreField: 'course_sub_subcategories',
                nestedKey: state.subCategory,
                currentValue: state.subSubCategory,
                onChanged: (val) {
                  context
                      .read<CourseSelectionCubit>()
                      .selectSubSubCategory(val);
                },
              );
            },
          ),
          BlocBuilder<CourseSelectionCubit, CourseSelectionState>(
            builder: (context, state) {
              return DynamicDropdown(
                title: 'Language',
                firestoreField: 'languages',
                currentValue: state.language,
                onChanged: (val) {
                  context.read<CourseSelectionCubit>().selectLanguage(val);
                },
              );
            },
          ),
          BlocBuilder<CourseSelectionCubit, CourseSelectionState>(
            builder: (context, state) {
              return DynamicDropdown(
                title: 'Course Type',
                firestoreField: 'course_types',
                currentValue: state.language,
                onChanged: (val) {
                  context.read<CourseSelectionCubit>().selectCourseType(val);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnailSection(
      BuildContext context, ResponsiveConfig responsive) {
    return BlocBuilder<CourseThumbnailCubit, File?>(
      builder: (context, file) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (file != null)
            Column(
              children: [
                Image.file(file,
                    height: 200, width: double.infinity, fit: BoxFit.contain),
              ],
            ),
          ElevatedButton.icon(
            onPressed: () =>
                context.read<CourseThumbnailCubit>().pickThumbnail(),
            icon: const Icon(Icons.image, color: PColors.white),
            label: Text(file != null ? 'Change thumbanil' : "Add Thumbnail"),
            style: ElevatedButton.styleFrom(
              backgroundColor: PColors.containerBackground,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(
                  color: Colors.blueAccent,
                  width: 2,
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideosSection(
      BuildContext context, ResponsiveConfig responsive) {
    return BlocBuilder<CourseVideosCubit, List<VideoItem>>(
      builder: (context, videos) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton.icon(
            onPressed: () => showAddVideoDialog(context),
            icon: const Icon(Icons.video_call, color: Colors.white),
            label:
                const Text("Add Video", style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: PColors.containerBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            ),
          ),
          SizedBox(height: responsive.spacingMedium),
          if (videos.isNotEmpty) ...[
            const SizedBox(height: 10),
            const Text("Added Videos:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            ...videos.asMap().entries.map((entry) => VideoCard(
                  entry: entry,
                )),
          ],
        ],
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return CustomButton(
        onPressed: () {
          if (Validator.checkFormValid(formkey)) {
            submit(
              context,
              _nameController,
              _priceController,
              _descController,
            );
          }
        },
        text: "SAVE COURSE",
        color: PColors.containerBackground);
  }
}
