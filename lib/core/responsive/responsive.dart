import 'package:flutter/widgets.dart';

/// Layout breakpoints + helpers for adapting the mobile-first UI to wide web.
class Breakpoints {
  static const double tablet = 600;
  static const double desktop = 1024;

  /// At/above this the app switches from a bottom nav bar to a side rail.
  static const double sideNav = 900;

  /// Content never stretches wider than this on huge screens.
  static const double maxContent = 1180;
}

extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  bool get isMobileWidth => screenWidth < Breakpoints.tablet;
  bool get isTabletWidth =>
      screenWidth >= Breakpoints.tablet && screenWidth < Breakpoints.desktop;
  bool get isDesktopWidth => screenWidth >= Breakpoints.desktop;

  /// Use a side navigation rail instead of the bottom nav bar.
  bool get useSideNav => screenWidth >= Breakpoints.sideNav;
}

/// Column count for a card grid given the available width, targeting cards no
/// narrower than [minItemWidth]. Keeps a phone at 1 column and lets a wide
/// desktop fan out to several.
int responsiveColumns(double width,
    {double minItemWidth = 280, int max = 5}) {
  final n = (width / minItemWidth).floor();
  return n.clamp(1, max);
}

/// Horizontal page padding that centers form/content columns on wide screens
/// (adds symmetric insets so content never exceeds [maxWidth]), while keeping
/// [base] padding on phones. Handy for full-screen auth/onboarding pages.
EdgeInsets pagePadding(BuildContext context,
    {double base = 24, double maxWidth = 480}) {
  final inset = ((context.screenWidth - maxWidth) / 2).clamp(0.0, 1000.0);
  return EdgeInsets.symmetric(horizontal: base + inset);
}

/// Centers page content and caps its width on large screens, so nothing
/// stretches edge-to-edge. Horizontal [padding] is applied inside the cap.
class MaxWidth extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry padding;

  const MaxWidth({
    super.key,
    required this.child,
    this.maxWidth = Breakpoints.maxContent,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
