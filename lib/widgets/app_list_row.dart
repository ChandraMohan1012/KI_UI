import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────
//  AppListRow — standard key-value / list row with leading icon,
//  title, value/subtitle, trailing widget, and min 48 dp tap target.
// ─────────────────────────────────────────────────────────────

class AppListRow extends StatelessWidget {
  const AppListRow({
    super.key,
    required this.label,
    this.value,
    this.leadingIcon,
    this.leadingWidget,
    this.trailingWidget,
    this.onTap,
    this.subtitle,
    this.showDivider = false,
    this.isAccent = false,
  });

  final String label;
  final String? value;
  final IconData? leadingIcon;
  final Widget? leadingWidget;
  final Widget? trailingWidget;
  final VoidCallback? onTap;
  final String? subtitle;
  final bool showDivider;
  final bool isAccent;

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;
    final tt = context.tt;

    Widget rowContent = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: AppSpacing.minTapTarget),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (leadingWidget != null) ...[
              leadingWidget!,
              const SizedBox(width: AppSpacing.md),
            ] else if (leadingIcon != null) ...[
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isAccent
                      ? cs.primary.withValues(alpha: 0.15)
                      : cs.surfaceContainerHighest.withValues(alpha: 0.4),
                  borderRadius: AppRadius.smBorder,
                ),
                child: Icon(
                  leadingIcon,
                  size: 18,
                  color: isAccent ? cs.primary : cs.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: tt.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: cs.onSurface,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: tt.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (value != null) ...[
              const SizedBox(width: AppSpacing.sm),
              Text(
                value!,
                style: tt.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isAccent ? cs.primary : cs.onSurface,
                ),
              ),
            ],
            if (trailingWidget != null) ...[
              const SizedBox(width: AppSpacing.sm),
              trailingWidget!,
            ],
            if (onTap != null && trailingWidget == null) ...[
              const SizedBox(width: AppSpacing.xs),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: cs.onSurfaceVariant.withValues(alpha: 0.7),
              ),
            ],
          ],
        ),
      ),
    );

    if (onTap != null) {
      rowContent = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.smBorder,
          child: rowContent,
        ),
      );
    }

    if (showDivider) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          rowContent,
          Divider(
            height: 1,
            indent: AppSpacing.md,
            endIndent: AppSpacing.md,
            color: cs.outlineVariant.withValues(alpha: 0.5),
          ),
        ],
      );
    }

    return rowContent;
  }
}
