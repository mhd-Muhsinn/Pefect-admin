import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_super_admin/features/manage/presentation/cubits/course_cubit.dart';
import 'package:perfect_super_admin/features/manage/presentation/widgets/course_card.dart';

class CourseStreamBuilder extends StatelessWidget {
  const CourseStreamBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseCubit, List<DocumentSnapshot>>(
      builder: (context, courses) {
        // if (courses.isEmpty) {
        //   return const Center(child: CircularProgressIndicator());
        // }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final course = courses[index];
            
            return CourseCard(
              courseId: course.id,
              name: course['name'] ?? 'No name',
              description: course['description'] ?? '',
              thumbnail: course['thumbnailUrl'] ?? '',
              createdAt: course['createdAt'] ?? Timestamp.now(),
              oldThumbnailPublicId: course['thumbnail_id'] ?? '',
              initialPrice: course['price']?.toString() ?? '0',
              category: course['category'] ?? '',
              subCAtegory: course['subcategory'] ?? '',
              subSubCategory: course['sub_subcategories'] ?? '',
              language: course['language'] ?? '',
              courseType: course['coureType'] ?? '',
             
            );
          },
        );
      },
    );
  }
}


