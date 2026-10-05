import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';
import 'app_button.dart';

class ReportOption {
  final String id;
  final String title;
  final int price;
  final IconData icon;

  const ReportOption({
    required this.id,
    required this.title,
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
      title: '3D Model',
      price: 499,
      icon: Icons.view_in_ar_rounded,
    ),
    ReportOption(
      id: 'vastu',
      title: 'Vastu Analysis',
      price: 299,
      icon: Icons.explore_rounded,
    ),
    ReportOption(
      id: 'cost',
      title: 'Cost Estimation',
      price: 199,
      icon: Icons.calculate_rounded,
    ),
    ReportOption(
      id: 'structural',
      title: 'Structural Design',
      price: 999,
      icon: Icons.architecture_rounded,
    ),
  ];

  final Set<String> _selectedIds = {'3d', 'vastu'};

  int get _totalPrice => _options
      .where((opt) => _selectedIds.contains(opt.id))
      .fold(0, (sum, opt) => sum + opt.price);

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;
    final tt = context.tt;

    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 440),
        margin: const EdgeInsets.all(AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: AppRadius.xlBorder,
          border: Border.all(color: cs.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Select Reports',
              style: tt.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              decoration: BoxDecoration(
                color: cs.surfaceContainerLow,
                borderRadius: AppRadius.lgBorder,
                border: Border.all(color: cs.outlineVariant),
              ),
              child: Column(
                children: _options.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final opt = entry.value;
                  final isSelected = _selectedIds.contains(opt.id);

                  return Column(
                    children: [
                      if (idx > 0)
                        Divider(
                            height: 1,
                            color: cs.outlineVariant.withValues(alpha: 0.5)),
                      ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.xs,
                        ),
                        leading: Icon(opt.icon, color: cs.primary, size: 20),
                        title: Text(
                          opt.title,
                          style: tt.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '₹${opt.price}',
                              style: tt.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Checkbox(
                              value: isSelected,
                              activeColor: cs.primary,
                              onChanged: (val) {
                                setState(() {
                                  if (isSelected && _selectedIds.length > 1) {
                                    _selectedIds.remove(opt.id);
                                  } else {
                                    _selectedIds.add(opt.id);
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            if (isSelected && _selectedIds.length > 1) {
                              _selectedIds.remove(opt.id);
                            } else {
                              _selectedIds.add(opt.id);
                            }
                          });
                        },
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Amount',
                  style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                ),
                Text(
                  '₹$_totalPrice',
                  style: tt.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: 'Pay ₹$_totalPrice',
              trailingIcon: Icons.arrow_forward_rounded,
              isFullWidth: true,
              onPressed: () => widget.onContinue(_selectedIds),
            ),
          ],
        ),
      ),
    );
  }
}
