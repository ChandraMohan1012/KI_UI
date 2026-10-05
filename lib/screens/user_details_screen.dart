import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/app_assets.dart';
import '../theme/theme.dart';
import '../widgets/widgets.dart';
import 'shell_screen.dart';

class UserDetailsScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const UserDetailsScreen({super.key, this.userData});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.userData?['name'] ?? '');
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _submitDetails() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', _nameController.text.trim());
      await prefs.setString('user_phone', _phoneController.text.trim());
      await prefs.setString('user_address', _addressController.text.trim());

      if (widget.userData?['email'] != null) {
        await prefs.setString('user_email', widget.userData!['email']);
      }

      await Future.delayed(const Duration(milliseconds: 300));

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => ShellScreen(userData: widget.userData),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
                  // Logo Header
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

                  // Details Card
                  AppCard(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'User Details',
                            style: tt.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          AppTextField(
                            controller: _nameController,
                            label: 'Name',
                            prefixIcon: Icons.person_outline_rounded,
                            validator: (v) =>
                                v == null || v.isEmpty ? 'Required' : null,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          AppTextField(
                            controller: _phoneController,
                            label: 'Phone',
                            keyboardType: TextInputType.phone,
                            prefixIcon: Icons.phone_outlined,
                            validator: (v) =>
                                v == null || v.isEmpty ? 'Required' : null,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          AppTextField(
                            controller: _addressController,
                            label: 'Location',
                            prefixIcon: Icons.location_on_outlined,
                            validator: (v) =>
                                v == null || v.isEmpty ? 'Required' : null,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          AppPillButton(
                            label: 'Save & Continue',
                            onPressed: _submitDetails,
                            isLoading: _isLoading,
                            isFullWidth: true,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Skip action
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) =>
                              ShellScreen(userData: widget.userData),
                        ),
                      );
                    },
                    child: Text(
                      'Skip for now',
                      style: tt.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
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
