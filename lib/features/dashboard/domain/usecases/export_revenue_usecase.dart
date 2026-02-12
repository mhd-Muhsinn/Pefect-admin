import 'package:excel/excel.dart';

import '../../data/models/sale_model.dart';

class ExportRevenueUsecase {
  Excel createExcel(List<SaleModel> sales) {
    final excel = Excel.createExcel();
    final sheet = excel['Revenue'];
    excel.delete('Sheet1');

    sheet.appendRow([
      TextCellValue('Course Name'),
      TextCellValue('Customer Name'),
      TextCellValue('Amount'),
      TextCellValue('Date'),
    ]);

    for (final sale in sales) {
      sheet.appendRow([
        TextCellValue(sale.courseName),
        TextCellValue(sale.customerName),
        DoubleCellValue(sale.amount),
        DateCellValue(
          year: sale.date.year,
          month: sale.date.month,
          day: sale.date.day,
        ),
      ]);
    }

    return excel;
  }
}
