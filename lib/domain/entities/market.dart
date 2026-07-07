import 'entity_json.dart';

/// A market. `cashSerialNext` is the next per-market cash-entry serial.
class Market {
  const Market({
    required this.id,
    required this.name,
    required this.cashSerialNext,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final int cashSerialNext;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'cashSerialNext': cashSerialNext,
        'createdAt': millisFromDate(createdAt),
        'updatedAt': millisFromDate(updatedAt),
      };

  factory Market.fromJson(Map<String, dynamic> json) => Market(
        id: (json['id'] as String?) ?? '',
        name: (json['name'] as String?) ?? '',
        cashSerialNext: (json['cashSerialNext'] as int?) ?? 1,
        createdAt: dateFromMillis(json['createdAt']),
        updatedAt: dateFromMillis(json['updatedAt']),
      );
}
