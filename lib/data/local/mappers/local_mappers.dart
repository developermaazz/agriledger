import '../../../domain/entities/cash_entry.dart';
import '../../../domain/entities/labour_job.dart';
import '../../../domain/entities/market.dart';
import '../../../domain/entities/shipment.dart';
import '../db/app_database.dart';

/// drift row -> entity mappers. Dates are stored as epoch millis.

DateTime? _optDate(int? millis) =>
    millis == null ? null : DateTime.fromMillisecondsSinceEpoch(millis);

Market marketFromRow(MarketRow r) => Market(
      id: r.id,
      name: r.name,
      cashSerialNext: r.cashSerialNext,
      createdAt: _optDate(r.createdAt),
      updatedAt: _optDate(r.updatedAt),
    );

Shipment shipmentFromRow(ShipmentRow r) => Shipment(
      id: r.id,
      serial: r.serial,
      date: DateTime.fromMillisecondsSinceEpoch(r.date),
      marketId: r.marketId,
      marketName: r.marketName,
      buyerName: r.buyerName,
      quantity: r.quantity,
      totalAmount: r.totalAmount,
      amountReceived: r.amountReceived,
      balance: r.balance,
      status: r.status,
      remarks: r.remarks,
      createdAt: _optDate(r.createdAt),
      updatedAt: _optDate(r.updatedAt),
    );

CashEntry cashEntryFromRow(CashEntryRow r) => CashEntry(
      id: r.id,
      serial: r.serial,
      date: DateTime.fromMillisecondsSinceEpoch(r.date),
      amountReceived: r.amountReceived,
      payments: r.payments,
      previousCash: r.previousCash,
      cashAvailable: r.cashAvailable,
      balance: r.balance,
      remarks: r.remarks,
      createdAt: _optDate(r.createdAt),
      updatedAt: _optDate(r.updatedAt),
    );

LabourJob labourFromRow(LabourJobRow r) => LabourJob(
      id: r.id,
      serial: r.serial,
      dateStart: DateTime.fromMillisecondsSinceEpoch(r.dateStart),
      dateEnd: DateTime.fromMillisecondsSinceEpoch(r.dateEnd),
      totalCost: r.totalCost,
      receivedPayment: r.receivedPayment,
      remainingBalance: r.remainingBalance,
      status: r.status,
      remarks: r.remarks,
      createdAt: _optDate(r.createdAt),
      updatedAt: _optDate(r.updatedAt),
    );
