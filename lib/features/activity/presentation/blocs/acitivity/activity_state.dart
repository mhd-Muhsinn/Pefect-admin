abstract class ActivityState {}

class ActivityInitial extends ActivityState {}

class ActivityLoading extends ActivityState {}

class ActivitySuccess extends ActivityState {}

class ActivityError extends ActivityState {
  final String message;
  ActivityError(this.message);
}

