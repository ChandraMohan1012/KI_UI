import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';
import '../widgets/app_badge.dart';
import '../widgets/app_button.dart';
import 'upi_processing_screen.dart';

class UpiPaymentScreen extends StatefulWidget {
  final double amount;
  final VoidCallback? onFinish;

  const UpiPaymentScreen({super.key, required this.amount, this.onFinish});

  @override
  State<UpiPaymentScreen> createState() => _UpiPaymentScreenState();
}

class _UpiPaymentScreenState extends State<UpiPaymentScreen> {
  final TextEditingController _upiController =
      TextEditingController(text: 'user@upi');
  String _selectedApp = 'GPAY';

  @override
  void dispose() {
    _upiController.dispose();
    super.dispose();
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
        ),
        title: Text(
          'UPI CHECKOUT',
          style: tt.titleSmall?.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: AppSpacing.md),
            child: AppBadge(
              label: 'SECURE',
              icon: Icons.lock_rounded,
              variant: AppBadgeVariant.info,
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.sm),
                _buildPayUsingBanner(cs, tt),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'ENTER UPI ID',
                  style: tt.labelMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                _buildUpiInputField(cs),
                const SizedBox(height: AppSpacing.xl),
                _buildDividerWithText('OR SELECT APP', cs),
                const SizedBox(height: AppSpacing.lg),
                _buildUpiAppsList(cs),
                const SizedBox(height: AppSpacing.xl),
                _buildScanQrCard(cs),
                const SizedBox(height: AppSpacing.xl),
                _buildRedirectInfo(cs),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: _buildBottomBar(cs),
    );
  }

  Widget _buildPayUsingBanner(ColorScheme cs, TextTheme tt) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: AppRadius.lgBorder,
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: AppRadius.mdBorder,
            ),
            child: Icon(Icons.payment_rounded, color: cs.primary, size: 24),
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'UNIFIED PAYMENTS',
                style: tt.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                'Fast & Zero Transaction Fee',
                style: tt.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpiInputField(ColorScheme cs) {
    return TextField(
      controller: _upiController,
      style: TextStyle(
        color: cs.onSurface,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: cs.surfaceContainer,
        hintText: 'user@upi',
        hintStyle: TextStyle(color: cs.onSurfaceVariant.withValues(alpha: 0.6)),
        prefixIcon: Icon(Icons.alternate_email_rounded, color: cs.primary),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: AppSpacing.sm),
          child: Icon(Icons.verified_rounded,
              color: context.semanticColors.success, size: 20),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdBorder,
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdBorder,
          borderSide: BorderSide(color: cs.primary, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildDividerWithText(String text, ColorScheme cs) {
    return Row(
      children: [
        Expanded(
            child: Divider(color: cs.outlineVariant.withValues(alpha: 0.5))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            text,
            style: TextStyle(
              color: cs.onSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
        ),
        Expanded(
            child: Divider(color: cs.outlineVariant.withValues(alpha: 0.5))),
      ],
    );
  }

  Widget _buildUpiAppsList(ColorScheme cs) {
    final apps = [
      {'name': 'GPAY', 'icon': Icons.account_balance_rounded},
      {'name': 'PHONEPE', 'icon': Icons.account_balance_wallet_rounded},
      {'name': 'PAYTM', 'icon': Icons.payment_rounded},
      {'name': 'BHIM', 'icon': Icons.security_rounded},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: apps.map((app) {
        final name = app['name'] as String;
        final icon = app['icon'] as IconData;
        final isSelected = _selectedApp == name;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () => setState(() => _selectedApp = name),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 80,
                decoration: BoxDecoration(
                  color: isSelected
                      ? cs.primary.withValues(alpha: 0.15)
                      : cs.surfaceContainer,
                  borderRadius: AppRadius.mdBorder,
                  border: Border.all(
                    color: isSelected ? cs.primary : cs.outlineVariant,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      color: isSelected ? cs.primary : cs.onSurfaceVariant,
                      size: 24,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      name,
                      style: TextStyle(
                        color: isSelected ? cs.primary : cs.onSurfaceVariant,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
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

  Widget _buildScanQrCard(ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: AppRadius.lgBorder,
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.15),
              borderRadius: AppRadius.mdBorder,
            ),
            child: Icon(Icons.qr_code_scanner_rounded,
                color: cs.primary, size: 26),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SCAN QR CODE',
                  style: TextStyle(
                    color: cs.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Generate dynamic QR for instant pay',
                  style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant),
        ],
      ),
    );
  }

  Widget _buildRedirectInfo(ColorScheme cs) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline_rounded,
              color: cs.onSurfaceVariant, size: 16),
          const SizedBox(width: AppSpacing.xs),
          Text(
            'Securely redirecting to authorized UPI app',
            style: TextStyle(
              color: cs.onSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        border: Border(top: BorderSide(color: cs.outlineVariant)),
      ),
      child: AppButton(
        label: 'PAY SECURELY (₹${widget.amount.toInt()})',
        icon: Icons.verified_user_rounded,
        isFullWidth: true,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UpiProcessingScreen(
                amount: widget.amount,
                onFinish: widget.onFinish,
              ),
            ),
          );
        },
      ),
    );
  }
}
