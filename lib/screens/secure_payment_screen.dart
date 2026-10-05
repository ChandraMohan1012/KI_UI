import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../services/api_service.dart';
import '../theme/theme.dart';
import '../widgets/widgets.dart';
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
      await Future.delayed(const Duration(milliseconds: 600));
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentSuccessScreen(
              amount: widget.amount,
              onFinish: widget.onFinish,
            ),
          ),
        );
      }
    } catch (_) {
      if (mounted) setState(() => _isProcessing = false);
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

      if (verification['success'] == true && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentSuccessScreen(
              amount: widget.amount,
              onFinish: widget.onFinish,
            ),
          ),
        );
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    if (mounted) {
      setState(() => _isProcessing = false);
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {}

  @override
  Widget build(BuildContext context) {
    final tt = context.tt;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Checkout',
            style: tt.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HeroCard(
                title: '₹${widget.amount.toInt()}',
                subtitle: 'Order Total',
              ),
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: AppCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      AppListRow(
                        label: 'Payment Method',
                        value: 'UPI / Card',
                        leadingIcon: Icons.payment_rounded,
                        showDivider: true,
                      ),
                      AppListRow(
                        label: 'Security',
                        value: 'Encrypted',
                        leadingIcon: Icons.security_rounded,
                        showDivider: false,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppPillButton(
                label: 'Pay ₹${widget.amount.toInt()}',
                onPressed: _handlePayment,
                isLoading: _isProcessing,
                isFullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
