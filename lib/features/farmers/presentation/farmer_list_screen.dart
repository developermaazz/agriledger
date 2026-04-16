import 'package:flutter/material.dart';

import '../../../app/app_dependencies.dart';
import '../../../app/app_router.dart';
import '../../../models/farmer.dart';
import '../../../shared/widgets/empty_state.dart';

class FarmerListScreen extends StatefulWidget {
  const FarmerListScreen({super.key});

  @override
  State<FarmerListScreen> createState() => _FarmerListScreenState();
}

class _FarmerListScreenState extends State<FarmerListScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _query = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final farmersRepo = AppDependencies.of(context).farmerRepository;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmers'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.farmerNew);
        },
        icon: const Icon(Icons.person_add_alt_1_outlined),
        label: const Text('Add farmer'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search by name',
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Farmer>>(
              stream: farmersRepo.watchFarmers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }

                final farmers = snapshot.data ?? const <Farmer>[];
                final filtered = farmers
                    .where((f) => f.name.toLowerCase().contains(_query))
                    .toList();

                if (filtered.isEmpty) {
                  return EmptyState(
                    title: farmers.isEmpty
                        ? 'No farmers yet'
                        : 'No matches for your search',
                    subtitle: farmers.isEmpty
                        ? 'Add your first farmer to start the ledger.'
                        : 'Try a different name.',
                    action: farmers.isEmpty
                        ? FilledButton.icon(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(AppRoutes.farmerNew);
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Add farmer'),
                          )
                        : null,
                  );
                }

                return ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (context, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final farmer = filtered[index];
                    return ListTile(
                      title: Text(farmer.name.isEmpty ? 'Unnamed farmer' : farmer.name),
                      subtitle: Text(
                        'Balance: ${farmer.currentBalance.toStringAsFixed(2)}',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          AppRoutes.farmerDetail,
                          arguments: farmer.id,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
