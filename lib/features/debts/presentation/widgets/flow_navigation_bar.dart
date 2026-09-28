import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';

class FlowNavigationBar extends StatelessWidget {
  const FlowNavigationBar({
    required this.onBack,
    required this.onNext,
    required this.isFirstStep,
    required this.isLastStep,
    super.key,
  });

  final VoidCallback onBack;
  final VoidCallback onNext;
  final bool isFirstStep;
  final bool isLastStep;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: Row(
          children: [
            Expanded(
              child: FilledButton(
                onPressed: onBack,
                style: FilledButton.styleFrom(
                  backgroundColor:
                      AppColors.surfaceSoft,
                  foregroundColor:
                      AppColors.textPrimary,
                  elevation: 0,
                ),
                child: const Text('Back'),
              ),
            ),
            const SizedBox(
              width: AppSpacing.md,
            ),
            Expanded(
              flex: 2,
              child: AppButton(
                label: 'Next Step',
                icon: Icons.arrow_forward_rounded,
                onPressed: onNext,
              ),
            ),
          ],
        ),
      ),
    );
  }
}