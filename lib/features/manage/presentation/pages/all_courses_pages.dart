import 'package:flutter/material.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';
import 'package:perfect_super_admin/features/manage/presentation/widgets/course_stream_builder.dart';

class AllCoursesPages extends StatelessWidget {
  const AllCoursesPages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PColors.backgrndPrimary,
      appBar: AppBar(
        title: const Text('All Courses'),
        backgroundColor: Colors.transparent,
      ),
      body: const CourseStreamBuilder(),
    );
  }
}
