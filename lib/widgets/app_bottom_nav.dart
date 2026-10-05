import 'package:flutter/material.dart';
import '../theme/theme.dart';

class AppBottomNavItem {
  final IconData icon;
  final String label;

  const AppBottomNavItem({required this.icon, required this.label});
}

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<AppBottomNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: AppSpacing.lg,
        left: AppSpacing.lg,
        right: AppSpacing.lg,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xs,
        horizontal: AppSpacing.md,
      ),
      decoration: const BoxDecoration(
        color: AppColors.textPrimary,
        borderRadius: AppRadius.fullBorder,
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final isSelected = currentIndex == index;
          final item = items[index];

          return Semantics(
            button: true,
            selected: isSelected,
            label: item.label,
            child: Tooltip(
              message: item.label,
              child: InkWell(
                onTap: () => onTap(index),
                borderRadius: AppRadius.fullBorder,
                child: SizedBox(
                  width: 56,
                  height: 48,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        item.icon,
                        color: isSelected
                            ? AppColors.white
                            : AppColors.textSecondary,
                        size: 24,
                      ),
                      if (isSelected)
                        Positioned(
                          bottom: 6,
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              color: AppColors.accent,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
