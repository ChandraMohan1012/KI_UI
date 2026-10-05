import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────
//  AppCard — consistent card with theme-driven radius and color.
// ─────────────────────────────────────────────────────────────

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.header,
    this.footer,
    this.semanticLabel,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Widget? header;
  final Widget? footer;
  final String? semanticLabel;

  /// Glass-morphism is deprecated in the new design system.
  /// This constructor maps directly to the standard flat card.
  const AppCard.glass({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.header,
    this.footer,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (header != null) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: header!,
          ),
          Divider(height: 20, color: cs.outlineVariant),
        ],
        Padding(
          padding: padding ?? const EdgeInsets.all(20),
          child: child,
        ),
        if (footer != null) ...[
          Divider(height: 20, color: cs.outlineVariant),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: footer!,
          ),
        ],
      ],
    );

    Widget card = Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgBorder,
        boxShadow: AppTheme.cardShadow,
      ),
      child: content,
    );

    if (margin != null) {
      card = Padding(padding: margin!, child: card);
    }

    if (semanticLabel != null) {
      card = Semantics(label: semanticLabel, container: true, child: card);
    }

    return card;
  }
}

/// AppGlassCard is deprecated in the new design system.
/// It acts identically to AppCard.
class AppGlassCard extends StatelessWidget {
  const AppGlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    double blurSigma = 20.0,
    Color? borderColor,
    double borderWidth = 1.2,
    BorderRadius? borderRadius,
    Color? glowColor,
    double glowBlur = 28.0,
    this.semanticLabel,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: padding,
      margin: margin,
      semanticLabel: semanticLabel,
      child: child,
    );
  }
}
