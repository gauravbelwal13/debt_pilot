import 'dart:math';

abstract final class DateCalculator {
  static DateTime addMonthsClamped(
    DateTime date,
    int months,
  ) {
    final totalMonths =
        date.year * 12 + (date.month - 1) + months;

    final year = totalMonths ~/ 12;
    final month = (totalMonths % 12) + 1;

    final lastDayOfMonth = DateTime(
      year,
      month + 1,
      0,
    ).day;

    return DateTime(
      year,
      month,
      min(date.day, lastDayOfMonth),
    );
  }

  static int monthsInclusive(
    DateTime start,
    DateTime end,
  ) {
    if (end.isBefore(start)) {
      return 0;
    }

    return ((end.year - start.year) * 12) +
        end.month -
        start.month +
        1;
  }

  static List<DateTime> monthlyDates({
    required DateTime start,
    required DateTime end,
  }) {
    if (end.isBefore(start)) {
      return const [];
    }

    final months = monthsInclusive(start, end);

    return List.generate(
      months,
      (index) => addMonthsClamped(start, index),
    ).where(
      (date) => !date.isAfter(end),
    ).toList();
  }
}