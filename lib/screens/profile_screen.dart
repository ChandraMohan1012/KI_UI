import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';
import '../utils/app_assets.dart';
import '../widgets/app_button.dart';
import '../widgets/app_list_row.dart';
import 'auth_screen.dart';
import 'history_screen.dart';

class ProfileScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;
  const ProfileScreen({super.key, this.userData});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = '';
  String email = '';
  String phone = '';
  String address = '';
  int runCount = 0;
  int amountSpent = 0;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final meta = widget.userData?['user_metadata'] as Map<String, dynamic>?;

      name =
          prefs.getString('user_name') ?? (meta?['name'] as String?) ?? 'User';
      email = prefs.getString('user_email') ??
          (widget.userData?['email'] as String?) ??
          'unknown';
      phone = prefs.getString('user_phone') ??
          (meta?['phone'] as String?) ??
          'unknown';
      address = prefs.getString('user_address') ?? 'No Address Provided';
    });

    try {
      final projects = await _apiService.getAllProjects(email);
      if (mounted) {
        setState(() {
          runCount = projects.length;
          int total = 0;
          for (var p in projects) {
            String pName = p['name'] ?? '';
            if (pName.contains('|')) {
              var parts = pName.split('|');
              if (parts.length > 2) {
                total += (double.tryParse(parts[2]) ?? 99.0).round();
              } else {
                total += 99;
              }
            } else {
              total += 99;
            }
          }
          amountSpent = total;
        });
      }
    } catch (e) {
      debugPrint('Error fetching project stats: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;
    final sc = context.semanticColors;
    final tt = context.tt;

    return Scaffold(
      backgroundColor: cs.surface,
      body: Stack(
        children: [
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
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.5),
                    Colors.black.withValues(alpha: 0.75),
                    cs.surface.withValues(alpha: 0.98),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                    child: Column(
                      children: [
                        _buildProfileHeader(cs, tt),
                        const SizedBox(height: AppSpacing.lg),
                        _buildStatsRow(cs, sc),
                        const SizedBox(height: AppSpacing.lg),
                        _buildProfileCard(cs, tt),
                        const SizedBox(height: AppSpacing.xl),
                        AppButton(
                          label: 'Logout Account',
                          icon: Icons.logout_rounded,
                          variant: AppButtonVariant.secondary,
                          isFullWidth: true,
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => const AuthScreen(),
                              ),
                            );
                          },
                        ).animate().fadeIn(delay: 450.ms),
                        const SizedBox(height: AppSpacing.lg),
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

  Widget _buildProfileHeader(ColorScheme cs, TextTheme tt) {
    return Column(
      children: [
        Container(
          width: 84,
          height: 84,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: cs.primary.withValues(alpha: 0.2),
            border:
                Border.all(color: cs.primary.withValues(alpha: 0.6), width: 2),
            boxShadow: [
              BoxShadow(
                color: cs.primary.withValues(alpha: 0.25),
                blurRadius: 18,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipOval(
            child: Container(
              color: cs.surfaceContainerHighest,
              child: Icon(
                Icons.person_rounded,
                color: cs.primary,
                size: 42,
              ),
            ),
          ),
        ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack).fadeIn(),
        const SizedBox(height: AppSpacing.sm),
        Text(
          name.isNotEmpty ? name : 'Architect User',
          style: tt.titleLarge?.copyWith(
            color: cs.primary,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.3,
          ),
        ).animate().fadeIn(delay: 150.ms),
        const SizedBox(height: 2),
        Text(
          email.isNotEmpty ? email : 'user@kanavuillam.com',
          style: tt.bodySmall?.copyWith(
            color: cs.onSurfaceVariant,
            fontSize: 13,
          ),
        ).animate().fadeIn(delay: 200.ms),
      ],
    );
  }

  Widget _buildStatsRow(ColorScheme cs, AppSemanticColors sc) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: cs.surfaceContainer.withValues(alpha: 0.8),
              borderRadius: AppRadius.lgBorder,
              border:
                  Border.all(color: cs.outlineVariant.withValues(alpha: 0.6)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.15),
                    borderRadius: AppRadius.mdBorder,
                  ),
                  child: Icon(Icons.analytics_rounded,
                      color: cs.primary, size: 20),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$runCount',
                        style: TextStyle(
                          color: cs.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Projects',
                        style: TextStyle(
                          color: cs.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: cs.surfaceContainer.withValues(alpha: 0.8),
              borderRadius: AppRadius.lgBorder,
              border:
                  Border.all(color: cs.outlineVariant.withValues(alpha: 0.6)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: sc.successContainer,
                    borderRadius: AppRadius.mdBorder,
                  ),
                  child:
                      Icon(Icons.payments_rounded, color: sc.success, size: 20),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '₹$amountSpent',
                        style: TextStyle(
                          color: sc.success,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Invested',
                        style: TextStyle(
                          color: cs.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 250.ms);
  }

  Widget _buildProfileCard(ColorScheme cs, TextTheme tt) {
    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainer.withValues(alpha: 0.8),
        borderRadius: AppRadius.xlBorder,
        border: Border.all(
          color: cs.outlineVariant.withValues(alpha: 0.6),
          width: 1.2,
        ),
      ),
      child: ClipRRect(
        borderRadius: AppRadius.xlBorder,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                child: Text(
                  'Account Details',
                  style: tt.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              AppListRow(
                leadingIcon: Icons.person_outline_rounded,
                label: 'Full Name',
                value: name.isNotEmpty ? name : 'Not Set',
                showDivider: true,
              ),
              AppListRow(
                leadingIcon: Icons.phone_outlined,
                label: 'Phone Number',
                value: phone.isNotEmpty ? phone : 'Not Provided',
                showDivider: true,
              ),
              AppListRow(
                leadingIcon: Icons.email_outlined,
                label: 'Email Address',
                value: email.isNotEmpty ? email : 'Not Provided',
                showDivider: true,
              ),
              AppListRow(
                leadingIcon: Icons.location_on_outlined,
                label: 'Site Location',
                value: address.isNotEmpty ? address : 'No Address Provided',
                showDivider: true,
              ),
              AppListRow(
                leadingIcon: Icons.history_rounded,
                label: 'Project History',
                subtitle: 'View all generated plans and reports',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HistoryScreen(),
                    ),
                  );
                },
                isAccent: true,
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 350.ms);
  }
}
