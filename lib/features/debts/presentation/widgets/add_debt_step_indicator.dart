import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';

class AddDebtStepIndicator extends StatelessWidget {
  const AddDebtStepIndicator({
    required this.currentStep,
    super.key,
  });

  final int currentStep;

  static const _steps = [
    'Details',
    'Payments',
    'Review',
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        _steps.length * 2 - 1,
        (index) {
          if (index.isOdd) {
            final stepBefore = index ~/ 2;

            return Expanded(
              child: Container(
                height: 2,
                color: stepBefore < currentStep
                    ? AppColors.primary
                    : AppColors.border,
              ),
            );
          }

          final step = index ~/ 2;
          final active = step <= currentStep;

          return _StepItem(
            number: step + 1,
            label: _steps[step],
            active: active,
            current: step == currentStep,
          );
        },
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  const _StepItem({
    required this.number,
    required this.label,
    required this.active,
    required this.current,
  });

  final int number;
  final String label;
  final bool active;
  final bool current;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: current ? 32 : 28,
          height: current ? 32 : 28,
          decoration: BoxDecoration(
            color: active
                ? AppColors.primary
                : const Color(0xFFD4D5F5),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$number',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: active
                    ? AppColors.primary
                    : AppColors.textMuted,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              ),
        ),
      ],
    );
  }
}