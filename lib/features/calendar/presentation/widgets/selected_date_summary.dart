import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/amount_text.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/models/calendar_day.dart';
import 'calendar_payment_row.dart';

class SelectedDateSummary extends StatelessWidget {
  const SelectedDateSummary({
    required this.day,
    required this.onPaymentTap,
    super.key,
  });

  final CalendarDay? day;
  final ValueChanged<String> onPaymentTap;

  @override
  Widget build(BuildContext context) {
    if (day == null || !day!.hasPayments) {
      return AppCard(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              'No payments',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium,
            ),
            const SizedBox(
              height: AppSpacing.xs,
            ),
            Text(
              'There are no scheduled payments on this date.',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall,
            ),
          ],
        ),
      );
    }

    final selectedDay = day!;

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                DateFormatter.short(
                  selectedDay.date,
                ),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium,
              ),
              const SizedBox(
                height: AppSpacing.xs,
              ),
              Text(
                _weekdayName(
                  selectedDay.date,
                ),
                style: Theme.of(context)
                    .textTheme
                    .bodySmall,
              ),
              const SizedBox(
                height: AppSpacing.lg,
              ),
              Row(
                children: [
                  Expanded(
                    child: _SummaryMetric(
                      label: 'Scheduled',
                      amount: selectedDay.totalAmount,
                      color: AppColors.primary,
                    ),
                  ),
                  Expanded(
                    child: _SummaryMetric(
                      label: 'Paid',
                      amount: selectedDay.paidAmount,
                      color: AppColors.success,
                    ),
                  ),
                  Expanded(
                    child: _SummaryMetric(
                      label: 'Remaining',
                      amount: selectedDay.unpaidAmount,
                      color: AppColors.blue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: AppSpacing.md,
        ),
        ...selectedDay.payments.map(
          (payment) => Padding(
            padding: const EdgeInsets.only(
              bottom: AppSpacing.sm,
            ),
            child: CalendarPaymentRow(
              payment: payment,
              onTap: () {
                onPaymentTap(payment.id);
              },
            ),
          ),
        ),
      ],
    );
  }

  String _weekdayName(DateTime date) {
    const names = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return names[date.weekday - 1];
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.amount,
    required this.color,
  });

  final String label;
  final double amount;
  final Color color;

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
              .bodySmall,
        ),
        const SizedBox(height: 3),
        AmountText(
          amount,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
          color: color,
        ),
      ],
    );
  }
}