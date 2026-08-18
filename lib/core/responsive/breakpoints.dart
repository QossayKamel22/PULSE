/// PULSE responsive breakpoints. Used across mobile / tablet / desktop /
/// large-desktop (including Web) layouts.
class PulseBreakpoints {
  PulseBreakpoints._();

  static const double mobile = 600;
  static const double tablet = 1024;
  static const double desktop = 1440;
  // Above `desktop` is treated as large desktop.

  static const double maxContentWidth = 1200;
}

enum PulseScreenSize { mobile, tablet, desktop, largeDesktop }

PulseScreenSize screenSizeFor(double width) {
  if (width < PulseBreakpoints.mobile) return PulseScreenSize.mobile;
  if (width < PulseBreakpoints.tablet) return PulseScreenSize.tablet;
  if (width < PulseBreakpoints.desktop) return PulseScreenSize.desktop;
  return PulseScreenSize.largeDesktop;
}
