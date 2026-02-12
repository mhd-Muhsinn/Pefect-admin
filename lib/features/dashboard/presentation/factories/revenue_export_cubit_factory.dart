import '../../../../core/services/file_service.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/services/permission_service.dart';
import '../../../../main.dart';
import '../../domain/usecases/export_revenue_usecase.dart';
import '../blocs/revenue_export/revenueexport_cubit.dart';

class RevenueExportCubitFactory {
  static RevenueExportCubit create() {
    return RevenueExportCubit(
      exportUsecase: ExportRevenueUsecase(),
      fileService: FileService(),
      notificationService: NotificationService(notifications),
      permissionService: PermissionService(),
    );
  }
}
