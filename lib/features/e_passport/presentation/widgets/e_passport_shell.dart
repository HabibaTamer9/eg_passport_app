import 'package:eg_passport_app/features/e_passport/e_passport_routes.dart';
import 'package:eg_passport_app/features/e_passport/presentation/widgets/e_passport_design.dart';
import 'package:flutter/material.dart';

enum EPassportDestination {
  home,
  identity,
  requests,
  documents,
  notifications,
  profile,
  settings,
}

extension EPassportDestinationInfo on EPassportDestination {
  String get label {
    switch (this) {
      case EPassportDestination.home:
        return 'الرئيسية';
      case EPassportDestination.identity:
        return 'الهوية الرقمية';
      case EPassportDestination.requests:
        return 'طلباتي';
      case EPassportDestination.documents:
        return 'المستندات';
      case EPassportDestination.notifications:
        return 'الإشعارات';
      case EPassportDestination.profile:
        return 'الملف الشخصي';
      case EPassportDestination.settings:
        return 'الإعدادات';
    }
  }

  IconData get icon {
    switch (this) {
      case EPassportDestination.home:
        return Icons.home_outlined;
      case EPassportDestination.identity:
        return Icons.badge_outlined;
      case EPassportDestination.requests:
        return Icons.receipt_long_outlined;
      case EPassportDestination.documents:
        return Icons.folder_copy_outlined;
      case EPassportDestination.notifications:
        return Icons.notifications_none_rounded;
      case EPassportDestination.profile:
        return Icons.person_outline;
      case EPassportDestination.settings:
        return Icons.settings_outlined;
    }
  }

  String? get routeName {
    switch (this) {
      case EPassportDestination.requests:
        return EPassportRoutes.requests;
      case EPassportDestination.documents:
        return EPassportRoutes.documents;
      case EPassportDestination.profile:
        //return ProfileScreen.routeName;
      case EPassportDestination.home:
      case EPassportDestination.identity:
      case EPassportDestination.notifications:
      case EPassportDestination.settings:
        return null;
    }
  }
}

class EPassportShell extends StatelessWidget {
  const EPassportShell({
    super.key,
    required this.activeDestination,
    required this.child,
  });

  static const double webBreakpoint = 900;
  final EPassportDestination activeDestination;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: EPassportColors.pageBackground,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= webBreakpoint;
            if (isWide) {
              return Column(
                children: [
                  const _TopBar(compact: false),
                  Expanded(
                    child: Row(
                      textDirection: TextDirection.ltr,
                      children: [
                        _Sidebar(activeDestination: activeDestination),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(28, 22, 28, 28),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 1120,
                                ),
                                child: child,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            return Column(
              children: [
                const _TopBar(compact: true),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
                    child: child,
                  ),
                ),
                _BottomNavigation(activeDestination: activeDestination),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        height: compact ? 74 : 82,
        padding: EdgeInsets.symmetric(horizontal: compact ? 12 : 28),
        decoration: const BoxDecoration(
          color: EPassportColors.surface,
          border: Border(bottom: BorderSide(color: EPassportColors.border)),
        ),
        child: Row(
          textDirection: TextDirection.ltr,
          children: [
            IconButton(
              onPressed: () {},
              tooltip: 'القائمة',
              icon: const Icon(Icons.menu_rounded),
              color: EPassportColors.ink,
            ),
            SizedBox(width: compact ? 6 : 18),
            const _BrandMark(),
            const Spacer(),
            if (!compact) ...[
              _NotificationButton(),
              const SizedBox(width: 12),
              const _LanguageSelector(),
              const SizedBox(width: 16),
              const _UserHeader(),
            ] else
              _NotificationButton(),
          ],
        ),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    final isCompact =
        MediaQuery.sizeOf(context).width < EPassportShell.webBreakpoint;
    return Row(
      textDirection: TextDirection.ltr,
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Egy E-Passport',
              style: EPassportTextStyles.body(
                size: isCompact ? 15 : 18,
                color: EPassportColors.red,
                weight: FontWeight.w800,
              ).copyWith(height: 1.05),
            ),
            Text(
              'الهوية الرقمية للسفر',
              style: EPassportTextStyles.body(
                size: isCompact ? 10 : 12,
                color: EPassportColors.ink,
                weight: FontWeight.w700,
              ),
            ),
          ],
        ),
        SizedBox(width: isCompact ? 8 : 12),
        Container(
          width: isCompact ? 34 : 42,
          height: isCompact ? 34 : 42,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF7D77C), EPassportColors.gold],
            ),
            borderRadius: BorderRadius.circular(7),
          ),
          child: const Icon(
            Icons.account_balance_rounded,
            color: EPassportColors.surface,
            size: 23,
          ),
        ),
      ],
    );
  }
}

