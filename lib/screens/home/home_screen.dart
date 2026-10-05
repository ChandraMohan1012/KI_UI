import 'package:flutter/material.dart';
import '../../core/app_assets.dart';
import '../../theme/theme.dart';
import '../../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onStartNewPlan;
  final VoidCallback onOpen3D;
  final VoidCallback onOpenVastu;
  final VoidCallback onOpenCost;
  final VoidCallback onOpenStructural;
  final Map<String, dynamic>? recentProject;
  final VoidCallback? onOpenRecentProject;

  const HomeScreen({
    super.key,
    required this.onStartNewPlan,
    required this.onOpen3D,
    required this.onOpenVastu,
    required this.onOpenCost,
    required this.onOpenStructural,
    this.recentProject,
    this.onOpenRecentProject,
  });

  @override
  Widget build(BuildContext context) {
    final tt = context.tt;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: AppSpacing.md,
        title: Image.asset(
          AppAssets.logo,
          height: 28,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Text(
            'Kanavu Illam',
            style: tt.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: false,
        actions: [
          AppIconButton(
            icon: Icons.notifications_none_rounded,
            onPressed: () {},
            tooltip: 'Notifications',
            backgroundColor: AppColors.transparent,
          ),
          const SizedBox(width: AppSpacing.xs),
          AppIconButton(
            icon: Icons.person_outline_rounded,
            onPressed: () {},
            tooltip: 'Profile',
            backgroundColor: AppColors.transparent,
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero Section - No stat line, 3-word title
              Expanded(
                flex: 5,
                child: HeroCard(
                  title: 'Plan Your Home',
                  imagePath: AppAssets.isometricPreview,
                  buttonLabel: 'Start New Plan',
                  onButtonTap: onStartNewPlan,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Tools Section - Single Card, 1-word labels, no subtitles
              Expanded(
                flex: 4,
                child: AppCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AppListRow(
                        label: '3D',
                        leadingIcon: Icons.view_in_ar_rounded,
                        showDivider: true,
                        onTap: onOpen3D,
                      ),
                      AppListRow(
                        label: 'Vastu',
                        leadingIcon: Icons.self_improvement_outlined,
                        value: '98%',
                        showDivider: true,
                        onTap: onOpenVastu,
                      ),
                      AppListRow(
                        label: 'Cost',
                        leadingIcon: Icons.calculate_outlined,
                        showDivider: true,
                        onTap: onOpenCost,
                      ),
                      AppListRow(
                        label: 'Structural',
                        leadingIcon: Icons.foundation_outlined,
                        showDivider: false,
                        onTap: onOpenStructural,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Recent Project Section - Single Row
              AppCard(
                padding: EdgeInsets.zero,
                child: AppListRow(
                  label: recentProject?['name'] ?? 'Sample Villa',
                  leadingIcon: Icons.home_work_outlined,
                  trailingWidget: const AppStatusChip(
                    label: 'Ready',
                    variant: AppBadgeVariant.success,
                  ),
                  onTap: onOpenRecentProject ?? onOpen3D,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
