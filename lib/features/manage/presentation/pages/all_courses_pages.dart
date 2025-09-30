import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';
import 'package:perfect_super_admin/features/manage/presentation/cubits/course_cubit.dart';
import 'package:perfect_super_admin/features/manage/presentation/widgets/course_stream_builder.dart';

class AllCoursesPages extends StatelessWidget {
  const AllCoursesPages({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CourseCubit(FirebaseFirestore.instance),
      child: Scaffold(
        backgroundColor: PColors.backgrndPrimary,
        appBar: AppBar(
          title: const Text('All Courses'),
          backgroundColor: Colors.transparent,
        ),
        body: const CourseStreamBuilder(),
      ),
    );
  }
}
