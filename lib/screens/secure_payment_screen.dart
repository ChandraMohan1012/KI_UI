import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../services/api_service.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';
import '../widgets/app_button.dart';
import 'payment_success_screen.dart';

class SecurePaymentScreen extends StatefulWidget {
  final double amount;
  final List<String> selectedItems;
  final VoidCallback? onFinish;

  const SecurePaymentScreen({
    super.key,
    required this.amount,
    required this.selectedItems,
    this.onFinish,
  });

  @override
  State<SecurePaymentScreen> createState() => _SecurePaymentScreenState();
}

class _SecurePaymentScreenState extends State<SecurePaymentScreen> {
  String _selectedMethod = 'UPI';
  bool _isProcessing = false;
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePayment() async {
    setState(() => _isProcessing = true);

    try {
      await Future.delayed(const Duration(seconds: 1));

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
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);
        _showError('Checkout initialization could not be completed.');
      }
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      final api = ApiService();
      final verification = await api.verifyRazorpayPayment({
        'razorpay_order_id': response.orderId,
        'razorpay_payment_id': response.paymentId,
        'razorpay_signature': response.signature,
      });

      if (verification['success'] == true) {
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
      } else {
        _showError('Payment verification was not successful.');
      }
    } catch (_) {
      _showError('Payment verification encountered an issue.');
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    if (mounted) {
      setState(() => _isProcessing = false);
      _showError(response.message ?? 'Payment failed. Please try again.');
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint("External Wallet Selected: ${response.walletName}");
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: context.cs.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
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
          'CHECKOUT',
          style: tt.titleSmall?.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 540),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.sm),
                _buildStepper(cs),
                const SizedBox(height: AppSpacing.xl),
                _buildOrderSummary(cs, tt),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'PAYMENT METHOD',
                  style: tt.labelLarge?.copyWith(
                    color: cs.onSurface,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _buildPaymentMethods(cs),
                const SizedBox(height: 120),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: _buildBottomPayAction(cs),
    );
  }

  Widget _buildStepper(ColorScheme cs) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _stepItem(1, 'Order', true, cs),
        _stepDivider(true, cs),
        _stepItem(2, 'Payment', true, cs),
        _stepDivider(false, cs),
        _stepItem(3, 'Review', false, cs),
      ],
    );
  }

  Widget _stepItem(int num, String label, bool active, ColorScheme cs) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: active ? cs.primary : cs.surfaceContainerHighest,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              num.toString(),
              style: TextStyle(
                color: active ? cs.onPrimary : cs.onSurfaceVariant,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: active ? cs.primary : cs.onSurfaceVariant,
            fontSize: 12,
            fontWeight: active ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _stepDivider(bool active, ColorScheme cs) {
    return Container(
      width: 36,
      height: 2,
      margin: const EdgeInsets.only(bottom: 22, left: 8, right: 8),
      decoration: BoxDecoration(
        color: active ? cs.primary : cs.outlineVariant,
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }

  Widget _buildOrderSummary(ColorScheme cs, TextTheme tt) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: AppRadius.xlBorder,
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.receipt_long_rounded,
                    color: cs.primary, size: 18),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'ORDER SUMMARY',
                style: tt.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              Text(
                '#PXN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          ...widget.selectedItems.map((item) {
            String price = '₹299';
            final id = item.toLowerCase();
            if (id.contains('3d')) {
              price = '₹499';
            } else if (id.contains('vastu')) {
              price = '₹299';
            } else if (id.contains('cost')) {
              price = '₹199';
            } else if (id.contains('structural')) {
              price = '₹999';
            } else if (id.contains('elevation')) {
              price = '₹799';
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                children: [
                  Text(
                    item.toUpperCase(),
                    style: TextStyle(
                      color: cs.onSurfaceVariant,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    price,
                    style: TextStyle(
                      color: cs.onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            );
          }),
          Divider(color: cs.outlineVariant.withValues(alpha: 0.5), height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TOTAL AMOUNT',
                style: TextStyle(
                  color: cs.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                '₹${widget.amount.toInt()}',
                style: TextStyle(
                  color: cs.primary,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethods(ColorScheme cs) {
    return Row(
      children: [
        _methodCard('UPI', Icons.account_balance_wallet_rounded, 'Instant Pay',
            cs.primary, cs),
        const SizedBox(width: AppSpacing.sm),
        _methodCard('CARDS', Icons.credit_card_rounded, 'Debit / Credit',
            cs.secondary, cs),
        const SizedBox(width: AppSpacing.sm),
        _methodCard('NET BANKING', Icons.account_balance_rounded, 'All Banks',
            context.semanticColors.info, cs),
      ],
    );
  }

  Widget _methodCard(
    String title,
    IconData icon,
    String subtitle,
    Color accentColor,
    ColorScheme cs,
  ) {
    bool isSelected = _selectedMethod == title;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedMethod = title),
        child: Container(
          height: 120,
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: isSelected
                ? cs.surfaceContainerHighest.withValues(alpha: 0.5)
                : cs.surfaceContainer,
            borderRadius: AppRadius.lgBorder,
            border: Border.all(
              color: isSelected ? accentColor : cs.outlineVariant,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: accentColor, size: 22),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                title,
                style: TextStyle(
                  color: cs.onSurface,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: cs.onSurfaceVariant,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomPayAction(ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        border: Border(top: BorderSide(color: cs.outlineVariant)),
      ),
      child: SafeArea(
        child: AppButton(
          label: 'PAY ₹${widget.amount.toInt()} NOW',
          icon: Icons.lock_rounded,
          isFullWidth: true,
          isLoading: _isProcessing,
          onPressed: _isProcessing ? null : _handlePayment,
        ),
      ),
    );
  }
}
