import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../domain/models/calendar_day.dart';
import 'calendar_payment_row.dart';

class AgendaView extends StatelessWidget {
  const AgendaView({
    required this.month,
    required this.days,
    required this.onPaymentTap,
    super.key,
  });

  final DateTime month;
  final List<CalendarDay> days;
  final ValueChanged<String> onPaymentTap;

  @override
  Widget build(BuildContext context) {
    final paymentDays = days
        .where((day) => day.hasPayments)
        .toList()
      ..sort(
        (a, b) => a.date.compareTo(b.date),
      );

    if (paymentDays.isEmpty) {
      return const _EmptyAgenda();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat('MMMM yyyy').format(month),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),

        const SizedBox(
          height: AppSpacing.lg,
        ),

        ...paymentDays.map(
          (day) => _AgendaDaySection(
            day: day,
            onPaymentTap: onPaymentTap,
          ),
        ),
      ],
    );
  }
}

class _AgendaDaySection extends StatelessWidget {
  const _AgendaDaySection({
    required this.day,
    required this.onPaymentTap,
  });

  final CalendarDay day;
  final ValueChanged<String> onPaymentTap;

  String _weekday(DateTime date) {
    return DateFormat('EEEE').format(date);
  }

  String _date(DateTime date) {
    return DateFormat('dd MMM').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppSpacing.xxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(
                    AppSpacing.radiusMd,
                  ),
                ),
                child: Text(
                  '${day.date.day}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),

              const SizedBox(
                width: AppSpacing.md,
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _weekday(day.date),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    _date(day.date),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),

              const Spacer(),

              Text(
                '₹${day.totalAmount.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ],
          ),

          const SizedBox(
            height: AppSpacing.sm,
          ),

          ...day.payments.map(
            (payment) => Padding(
              padding: const EdgeInsets.only(
                bottom: AppSpacing.sm,
              ),
              child: CalendarPaymentRow(
                payment: payment,
                onTap: () => onPaymentTap(payment.id),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyAgenda extends StatelessWidget {
  const _EmptyAgenda();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(
        AppSpacing.xxl,
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
        children: [
          const Icon(
            Icons.event_available_rounded,
            size: 42,
            color: AppColors.success,
          ),

          const SizedBox(
            height: AppSpacing.md,
          ),

          Text(
            'No Payments Scheduled',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),

          const SizedBox(
            height: AppSpacing.xs,
          ),

          Text(
            'There are no debt payments scheduled for this month.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}