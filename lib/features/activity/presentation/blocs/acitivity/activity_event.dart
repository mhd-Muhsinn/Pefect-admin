import '../../../data/models/daily_insight_model.dart';
import '../../../data/models/quiz_model.dart';

abstract class ActivityEvent {}

class CreateDailyInsightEvent extends ActivityEvent {
  final DailyInsightModel insight;
  CreateDailyInsightEvent(this.insight);
}

class UpdateDailyInsightEvent extends ActivityEvent {
  final DailyInsightModel insight;
  UpdateDailyInsightEvent(this.insight);
}

class DeleteDailyInsightEvent extends ActivityEvent {
  final String courseId;
  final String insightId;
  DeleteDailyInsightEvent({
    required this.courseId,
    required this.insightId,
  });
}
class CreateQuizEvent extends ActivityEvent {
  final QuizModel quiz;
  CreateQuizEvent(this.quiz);
}

