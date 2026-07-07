import '../record_status.dart';
import 'entity_json.dart';

/// A labour job. `remainingBalance` and `status` are derived from the amounts
/// via [derivedFields] at write time.
class LabourJob {
  const LabourJob({
    required this.id,
    required this.serial,
    required this.dateStart,
    required this.dateEnd,
    required this.totalCost,
    required this.receivedPayment,
    required this.remainingBalance,
    required this.status,
    required this.remarks,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final int serial;
  final DateTime dateStart;
  final DateTime dateEnd;
  final double totalCost;
  final double receivedPayment;
  final double remainingBalance;
  final String status;
  final String remarks;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// The balance/status business rule: `remaining = cost - received`, and the
  /// status is derived from it. Both backends call this.
  static Map<String, dynamic> derivedFields({
    required double totalCost,
    required double receivedPayment,
  }) {
    final remaining = totalCost - receivedPayment;
    return {
      'remainingBalance': remaining,
      'status': statusFromBalance(remaining),
    };
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'serial': serial,
        'dateStart': dateStart.millisecondsSinceEpoch,
        'dateEnd': dateEnd.millisecondsSinceEpoch,
        'totalCost': totalCost,
        'receivedPayment': receivedPayment,
        'remainingBalance': remainingBalance,
        'status': status,
        'remarks': remarks,
        'createdAt': millisFromDate(createdAt),
        'updatedAt': millisFromDate(updatedAt),
      };

  factory LabourJob.fromJson(Map<String, dynamic> json) => LabourJob(
        id: (json['id'] as String?) ?? '',
        serial: (json['serial'] as int?) ?? 0,
        dateStart: dateFromMillis(json['dateStart']) ?? DateTime.now(),
        dateEnd: dateFromMillis(json['dateEnd']) ?? DateTime.now(),
        totalCost: ((json['totalCost'] as num?) ?? 0).toDouble(),
        receivedPayment: ((json['receivedPayment'] as num?) ?? 0).toDouble(),
        remainingBalance: ((json['remainingBalance'] as num?) ?? 0).toDouble(),
        status: (json['status'] as String?) ?? RecordStatuses.pending,
        remarks: (json['remarks'] as String?) ?? '',
        createdAt: dateFromMillis(json['createdAt']),
        updatedAt: dateFromMillis(json['updatedAt']),
      );
}
