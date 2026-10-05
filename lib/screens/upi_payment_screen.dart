import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';
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
          tooltip: 'Back',
        ),
        title: Text(
          'UPI Payment',
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
            constraints: const BoxConstraints(maxWidth: 440),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Amount Hero Card
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerLow,
                      borderRadius: AppRadius.lgBorder,
                      border: Border.all(color: cs.outlineVariant),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Payable',
                          style: tt.bodyMedium
                              ?.copyWith(color: cs.onSurfaceVariant),
                        ),
                        Text(
                          '₹${widget.amount.toInt()}',
                          style: tt.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: cs.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // UPI Field
                  Text(
                    'UPI ID',
                    style: tt.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  TextField(
                    controller: _upiController,
                    style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: cs.surfaceContainerLow,
                      hintText: 'username@upi',
                      prefixIcon: Icon(Icons.alternate_email_rounded,
                          color: cs.primary, size: 20),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: AppRadius.mdBorder,
                        borderSide: BorderSide(color: cs.outlineVariant),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: AppRadius.mdBorder,
                        borderSide: BorderSide(color: cs.primary, width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // Apps Row
                  Text(
                    'Or Select App',
                    style: tt.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  _buildUpiAppsList(cs, tt),
                  const Spacer(),
                  // Submit CTA
                  AppButton(
                    label: 'Pay ₹${widget.amount.toInt()}',
                    trailingIcon: Icons.arrow_forward_rounded,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUpiAppsList(ColorScheme cs, TextTheme tt) {
    final apps = [
      {'name': 'GPay', 'icon': Icons.account_balance_rounded},
      {'name': 'PhonePe', 'icon': Icons.account_balance_wallet_rounded},
      {'name': 'Paytm', 'icon': Icons.payment_rounded},
      {'name': 'BHIM', 'icon': Icons.security_rounded},
    ];

    return Row(
      children: apps.map((app) {
        final name = app['name'] as String;
        final icon = app['icon'] as IconData;
        final isSelected = _selectedApp == name;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: InkWell(
              onTap: () => setState(() => _selectedApp = name),
              borderRadius: AppRadius.mdBorder,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: isSelected
                      ? cs.primary.withValues(alpha: 0.1)
                      : cs.surfaceContainerLow,
                  borderRadius: AppRadius.mdBorder,
                  border: Border.all(
                    color: isSelected ? cs.primary : cs.outlineVariant,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      color: isSelected ? cs.primary : cs.onSurfaceVariant,
                      size: 20,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      name,
                      style: tt.bodySmall?.copyWith(
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? cs.primary : cs.onSurface,
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
}
