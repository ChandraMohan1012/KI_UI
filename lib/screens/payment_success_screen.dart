import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';
import '../utils/app_assets.dart';
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
              ClipRRect(
                borderRadius: AppRadius.lgBorder,
                child: Image.asset(
                  AppAssets.houseGif,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.home_work_outlined,
                    size: 80,
                    color: cs.primary,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Loading your home...',
                style: tt.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: cs.primary,
                      shape: BoxShape.circle,
                    ),
                  )
                      .animate(onPlay: (c) => c.repeat())
                      .scaleXY(
                        begin: 0.5,
                        end: 1.5,
                        duration: 400.ms,
                        curve: Curves.easeInOut,
                        delay: (index * 100).ms,
                      )
                      .then()
                      .scaleXY(
                        begin: 1.5,
                        end: 0.5,
                        duration: 400.ms,
                        curve: Curves.easeInOut,
                      ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final now = DateTime.now();
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final month = months[now.month - 1];
    final hour =
        now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final ampm = now.hour >= 12 ? 'PM' : 'AM';
    final minute = now.minute.toString().padLeft(2, '0');
    final formattedDate = '${now.day} $month ${now.year}, $hour:$minute $ampm';

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: cs.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          color: sc.successContainer,
                          shape: BoxShape.circle,
                        ),
                      ).animate().scale(
                            duration: 500.ms,
                            curve: Curves.easeOutBack,
                          ),
                      Icon(
                        Icons.check_circle_rounded,
                        color: sc.success,
                        size: 72,
                      ).animate().scale(
                            duration: 350.ms,
                            curve: Curves.easeOutBack,
                          ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Payment Successful!',
                    textAlign: TextAlign.center,
                    style: tt.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.3,
                    ),
                  ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.1),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '₹${widget.amount.toInt()} Paid Successfully',
                    style: tt.titleMedium?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate().fadeIn(delay: 250.ms),
                  const SizedBox(height: AppSpacing.xl),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainer,
                      borderRadius: AppRadius.lgBorder,
                      border: Border.all(color: cs.outlineVariant),
                    ),
                    child: Column(
                      children: [
                        _detailRow('Payment ID', '#PXN78451236', cs),
                        Divider(
                            color: cs.outlineVariant.withValues(alpha: 0.5),
                            height: 24),
                        _detailRow('Date & Time', formattedDate, cs),
                        Divider(
                            color: cs.outlineVariant.withValues(alpha: 0.5),
                            height: 24),
                        _detailRow('Payment Method', 'UPI', cs),
                        Divider(
                            color: cs.outlineVariant.withValues(alpha: 0.5),
                            height: 24),
                        _detailRow('Amount', '₹${widget.amount.toInt()}', cs,
                            isTotal: true),
                      ],
                    ),
                  ).animate().fadeIn(delay: 350.ms).slideY(begin: 0.05),
                  const SizedBox(height: AppSpacing.xl),
                  AppButton(
                    label: 'GENERATE YOUR PLAN TO LIFE',
                    icon: Icons.auto_awesome_rounded,
                    isFullWidth: true,
                    isLoading: _isGenerating,
                    onPressed: _isGenerating
                        ? null
                        : () {
                            setState(() => _isGenerating = true);
                            debugPrint(
                              'SUCCESS_SCREEN: Generate button clicked, calling onFinish',
                            );
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
                  ).animate().fadeIn(delay: 450.ms),
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
            fontWeight: isTotal ? FontWeight.w900 : FontWeight.bold,
            fontSize: isTotal ? 16 : 13,
          ),
        ),
      ],
    );
  }
}
