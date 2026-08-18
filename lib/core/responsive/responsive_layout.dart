import 'package:flutter/material.dart';
import 'breakpoints.dart';

/// Chooses the right layout for the current width. Each PULSE screen
/// should provide a mobile builder at minimum; tablet/desktop fall back
/// to the nearest larger definition available, mobile falls back up.
class ResponsiveLayout extends StatelessWidget {
  final WidgetBuilder mobile;
  final WidgetBuilder? tablet;
  final WidgetBuilder? desktop;
  final WidgetBuilder? largeDesktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.largeDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final size = screenSizeFor(width);

    switch (size) {
      case PulseScreenSize.mobile:
        return mobile(context);
      case PulseScreenSize.tablet:
        return (tablet ?? desktop ?? largeDesktop ?? mobile)(context);
      case PulseScreenSize.desktop:
        return (desktop ?? largeDesktop ?? tablet ?? mobile)(context);
      case PulseScreenSize.largeDesktop:
        return (largeDesktop ?? desktop ?? tablet ?? mobile)(context);
    }
  }
}

/// Constrains content to a comfortable reading/working width on large
/// screens instead of letting cards stretch edge to edge.
class MaxWidthBox extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const MaxWidthBox({super.key, required this.child, this.maxWidth = PulseBreakpoints.maxContentWidth});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}

extension ResponsiveContext on BuildContext {
  PulseScreenSize get screenSize => screenSizeFor(MediaQuery.sizeOf(this).width);
  bool get isMobile => screenSize == PulseScreenSize.mobile;
  bool get isDesktopClass =>
      screenSize == PulseScreenSize.desktop || screenSize == PulseScreenSize.largeDesktop;
}
