import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';

class _TabSpec {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final int? branchIndex;

  const _TabSpec({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.branchIndex,
  });
}

class AppNavigation extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const AppNavigation({required this.navigationShell, super.key});

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  int _selectedVisualIndex = 0;

  static const List<_TabSpec> _tabs = [
    _TabSpec(
      label: 'घर',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
      branchIndex: 0,
    ),
    _TabSpec(
      label: 'सेवा',
      icon: Icons.miscellaneous_services_outlined,
      selectedIcon: Icons.miscellaneous_services_rounded,
      branchIndex: 1,
    ),
    _TabSpec(
      label: 'तक्रारी',
      icon: Icons.report_problem_outlined,
      selectedIcon: Icons.report_problem_rounded,
      branchIndex: 2,
    ),
    _TabSpec(
      label: 'सूचना',
      icon: Icons.campaign_outlined,
      selectedIcon: Icons.campaign_rounded,
      branchIndex: 3,
    ),
    _TabSpec(
      label: 'योजना',
      icon: Icons.account_balance_outlined,
      selectedIcon: Icons.account_balance_rounded,
      branchIndex: 4,
    ),
    _TabSpec(
      label: 'नोटिफिकेशन',
      icon: Icons.notifications_outlined,
      selectedIcon: Icons.notifications_rounded,
      branchIndex: 5,
    ),
  ];

  void _onTabTapped(int visualIndex) {
    final tab = _tabs[visualIndex];
    if (tab.branchIndex == null) {
      return;
    }
    setState(() {
      _selectedVisualIndex = visualIndex;
    });
    widget.navigationShell.goBranch(
      tab.branchIndex!,
      initialLocation: tab.branchIndex == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    for (int i = 0; i < _tabs.length; i++) {
      if (_tabs[i].branchIndex == widget.navigationShell.currentIndex) {
        if (_selectedVisualIndex != i) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _selectedVisualIndex = i);
          });
        }
        break;
      }
    }

    return NavigationBar(
      selectedIndex: _selectedVisualIndex,
      onDestinationSelected: _onTabTapped,
      backgroundColor: theme.colorScheme.surface,
      indicatorColor: AppTheme.primaryContainer,
      elevation: 8,
      shadowColor: const Color(0x1A000000),
      destinations: List.generate(_tabs.length, (i) {
        final tab = _tabs[i];
        final isStub = tab.branchIndex == null;
        return NavigationDestination(
          icon: Opacity(opacity: isStub ? 0.4 : 1.0, child: Icon(tab.icon)),
          selectedIcon: Opacity(
            opacity: isStub ? 0.4 : 1.0,
            child: Icon(tab.selectedIcon),
          ),
          label: tab.label,
          tooltip: isStub ? '' : tab.label,
        );
      }),
    );
  }
}
