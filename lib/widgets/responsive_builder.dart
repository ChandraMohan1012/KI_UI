import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';

enum AppBreakpointDevice {
  compact,
  medium,
  expanded;

  bool get isCompact => this == AppBreakpointDevice.compact;
  bool get isMedium => this == AppBreakpointDevice.medium;
  bool get isExpanded => this == AppBreakpointDevice.expanded;
}

class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    super.key,
    required this.builder,
  });

  final Widget Function(
    BuildContext context,
    AppBreakpointDevice breakpoint,
    BoxConstraints constraints,
  ) builder;

  static AppBreakpointDevice getBreakpoint(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w < AppBreakpoints.compact) return AppBreakpointDevice.compact;
    if (w < AppBreakpoints.medium) return AppBreakpointDevice.medium;
    return AppBreakpointDevice.expanded;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final breakpoint = w < AppBreakpoints.compact
            ? AppBreakpointDevice.compact
            : w < AppBreakpoints.medium
                ? AppBreakpointDevice.medium
                : AppBreakpointDevice.expanded;
        return builder(context, breakpoint, constraints);
      },
    );
  }
}

/// A wrapper that centers and caps maximum content width at 1100px.
class CenteredConstrainedBody extends StatelessWidget {
  const CenteredConstrainedBody({
    super.key,
    required this.child,
    this.maxWidth = AppSpacing.maxContentWidth,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
