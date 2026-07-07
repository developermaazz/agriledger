import 'package:agri_ledger/domain/record_status.dart';
import 'package:agri_ledger/shared/formatters/money.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../app/app_dependencies.dart';
import '../../../core/error/app_error_l10n.dart';
import '../../../domain/entities/market.dart';
import '../../../domain/entities/shipment.dart';
import '../../../shared/l10n/l10n.dart';
import '../../../shared/responsive/breakpoints.dart';
import '../../../shared/responsive/max_width_body.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/pull_to_refresh.dart';
import '../../../shared/widgets/firestore_error_view.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../../shared/snackbar/app_snackbar.dart';
import 'shipment_details_screen.dart';
import 'shipment_form_screen.dart';

class ShipmentListScreen extends StatefulWidget {
  const ShipmentListScreen({super.key});

  @override
  State<ShipmentListScreen> createState() => _ShipmentListScreenState();
}

class _ShipmentListScreenState extends State<ShipmentListScreen> {
  final _search = TextEditingController();
  String _query = '';
  String? _statusFilter; // null = all
  String? _marketIdFilter;
  bool _deleting = false;

  @override
  void initState() {
    super.initState();
    _search.addListener(() {
      setState(() => _query = _search.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _refreshShipmentLists() async {
    final deps = AppDependencies.of(context);
    await Future.wait([
      deps.shipmentRepository.refreshFromServer(),
      deps.marketRepository.refreshFromServer(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final shipRepo = AppDependencies.of(context).shipmentRepository;
    final marketRepo = AppDependencies.of(context).marketRepository;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text(context.l10n.shipmentsTitle),
        scrolledUnderElevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        elevation: 2,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const ShipmentFormScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add_rounded),
        label: Text(context.l10n.commonAdd),
      ),
      body: MaxWidthBody(
        maxWidth: Breakpoints.contentMaxWidth,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: cs.surfaceContainerLow,
                border: Border(
                  bottom: BorderSide(
                    color: cs.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _search,
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          hintText: context.l10n.shipmentsSearchHint,
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: cs.onSurfaceVariant,
                          ),
                          suffixIcon: _search.text.isEmpty
                              ? null
                              : IconButton(
                                  tooltip: MaterialLocalizations.of(context)
                                      .deleteButtonTooltip,
                                  onPressed: () {
                                    _search.clear();
                                    setState(() {});
                                  },
                                  icon: Icon(
                                    Icons.close_rounded,
                                    color: cs.onSurfaceVariant,
                                  ),
                                ),
                          filled: true,
                          fillColor: cs.surface,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 12,
                          ),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 14),
                      StreamBuilder<List<Market>>(
                        stream: marketRepo.watchMarkets(),
                        builder: (context, mSnap) {
                          if (mSnap.hasError) {
                            return FirestoreErrorView(
                              error: mSnap.error!,
                              title: context.l10n.shipmentsUnableToLoadMarkets,
                            );
                          }
                          final markets = mSnap.data ?? [];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                context.l10n.commonStatus,
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                      color: cs.onSurfaceVariant,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    _StatusChip(
                                      label: context.l10n.commonAll,
                                      selected: _statusFilter == null,
                                      onTap: () =>
                                          setState(() => _statusFilter = null),
                                    ),
                                    _StatusChip(
                                      label: context.l10n.commonPending,
                                      selected:
                                          _statusFilter == RecordStatuses.pending,
                                      onTap: () => setState(
                                        () => _statusFilter = RecordStatuses.pending,
                                      ),
                                    ),
                                    _StatusChip(
                                      label: context.l10n.commonCompleted,
                                      selected: _statusFilter ==
                                          RecordStatuses.completed,
                                      onTap: () => setState(
                                        () => _statusFilter =
                                            RecordStatuses.completed,
                                      ),
                                    ),
                                    _StatusChip(
                                      label: context.l10n.commonOverpaid,
                                      selected:
                                          _statusFilter == RecordStatuses.overpaid,
                                      onTap: () => setState(
                                        () => _statusFilter =
                                            RecordStatuses.overpaid,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),
                              DropdownButtonFormField<String?>(
                                // ignore: deprecated_member_use
                                value: _marketIdFilter,
                                decoration: InputDecoration(
                                  labelText: context.l10n.shipmentsMarketLabel,
                                  prefixIcon: Icon(
                                    Icons.storefront_outlined,
                                    color: cs.primary,
                                    size: 22,
                                  ),
                                  isDense: true,
                                ),
                                borderRadius: BorderRadius.circular(14),
                                items: [
                                  DropdownMenuItem(
                                    value: null,
                                    child: Text(
                                      context.l10n.shipmentsMarketFilterAll,
                                    ),
                                  ),
                                  ...markets.map(
                                    (m) => DropdownMenuItem(
                                      value: m.id,
                                      child: Text(m.name),
                                    ),
                                  ),
                                ],
                                onChanged: (v) =>
                                    setState(() => _marketIdFilter = v),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshShipmentLists,
                child: StreamBuilder<List<Shipment>>(
                  stream: shipRepo.watchShipments(),
                  builder: (context, snap) {
                    if (snap.hasError) {
                      return MinHeightRefreshContent(
                        child: FirestoreErrorView(
                          error: snap.error!,
                          title: context.l10n.shipmentsUnableToLoad,
                        ),
                      );
                    }
                    if (!snap.hasData) {
                      return MinHeightRefreshContent(
                        child: const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      );
                    }
                    var list = snap.data!;
                    list = list.where((s) {
                      if (_statusFilter != null && s.status != _statusFilter) {
                        return false;
                      }
                      if (_marketIdFilter != null &&
                          s.marketId != _marketIdFilter) {
                        return false;
                      }
                      if (_query.isEmpty) {
                        return true;
                      }
                      final hay = '${s.buyerName} ${s.marketName} ${s.remarks}'
                          .toLowerCase();
                      return hay.contains(_query);
                    }).toList();

                    if (list.isEmpty) {
                      return MinHeightRefreshContent(
                        child: EmptyState(
                          title: context.l10n.shipmentsNoShipmentsTitle,
                          subtitle: context.l10n.shipmentsNoShipmentsSubtitle,
                        ),
                      );
                    }

                    return ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                      itemCount: list.length,
                      itemBuilder: (context, i) {
                        final s = list[i];
                        final locked = s.status == RecordStatuses.completed;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _ShipmentCard(
                            shipment: s,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => locked
                                      ? ShipmentDetailsScreen(shipment: s)
                                      : ShipmentFormScreen(existing: s),
                                ),
                              );
                            },
                            onLongPress:
                                locked ? null : () => _confirmDeleteShipment(s.id),
                            onEdit: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => ShipmentFormScreen(existing: s),
                                ),
                              );
                            },
                            onDelete: () => _confirmDeleteShipment(s.id),
                            showMenu: !locked,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDeleteShipment(String id) async {
    if (_deleting) return;
    final repo = AppDependencies.of(context).shipmentRepository;
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(context.l10n.shipmentsDeleteConfirmTitle),
        content: Text(context.l10n.shipmentsDeleteConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: Text(context.l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(c, true),
            child: Text(context.l10n.commonDelete),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;

    setState(() => _deleting = true);
    try {
      await repo.deleteShipment(id);
      if (!mounted) return;
      AppSnackBar.show(
        context,
        message: context.l10n.shipmentsDeleted,
        type: AppSnackType.success,
      );
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.show(
        context,
        message: appErrorMessage(context, e),
        type: AppSnackType.error,
      );
    } finally {
      if (mounted) {
        setState(() => _deleting = false);
      }
    }
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        selectedColor: cs.primaryContainer,
        labelStyle: TextStyle(
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          color: selected ? cs.onPrimaryContainer : cs.onSurfaceVariant,
        ),
        side: BorderSide(
          color: selected
              ? cs.primary.withValues(alpha: 0.35)
              : cs.outlineVariant.withValues(alpha: 0.9),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class _ShipmentCard extends StatelessWidget {
  const _ShipmentCard({
    required this.shipment,
    required this.onTap,
    required this.onLongPress,
    required this.onEdit,
    required this.onDelete,
    required this.showMenu,
  });

  final Shipment shipment;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool showMenu;

  Color _accent(ColorScheme cs) {
    switch (shipment.status) {
      case RecordStatuses.completed:
        return cs.tertiary;
      case RecordStatuses.overpaid:
        return cs.secondary;
      default:
        return cs.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final s = shipment;
    final accent = _accent(cs);
    final loc = Localizations.localeOf(context).toString();
    final dateStr = DateFormat.yMMMd(loc).format(s.date);

    return Material(
      color: cs.surfaceContainerLow,
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: cs.outlineVariant.withValues(alpha: 0.45),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 5,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(17),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: accent.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.local_shipping_rounded,
                              size: 22,
                              color: accent,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.l10n.shipmentsListTileTitle(
                                    s.serial,
                                    s.marketName,
                                  ),
                                  style: t.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.2,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  s.buyerName,
                                  style: t.bodyMedium?.copyWith(
                                    color: cs.onSurfaceVariant,
                                    height: 1.25,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today_outlined,
                                      size: 14,
                                      color: cs.onSurfaceVariant
                                          .withValues(alpha: 0.85),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      dateStr,
                                      style: t.labelSmall?.copyWith(
                                        color: cs.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              StatusBadge(status: s.status),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: cs.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: cs.outlineVariant
                                        .withValues(alpha: 0.5),
                                  ),
                                ),
                                child: Text(
                                  MoneyFmt.of(s.balance),
                                  style: t.labelLarge?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.3,
                                    color: cs.onSurface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (showMenu)
                Align(
                  alignment: Alignment.topCenter,
                  child: PopupMenuButton<String>(
                    tooltip: context.l10n.commonActions,
                    icon: Icon(
                      Icons.more_vert_rounded,
                      color: cs.onSurfaceVariant,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    onSelected: (v) {
                      if (v == 'edit') {
                        onEdit();
                      } else if (v == 'delete') {
                        onDelete();
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined, size: 20, color: cs.primary),
                            const SizedBox(width: 10),
                            Text(context.l10n.commonEdit),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline, size: 20, color: cs.error),
                            const SizedBox(width: 10),
                            Text(context.l10n.commonDelete),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
