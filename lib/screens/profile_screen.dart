import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/theme.dart';
import '../widgets/widgets.dart';
import 'auth_screen.dart';

class ProfileScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;
  const ProfileScreen({super.key, this.userData});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = 'User';
  String email = 'user@example.com';
  String phone = '+91 98765 43210';
  String address = 'Chennai, Tamil Nadu';

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
          'user@example.com';
      phone = prefs.getString('user_phone') ??
          (meta?['phone'] as String?) ??
          '+91 98765 43210';
      address = prefs.getString('user_address') ?? 'Chennai, Tamil Nadu';
    });
  }

  @override
  Widget build(BuildContext context) {
    final tt = context.tt;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: tt.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Avatar & Name on top
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: AppColors.textPrimary,
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : 'U',
                        style: tt.headlineMedium?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      name,
                      style:
                          tt.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 3 Rows: Phone, Email, Location inside one AppCard
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    AppListRow(
                      label: 'Phone',
                      value: phone,
                      leadingIcon: Icons.phone_outlined,
                      showDivider: true,
                    ),
                    AppListRow(
                      label: 'Email',
                      value: email,
                      leadingIcon: Icons.email_outlined,
                      showDivider: true,
                    ),
                    AppListRow(
                      label: 'Location',
                      value: address,
                      leadingIcon: Icons.location_on_outlined,
                      showDivider: false,
                    ),
                  ],
                ),
              ),
              const Spacer(),

              // Logout text button in error color
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const AuthScreen(),
                      ),
                    );
                  },
                  icon:
                      const Icon(Icons.logout_rounded, color: AppColors.error),
                  label: Text(
                    'Logout',
                    style: tt.titleSmall?.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