class _NotificationButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          onPressed: () {},
          tooltip: 'الإشعارات',
          icon: const Icon(Icons.notifications_none_rounded),
          color: EPassportColors.ink,
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            width: 17,
            height: 17,
            decoration: const BoxDecoration(
              color: EPassportColors.red,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '3',
                style: EPassportTextStyles.body(
                  size: 9,
                  color: EPassportColors.surface,
                  weight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  const _LanguageSelector();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: EPassportColors.surface,
        border: Border.all(color: EPassportColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.language_rounded, size: 18),
          const SizedBox(width: 8),
          Text('العربية', style: EPassportTextStyles.body(size: 13)),
          const SizedBox(width: 4),
          const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
        ],
      ),
    );
  }
}

class _UserHeader extends StatelessWidget {
  const _UserHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircleAvatar(
          radius: 20,
          backgroundColor: Color(0xFFE7EEF7),
          child: Icon(
            Icons.person_rounded,
            color: EPassportColors.officialBlue,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'أحمد محمد علي',
              style: EPassportTextStyles.body(
                size: 13,
                weight: FontWeight.w800,
              ),
            ),
            Text(
              'المواطن المصري',
              style: EPassportTextStyles.body(
                size: 11,
                color: EPassportColors.muted,
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
        const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
      ],
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({required this.activeDestination});

  final EPassportDestination activeDestination;

  @override
  Widget build(BuildContext context) {
    final items = [
      EPassportDestination.home,
      EPassportDestination.identity,
      EPassportDestination.requests,
      EPassportDestination.documents,
      EPassportDestination.notifications,
      EPassportDestination.profile,
      EPassportDestination.settings,
    ];

    return Container(
      width: 210,
      decoration: const BoxDecoration(
        color: EPassportColors.surface,
        border: Border(left: BorderSide(color: EPassportColors.border)),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(12, 22, 12, 12),
              itemBuilder: (context, index) {
                final destination = items[index];
                return _NavigationTile(
                  destination: destination,
                  active: destination == activeDestination,
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 4),
              itemCount: items.length,
            ),
          ),
          const _SidebarArt(),
        ],
      ),
    );
  }
}

class _NavigationTile extends StatelessWidget {
  const _NavigationTile({required this.destination, required this.active});

  final EPassportDestination destination;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? EPassportColors.activeNavBackground : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () => _handleNavigation(context, destination, active),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              Icon(
                destination.icon,
                color: active ? EPassportColors.gold : EPassportColors.muted,
                size: 21,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  destination.label,
                  style: EPassportTextStyles.body(
                    size: 14,
                    color: active ? EPassportColors.ink : EPassportColors.ink,
                    weight: active ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
              ),
              if (destination == EPassportDestination.notifications)
                const _SmallCounter(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SidebarArt extends StatelessWidget {
  const _SidebarArt();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      margin: const EdgeInsets.all(14),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F2E7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 18,
            bottom: 34,
            child: Icon(
              Icons.account_balance_rounded,
              size: 82,
              color: EPassportColors.gold.withValues(alpha: 0.32),
            ),
          ),
          Positioned(
            right: 62,
            bottom: 22,
            child: Icon(
              Icons.location_city_rounded,
              size: 74,
              color: EPassportColors.gold.withValues(alpha: 0.24),
            ),
          ),
          Positioned(
            left: -34,
            bottom: -34,
            child: Container(
              width: 158,
              height: 158,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: EPassportColors.red, width: 16),
              ),
            ),
          ),
          Positioned(
            left: 28,
            bottom: 18,
            child: Container(
              width: 118,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation({required this.activeDestination});

  final EPassportDestination activeDestination;

  @override
  Widget build(BuildContext context) {
    const items = [
      EPassportDestination.home,
      EPassportDestination.identity,
      EPassportDestination.requests,
      EPassportDestination.documents,
      EPassportDestination.notifications,
      EPassportDestination.profile,
    ];

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: EPassportColors.surface,
        border: Border(top: BorderSide(color: EPassportColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 66,
          child: Row(
            textDirection: TextDirection.ltr,
            children: items.map((destination) {
              final active = destination == activeDestination;
              return Expanded(
                child: InkWell(
                  onTap: () => _handleNavigation(context, destination, active),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            destination.icon,
                            color: active
                                ? EPassportColors.red
                                : EPassportColors.muted,
                            size: 22,
                          ),
                          const SizedBox(height: 3),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              destination.label,
                              maxLines: 1,
                              style: EPassportTextStyles.body(
                                size: 10,
                                color: active
                                    ? EPassportColors.red
                                    : EPassportColors.ink,
                                weight: active
                                    ? FontWeight.w800
                                    : FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (destination == EPassportDestination.notifications)
                        const Positioned(
                          top: 11,
                          right: 20,
                          child: _SmallCounter(),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _SmallCounter extends StatelessWidget {
  const _SmallCounter();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 17,
      height: 17,
      decoration: const BoxDecoration(
        color: EPassportColors.red,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '3',
          style: EPassportTextStyles.body(
            size: 9,
            color: EPassportColors.surface,
            weight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

void _handleNavigation(
  BuildContext context,
  EPassportDestination destination,
  bool active,
) {
  final route = destination.routeName;
  if (active || route == null) return;
  Navigator.of(context).pushReplacementNamed(route);
}
