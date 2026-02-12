import '../repositories/activity_repository.dart';

class DeleteDailyInsight {
  final ActivityRepository repository;

  DeleteDailyInsight(this.repository);

  Future<void> call({
    required String courseId,
    required String insightId,
  }) {
    return repository.deleteDailyInsight(
      courseId: courseId,
      insightId: insightId,
    );
  }
}
