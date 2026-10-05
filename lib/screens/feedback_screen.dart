import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';
import '../widgets/app_button.dart';
import 'shell_screen.dart';

class FeedbackScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const FeedbackScreen({super.key, this.userData});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  int _rating = 0;
  final TextEditingController _feedbackController = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _submitFeedback() {
    if (_rating == 0 && _feedbackController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide a rating or comment first.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    setState(() => _submitted = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Thank you for your valuable feedback!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _exitToHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => ShellScreen(userData: widget.userData),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;
    final sc = context.semanticColors;
    final tt = context.tt;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: AppSpacing.xl),
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          decoration: BoxDecoration(
                            color: sc.successContainer,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check_circle_rounded,
                            color: sc.success,
                            size: 60,
                          ),
                        ).animate().scale(
                              duration: 400.ms,
                              curve: Curves.easeOutBack,
                            ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          'Report Downloaded Successfully!',
                          textAlign: TextAlign.center,
                          style: tt.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.3,
                          ),
                        ).animate().fadeIn(delay: 150.ms),
                        const SizedBox(height: AppSpacing.xl),
                        if (!_submitted) ...[
                          Text(
                            'How was your experience?',
                            style: tt.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: cs.onSurfaceVariant,
                            ),
                          ).animate().fadeIn(delay: 250.ms),
                          const SizedBox(height: AppSpacing.md),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) {
                              return IconButton(
                                iconSize: 36,
                                icon: Icon(
                                  index < _rating
                                      ? Icons.star_rounded
                                      : Icons.star_outline_rounded,
                                  color: cs.primary,
                                ),
                                tooltip: '${index + 1} Stars',
                                onPressed: () {
                                  setState(() => _rating = index + 1);
                                },
                              );
                            }),
                          ).animate().fadeIn(delay: 350.ms),
                          const SizedBox(height: AppSpacing.lg),
                          TextField(
                            controller: _feedbackController,
                            maxLines: 4,
                            style: tt.bodyMedium?.copyWith(color: cs.onSurface),
                            decoration: InputDecoration(
                              hintText:
                                  'Share your feedback with us (optional)...',
                              hintStyle: tt.bodySmall?.copyWith(
                                color:
                                    cs.onSurfaceVariant.withValues(alpha: 0.6),
                              ),
                              filled: true,
                              fillColor: cs.surfaceContainerHighest
                                  .withValues(alpha: 0.4),
                              border: OutlineInputBorder(
                                borderRadius: AppRadius.mdBorder,
                                borderSide:
                                    BorderSide(color: cs.outlineVariant),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: AppRadius.mdBorder,
                                borderSide:
                                    BorderSide(color: cs.outlineVariant),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: AppRadius.mdBorder,
                                borderSide:
                                    BorderSide(color: cs.primary, width: 1.5),
                              ),
                            ),
                          ).animate().fadeIn(delay: 450.ms).slideY(begin: 0.05),
                          const SizedBox(height: AppSpacing.lg),
                          AppButton(
                            label: 'Submit Feedback',
                            isFullWidth: true,
                            onPressed: _submitFeedback,
                          ).animate().fadeIn(delay: 550.ms),
                        ] else ...[
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            decoration: BoxDecoration(
                              color: cs.surfaceContainerHighest
                                  .withValues(alpha: 0.3),
                              borderRadius: AppRadius.lgBorder,
                              border: Border.all(color: cs.outlineVariant),
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.favorite_rounded,
                                    color: cs.primary, size: 36),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  'Thank you! Your feedback helps us build a better Kanavu Illam.',
                                  textAlign: TextAlign.center,
                                  style: tt.bodyMedium?.copyWith(
                                    color: cs.onSurface,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ).animate().fadeIn(),
                        ],
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: AppButton(
                    label: 'Exit to Home',
                    icon: Icons.home_rounded,
                    variant: AppButtonVariant.secondary,
                    isFullWidth: true,
                    onPressed: _exitToHome,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
