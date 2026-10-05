import 'package:flutter/material.dart';
import '../theme/theme.dart';
import '../widgets/widgets.dart';

class StructuralScreen extends StatefulWidget {
  final Map<String, dynamic> projectData;
  const StructuralScreen({super.key, required this.projectData});

  @override
  State<StructuralScreen> createState() => _StructuralScreenState();
}

class _StructuralScreenState extends State<StructuralScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Expanded(
              flex: 5,
              child: HeroCard(
                title: 'Safe',
                subtitle: 'Structural Load',
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            AppTabBar(
              controller: _tabController,
              tabs: const ['Beams', 'Columns'],
            ),
            const SizedBox(height: AppSpacing.xs),
            Expanded(
              flex: 4,
              child: TabBarView(
                controller: _tabController,
                children: [
                  AppCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        AppListRow(
                          label: 'PB1 (9"x15")',
                          value: '2-12Ø',
                          leadingIcon: Icons.line_weight_rounded,
                          trailingWidget: AppStatusChip(
                              label: 'Safe', variant: AppBadgeVariant.success),
                          showDivider: true,
                        ),
                        AppListRow(
                          label: 'PB2 (9"x18")',
                          value: '3-16Ø',
                          leadingIcon: Icons.line_weight_rounded,
                          trailingWidget: AppStatusChip(
                              label: 'Safe', variant: AppBadgeVariant.success),
                          showDivider: false,
                        ),
                      ],
                    ),
                  ),
                  AppCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        AppListRow(
                          label: 'C1 (9"x15")',
                          value: '6-16Ø',
                          leadingIcon: Icons.view_column_rounded,
                          trailingWidget: AppStatusChip(
                              label: 'Safe', variant: AppBadgeVariant.success),
                          showDivider: true,
                        ),
                        AppListRow(
                          label: 'C2 (9"x18")',
                          value: '8-16Ø',
                          leadingIcon: Icons.view_column_rounded,
                          trailingWidget: AppStatusChip(
                              label: 'Safe', variant: AppBadgeVariant.success),
                          showDivider: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
