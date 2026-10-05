import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────
//  AppBadge — semantic badge / status chip for ratings, status,
//  and tags with success, warning, error, info, and accent variants.
// ─────────────────────────────────────────────────────────────

enum AppBadgeVariant {
  primary,
  success,
  warning,
  error,
  info,
  neutral,
  vastu,
  structural,
  cost,
  amber,
}

class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.label,
    this.variant = AppBadgeVariant.neutral,
    this.icon,
    this.isOutlined = false,
  });

  final String label;
  final AppBadgeVariant variant;
  final IconData? icon;
  final bool isOutlined;

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;
    final sc = context.semanticColors;
    final tt = context.tt;

    Color fg;
    Color bg;

    switch (variant) {
      case AppBadgeVariant.primary:
        fg = cs.primary;
        bg = cs.primary.withValues(alpha: 0.15);
        break;
      case AppBadgeVariant.success:
        fg = sc.success;
        bg = sc.successContainer;
        break;
      case AppBadgeVariant.warning:
        fg = sc.warning;
        bg = sc.warningContainer;
        break;
      case AppBadgeVariant.error:
        fg = cs.error;
        bg = cs.error.withValues(alpha: 0.15);
        break;
      case AppBadgeVariant.info:
        fg = sc.info;
        bg = sc.infoContainer;
        break;
      case AppBadgeVariant.vastu:
        fg = sc.vastuAccent;
        bg = sc.vastuAccent.withValues(alpha: 0.15);
        break;
      case AppBadgeVariant.structural:
        fg = sc.structuralAccent;
        bg = sc.structuralAccent.withValues(alpha: 0.15);
        break;
      case AppBadgeVariant.cost:
        fg = sc.costAccent;
        bg = sc.costAccent.withValues(alpha: 0.15);
        break;
      case AppBadgeVariant.amber:
        fg = cs.primary;
        bg = cs.primary.withValues(alpha: 0.15);
        break;
      case AppBadgeVariant.neutral:
        fg = cs.onSurfaceVariant;
        bg = cs.surfaceContainerHighest.withValues(alpha: 0.5);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: isOutlined ? Colors.transparent : bg,
        borderRadius: AppRadius.fullBorder,
        border: Border.all(
          color: isOutlined ? fg : fg.withValues(alpha: 0.3),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: fg),
            const SizedBox(width: AppSpacing.xs),
          ],
          Text(
            label,
            style: tt.labelSmall?.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

typedef AppStatusChip = AppBadge;
