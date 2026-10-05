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
        title: Text(
          'Kanavu Illam',
          style: tt.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          AppIconButton(
            icon: Icons.notifications_none_rounded,
            onPressed: () {},
            tooltip: 'Notifications',
            backgroundColor: AppColors.transparent,
          ),
          const SizedBox(width: AppSpacing.sm),
          AppIconButton(
            icon: Icons.person_outline_rounded,
            onPressed: () {},
            tooltip: 'Profile',
            backgroundColor: AppColors.transparent,
          ),
          const SizedBox(width: AppSpacing.md),
        ],
      ),
      body: ResponsiveBuilder(
        builder: (context, breakpoint, constraints) {
          final isExpanded = breakpoint.isExpanded;

          final heroWidget = HeroCard(
            title: 'Your Dream Home, Ready to Plan',
            imagePath: AppAssets.isometricPreview,
            buttonLabel: 'Start New Plan',
            onButtonTap: onStartNewPlan,
            statLine: const AppStatLine(
              statText: '12.4k+ plans generated',
            ),
          );

          final toolsAndRecentWidget = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Tools',
                style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: AppSpacing.md),
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    AppListRow(
                      label: '3D Walkthrough',
                      subtitle: 'Interactive models & renders',
                      leadingIcon: Icons.view_in_ar_rounded,
                      showDivider: true,
                      onTap: onOpen3D,
                    ),
                    AppListRow(
                      label: 'Vastu Score',
                      subtitle: 'Compliance analysis',
                      leadingIcon: Icons.self_improvement_outlined,
                      value: '98.4%',
                      showDivider: true,
                      onTap: onOpenVastu,
                    ),
                    AppListRow(
                      label: 'Cost Estimator',
                      subtitle: 'Material & labor BOQ',
                      leadingIcon: Icons.calculate_outlined,
                      showDivider: true,
                      onTap: onOpenCost,
                    ),
                    AppListRow(
                      label: 'Structural Load',
                      subtitle: 'Safety & analysis reports',
                      leadingIcon: Icons.foundation_outlined,
                      showDivider: false,
                      onTap: onOpenStructural,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Recent Project',
                style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: AppSpacing.md),
              if (recentProject != null)
                AppCard(
                  padding: EdgeInsets.zero,
                  child: AppListRow(
                    label: recentProject!['name'] ?? 'Untitled Project',
                    subtitle: 'Last updated today',
                    leadingIcon: Icons.home_work_outlined,
                    trailingWidget: const AppStatusChip(
                      label: 'Ready',
                      variant: AppBadgeVariant.success,
                    ),
                    onTap: onOpenRecentProject,
                  ),
                )
              else
                const AppEmptyState(
                  icon: Icons.history,
                  title: 'No recent projects',
                  message: 'Start a new plan to see it here.',
                ),
            ],
          );

          return SingleChildScrollView(
            child: CenteredConstrainedBody(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (isExpanded)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: heroWidget),
                        const SizedBox(width: AppSpacing.xl),
                        Expanded(child: toolsAndRecentWidget),
                      ],
                    )
                  else ...[
                    heroWidget,
                    const SizedBox(height: AppSpacing.xl),
                    toolsAndRecentWidget,
                  ],
                  const SizedBox(height: 100), // Space for bottom nav padding
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
