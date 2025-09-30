part of 'course_bloc.dart';

@immutable
sealed class CourseEvent {}

class CreateCourseEvent extends CourseEvent {
  final String name;
  final String description;
  final String price;
  final File thumbnail;
  final String category;
  final String subCategory;
  final String subSubCategory;
  final String language;
  final String coursetype;
  final List<Map<String, dynamic>> videos; // {'title', 'description', 'file'}

  CreateCourseEvent({
    required this.name,
    required this.description,
    required this.price,
    required this.thumbnail,
    required this.videos,
    required this.category,
    required this.subCategory,
    required this.subSubCategory,
    required this.language,
    required this.coursetype
  });
}

class EditCourseEvent extends CourseEvent {
  final String courseId;
  final String name;
  final String description;
  final String price;
  final File? newThumbnail;
  final String oldThumbnailPublicId;
  final List<Map<String, dynamic>> videos; // Updated videos

  EditCourseEvent({
    required this.courseId,
    required this.name,
    required this.description,
    required this.price,
    required this.videos,
    this.newThumbnail,
    required this.oldThumbnailPublicId,
  });
}

class CourseVideoRemove extends CourseEvent {
  final String courseId;
  final String courseVideoId;
  final String videoPublicId;
  CourseVideoRemove(this.videoPublicId,
      {required this.courseId, required this.courseVideoId});
}
