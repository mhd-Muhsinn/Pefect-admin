/// Revenue Data Model
/// Represents top selling courses for charts
class RevenueData {
  final String courseName;
  final int salesCount;
  final double percentage;

  RevenueData({
    required this.courseName,
    required this.salesCount,
    required this.percentage,
  });
}