import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/repositories/activity_repository.dart';
import '../models/daily_insight_model.dart';
import '../models/quiz_model.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  final FirebaseFirestore firestore;

  ActivityRepositoryImpl(this.firestore);
 @override
  Future<void> createDailyInsight(DailyInsightModel insight) async {
    await firestore
        .collection('activity')
        .doc('daily_insights')
        .collection(insight.courseId)
        .doc(insight.id)
        .set(insight.toMap());
  }

  @override
  Future<void> updateDailyInsight(DailyInsightModel insight) async {
    await firestore
        .collection('activity')
        .doc('daily_insights')
        .collection(insight.courseId)
        .doc(insight.id)
        .update(insight.toMap());
  }

  @override
  Future<void> deleteDailyInsight({
    required String courseId,
    required String insightId,
  }) async {
    await firestore
        .collection('activity')
        .doc('daily_insights')
        .collection(courseId)
        .doc(insightId)
        .delete();
  }

  @override
  Future<void> createQuiz(QuizModel quiz) async {
    await firestore
        .collection('activity')
        .doc('quiz')
        .collection('quizzes')
        .doc(quiz.quizId)
        .set(quiz.toMap());
  }
}
