import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';
import 'app_button.dart';

class ReportOption {
  final String id;
  final String title;
  final String description;
  final int price;
  final IconData icon;

  const ReportOption({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.icon,
  });
}

class PlanXReportPopup extends StatefulWidget {
  final void Function(Set<String> selectedIds) onContinue;
  const PlanXReportPopup({super.key, required this.onContinue});

  @override
  State<PlanXReportPopup> createState() => _PlanXReportPopupState();
}

class _PlanXReportPopupState extends State<PlanXReportPopup> {
  static const List<ReportOption> _options = [
    ReportOption(
      id: '3d',
      title: '3D Visualization',
      description: 'Interactive realistic 3D floor model',
      price: 499,
      icon: Icons.view_in_ar_rounded,
    ),
    ReportOption(
      id: 'vastu',
      title: 'Vastu Analysis',
      description: 'AI-powered Vastu scores and remedy tips',
      price: 299,
      icon: Icons.explore_rounded,
    ),
    ReportOption(
      id: 'cost',
      title: 'Cost Estimation',
      description: 'Detailed construction and BOQ breakdown',
      price: 199,
      icon: Icons.calculate_rounded,
    ),
    ReportOption(
      id: 'structural',
      title: 'Structural Design',
      description: 'Structural safety and load specifications',
      price: 999,
      icon: Icons.architecture_rounded,
    ),
  ];

  final Set<String> _selectedIds = {'3d', 'vastu'};

  int get _totalPrice => _options
      .where((opt) => _selectedIds.contains(opt.id))
      .fold(0, (sum, opt) => sum + opt.price);

  Color _getOptionAccent(BuildContext context, String id) {
    final cs = context.cs;
    final sc = context.semanticColors;
    switch (id) {
      case '3d':
        return cs.secondary;
      case 'vastu':
        return sc.vastuAccent;
      case 'cost':
        return sc.success;
      case 'structural':
        return sc.structuralAccent;
      default:
        return cs.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.92,
          constraints: const BoxConstraints(
            maxWidth: 520,
            maxHeight: 720,
          ),
          decoration: BoxDecoration(
            color: cs.surfaceContainer,
            borderRadius: AppRadius.xlBorder,
            border: Border.all(
              color: cs.outlineVariant.withValues(alpha: 0.6),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 36,
                spreadRadius: 4,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: AppRadius.xlBorder,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTopSection(),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: _buildGrid(),
                  ),
                ),
                _buildBottomSection(),
              ],
            ),
          ),
        )
            .animate()
            .scale(
              duration: 350.ms,
              curve: Curves.easeOutBack,
              begin: const Offset(0.9, 0.9),
            )
            .fadeIn(),
      ),
    );
  }

  Widget _buildTopSection() {
    final cs = context.cs;
    final sc = context.semanticColors;
    final tt = context.tt;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: sc.successContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_rounded,
              color: sc.success,
              size: 32,
            ),
          ).animate().scale(duration: 350.ms, curve: Curves.easeOutBack),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Floor Plan Uploaded!',
            style: tt.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Choose the reports you want to generate.\nPay only for what you select.',
            textAlign: TextAlign.center,
            style: tt.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    final cs = context.cs;

    return Column(
      children: _options.map((opt) {
        final isSelected = _selectedIds.contains(opt.id);
        final accent = _getOptionAccent(context, opt.id);

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Semantics(
            selected: isSelected,
            button: true,
            label: '${opt.title}, ₹${opt.price}',
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    if (_selectedIds.length > 1) _selectedIds.remove(opt.id);
                  } else {
                    _selectedIds.add(opt.id);
                  }
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: isSelected
                      ? cs.surfaceContainerHighest.withValues(alpha: 0.7)
                      : cs.surfaceContainerHighest.withValues(alpha: 0.25),
                  borderRadius: AppRadius.lgBorder,
                  border: Border.all(
                    color: isSelected
                        ? accent
                        : cs.outlineVariant.withValues(alpha: 0.4),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.15),
                        borderRadius: AppRadius.smBorder,
                      ),
                      child: Icon(opt.icon, color: accent, size: 22),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            opt.title,
                            style: TextStyle(
                              color: cs.onSurface,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            opt.description,
                            style: TextStyle(
                              color: cs.onSurfaceVariant,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      '₹${opt.price.toInt()}',
                      style: TextStyle(
                        color: accent,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Icon(
                      isSelected
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      color: isSelected ? accent : cs.onSurfaceVariant,
                      size: 22,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomSection() {
    final cs = context.cs;
    final sc = context.semanticColors;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.3),
        border: Border(
          top: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.4)),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
                    borderRadius: AppRadius.mdBorder,
                    border: Border.all(
                      color: cs.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        color: cs.primary,
                        size: 20,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_selectedIds.length} Selected',
                              style: TextStyle(
                                color: cs.onSurfaceVariant,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Total: ₹$_totalPrice',
                              style: TextStyle(
                                color: cs.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
                    borderRadius: AppRadius.mdBorder,
                    border: Border.all(
                      color: cs.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.verified_user_outlined,
                        color: sc.success,
                        size: 20,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Secure Checkout',
                              style: TextStyle(
                                color: cs.onSurface,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Instant Delivery',
                              style: TextStyle(
                                color: cs.onSurfaceVariant,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: 'Continue to Payment (₹$_totalPrice)',
            trailingIcon: Icons.arrow_forward_rounded,
            isFullWidth: true,
            onPressed: () => widget.onContinue(_selectedIds),
          ),
        ],
      ),
    );
  }
}
