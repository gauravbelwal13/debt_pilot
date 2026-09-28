import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';

class ExtraPaymentCalculator extends StatelessWidget {
  const ExtraPaymentCalculator({
    required this.extraPayment,
    required this.onChanged,
    required this.currentMonthlyPayment,
    required this.baseDays,
    required this.projectedDays,
    required this.projectedDate,
    super.key,
  });

  final double extraPayment;
  final ValueChanged<double> onChanged;

  final double currentMonthlyPayment;

  final int baseDays;
  final int projectedDays;
  final DateTime projectedDate;

  String _amount(double value) {
    return '₹${value.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final savedDays =
        baseDays - projectedDays;

    return Container(
      width: double.infinity,
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
          Text(
            'Debt-Free Accelerator',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(
                  fontWeight:
                      FontWeight.w800,
                ),
          ),
          const SizedBox(
            height: AppSpacing.xs,
          ),
          Text(
            'See how an extra monthly payment '
            'could change your projected payoff date.',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(
                  color:
                      AppColors.textSecondary,
                ),
          ),
          const SizedBox(
            height: AppSpacing.xl,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Extra every month',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                        fontWeight:
                            FontWeight.w700,
                      ),
                ),
              ),
              Text(
                _amount(extraPayment),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                      color:
                          AppColors.primary,
                      fontWeight:
                          FontWeight.w800,
                    ),
              ),
            ],
          ),
          Slider(
            min: 0,
            max: 20000,
            divisions: 20,
            value: extraPayment,
            activeColor:
                AppColors.primary,
            inactiveColor:
                AppColors.primaryLight,
            label: _amount(extraPayment),
            onChanged: onChanged,
          ),
          const SizedBox(
            height: AppSpacing.sm,
          ),
          Container(
            padding: const EdgeInsets.all(
              AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius:
                  BorderRadius.circular(
                AppSpacing.radiusMd,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.auto_graph_rounded,
                  color:
                      AppColors.primaryDark,
                ),
                const SizedBox(
                  width: AppSpacing.sm,
                ),
                Expanded(
                  child: Text(
                    savedDays > 0
                        ? 'You could finish about '
                            '$savedDays days earlier.'
                        : 'Your current payment pace '
                            'is used for the projection.',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                          color:
                              AppColors.primaryDark,
                          fontWeight:
                              FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: AppSpacing.lg,
          ),
          Row(
            children: [
              Expanded(
                child: _ProjectionMetric(
                  label: 'Current',
                  value:
                      '$baseDays days',
                ),
              ),
              Expanded(
                child: _ProjectionMetric(
                  label: 'New estimate',
                  value:
                      '$projectedDays days',
                ),
              ),
              Expanded(
                child: _ProjectionMetric(
                  label: 'New date',
                  value: DateFormat(
                    'dd MMM',
                  ).format(projectedDate),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: AppSpacing.md,
          ),
          Text(
            'Current monthly payment: '
            '${_amount(currentMonthlyPayment)}',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(
                  color:
                      AppColors.textMuted,
                ),
          ),
        ],
      ),
    );
  }
}

class _ProjectionMetric extends StatelessWidget {
  const _ProjectionMetric({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(
                color:
                    AppColors.textMuted,
              ),
        ),
        const SizedBox(
          height: 3,
        ),
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(
                fontWeight:
                    FontWeight.w800,
              ),
        ),
      ],
    );
  }
}