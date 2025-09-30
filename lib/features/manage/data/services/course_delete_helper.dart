import 'package:flutter/material.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';
import 'package:perfect_super_admin/core/utils/snackbar_helper.dart';
import 'package:perfect_super_admin/features/manage/data/services/firebase_course_service.dart';

Future<void> showDeleteCourseDialog(
    BuildContext context, String courseId) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Delete Course"),
        content: const Text(
          "Are you sure you want to delete this course? This action cannot be undone.",
        ),
        actions: [
          TextButton(
            child: const Text("Cancel",
                style: TextStyle(color: PColors.textPrimary)),
            onPressed: () {
              Navigator.of(context).pop(); // close dialog
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text(
              "Delete",
              style: TextStyle(color: PColors.white),
            ),
            onPressed: () async {
             await FirebaseCourseService().deletecourse(courseId); // delete
              Navigator.of(context).pop(); // close dialog
              
   
            },
          ),
        ],
      );
    },
  );
}
