import 'package:eg_passport_app/features/e_passport/presentation/widgets/e_passport_design.dart';
import 'package:eg_passport_app/features/requests/data/passport_request.dart';
import 'package:flutter/material.dart';

class RequestFilterTabs extends StatelessWidget {
  const RequestFilterTabs({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
    this.countForFilter,
  });

  final RequestFilter selectedFilter;
  final ValueChanged<RequestFilter> onFilterSelected;
  final int Function(RequestFilter filter)? countForFilter;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 620;
        final tabs = RequestFilter.values.map((filter) {
          return _FilterTab(
            filter: filter,
            selected: filter == selectedFilter,
            count: countForFilter?.call(filter),
            onTap: () => onFilterSelected(filter),
            wide: wide,
          );
        }).toList();

        return Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: EPassportColors.surface,
            border: Border.all(color: EPassportColors.border),
            borderRadius: BorderRadius.circular(8),
          ),
          child: wide
              ? Row(children: tabs.map((tab) => Expanded(child: tab)).toList())
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: tabs),
                ),
        );
      },
    );
  }
}

class _FilterTab extends StatelessWidget {
  const _FilterTab({
    required this.filter,
    required this.selected,
    required this.onTap,
    required this.wide,
    this.count,
  });

  final RequestFilter filter;
  final bool selected;
  final VoidCallback onTap;
  final bool wide;
  final int? count;

  Color get _filterAccentColor {
    switch (filter) {
      case RequestFilter.all:
        return EPassportColors.red;
      case RequestFilter.pending:
        return EPassportColors.pending;
      case RequestFilter.approved:
      case RequestFilter.completed:
        return EPassportColors.approved;
      case RequestFilter.rejected:
        return EPassportColors.rejected;
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = selected ? _filterAccentColor : EPassportColors.muted;

    return SizedBox(
      width: wide ? null : 116,
      height: 38,
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: accent,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  filter.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: EPassportTextStyles.body(
                    size: 12,
                    color: selected ? accent : EPassportColors.ink,
                    weight: selected ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
                if (count != null) ...[
                  const SizedBox(width: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? accent.withValues(alpha: 0.12)
                          : EPassportColors.surfaceSoft,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '$count',
                      style: EPassportTextStyles.body(
                        size: 10,
                        color: selected ? accent : EPassportColors.muted,
                        weight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            if (selected)
              Positioned(
                bottom: 0,
                left: 8,
                right: 8,
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
