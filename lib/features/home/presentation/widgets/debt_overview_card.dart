import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/amount_text.dart';
import '../../../../core/widgets/app_card.dart';

class DebtOverviewCard extends StatelessWidget {
  const DebtOverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Outstanding',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    const AmountText(
                      482500,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    const _MonthlyChange(),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              const _ProgressRing(),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          Row(
            children: const [
              Expanded(
                child: _DebtMetric(
                  label: 'Paid',
                  amount: 231000,
                  icon: Icons.check_circle_rounded,
                  color: AppColors.success,
                ),
              ),
              Expanded(
                child: _DebtMetric(
                  label: 'Remaining',
                  amount: 191500,
                  icon: Icons.account_balance_wallet_rounded,
                  color: AppColors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressRing extends StatelessWidget {
  const _ProgressRing();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 66,
      height: 66,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: 0.68,
            strokeWidth: 8,
            backgroundColor: AppColors.orange,
            color: AppColors.primary,
          ),
          Center(
            child: Text(
              '68%',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthlyChange extends StatelessWidget {
  const _MonthlyChange();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(
          AppSpacing.radiusRound,
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.arrow_downward_rounded,
            size: 13,
            color: AppColors.success,
          ),
          SizedBox(width: 3),
          Text(
            '12% from last month',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}

class _DebtMetric extends StatelessWidget {
  const _DebtMetric({
    required this.label,
    required this.amount,
    required this.icon,
    required this.color,
  });

  final String label;
  final num amount;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.10),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 15,
            color: color,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            AmountText(
              amount,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
              color: AppColors.textPrimary,
            ),
          ],
        ),
      ],
    );
  }
}