import '../../data/models/daily_insight_model.dart';
import '../../data/models/quiz_model.dart';

abstract class ActivityRepository {
  Future<void> createDailyInsight(DailyInsightModel insight);
  Future<void> updateDailyInsight(DailyInsightModel insight);
  Future<void> deleteDailyInsight({
    required String courseId,
    required String insightId,
  });
  Future<void> createQuiz(QuizModel quiz);
}
