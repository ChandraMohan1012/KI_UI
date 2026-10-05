import 'package:flutter/material.dart';
import '../theme/theme.dart';

class AppStatLine extends StatelessWidget {
  const AppStatLine({
    super.key,
    required this.statText,
    this.avatarUrls,
  });

  final String statText;
  final List<String>? avatarUrls;

  @override
  Widget build(BuildContext context) {
    final tt = context.tt;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (avatarUrls != null && avatarUrls!.isNotEmpty) ...[
          SizedBox(
            width:
                (24.0 * avatarUrls!.length) - ((avatarUrls!.length - 1) * 8.0),
            height: 24,
            child: Stack(
              children: List.generate(avatarUrls!.length, (index) {
                return Positioned(
                  left: index * 16.0,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.surface, width: 2),
                      image: DecorationImage(
                        image: NetworkImage(avatarUrls![index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
        Text(
          statText,
          style: tt.bodySmall?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
