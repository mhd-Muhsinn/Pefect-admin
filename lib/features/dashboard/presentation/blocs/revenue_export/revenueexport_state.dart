abstract class RevenueExportState {}

class RevenueExportInitial extends RevenueExportState {}

class RevenueExportLoading extends RevenueExportState {}

class RevenueExportSuccess extends RevenueExportState {
  final String filePath;
  RevenueExportSuccess(this.filePath);
}

class RevenueExportFailure extends RevenueExportState {
  final String message;
  RevenueExportFailure(this.message);
}
