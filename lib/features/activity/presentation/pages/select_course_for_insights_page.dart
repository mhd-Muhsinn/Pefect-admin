import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_super_admin/core/utils/responsive_config.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constants/colors.dart';
import '../../../manage/presentation/cubits/course_cubit.dart';
import '../../../manage/presentation/widgets/course_stream_builder.dart';
import 'daily_insights_timeline_page.dart';

class SelectCourseForInsightsPage extends StatelessWidget {
  const SelectCourseForInsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PColors.backgrndPrimary,
      appBar: AppBar(
        title: const Text('All Courses'),
        backgroundColor: Colors.transparent,
      ),
      body: const CoursesList(),
    );
  }
}

class CoursesList extends StatelessWidget {
  const CoursesList({super.key});

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

            return GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>DailyInsightsTimelinePage(courseId:  course.id,)));
              },
              child: _CourseCard(
                courseId: course.id,
                name: course['name'] ?? 'No name',
                thumbnail: course['thumbnailUrl'] ?? '',
                language: course['language'] ?? '',
                 
              ),
            );
          },
        );
      },
    );
  }
}

class _CourseCard extends StatelessWidget {
  final String courseId;
  final String name;
  final String thumbnail;
  final String language;
  const _CourseCard({super.key, required this.courseId, required this.name, required this.thumbnail, required this.language});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveConfig(context);
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: responsive.percentHeight(0.01),
        horizontal: responsive.percentWidth(0.01),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.percentWidth(0.04)),
        boxShadow: [
          BoxShadow(
            color: PColors.grey,
            blurRadius: responsive.percentWidth(0.03),
            spreadRadius: responsive.percentWidth(0.01),
            offset: Offset(0, responsive.percentHeight(0.005)),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left side - Photo
          ClipRRect(
            borderRadius: BorderRadius.circular(responsive.percentWidth(0.04)),
            child: SizedBox(
              height: responsive.percentHeight(0.13),
              width: responsive.percentWidth(0.45),
              child: Image.network(
                thumbnail,
                fit: BoxFit.cover,
                // Show shimmer while loading
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(color: Colors.white),
                  );
                },
                // Show icon if error occurs
                errorBuilder: (context, error, stackTrace) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      color: Colors.white,
                      child: Icon(
                        Icons.image,
                        size: responsive.percentWidth(0.1),
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          SizedBox(width: responsive.percentWidth(0.04)),

          // Right side - Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.percentWidth(0.045),
                  ),
                ),
                SizedBox(height: responsive.percentHeight(0.005)),
                SizedBox(height: responsive.percentHeight(0.015)),
                Text(
                  language,
                  style: TextStyle(
                    fontSize: responsive.percentWidth(0.035),
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: responsive.percentHeight(0.015)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
