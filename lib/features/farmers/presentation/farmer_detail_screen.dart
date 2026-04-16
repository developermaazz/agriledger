import 'package:flutter/material.dart';

import '../../../app/app_dependencies.dart';
import '../../../app/app_router.dart';
import '../../../models/farmer.dart';
import '../../../models/ledger_entry.dart';
import '../../../shared/widgets/empty_state.dart';
import 'farmer_form_screen.dart';

class FarmerDetailScreen extends StatelessWidget {
  const FarmerDetailScreen({super.key, required this.farmerId});

  final String farmerId;

  @override
  Widget build(BuildContext context) {
    final farmersRepo = AppDependencies.of(context).farmerRepository;
    final ledgerRepo = AppDependencies.of(context).ledgerRepository;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmer'),
        actions: [
          IconButton(
            tooltip: 'Edit farmer',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => FarmerFormScreen(farmerId: farmerId),
                ),
              );
            },
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed(
            AppRoutes.entryNew,
            arguments: {'farmerId': farmerId},
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add entry'),
      ),
      body: StreamBuilder<Farmer>(
        stream: farmersRepo.watchFarmer(farmerId),
        builder: (context, farmerSnap) {
          if (farmerSnap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (farmerSnap.hasError) {
            return Center(child: Text(farmerSnap.error.toString()));
          }
          final farmer = farmerSnap.data;
          if (farmer == null) {
            return const Center(child: Text('Farmer not found'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        farmer.name.isEmpty ? 'Unnamed farmer' : farmer.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      _InfoRow(label: 'Phone', value: farmer.phone),
                      _InfoRow(label: 'Address', value: farmer.address),
                      if (farmer.notes.isNotEmpty)
                        _InfoRow(label: 'Notes', value: farmer.notes),
                      const Divider(height: 24),
                      Text(
                        'Current balance',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        farmer.currentBalance.toStringAsFixed(2),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Credits increase the balance, debits decrease it.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Ledger',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              StreamBuilder<List<LedgerEntry>>(
                stream: ledgerRepo.watchEntries(farmerId),
                builder: (context, entriesSnap) {
                  if (entriesSnap.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    );
                  }
                  if (entriesSnap.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(entriesSnap.error.toString()),
                    );
                  }

                  final entries = entriesSnap.data ?? const <LedgerEntry>[];
                  if (entries.isEmpty) {
                    return const EmptyState(
                      title: 'No ledger entries yet',
                      subtitle: 'Tap “Add entry” to record a credit or debit.',
                    );
                  }

                  return Card(
                    child: Column(
                      children: [
                        for (var i = 0; i < entries.length; i++) ...[
                          if (i != 0) const Divider(height: 1),
                          ListTile(
                            title: Text(entries[i].description.isEmpty
                                ? entries[i].typeLabel
                                : entries[i].description),
                            subtitle: Text(
                              '${entries[i].entryDate.toLocal().toString().split('.').first} • ${entries[i].typeLabel}',
                            ),
                            trailing: Text(
                              entries[i].signedAmount >= 0
                                  ? '+${entries[i].amount.toStringAsFixed(2)}'
                                  : '-${entries[i].amount.toStringAsFixed(2)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: entries[i].type ==
                                            LedgerEntryType.credit
                                        ? Colors.green.shade800
                                        : Colors.red.shade800,
                                  ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    if (value.trim().isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 86,
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
