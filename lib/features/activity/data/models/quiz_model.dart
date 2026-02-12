import 'package:perfect_super_admin/features/activity/data/models/question_mode.dart';

class QuizModel {
  final String quizId;
  final String title;
  final List<QuestionModel> questions;
  final String createdBy;

  QuizModel({
    required this.quizId,
    required this.title,
    required this.questions,
    required this.createdBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'questions': questions.map((q) => q.toMap()).toList(),
      'date': DateTime.now(),
      'createdBy': createdBy,
      'createdAt': DateTime.now(),
    };
  }
}
