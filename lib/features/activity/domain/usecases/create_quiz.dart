import '../../data/models/quiz_model.dart';
import '../repositories/activity_repository.dart';

class CreateQuiz {
  final ActivityRepository repository;

  CreateQuiz(this.repository);

  Future<void> call(QuizModel quiz) {
    return repository.createQuiz(quiz);
  }
}
