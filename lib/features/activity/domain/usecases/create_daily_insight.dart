
import '../../data/models/daily_insight_model.dart';
import '../repositories/activity_repository.dart';

class CreateDailyInsight {
  final ActivityRepository repository;

  CreateDailyInsight(this.repository);

  Future<void> call(DailyInsightModel insight) {
    return repository.createDailyInsight(insight);
  }
}
