import '../../domain/repositories/auth_provider.dart';
import '../../domain/repositories/labour_store.dart';
import '../../domain/repositories/market_cash_store.dart';
import '../../domain/repositories/market_store.dart';
import '../../domain/repositories/serial_meta_store.dart';
import '../../domain/repositories/shipment_store.dart';
import '../../domain/repositories/storage_provider.dart';
import 'backend_kind.dart';

/// A fully-constructed set of backend implementations for one [BackendKind].
///
/// Settings are intentionally NOT part of this bundle — they are device-local
/// configuration shared across all backends.
class Backend {
  Backend({
    required this.kind,
    required this.auth,
    required this.shipments,
    required this.markets,
    required this.marketCash,
    required this.labour,
    required this.serialMeta,
    required this.storage,
    Future<void> Function()? onDispose,
  }) : _onDispose = onDispose;

  final BackendKind kind;
  final AuthProvider auth;
  final ShipmentStore shipments;
  final MarketStore markets;
  final MarketCashStore marketCash;
  final LabourStore labour;
  final SerialMetaStore serialMeta;
  final StorageProvider storage;

  final Future<void> Function()? _onDispose;

  /// Releases backend resources (e.g. closes the local database). Called when
  /// switching backends at runtime.
  Future<void> dispose() async => _onDispose?.call();
}
