import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../domain/models/calendar_day.dart';
import '../../domain/models/calendar_payment.dart';

class WeekCalendar extends StatelessWidget {
  const WeekCalendar({
    required this.weekStart,
    required this.days,
    required this.onPreviousWeek,
    required this.onNextWeek,
    required this.onDateSelected,
    super.key,
  });

  final DateTime weekStart;
  final List<CalendarDay> days;
  final VoidCallback onPreviousWeek;
  final VoidCallback onNextWeek;
  final ValueChanged<DateTime> onDateSelected;

  double get _totalScheduled {
    return days.fold(
      0,
      (total, day) => total + day.totalAmount,
    );
  }

  double get _paidAmount {
    return days.fold(
      0,
      (total, day) => total + day.paidAmount,
    );
  }

  double get _remainingAmount {
    return _totalScheduled - _paidAmount;
  }

  String _formatAmount(double amount) {
    return '₹${amount.toStringAsFixed(0)}';
  }

  String _weekdayLabel(DateTime date) {
    const labels = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return labels[date.weekday - 1];
  }

  String _shortDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${date.day} ${months[date.month - 1]}';
  }

  CalendarPaymentStatus? _primaryStatus(
    CalendarDay day,
  ) {
    if (!day.hasPayments) {
      return null;
    }

    if (day.isAllPaid) {
      return CalendarPaymentStatus.paid;
    }

    final hasOverdue = day.payments.any(
      (payment) =>
          payment.status(DateTime.now()) ==
          CalendarPaymentStatus.overdue,
    );

    if (hasOverdue) {
      return CalendarPaymentStatus.overdue;
    }

    return CalendarPaymentStatus.upcoming;
  }

  Color _statusColor(
    CalendarPaymentStatus? status,
  ) {
    switch (status) {
      case CalendarPaymentStatus.paid:
        return AppColors.success;

      case CalendarPaymentStatus.overdue:
        return AppColors.error;

      case CalendarPaymentStatus.upcoming:
        return AppColors.blue;

      case null:
        return AppColors.textMuted;
    }
  }

  String _statusLabel(
    CalendarDay day,
  ) {
    if (!day.hasPayments) {
      return 'No payments';
    }

    if (day.hasMultiplePayments) {
      return '${day.paymentCount} payments';
    }

    final status = _primaryStatus(day);

    switch (status) {
      case CalendarPaymentStatus.paid:
        return 'Paid';

      case CalendarPaymentStatus.overdue:
        return 'Overdue';

      case CalendarPaymentStatus.upcoming:
        return 'Upcoming';

      case null:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final weekEnd = weekStart.add(
      const Duration(days: 6),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _WeekHeader(
          weekStart: weekStart,
          weekEnd: weekEnd,
          onPreviousWeek: onPreviousWeek,
          onNextWeek: onNextWeek,
        ),

        const SizedBox(
          height: AppSpacing.lg,
        ),

        _WeeklyMoneySummary(
          totalScheduled: _totalScheduled,
          paidAmount: _paidAmount,
          remainingAmount: _remainingAmount,
          formatAmount: _formatAmount,
        ),

        const SizedBox(
          height: AppSpacing.xxl,
        ),

        Text(
          'Daily Breakdown',
          style: Theme.of(context).textTheme.titleMedium,
        ),

        const SizedBox(
          height: AppSpacing.md,
        ),

        ...days.map(
          (day) {
            final status = _primaryStatus(day);

            return Padding(
              padding: const EdgeInsets.only(
                bottom: AppSpacing.sm,
              ),
              child: _WeekDayRow(
                day: day,
                weekdayLabel: _weekdayLabel(day.date),
                dateLabel: _shortDate(day.date),
                amountLabel: _formatAmount(day.totalAmount),
                statusLabel: _statusLabel(day),
                statusColor: _statusColor(status),
                onTap: () => onDateSelected(day.date),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _WeekHeader extends StatelessWidget {
  const _WeekHeader({
    required this.weekStart,
    required this.weekEnd,
    required this.onPreviousWeek,
    required this.onNextWeek,
  });

  final DateTime weekStart;
  final DateTime weekEnd;
  final VoidCallback onPreviousWeek;
  final VoidCallback onNextWeek;

  String _formatRange() {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    if (weekStart.month == weekEnd.month) {
      return '${weekStart.day} - ${weekEnd.day} '
          '${months[weekStart.month - 1]} ${weekStart.year}';
    }

    return '${weekStart.day} ${months[weekStart.month - 1]}'
        ' - '
        '${weekEnd.day} ${months[weekEnd.month - 1]} '
        '${weekEnd.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _WeekArrow(
          icon: Icons.chevron_left_rounded,
          onPressed: onPreviousWeek,
        ),

        Expanded(
          child: Center(
            child: Text(
              _formatRange(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ),

        _WeekArrow(
          icon: Icons.chevron_right_rounded,
          onPressed: onNextWeek,
        ),
      ],
    );
  }
}

class _WeekArrow extends StatelessWidget {
  const _WeekArrow({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(
        AppSpacing.radiusRound,
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(
          AppSpacing.radiusRound,
        ),
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(
            icon,
            color: AppColors.textPrimary,
            size: 22,
          ),
        ),
      ),
    );
  }
}

class _WeeklyMoneySummary extends StatelessWidget {
  const _WeeklyMoneySummary({
    required this.totalScheduled,
    required this.paidAmount,
    required this.remainingAmount,
    required this.formatAmount,
  });

  final double totalScheduled;
  final double paidAmount;
  final double remainingAmount;
  final String Function(double amount) formatAmount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(
        AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(
          AppSpacing.radiusLg,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Money Needed This Week',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
          ),

          const SizedBox(
            height: AppSpacing.xs,
          ),

          Text(
            formatAmount(remainingAmount),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w800,
                ),
          ),

          const SizedBox(
            height: AppSpacing.lg,
          ),

          Row(
            children: [
              Expanded(
                child: _MoneyMetric(
                  label: 'Scheduled',
                  value: formatAmount(totalScheduled),
                ),
              ),
              Expanded(
                child: _MoneyMetric(
                  label: 'Paid',
                  value: formatAmount(paidAmount),
                ),
              ),
              Expanded(
                child: _MoneyMetric(
                  label: 'Remaining',
                  value: formatAmount(remainingAmount),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MoneyMetric extends StatelessWidget {
  const _MoneyMetric({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.white.withValues(
                  alpha: 0.75,
                ),
              ),
        ),
        const SizedBox(
          height: 2,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}

class _WeekDayRow extends StatelessWidget {
  const _WeekDayRow({
    required this.day,
    required this.weekdayLabel,
    required this.dateLabel,
    required this.amountLabel,
    required this.statusLabel,
    required this.statusColor,
    required this.onTap,
  });

  final CalendarDay day;
  final String weekdayLabel;
  final String dateLabel;
  final String amountLabel;
  final String statusLabel;
  final Color statusColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasPayments = day.hasPayments;

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(
        AppSpacing.radiusMd,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          AppSpacing.radiusMd,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.border,
            ),
            borderRadius: BorderRadius.circular(
              AppSpacing.radiusMd,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: hasPayments
                      ? statusColor.withValues(alpha: 0.10)
                      : AppColors.surfaceSoft,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${day.date.day}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: hasPayments
                            ? statusColor
                            : AppColors.textMuted,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),

              const SizedBox(
                width: AppSpacing.md,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weekdayLabel,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      dateLabel,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    amountLabel,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    statusLabel,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),

              const SizedBox(
                width: AppSpacing.sm,
              ),

              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}