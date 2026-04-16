import 'package:agri_ledger/domain/cash_ledger_math.dart';
import 'package:agri_ledger/models/cash_entry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('recomputeCashChain carries balance forward', () {
    final entries = [
      CashEntry(
        id: 'a',
        serial: 1,
        date: DateTime(2025, 1, 1),
        amountReceived: 100,
        payments: 30,
        previousCash: 0,
        cashAvailable: 0,
        balance: 0,
        remarks: '',
        createdAt: null,
        updatedAt: null,
      ),
      CashEntry(
        id: 'b',
        serial: 2,
        date: DateTime(2025, 1, 2),
        amountReceived: 50,
        payments: 20,
        previousCash: 0,
        cashAvailable: 0,
        balance: 0,
        remarks: '',
        createdAt: null,
        updatedAt: null,
      ),
    ];

    final out = recomputeCashChain(entries);
    expect(out[0].previousCash, 0);
    expect(out[0].cashAvailable, 100);
    expect(out[0].balance, 70);

    expect(out[1].previousCash, 70);
    expect(out[1].cashAvailable, 120);
    expect(out[1].balance, 100);
  });
}
