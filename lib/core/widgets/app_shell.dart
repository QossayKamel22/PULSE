import 'package:flutter/material.dart';
import '../responsive/responsive_layout.dart';
import '../theme/pulse_colors.dart';
import '../theme/pulse_spacing.dart';
import 'pulse_logo.dart';

/// Root navigation shell. Mobile gets a bottom NavigationBar; tablet/
/// desktop/web get a persistent sidebar. Both wrap the same [child] pages
/// so business logic and Firebase-backed controllers are shared.
class AppShell extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final Widget child;

  const AppShell({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    required this.child,
  });

  static const _destinations = [
    (icon: Icons.home_rounded, label: 'Home'),
    (icon: Icons.insights_rounded, label: 'Insights'),
    (icon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: (_) => Scaffold(
        body: SafeArea(child: child),
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: onTabSelected,
          destinations: _destinations
              .map((d) => NavigationDestination(icon: Icon(d.icon), label: d.label))
              .toList(),
        ),
      ),
      desktop: (_) => Scaffold(
        body: Row(
          children: [
            _Sidebar(currentIndex: currentIndex, onTabSelected: onTabSelected),
            Expanded(child: SafeArea(child: child)),
          ],
        ),
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const _Sidebar({required this.currentIndex, required this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    final border = Theme.of(context).dividerColor;
    return Container(
      width: 240,
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: PulseSpacing.xl),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: PulseSpacing.lg),
            child: Row(
              children: [
                PulseLogo(size: 28),
                SizedBox(width: PulseSpacing.sm),
                Text('PULSE', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
              ],
            ),
          ),
          const SizedBox(height: PulseSpacing.xxl),
          for (int i = 0; i < AppShell._destinations.length; i++)
            _SidebarItem(
              icon: AppShell._destinations[i].icon,
              label: AppShell._destinations[i].label,
              selected: currentIndex == i,
              onTap: () => onTabSelected(i),
            ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.all(PulseSpacing.lg),
            child: Text('Build your rhythm.', style: TextStyle(fontSize: 12, color: PulseColors.pulseBlue)),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: PulseSpacing.sm, vertical: 2),
      child: Material(
        color: selected ? PulseColors.pulseBlue.withValues(alpha: 0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(PulseSpacing.sm),
        child: InkWell(
          borderRadius: BorderRadius.circular(PulseSpacing.sm),
          onTap: onTap,
          hoverColor: PulseColors.pulseBlue.withValues(alpha: 0.06),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: PulseSpacing.md, vertical: PulseSpacing.sm + 2),
            child: Row(
              children: [
                Icon(icon, size: 20, color: selected ? PulseColors.pulseBlue : null),
                const SizedBox(width: PulseSpacing.sm),
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    color: selected ? PulseColors.pulseBlue : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
