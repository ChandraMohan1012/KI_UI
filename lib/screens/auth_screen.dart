import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/api_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';
import '../utils/app_assets.dart';
import '../utils/legal_texts.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';
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
        SnackBar(
          content:
              const Text('Please accept the Terms & Conditions to proceed.'),
          backgroundColor: context.semanticColors.warning,
          behavior: SnackBarBehavior.floating,
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
        final errorMsg = response?['error']?.toString() ??
            (_isLogin
                ? 'Invalid email or password. Please try again.'
                : 'Unable to create account. Please try again.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: context.cs.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      debugPrint('AUTH_ERROR: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Connection error. Please check your internet connection.',
            ),
            backgroundColor: context.cs.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _loginAsDemoUser() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const UserDetailsScreen(
          userData: {
            'name': 'Er. Senthil Kumar',
            'email': 'senthil@kanavuillam.ai',
            'phone': '9840123456',
            'role': 'architect',
          },
        ),
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    if (!_agreedToLegal) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Please agree to Terms & Conditions and Privacy Policy to continue.',
          ),
          backgroundColor: context.semanticColors.warning,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize(
        serverClientId:
            '665187508900-rrg56qkkn3jqa6cjj0s8401qkk5b6vfo.apps.googleusercontent.com',
      );

      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        throw Exception('Missing Google ID token');
      }

      final response = await ApiService.post('/auth/google/token', {
        'idToken': idToken,
        'email': googleUser.email,
        'name': googleUser.displayName,
      });

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
            content: Text(response?['error'] ?? 'Google Sign-In failed.'),
            backgroundColor: context.cs.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      debugPrint('GOOGLE_SIGN_IN_ERROR: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Google Sign-In failed. Please try again.'),
            backgroundColor: context.cs.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showLegalBottomSheet(String title, String content) {
    final cs = context.cs;
    final tt = context.tt;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: cs.surfaceContainer,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppSpacing.lg)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.md,
                    AppSpacing.md,
                    AppSpacing.md,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: tt.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.primary,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: cs.onSurfaceVariant),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                Divider(color: cs.outlineVariant, height: 1),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: _buildSimpleMarkdownText(content),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildSimpleMarkdownText(String text) {
    final cs = context.cs;
    final lines = text.split('\n');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        if (line.startsWith('# ')) {
          return Padding(
            padding: const EdgeInsets.only(
                bottom: AppSpacing.md, top: AppSpacing.sm),
            child: Text(
              line.replaceFirst('# ', ''),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: cs.primary,
              ),
            ),
          );
        } else if (line.startsWith('## ')) {
          return Padding(
            padding: const EdgeInsets.only(
                bottom: AppSpacing.sm, top: AppSpacing.md),
            child: Text(
              line.replaceFirst('## ', ''),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: cs.onSurface,
              ),
            ),
          );
        } else if (line.startsWith('* ')) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 6, left: AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• ', style: TextStyle(fontSize: 16, color: cs.primary)),
                Expanded(
                  child: Text(
                    line.replaceFirst('* ', ''),
                    style: TextStyle(
                      fontSize: 14,
                      color: cs.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (line.trim().isEmpty) {
          return const SizedBox(height: AppSpacing.sm);
        } else {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Text(
              line,
              style: TextStyle(
                fontSize: 14,
                color: cs.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          );
        }
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;

    return Scaffold(
      backgroundColor: cs.surface,
      body: Stack(
        children: [
          // 1. Background image with fallback
          Positioned.fill(
            child: Image.asset(
              AppAssets.luxuryVillaBg,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              errorBuilder: (_, __, ___) => Image.asset(
                AppAssets.architecturalBg,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),

          // 2. Dark Scrim & Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.45),
                    Colors.black.withValues(alpha: 0.75),
                    cs.surface.withValues(alpha: 0.98),
                  ],
                ),
              ),
            ),
          ),

          // 3. Ambient Gold Warm Glow
          Positioned(
            top: -40,
            left: -40,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cs.primary.withValues(alpha: 0.18),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            right: -50,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cs.primary.withValues(alpha: 0.12),
              ),
            ),
          ),

          // 4. Main Scrollable Content
          Positioned.fill(
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildHeaderSection(),
                        const SizedBox(height: AppSpacing.lg),
                        _buildGlassAuthCard(),
                        const SizedBox(height: AppSpacing.md),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    final cs = context.cs;

    return Column(
      children: [
        Semantics(
          label: 'Kanavu Illam Logo',
          image: true,
          child: Container(
            height: 120,
            padding: const EdgeInsets.all(AppSpacing.xs),
            child: Image.asset(
              AppAssets.logo,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Icon(
                Icons.architecture_rounded,
                color: cs.primary,
                size: 72,
              ),
            ),
          ),
        ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack).fadeIn(),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: cs.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: cs.primary, blurRadius: 6),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'KANAVU ILLAM',
              style: TextStyle(
                color: cs.primary,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.0,
                shadows: const [Shadow(color: Colors.black, blurRadius: 8)],
              ),
            ),
          ],
        ).animate().fadeIn(delay: 150.ms),
        const SizedBox(height: 4),
        Text(
          'AI-Powered Architectural Design',
          style: TextStyle(
            color: cs.onSurfaceVariant,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ).animate().fadeIn(delay: 200.ms),
      ],
    );
  }

  Widget _buildGlassAuthCard() {
    final cs = context.cs;

    return Container(
      decoration: BoxDecoration(
        borderRadius: AppRadius.xlBorder,
        border: Border.all(
          color: cs.outlineVariant.withValues(alpha: 0.5),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withValues(alpha: 0.12),
            blurRadius: 28,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: AppRadius.xlBorder,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.lg + 4,
            ),
            color: cs.surfaceContainer.withValues(alpha: 0.75),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Pill & Headline
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _isLogin ? 'Sign In' : 'Create Account',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.3,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: cs.primary.withValues(alpha: 0.18),
                          borderRadius: AppRadius.fullBorder,
                          border: Border.all(
                            color: cs.primary.withValues(alpha: 0.35),
                          ),
                        ),
                        child: Text(
                          _isLogin ? 'WELCOME' : 'JOIN US',
                          style: TextStyle(
                            color: cs.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 100.ms),

                  const SizedBox(height: 6),

                  Text(
                    _isLogin
                        ? 'Welcome back! Ready to build your dream home?'
                        : 'Join Kanavu Illam and explore AI floor plans!',
                    style: TextStyle(
                      color: cs.onSurfaceVariant,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ).animate().fadeIn(delay: 150.ms),

                  const SizedBox(height: AppSpacing.lg),

                  // Name input (for Sign Up)
                  if (!_isLogin) ...[
                    AppTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      hint: 'Enter your name',
                      prefixIcon: Icons.person_outline_rounded,
                      autofillHints: const [AutofillHints.name],
                      textInputAction: TextInputAction.next,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.05),
                    const SizedBox(height: AppSpacing.md),
                  ],

                  // Email input
                  AppTextField(
                    controller: _emailController,
                    label: 'Email Address',
                    hint: 'name@example.com',
                    prefixIcon: Icons.alternate_email_rounded,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    textInputAction: TextInputAction.next,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!val.contains('@') || !val.contains('.')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ).animate().fadeIn(delay: 250.ms).slideY(begin: 0.05),

                  const SizedBox(height: AppSpacing.md),

                  // Password input
                  AppTextField(
                    controller: _passwordController,
                    label: 'Password',
                    hint: '••••••••',
                    prefixIcon: Icons.lock_outline_rounded,
                    isObscure: true,
                    autofillHints: const [AutofillHints.password],
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _submit(),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (!_isLogin && val.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.05),

                  // Forgot Password Link
                  if (_isLogin) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Password reset link sent to your email.',
                              ),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xs,
                            vertical: AppSpacing.xs,
                          ),
                          minimumSize: const Size(48, 36),
                        ),
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: cs.primary,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: 320.ms),
                  ] else
                    const SizedBox(height: AppSpacing.sm),

                  // Legal Checkbox
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 32,
                        height: 32,
                        child: Checkbox(
                          value: _agreedToLegal,
                          onChanged: (val) {
                            setState(() => _agreedToLegal = val ?? false);
                          },
                          activeColor: cs.primary,
                          checkColor: cs.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          side: BorderSide(
                            color: cs.outlineVariant,
                            width: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text.rich(
                            TextSpan(
                              text: 'I agree to the ',
                              style: TextStyle(
                                color: cs.onSurfaceVariant,
                                fontSize: 12,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Terms & Conditions',
                                  style: TextStyle(
                                    color: cs.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    decorationColor: cs.primary,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => _showLegalBottomSheet(
                                          'Terms & Conditions',
                                          LegalTexts.termsAndConditions,
                                        ),
                                ),
                                TextSpan(
                                  text: ' and ',
                                  style: TextStyle(
                                    color: cs.onSurfaceVariant,
                                    fontSize: 12,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: TextStyle(
                                    color: cs.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    decorationColor: cs.primary,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => _showLegalBottomSheet(
                                          'Privacy Policy',
                                          LegalTexts.privacyPolicy,
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 350.ms),

                  const SizedBox(height: AppSpacing.lg),

                  // Primary Submit Button
                  AppButton(
                    label: _isLogin ? 'Sign In' : 'Sign Up',
                    trailingIcon: Icons.arrow_forward_rounded,
                    isLoading: _isLoading,
                    isFullWidth: true,
                    onPressed: _submit,
                  ).animate().fadeIn(delay: 400.ms),

                  const SizedBox(height: AppSpacing.lg),

                  // OR Divider
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: cs.outlineVariant.withValues(alpha: 0.5),
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                        ),
                        child: Text(
                          'or continue with',
                          style: TextStyle(
                            color: cs.onSurfaceVariant.withValues(alpha: 0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: cs.outlineVariant.withValues(alpha: 0.5),
                          thickness: 1,
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 450.ms),

                  const SizedBox(height: AppSpacing.md),

                  // Google Social Login Button
                  Center(
                    child: InkWell(
                      onTap: _signInWithGoogle,
                      borderRadius: AppRadius.fullBorder,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.sm + 3,
                        ),
                        decoration: BoxDecoration(
                          color:
                              cs.surfaceContainerHighest.withValues(alpha: 0.5),
                          borderRadius: AppRadius.fullBorder,
                          border: Border.all(
                            color: cs.outlineVariant,
                            width: 1.2,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              AppAssets.searchIcon,
                              height: 18,
                              width: 18,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.g_mobiledata,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'Google Account',
                              style: TextStyle(
                                color: cs.onSurface,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 500.ms),

                  const SizedBox(height: AppSpacing.md),

                  // Quick Demo Access Button (Instant 1-Click login)
                  Center(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.bolt_rounded,
                          color: AppColors.amber500, size: 18),
                      label: Text(
                        'Instant Demo Access (No Login Required)',
                        style: TextStyle(
                          color: cs.onSurface,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.sm + 4,
                        ),
                        side: BorderSide(
                          color: AppColors.amber500.withValues(alpha: 0.6),
                          width: 1.2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.fullBorder,
                        ),
                      ),
                      onPressed: _loginAsDemoUser,
                    ),
                  ).animate().fadeIn(delay: 520.ms),

                  const SizedBox(height: AppSpacing.lg),

                  // Toggle Login / Sign Up
                  Center(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _isLogin = !_isLogin;
                          _emailController.clear();
                          _passwordController.clear();
                          _nameController.clear();
                        });
                      },
                      borderRadius: AppRadius.smBorder,
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.xs),
                        child: RichText(
                          text: TextSpan(
                            text: _isLogin
                                ? "Don't have an account? "
                                : "Already have an account? ",
                            style: TextStyle(
                              color: cs.onSurfaceVariant,
                              fontSize: 13,
                            ),
                            children: [
                              TextSpan(
                                text: _isLogin ? 'Sign Up' : 'Sign In',
                                style: TextStyle(
                                  color: cs.primary,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  decorationColor: cs.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 550.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
