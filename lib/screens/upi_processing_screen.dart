import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';
import '../widgets/app_badge.dart';
import '../widgets/app_button.dart';
import 'payment_success_screen.dart';

class UpiProcessingScreen extends StatefulWidget {
  final double amount;
  final VoidCallback? onFinish;

  const UpiProcessingScreen({super.key, required this.amount, this.onFinish});

  @override
  State<UpiProcessingScreen> createState() => _UpiProcessingScreenState();
}

class _UpiProcessingScreenState extends State<UpiProcessingScreen> {
  @override
  void initState() {
    super.initState();
    _simulateProcessing();
  }

  void _simulateProcessing() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentSuccessScreen(
            amount: widget.amount,
            onFinish: widget.onFinish,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;
    final sc = context.semanticColors;
    final tt = context.tt;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: cs.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Processing Payment',
          style: tt.titleMedium?.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: AppSpacing.md),
            child: AppBadge(
              label: '100% Secure',
              icon: Icons.shield_rounded,
              variant: AppBadgeVariant.info,
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildProcessingCircle(cs, sc),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'Opening UPI App...',
                  style: tt.headlineSmall?.copyWith(
                    color: cs.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Please complete the payment\nin your UPI application',
                  textAlign: TextAlign.center,
                  style: tt.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                    height: 1.35,
                  ),
                ).animate().fadeIn(delay: 150.ms),
                const SizedBox(height: AppSpacing.xxl),
                _buildStatusList(cs, sc),
                const SizedBox(height: AppSpacing.xxl),
                AppButton(
                  label: 'Cancel Payment',
                  variant: AppButtonVariant.secondary,
                  isFullWidth: true,
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(height: AppSpacing.lg),
                _buildFooter(cs),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProcessingCircle(ColorScheme cs, AppSemanticColors sc) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 150,
          height: 150,
          child: CircularProgressIndicator(
            strokeWidth: 4,
            valueColor: AlwaysStoppedAnimation<Color>(sc.info),
            backgroundColor: cs.surfaceContainerHighest.withValues(alpha: 0.3),
          ),
        )
            .animate(onPlay: (controller) => controller.repeat())
            .rotate(duration: 2.seconds),
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: cs.surfaceContainer,
            shape: BoxShape.circle,
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Center(
            child: Icon(Icons.payment_rounded, color: sc.info, size: 38),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusList(ColorScheme cs, AppSemanticColors sc) {
    return Column(
      children: [
        _statusItem('Do not close this screen', true, cs, sc),
        _statusItem('You will be redirected automatically', true, cs, sc),
        _statusItem('Payment status will be updated instantly', true, cs, sc),
      ],
    );
  }

  Widget _statusItem(
    String text,
    bool active,
    ColorScheme cs,
    AppSemanticColors sc,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_rounded,
            color: active ? sc.success : cs.outlineVariant,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: active ? cs.onSurface : cs.onSurfaceVariant,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(ColorScheme cs) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Secured by',
          style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12),
        ),
        const SizedBox(width: AppSpacing.xs),
        Icon(Icons.bolt, color: cs.primary, size: 16),
        Text(
          'Razorpay',
          style: TextStyle(
            color: cs.onSurface,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
