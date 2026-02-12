import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';
import 'package:perfect_super_admin/core/utils/responsive_config.dart';
import 'package:perfect_super_admin/features/manage/data/services/course_delete_helper.dart';
import 'package:perfect_super_admin/features/manage/data/services/firebase_course_service.dart';
import 'package:perfect_super_admin/features/manage/presentation/pages/edit_course_page.dart';
import 'package:shimmer/shimmer.dart';

class CourseCard extends StatelessWidget {
  final String courseId;
  final String name;
  final String description;
  final String thumbnail;
  final String oldThumbnailPublicId;
  final String initialPrice;
  final String category;
  final String subCAtegory;
  final String subSubCategory;
  final String language;
  final String courseType;
  final Timestamp createdAt;

  const CourseCard({
    super.key,
    required this.name,
    required this.description,
    required this.thumbnail,
    required this.createdAt,
    required this.oldThumbnailPublicId,
    required this.initialPrice,
    required this.courseId,
    required this.category,
    required this.subCAtegory,
    required this.subSubCategory,
    required this.courseType,
    required this.language
  });



  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveConfig(context);

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: FirebaseCourseService().fetchVideos(courseId),
      builder: (context, snapshot) {
        final videos = snapshot.data ?? [];
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
                borderRadius:
                    BorderRadius.circular(responsive.percentWidth(0.04)),
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

              PopupMenuButton<String>(
                color: PColors.backgrndPrimary,
                onSelected: (value) async {
                  if (value == 'edit') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditCoursePage(
                          courseId: courseId,
                          oldThumbnailPublicId: oldThumbnailPublicId,
                          initialName: name,
                          initialDescription: description,
                          initialPrice: initialPrice,
                          initialThumbnailUrl: thumbnail,
                          initialVideos: videos, category: category, subCAtegory: subCAtegory, subSubCategory: subSubCategory, language: language, courseType: courseType,
                        ),
                      ),
                    );
                  } else if (value == 'delete') {
                    await showDeleteCourseDialog(context, courseId);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),
        );
      },
    );
  }
}
