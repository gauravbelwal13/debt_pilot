import 'package:intl/intl.dart';

abstract final class DateFormatter {
  static final _short = DateFormat('dd MMM yyyy');
  static final _month = DateFormat('MMMM yyyy');
  static final _dayMonth = DateFormat('dd MMM');

  static String short(DateTime date) => _short.format(date);

  static String month(DateTime date) => _month.format(date);

  static String dayMonth(DateTime date) => _dayMonth.format(date);
}
