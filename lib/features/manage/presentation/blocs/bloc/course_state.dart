part of 'course_bloc.dart';

abstract class CourseState extends Equatable {
  const CourseState();
  @override
  List<Object> get props => [];
}

class CourseInitial extends CourseState {}
class CourseLoading extends CourseState {}
class CourseSuccess extends CourseState {}
class CourseError extends CourseState {
  final String message;
  const CourseError(this.message);
}
class CourseVideoRemoveSuccess extends CourseState {}
class CourseVideoRemoving extends CourseState {}

