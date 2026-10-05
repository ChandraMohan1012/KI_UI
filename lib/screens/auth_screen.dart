import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../core/app_assets.dart';
import '../services/api_service.dart';
import '../theme/theme.dart';
import '../utils/legal_texts.dart';
import '../widgets/widgets.dart';
import 'user_details_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  bool _isLoading = false;
  bool _agreedToLegal = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToLegal) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept Terms & Conditions.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final endpoint = _isLogin ? '/auth/login' : '/auth/signup';
      final body = {
        'email': _emailController.text.trim(),
        'password': _passwordController.text,
        if (!_isLogin) 'name': _nameController.text.trim(),
      };

      final response = await ApiService.post(endpoint, body);

      if (!mounted) return;

      if (response != null && response['error'] == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => UserDetailsScreen(userData: response['user']),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response?['error']?.toString() ?? 'Auth failed'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      debugPrint('AUTH_ERROR: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Network error'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const UserDetailsScreen(userData: {
              'email': 'demo.user@gmail.com',
              'name': 'Demo User',
            }),
          ),
        );
      }
    } catch (e) {
      debugPrint('GOOGLE_SIGN_IN_ERROR: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _bypassForDemo() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const UserDetailsScreen(userData: {
          'email': 'demo@kanavuillam.com',
          'name': 'Demo User',
        }),
      ),
    );
  }

  void _showLegalBottomSheet(String title, String content) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, controller) => Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              width: 36,
              height: 4,
              decoration: const BoxDecoration(
                color: AppColors.border,
                borderRadius: AppRadius.fullBorder,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text(
                title,
                style: context.tt.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.all(AppSpacing.md),
                children: [
                  Text(content, style: context.tt.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tt = context.tt;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Logo Top Header
                  Image.asset(
                    AppAssets.logo,
                    height: 36,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Text(
                      'Kanavu Illam',
                      style: tt.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),

                  // Auth Fields Card
                  AppCard(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            _isLogin ? 'Sign In' : 'Sign Up',
                            style: tt.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: AppSpacing.sm),

                          if (!_isLogin) ...[
                            AppTextField(
                              controller: _nameController,
                              label: 'Name',
                              prefixIcon: Icons.person_outline_rounded,
                              validator: (v) =>
                                  v == null || v.isEmpty ? 'Required' : null,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                          ],

                          AppTextField(
                            controller: _emailController,
                            label: 'Email',
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icons.email_outlined,
                            validator: (v) => v == null || !v.contains('@')
                                ? 'Invalid'
                                : null,
                          ),
                          const SizedBox(height: AppSpacing.xs),

                          AppTextField(
                            controller: _passwordController,
                            label: 'Password',
                            isObscure: true,
                            prefixIcon: Icons.lock_outline_rounded,
                            validator: (v) =>
                                v == null || v.length < 4 ? 'Too short' : null,
                          ),
                          const SizedBox(height: AppSpacing.xs),

                          // Single line Terms Checkbox
                          Row(
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: _agreedToLegal,
                                  onChanged: (v) => setState(
                                      () => _agreedToLegal = v ?? false),
                                  activeColor: AppColors.accent,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                    text: 'I agree to ',
                                    style: tt.bodySmall,
                                    children: [
                                      TextSpan(
                                        text: 'Terms & Conditions',
                                        style: tt.bodySmall?.copyWith(
                                          color: AppColors.accent,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () => _showLegalBottomSheet(
                                                'Terms & Conditions',
                                                LegalTexts.termsAndConditions,
                                              ),
                                      ),
                                    ],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),

                          // Primary Black Pill CTA
                          AppPillButton(
                            label: _isLogin ? 'Sign In' : 'Sign Up',
                            onPressed: _submit,
                            isLoading: _isLoading,
                            isFullWidth: true,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Actions & Demo Access
                  Column(
                    children: [
                      TextButton(
                        onPressed: () => setState(() => _isLogin = !_isLogin),
                        child: Text(
                          _isLogin ? 'Create Account' : 'Sign In Instead',
                          style: tt.labelLarge?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: _handleGoogleSignIn,
                        icon: const Icon(Icons.g_mobiledata_rounded, size: 20),
                        label: const Text('Google Sign-In'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textPrimary,
                          side: const BorderSide(color: AppColors.border),
                        ),
                      ),
                      TextButton(
                        onPressed: _bypassForDemo,
                        child: Text(
                          'Skip (Demo Mode)',
                          style: tt.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
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
