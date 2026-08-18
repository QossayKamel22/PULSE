import 'package:flutter/material.dart';
import '../../../core/widgets/app_shell.dart';
import 'home_view.dart';
import '../../insights/views/insights_view.dart';
import '../../profile/views/profile_view.dart';

/// Hosts the three-tab experience (Home / Insights / Profile) inside the
/// responsive AppShell (bottom nav on mobile, sidebar on desktop/web).
class RootShellView extends StatefulWidget {
  const RootShellView({super.key});

  @override
  State<RootShellView> createState() => _RootShellViewState();
}

class _RootShellViewState extends State<RootShellView> {
  int _index = 0;

  static const _pages = [HomeView(), InsightsView(), ProfileView()];

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentIndex: _index,
      onTabSelected: (i) => setState(() => _index = i),
      child: _pages[_index],
    );
  }
}
