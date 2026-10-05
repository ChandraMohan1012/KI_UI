import 'package:flutter/material.dart';
import '../theme/theme.dart';

enum AppButtonVariant { primary, secondary, text }

class AppPillButton extends StatelessWidget {
  const AppPillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.trailingIcon, // for backward compat
    this.isLoading = false,
    this.isFullWidth = false,
    this.tooltip,
    this.semanticLabel,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final IconData? trailingIcon;
  final bool isLoading;
  final bool isFullWidth;
  final String? tooltip;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;
    final enabled = onPressed != null && !isLoading;

    Widget buttonChild = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20),
          const SizedBox(width: AppSpacing.sm),
        ],
        Text(label),
        if (variant == AppButtonVariant.primary) ...[
          const SizedBox(width: AppSpacing.sm),
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: enabled
                  ? AppColors.accent
                  : AppColors.accent.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
            child: Icon(
              trailingIcon ?? Icons.arrow_forward_rounded,
              size: 14,
              color: AppColors.white,
            ),
          ),
        ] else if (trailingIcon != null) ...[
          const SizedBox(width: AppSpacing.sm),
          Icon(trailingIcon, size: 20),
        ],
      ],
    );

    if (isLoading) {
      buttonChild = SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color:
              variant == AppButtonVariant.primary ? cs.onPrimary : cs.primary,
        ),
      );
    }

    if (isFullWidth) {
      buttonChild = Center(child: buttonChild);
    }

    final effectiveOnPressed = enabled ? onPressed : null;

    Widget btn;
    switch (variant) {
      case AppButtonVariant.primary:
        btn = ElevatedButton(onPressed: effectiveOnPressed, child: buttonChild);
      case AppButtonVariant.secondary:
        btn = OutlinedButton(onPressed: effectiveOnPressed, child: buttonChild);
      case AppButtonVariant.text:
        btn = TextButton(onPressed: effectiveOnPressed, child: buttonChild);
    }

    if (isFullWidth) {
      btn = SizedBox(width: double.infinity, child: btn);
    }

    if (tooltip != null) {
      btn = Tooltip(message: tooltip!, child: btn);
    }

    return Semantics(
      label: semanticLabel ?? label,
      button: true,
      enabled: enabled,
      child: btn,
    );
  }

  // Deprecated factory for backward compatibility
  static Widget gradient({
    required String label,
    required VoidCallback? onPressed,
    IconData? trailingIcon,
    bool isLoading = false,
    bool isFullWidth = false,
    String? tooltip,
  }) {
    return AppPillButton(
      label: label,
      onPressed: onPressed,
      trailingIcon: trailingIcon,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      tooltip: tooltip,
      variant: AppButtonVariant.primary,
    );
  }
}

typedef AppButton = AppPillButton;
