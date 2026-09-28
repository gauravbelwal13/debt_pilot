import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../models/add_debt_draft.dart';

class DebtTypeGrid extends StatelessWidget {
  const DebtTypeGrid({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final DebtType selected;
  final ValueChanged<DebtType> onSelected;

  static const _options = [
    (
      type: DebtType.personalLoan,
      label: 'Personal Loan',
      icon: Icons.account_balance_rounded,
    ),
    (
      type: DebtType.creditCard,
      label: 'Credit Card',
      icon: Icons.credit_card_rounded,
    ),
    (
      type: DebtType.vehicleLoan,
      label: 'Vehicle Loan',
      icon: Icons.directions_car_rounded,
    ),
    (
      type: DebtType.educationLoan,
      label: 'Education Loan',
      icon: Icons.school_rounded,
    ),
    (
      type: DebtType.friendFamily,
      label: 'Friend / Family',
      icon: Icons.people_alt_rounded,
    ),
    (
      type: DebtType.other,
      label: 'Other',
      icon: Icons.more_horiz_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: _options.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.sm,
        childAspectRatio: 1.2,
      ),
      itemBuilder: (context, index) {
        final option = _options[index];
        final isSelected = selected == option.type;

        return GestureDetector(
          onTap: () => onSelected(option.type),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryLight
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(
                AppSpacing.radiusMd,
              ),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.border,
                width: isSelected ? 1.4 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  option.icon,
                  size: 22,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
                const SizedBox(height: 6),
                Text(
                  option.label,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontSize: 10,
                        fontWeight: isSelected
                            ? FontWeight.w800
                            : FontWeight.w600,
                        color: isSelected
                            ? AppColors.primaryDark
                            : AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}