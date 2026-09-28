import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    required this.onMenuTap,
    required this.userName,
    super.key,
  });

  final VoidCallback onMenuTap;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onMenuTap,
          icon: const Icon(
            Icons.menu_rounded,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(
            minWidth: 40,
            minHeight: 40,
          ),
          tooltip: 'Open menu',
        ),

        const SizedBox(
          width: AppSpacing.sm,
        ),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'Good evening, $userName 👋',
                style: AppTextStyles
                    .textTheme
                    .titleLarge
                    ?.copyWith(
                      fontSize: 18,
                    ),
              ),
              const SizedBox(
                height: 2,
              ),
              Text(
                'Tue, 24 Sep 2026',
                style: AppTextStyles
                    .textTheme
                    .bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}