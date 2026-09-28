import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';

class InsightsOverviewCard extends StatelessWidget {
  const InsightsOverviewCard({
    required this.totalOutstanding,
    required this.totalPaid,
    required this.monthlyPayment,
    required this.upcoming,
    super.key,
  });

  final double totalOutstanding;
  final double totalPaid;
  final double monthlyPayment;
  final double upcoming;

  String _amount(double value) {
    return '₹${value.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                label: 'Outstanding',
                value: _amount(totalOutstanding),
                icon: Icons.account_balance_wallet_rounded,
                iconColor: AppColors.primary,
              ),
            ),
            const SizedBox(
              width: AppSpacing.md,
            ),
            Expanded(
              child: _MetricCard(
                label: 'Paid',
                value: _amount(totalPaid),
                icon: Icons.check_circle_rounded,
                iconColor: AppColors.success,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: AppSpacing.md,
        ),
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                label: 'Monthly',
                value: _amount(monthlyPayment),
                icon: Icons.calendar_month_rounded,
                iconColor: AppColors.blue,
              ),
            ),
            const SizedBox(
              width: AppSpacing.md,
            ),
            Expanded(
              child: _MetricCard(
                label: 'Upcoming',
                value: _amount(upcoming),
                icon: Icons.schedule_rounded,
                iconColor: AppColors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(
          color: AppColors.border,
        ),
        borderRadius: BorderRadius.circular(
          AppSpacing.radiusLg,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconColor.withValues(
                alpha: 0.10,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 19,
            ),
          ),
          const SizedBox(
            height: AppSpacing.md,
          ),
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(
            height: AppSpacing.xs,
          ),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}