import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';
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
    final tt = context.tt;

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
        title: Text(
          'Processing Payment',
          style: tt.titleMedium?.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                      color: cs.primary,
                      backgroundColor: cs.surfaceContainerLow,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    'Processing Payment',
                    style: tt.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '₹${widget.amount.toInt()}',
                    style: tt.titleLarge?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  AppButton(
                    label: 'Cancel',
                    variant: AppButtonVariant.secondary,
                    isFullWidth: true,
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
