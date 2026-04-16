import 'dart:io';

import 'package:agri_ledger/models/cash_entry.dart';
import 'package:agri_ledger/models/labour_job.dart';
import 'package:agri_ledger/models/shipment.dart';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

/// Excel + PDF export helpers (files written to temp dir, then shared).
class ExportService {
  static final _dateFmt = DateFormat('yyyy-MM-dd');
  static final _tsFmt = DateFormat('yyyyMMdd_HHmmss');

  static Future<File> exportShipmentsExcel(List<Shipment> rows) async {
    final excel = Excel.createExcel();
    excel.delete('Sheet1');
    final sheet = excel['Shipments'];
    sheet.appendRow([
      TextCellValue('S.No'),
      TextCellValue('Date'),
      TextCellValue('Market'),
      TextCellValue('Buyer'),
      TextCellValue('Qty'),
      TextCellValue('Total'),
      TextCellValue('Received'),
      TextCellValue('Balance'),
      TextCellValue('Status'),
      TextCellValue('Remarks'),
    ]);
    for (final s in rows) {
      sheet.appendRow([
        IntCellValue(s.serial),
        TextCellValue(_dateFmt.format(s.date)),
        TextCellValue(s.marketName),
        TextCellValue(s.buyerName),
        DoubleCellValue(s.quantity),
        DoubleCellValue(s.totalAmount),
        DoubleCellValue(s.amountReceived),
        DoubleCellValue(s.balance),
        TextCellValue(s.status),
        TextCellValue(s.remarks),
      ]);
    }
    final bytes = excel.encode()!;
    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/shipments_${_tsFmt.format(DateTime.now())}.xlsx';
    final f = File(path);
    await f.writeAsBytes(bytes, flush: true);
    return f;
  }

  static Future<File> exportCashExcel(String marketName, List<CashEntry> rows) async {
    final excel = Excel.createExcel();
    excel.delete('Sheet1');
    final safe = marketName.replaceAll(RegExp(r'[^\w-]'), '_');
    final sheet = excel['Cash_$safe'];
    sheet.appendRow([
      TextCellValue('S.No'),
      TextCellValue('Date'),
      TextCellValue('AmountReceived'),
      TextCellValue('PrevCash'),
      TextCellValue('CashAvailable'),
      TextCellValue('Payments'),
      TextCellValue('Balance'),
      TextCellValue('Remarks'),
    ]);
    for (final e in rows) {
      sheet.appendRow([
        IntCellValue(e.serial),
        TextCellValue(_dateFmt.format(e.date)),
        DoubleCellValue(e.amountReceived),
        DoubleCellValue(e.previousCash),
        DoubleCellValue(e.cashAvailable),
        DoubleCellValue(e.payments),
        DoubleCellValue(e.balance),
        TextCellValue(e.remarks),
      ]);
    }
    final bytes = excel.encode()!;
    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/cash_${_tsFmt.format(DateTime.now())}.xlsx';
    final f = File(path);
    await f.writeAsBytes(bytes, flush: true);
    return f;
  }

  static Future<File> exportLabourExcel(List<LabourJob> rows) async {
    final excel = Excel.createExcel();
    excel.delete('Sheet1');
    final sheet = excel['Labour'];
    sheet.appendRow([
      TextCellValue('S.No'),
      TextCellValue('Start'),
      TextCellValue('End'),
      TextCellValue('TotalCost'),
      TextCellValue('Received'),
      TextCellValue('Remaining'),
      TextCellValue('Status'),
      TextCellValue('Remarks'),
    ]);
    for (final j in rows) {
      sheet.appendRow([
        IntCellValue(j.serial),
        TextCellValue(_dateFmt.format(j.dateStart)),
        TextCellValue(_dateFmt.format(j.dateEnd)),
        DoubleCellValue(j.totalCost),
        DoubleCellValue(j.receivedPayment),
        DoubleCellValue(j.remainingBalance),
        TextCellValue(j.status),
        TextCellValue(j.remarks),
      ]);
    }
    final bytes = excel.encode()!;
    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/labour_${_tsFmt.format(DateTime.now())}.xlsx';
    final f = File(path);
    await f.writeAsBytes(bytes, flush: true);
    return f;
  }

  static Future<File> exportSummaryExcel({
    required DateTime from,
    required DateTime to,
    required int totalShipments,
    required double totalRevenue,
    required double totalReceived,
    required double totalPendingShipments,
    required double totalPendingLabour,
    required double totalCashAvailable,
    required double totalLabourCost,
  }) async {
    final excel = Excel.createExcel();
    excel.delete('Sheet1');
    final sheet = excel['Summary'];
    sheet.appendRow([TextCellValue('From'), TextCellValue(_dateFmt.format(from))]);
    sheet.appendRow([TextCellValue('To'), TextCellValue(_dateFmt.format(to))]);
    sheet.appendRow([TextCellValue('Total shipments'), IntCellValue(totalShipments)]);
    sheet.appendRow([
      TextCellValue('Total revenue'),
      DoubleCellValue(totalRevenue),
    ]);
    sheet.appendRow([
      TextCellValue('Total received'),
      DoubleCellValue(totalReceived),
    ]);
    sheet.appendRow([
      TextCellValue('Pending shipments'),
      DoubleCellValue(totalPendingShipments),
    ]);
    sheet.appendRow([
      TextCellValue('Pending labour'),
      DoubleCellValue(totalPendingLabour),
    ]);
    sheet.appendRow([
      TextCellValue('Cash available'),
      DoubleCellValue(totalCashAvailable),
    ]);
    sheet.appendRow([
      TextCellValue('Labour expenses'),
      DoubleCellValue(totalLabourCost),
    ]);
    final bytes = excel.encode()!;
    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/summary_${_tsFmt.format(DateTime.now())}.xlsx';
    final f = File(path);
    await f.writeAsBytes(bytes, flush: true);
    return f;
  }

  static Future<File> exportSummaryPdf({
    required DateTime from,
    required DateTime to,
    required int totalShipments,
    required double totalRevenue,
    required double totalReceived,
    required double totalPendingShipments,
    required double totalPendingLabour,
    required double totalCashAvailable,
    required double totalLabourCost,
  }) async {
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Fruit trading summary',
                style:
                    pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            pw.Text(
                '${_dateFmt.format(from)}  –  ${_dateFmt.format(to)}'),
            pw.SizedBox(height: 16),
            pw.Bullet(text: 'Total shipments: $totalShipments'),
            pw.Bullet(text: 'Total revenue (shipments): ${totalRevenue.toStringAsFixed(2)}'),
            pw.Bullet(text: 'Total received (shipments): ${totalReceived.toStringAsFixed(2)}'),
            pw.Bullet(text: 'Pending (shipments): ${totalPendingShipments.toStringAsFixed(2)}'),
            pw.Bullet(text: 'Pending (labour): ${totalPendingLabour.toStringAsFixed(2)}'),
            pw.Bullet(text: 'Cash available (markets): ${totalCashAvailable.toStringAsFixed(2)}'),
            pw.Bullet(text: 'Labour expenses: ${totalLabourCost.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
    final bytes = await doc.save();
    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/summary_${_tsFmt.format(DateTime.now())}.pdf';
    final f = File(path);
    await f.writeAsBytes(bytes, flush: true);
    return f;
  }

  static Future<void> shareFile(File file) async {
    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path)]),
    );
  }
}
