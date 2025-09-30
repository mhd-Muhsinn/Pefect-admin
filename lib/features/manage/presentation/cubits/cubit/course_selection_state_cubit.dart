import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'course_selection_state_state.dart';

class CourseSelectionCubit extends Cubit<CourseSelectionState> {
  CourseSelectionCubit() : super(const CourseSelectionState());

void selectCategory(String? value) {
  emit(state.copyWith(category: value, subCategory: null, subSubCategory: null));
}

void selectSubCategory(String? value) {
  emit(state.copyWith(
    subCategory: value,
    subSubCategory: null,  
  ));
}


  void selectSubSubCategory(String? value) =>
      emit(state.copyWith(subSubCategory: value));

  void selectLanguage(String? value) =>
      emit(state.copyWith(language: value));

  void selectCourseType(String? value) =>
      emit(state.copyWith(courseType: value));

  void reset() => emit(const CourseSelectionState());
}