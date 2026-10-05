import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';

@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    required this.accentGlow,
    // Backward compatibility
    this.successContainer = const Color(0x2210B981),
    this.warningContainer = const Color(0x22F59E0B),
    this.infoContainer = const Color(0x223B82F6),
    this.vastuAccent = const Color(0xFFFF5A26),
    this.structuralAccent = const Color(0xFFFF5A26),
    this.costAccent = const Color(0xFFFF5A26),
  });

  final Color success;
  final Color warning;
  final Color error;
  final Color info;
  final Color accentGlow;
  final Color successContainer;
  final Color warningContainer;
  final Color infoContainer;
  final Color vastuAccent;
  final Color structuralAccent;
  final Color costAccent;

  static const AppSemanticColors light = AppSemanticColors(
    success: AppColors.success,
    warning: AppColors.warning,
    error: AppColors.error,
    info: AppColors.info,
    accentGlow: Color(0x33FF5A26),
  );

  @override
  AppSemanticColors copyWith({
    Color? success,
    Color? warning,
    Color? error,
    Color? info,
    Color? accentGlow,
    Color? successContainer,
    Color? warningContainer,
    Color? infoContainer,
    Color? vastuAccent,
    Color? structuralAccent,
    Color? costAccent,
  }) {
    return AppSemanticColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      info: info ?? this.info,
      accentGlow: accentGlow ?? this.accentGlow,
      successContainer: successContainer ?? this.successContainer,
      warningContainer: warningContainer ?? this.warningContainer,
      infoContainer: infoContainer ?? this.infoContainer,
      vastuAccent: vastuAccent ?? this.vastuAccent,
      structuralAccent: structuralAccent ?? this.structuralAccent,
      costAccent: costAccent ?? this.costAccent,
    );
  }

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) return this;
    return AppSemanticColors(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      info: Color.lerp(info, other.info, t)!,
      accentGlow: Color.lerp(accentGlow, other.accentGlow, t)!,
      successContainer:
          Color.lerp(successContainer, other.successContainer, t)!,
      warningContainer:
          Color.lerp(warningContainer, other.warningContainer, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
      vastuAccent: Color.lerp(vastuAccent, other.vastuAccent, t)!,
      structuralAccent:
          Color.lerp(structuralAccent, other.structuralAccent, t)!,
      costAccent: Color.lerp(costAccent, other.costAccent, t)!,
    );
  }
}

abstract final class AppTheme {
  AppTheme._();

  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x0A000000), // 0.04 opacity black (approximate to 0x0A)
      blurRadius: 24,
      spreadRadius: 0,
      offset: Offset(0, 8),
    ),
  ];

  static const ColorScheme _lightScheme = ColorScheme.light(
    primary: AppColors.textPrimary, // Black primary buttons
    onPrimary: AppColors.white,
    secondary: AppColors.accent,
    onSecondary: AppColors.white,
    surface: AppColors.background,
    onSurface: AppColors.textPrimary,
    error: AppColors.error,
    onError: AppColors.white,
    outline: AppColors.border,
  );

  static InputDecorationTheme _inputDecorationTheme() => InputDecorationTheme(
        filled: true,
        fillColor: AppColors.formFill,
        hintStyle: AppTextStyles.textTheme.bodyMedium
            ?.copyWith(color: AppColors.textSecondary),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.md),
        border: const OutlineInputBorder(
          borderRadius: AppRadius.mdBorder,
          borderSide: BorderSide.none,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppRadius.mdBorder,
          borderSide: BorderSide.none,
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppRadius.mdBorder,
          borderSide: BorderSide(color: AppColors.accent, width: 2),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: AppRadius.mdBorder,
          borderSide: BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: AppRadius.mdBorder,
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
      );

  static ElevatedButtonThemeData _elevatedButtonTheme() =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.textPrimary,
          foregroundColor: AppColors.white,
          elevation: 0,
          minimumSize: const Size(64, AppSpacing.minTapTarget),
          shape: const StadiumBorder(),
          textStyle: AppTextStyles.textTheme.labelLarge
              ?.copyWith(fontWeight: FontWeight.w700),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        ),
      );

  static OutlinedButtonThemeData _outlinedButtonTheme() =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.border, width: 1.5),
          minimumSize: const Size(64, AppSpacing.minTapTarget),
          shape: const StadiumBorder(),
          textStyle: AppTextStyles.textTheme.labelLarge
              ?.copyWith(fontWeight: FontWeight.w700),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        ),
      );

  static TextButtonThemeData _textButtonTheme() => TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          minimumSize: const Size(64, AppSpacing.minTapTarget),
          shape: const StadiumBorder(),
          textStyle: AppTextStyles.textTheme.labelLarge
              ?.copyWith(fontWeight: FontWeight.w700),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        ),
      );

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: _lightScheme,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: AppTextStyles.textTheme,
      inputDecorationTheme: _inputDecorationTheme(),
      elevatedButtonTheme: _elevatedButtonTheme(),
      outlinedButtonTheme: _outlinedButtonTheme(),
      textButtonTheme: _textButtonTheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: AppTextStyles.textTheme.headlineSmall,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.lgBorder),
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
      extensions: const [AppSemanticColors.light],
    );
  }
}

extension AppThemeExtension on BuildContext {
  AppSemanticColors get semanticColors =>
      Theme.of(this).extension<AppSemanticColors>()!;
  ColorScheme get cs => Theme.of(this).colorScheme;
  TextTheme get tt => Theme.of(this).textTheme;
}
