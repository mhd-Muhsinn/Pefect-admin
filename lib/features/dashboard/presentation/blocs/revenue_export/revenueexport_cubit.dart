import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/file_service.dart';
import '../../../../../core/services/notification_service.dart';
import '../../../../../core/services/permission_service.dart';
import '../../../data/models/sale_model.dart';
import '../../../domain/usecases/export_revenue_usecase.dart';
import 'revenueexport_state.dart';

class RevenueExportCubit extends Cubit<RevenueExportState> {
  final ExportRevenueUsecase exportUsecase;
  final FileService fileService;
  final NotificationService notificationService;
  final PermissionService permissionService;

  RevenueExportCubit({
    required this.exportUsecase,
    required this.fileService,
    required this.notificationService,
    required this.permissionService,
  }) : super(RevenueExportInitial());

  Future<void> exportToExcel(List<SaleModel> sales) async {
    await permissionService.requestStorage();

    emit(RevenueExportLoading());
    await notificationService.showDownloading(
      id: 1,
      channelId: 'download_channel',
      channelName: 'Downloads',
      title: 'Exporting Revenue',
      body: 'Preparing Excel file...',
    );

    final excel = exportUsecase.createExcel(sales);
    final path = await fileService.saveExcel(excel);

    await notificationService.showCompleted(
      id: 1,
      channelId: 'download_channel',
      channelName: 'Downloads',
      title: 'Download Complete',
      body: 'Tap to open revenue report',
      payload: path,
    );
     emit(RevenueExportSuccess(path));
  }
}
