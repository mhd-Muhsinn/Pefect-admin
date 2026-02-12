import 'dart:io';

import 'package:excel/excel.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class FileService {
  /// Save excel safely (App Documents)
  Future<String> saveExcel(Excel excel) async {
    final directory = await getApplicationDocumentsDirectory();

    final fileName =
        'revenue_report_${DateTime.now().millisecondsSinceEpoch}.xlsx';

    final path = '${directory.path}/$fileName';

    final file = File(path);
    await file.writeAsBytes(excel.encode()!, flush: true);

    return path;
  }

  /// Open saved file
  Future<void> openFile(String path) async {
    await OpenFilex.open(path);
  }
}
