import 'package:bloc/bloc.dart';
import '../../../domain/usecases/create_daily_insight.dart';
import '../../../domain/usecases/create_quiz.dart';
import '../../../domain/usecases/delete_daily_insight.dart';
import '../../../domain/usecases/update_daily_insight.dart';
import 'activity_event.dart';
import 'activity_state.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  final CreateDailyInsight createDailyInsight;
  final UpdateDailyInsight updateDailyInsight;
  final DeleteDailyInsight deleteDailyInsight;
  final CreateQuiz createQuiz;

  ActivityBloc({
    required this.createDailyInsight,
    required this.updateDailyInsight,
    required this.deleteDailyInsight,
    required this.createQuiz,
  }) : super(ActivityInitial()) {
    on<CreateDailyInsightEvent>(_onCreateDailyInsight);
    on<UpdateDailyInsightEvent>(_onUpdateDailyInsight);
    on<DeleteDailyInsightEvent>(_onDeleteDailyInsight);
    on<CreateQuizEvent>(_onCreateQuiz);
  }

  Future<void> _onCreateDailyInsight(
    CreateDailyInsightEvent event,
    Emitter<ActivityState> emit,
  ) async {
    emit(ActivityLoading());
    try {
      await createDailyInsight(event.insight);
      emit(ActivitySuccess());
    } catch (e) {
      emit(ActivityError(e.toString()));
    }
  }

  Future<void> _onUpdateDailyInsight(
    UpdateDailyInsightEvent event,
    Emitter<ActivityState> emit,
  ) async {
    emit(ActivityLoading());
    try {
      await updateDailyInsight(event.insight);
      emit(ActivitySuccess());
    } catch (e) {
      emit(ActivityError(e.toString()));
    }
  }

  Future<void> _onDeleteDailyInsight(
    DeleteDailyInsightEvent event,
    Emitter<ActivityState> emit,
  ) async {
    emit(ActivityLoading());
    try {
      await deleteDailyInsight(
        courseId: event.courseId,
        insightId: event.insightId,
      );
      emit(ActivitySuccess());
    } catch (e) {
      emit(ActivityError(e.toString()));
    }
  }

  Future<void> _onCreateQuiz(
    CreateQuizEvent event,
    Emitter<ActivityState> emit,
  ) async {
    emit(ActivityLoading());
    try {
      await createQuiz(event.quiz);
      emit(ActivitySuccess());
    } catch (e) {
      emit(ActivityError(e.toString()));
    }
  }
}

