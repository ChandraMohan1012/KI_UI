import 'package:flutter/material.dart';
import '../core/app_assets.dart';
import '../theme/theme.dart';
import 'app_button.dart';
import 'app_card.dart';

class HeroCard extends StatelessWidget {
  const HeroCard({
    super.key,
    required this.title,
    this.subtitle,
    this.onSubtitleTap,
    this.imagePath = AppAssets.isometricPreview,
    this.statLine,
    this.buttonLabel,
    this.onButtonTap,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onSubtitleTap;
  final String imagePath;
  final Widget? statLine;
  final String? buttonLabel;
  final VoidCallback? onButtonTap;

  @override
  Widget build(BuildContext context) {
    final tt = context.tt;
    final sc = context.semanticColors;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: tt.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Semantics(
              button: onSubtitleTap != null,
              label: subtitle,
              child: GestureDetector(
                onTap: onSubtitleTap,
                child: Text(
                  subtitle!,
                  style: tt.bodyMedium?.copyWith(
                    color: AppColors.accent,
                    decoration:
                        onSubtitleTap != null ? TextDecoration.underline : null,
                    decorationColor: AppColors.accent,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      sc.accentGlow,
                      sc.accentGlow.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
              Semantics(
                label: '$title 3D visual preview',
                image: true,
                child: Image.asset(
                  imagePath,
                  height: 180,
                  cacheHeight: 360,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 140,
                    width: 140,
                    decoration: BoxDecoration(
                      color: context.cs.surfaceContainerHigh,
                      borderRadius: AppRadius.mdBorder,
                    ),
                    child: const Icon(
                      Icons.architecture_rounded,
                      size: 64,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (statLine != null) ...[
            const SizedBox(height: AppSpacing.lg),
            statLine!,
          ],
          if (buttonLabel != null) ...[
            const SizedBox(height: AppSpacing.xl),
            AppPillButton(
              label: buttonLabel!,
              onPressed: onButtonTap,
              isFullWidth: true,
            ),
          ],
        ],
      ),
    );
  }
}
