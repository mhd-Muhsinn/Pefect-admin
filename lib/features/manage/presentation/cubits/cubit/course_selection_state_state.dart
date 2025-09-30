part of 'course_selection_state_cubit.dart';

class CourseSelectionState {
  final String? category;
  final String? subCategory;
  final String? subSubCategory;
  final String? language;
  final String? courseType;

  const CourseSelectionState({
    this.category,
    this.subCategory,
    this.subSubCategory,
    this.language,
    this.courseType,
  });

  CourseSelectionState copyWith({
    String? category,
    String? subCategory,
    String? subSubCategory,
    String? language,
    String? courseType,
  }) {
    return CourseSelectionState(
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      subSubCategory: subSubCategory ?? this.subSubCategory,
      language: language ?? this.language,
      courseType: courseType ?? this.courseType,
    );
  }
}
