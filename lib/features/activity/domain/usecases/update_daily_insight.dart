import '../../data/models/daily_insight_model.dart';
import '../repositories/activity_repository.dart';

class UpdateDailyInsight {
  final ActivityRepository repository;

  UpdateDailyInsight(this.repository);

  Future<void> call(DailyInsightModel insight) {
    return repository.updateDailyInsight(insight);
  }
}
