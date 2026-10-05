import 'package:flutter/material.dart';
import '../theme/theme.dart';

class AppTabBar extends StatelessWidget {
  const AppTabBar({
    super.key,
    required this.tabs,
    required this.controller,
  });

  final List<String> tabs;
  final TabController controller;

  @override
  Widget build(BuildContext context) {
    final tt = context.tt;

    return TabBar(
      controller: controller,
      isScrollable: true,
      labelColor: AppColors.textPrimary,
      unselectedLabelColor: AppColors.textSecondary,
      labelStyle: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
      unselectedLabelStyle:
          tt.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
      indicatorColor: AppColors.accent,
      indicatorWeight: 2,
      dividerColor: AppColors.border,
      tabs: tabs.map((t) => Tab(text: t)).toList(),
    );
  }
}
