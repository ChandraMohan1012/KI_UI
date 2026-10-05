import 'package:flutter/material.dart';
import '../theme/theme.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.backgroundColor,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: tooltip,
      child: Tooltip(
        message: tooltip ?? '',
        child: Material(
          color: backgroundColor ?? AppColors.formFill,
          borderRadius: AppRadius.smBorder,
          child: InkWell(
            onTap: onPressed,
            borderRadius: AppRadius.smBorder,
            child: SizedBox(
              width: 48,
              height: 48,
              child: Center(
                child: Icon(
                  icon,
                  size: 20,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
