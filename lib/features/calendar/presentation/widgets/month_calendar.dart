import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../domain/models/calendar_day.dart';
import '../../domain/models/calendar_payment.dart';

class MonthCalendar extends StatelessWidget {
  const MonthCalendar({
    required this.month,
    required this.days,
    required this.selectedDate,
    required this.onDateSelected,
    required this.onPreviousMonth,
    required this.onNextMonth,
    super.key,
  });

  final DateTime month;
  final List<CalendarDay> days;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  @override
  Widget build(BuildContext context) {
    final calendarDays = _buildCalendarDates(month);
    final paymentMap = _buildPaymentMap();

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        final velocity = details.primaryVelocity ?? 0;

        if (velocity < 0) {
          onNextMonth();
        } else if (velocity > 0) {
          onPreviousMonth();
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
        ),
        child: Column(
          children: [
            _WeekdayHeader(),
            const SizedBox(
              height: AppSpacing.sm,
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: calendarDays.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, index) {
                final date = calendarDays[index];
                final day = paymentMap[_dateKey(date)];

                return _CalendarCell(
                  date: date,
                  currentMonth: date.month == month.month &&
                      date.year == month.year,
                  selected: _isSameDate(
                    date,
                    selectedDate,
                  ),
                  today: _isSameDate(
                    date,
                    DateTime.now(),
                  ),
                  day: day,
                  onTap: () {
                    onDateSelected(date);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Map<String, CalendarDay> _buildPaymentMap() {
    return {
      for (final day in days)
        _dateKey(day.date): day,
    };
  }

  List<DateTime> _buildCalendarDates(DateTime month) {
    final firstDay = DateTime(
      month.year,
      month.month,
      1,
    );

    final daysInMonth = DateTime(
      month.year,
      month.month + 1,
      0,
    ).day;

    // Monday = 1 ... Sunday = 7.
    final leadingDays = firstDay.weekday - 1;

    final totalCells = ((leadingDays + daysInMonth) / 7).ceil() * 7;

    return List.generate(
      totalCells,
      (index) {
        return DateTime(
          month.year,
          month.month,
          index - leadingDays + 1,
        );
      },
    );
  }

  static String _dateKey(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  static bool _isSameDate(
    DateTime a,
    DateTime b,
  ) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }
}

class _WeekdayHeader extends StatelessWidget {
  const _WeekdayHeader();

  static const _weekdays = [
    'M',
    'T',
    'W',
    'T',
    'F',
    'S',
    'S',
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _weekdays
          .map(
            (day) => Expanded(
              child: Center(
                child: Text(
                  day,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _CalendarCell extends StatelessWidget {
  const _CalendarCell({
    required this.date,
    required this.currentMonth,
    required this.selected,
    required this.today,
    required this.day,
    required this.onTap,
  });

  final DateTime date;
  final bool currentMonth;
  final bool selected;
  final bool today;
  final CalendarDay? day;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final indicatorColor = _indicatorColor();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(
                milliseconds: 180,
              ),
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primary
                    : today
                        ? AppColors.primaryLight
                        : Colors.transparent,
                shape: BoxShape.circle,
                border: today && !selected
                    ? Border.all(
                        color: AppColors.primary,
                        width: 1,
                      )
                    : null,
              ),
              child: Center(
                child: Text(
                  '${date.day}',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(
                        color: selected
                            ? AppColors.white
                            : currentMonth
                                ? AppColors.textPrimary
                                : AppColors.textMuted,
                        fontWeight: selected || today
                            ? FontWeight.w800
                            : FontWeight.w600,
                      ),
                ),
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            SizedBox(
              height: 8,
              child: indicatorColor == null
                  ? null
                  : Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: indicatorColor,
                        shape: BoxShape.circle,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Color? _indicatorColor() {
    if (day == null || !day!.hasPayments) {
      return null;
    }

    // Multiple payments gets the orange indicator.
    if (day!.hasMultiplePayments) {
      return AppColors.orange;
    }

    final payment = day!.payments.first;

    final status = payment.status(
      DateTime.now(),
    );

    switch (status) {
      case CalendarPaymentStatus.paid:
        return AppColors.success;

      case CalendarPaymentStatus.upcoming:
        return AppColors.blue;

      case CalendarPaymentStatus.overdue:
        return AppColors.error;
    }
  }
}