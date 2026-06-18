import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:study_quiz/core/di/service_locator.dart';
import 'package:study_quiz/core/responsive/responsive_builder.dart';
import 'package:study_quiz/core/theme/app_spacing.dart';
import 'package:study_quiz/features/history/presentation/cubit/history_cubit.dart';
import 'package:study_quiz/features/home/presentation/cubit/home_cubit.dart';
import 'package:study_quiz/features/quiz/domain/repositories/quiz_repository.dart';

/// Navigation destinations shared by both bottom nav and rail.
class _NavDest {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final String route;

  const _NavDest({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.route,
  });
}

const _destinations = [
  _NavDest(
    label: 'Home',
    icon: Icons.home_outlined,
    selectedIcon: Icons.home_rounded,
    route: '/home',
  ),
  _NavDest(
    label: 'History',
    icon: Icons.history_outlined,
    selectedIcon: Icons.history_rounded,
    route: '/history',
  ),
  _NavDest(
    label: 'Settings',
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings_rounded,
    route: '/settings',
  ),
];

/// The top-level shell around the main three screens.
/// Switches between [NavigationBar] on mobile and [NavigationRail] on tablet.
class AppShell extends StatelessWidget {
  final Widget child;
  final String currentLocation;

  const AppShell({
    super.key,
    required this.child,
    required this.currentLocation,
  });

  int get _selectedIndex {
    for (var i = 0; i < _destinations.length; i++) {
      if (currentLocation.startsWith(_destinations[i].route)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    // Provide cubits that survive the shell's lifetime (not re-created on nav)
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeCubit(sl<QuizRepository>())),
        BlocProvider(create: (_) => HistoryCubit(sl<QuizRepository>())),
      ],
      child: ResponsiveBuilder(
        mobile: (_, __) => _MobileShell(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (i) =>
              context.go(_destinations[i].route),
          child: child,
        ),
        tablet: (_, __) => _TabletShell(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (i) =>
              context.go(_destinations[i].route),
          child: child,
        ),
      ),
    );
  }
}

/// Mobile: content + bottom NavigationBar.
class _MobileShell extends StatelessWidget {
  final Widget child;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const _MobileShell({
    required this.child,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: _destinations
            .map((d) => NavigationDestination(
                  icon: Icon(d.icon),
                  selectedIcon: Icon(d.selectedIcon),
                  label: d.label,
                ))
            .toList(),
      ),
    );
  }
}

/// Tablet: NavigationRail on the side + content.
class _TabletShell extends StatelessWidget {
  final Widget child;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const _TabletShell({
    required this.child,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            // Show labels on tablet for better readability
            labelType: NavigationRailLabelType.all,
            // Extend rail on large tablet (> 900px)
            extended: MediaQuery.sizeOf(context).width > 900,
            backgroundColor: cs.surfaceContainerLow,
            destinations: _destinations
                .map((d) => NavigationRailDestination(
                      icon: Icon(d.icon),
                      selectedIcon: Icon(d.selectedIcon),
                      label: Text(d.label),
                      padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.xs),
                    ))
                .toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: child),
        ],
      ),
    );
  }
}
