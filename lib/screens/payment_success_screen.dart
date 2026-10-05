import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';
import '../widgets/app_button.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final double amount;
  final VoidCallback? onFinish;

  const PaymentSuccessScreen({
    super.key,
    required this.amount,
    this.onFinish,
  });

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  bool _isGenerating = false;

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;
    final sc = context.semanticColors;
    final tt = context.tt;

    if (_isGenerating) {
      return Scaffold(
        backgroundColor: cs.surface,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: cs.primary),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Generating Plan...',
                style: tt.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: cs.onSurface),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Back',
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: sc.successContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle_rounded,
                      color: sc.success,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Payment Successful',
                    style: tt.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '₹${widget.amount.toInt()}',
                    style: tt.titleLarge?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerLow,
                      borderRadius: AppRadius.lgBorder,
                      border: Border.all(color: cs.outlineVariant),
                    ),
                    child: Column(
                      children: [
                        _detailRow('Status', 'Paid', cs),
                        Divider(
                            color: cs.outlineVariant.withValues(alpha: 0.5),
                            height: 16),
                        _detailRow('Method', 'UPI', cs),
                        Divider(
                            color: cs.outlineVariant.withValues(alpha: 0.5),
                            height: 16),
                        _detailRow('Amount', '₹${widget.amount.toInt()}', cs,
                            isTotal: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppButton(
                    label: 'Start Plan',
                    trailingIcon: Icons.arrow_forward_rounded,
                    isFullWidth: true,
                    isLoading: _isGenerating,
                    onPressed: _isGenerating
                        ? null
                        : () {
                            setState(() => _isGenerating = true);
                            widget.onFinish?.call();
                            Future.delayed(
                              const Duration(milliseconds: 2500),
                              () {
                                if (mounted) {
                                  Navigator.of(context)
                                      .popUntil((route) => route.isFirst);
                                }
                              },
                            );
                          },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value, ColorScheme cs,
      {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13),
        ),
        Text(
          value,
          style: TextStyle(
            color: isTotal ? cs.primary : cs.onSurface,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            fontSize: isTotal ? 15 : 13,
          ),
        ),
      ],
    );
  }
}
