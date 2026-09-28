import 'package:debt_pilot/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../domain/models/calendar_day.dart';
import '../../domain/models/calendar_payment.dart';
import '../widgets/agenda_view.dart';
import '../widgets/calendar_header.dart';
import '../widgets/calendar_legend.dart';
import '../widgets/calendar_view_switcher.dart';
import '../widgets/month_calendar.dart';
import '../widgets/selected_date_summary.dart';
import '../widgets/week_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({
    super.key,
  });

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _displayedMonth;
  late DateTime _selectedDate;

  CalendarViewMode _viewMode =
      CalendarViewMode.month;

  late List<CalendarDay> _days;

  @override
  void initState() {
    super.initState();

    final today = DateTime.now();

    _displayedMonth = DateTime(
      today.year,
      today.month,
    );

    _selectedDate = DateTime(
      today.year,
      today.month,
      today.day,
    );

    _days = _buildMockDays(
      _displayedMonth,
    );
  }

  void _changeMonth(int offset) {
    final nextMonth = DateTime(
      _displayedMonth.year,
      _displayedMonth.month + offset,
    );

    setState(() {
      _displayedMonth = nextMonth;

      _days = _buildMockDays(
        nextMonth,
      );

      _selectedDate = DateTime(
        nextMonth.year,
        nextMonth.month,
        1,
      );
    });
  }

  void _changeWeek(int offset) {
    final nextDate = _selectedDate.add(
      Duration(days: offset * 7),
    );

    setState(() {
      _selectedDate = _dateOnly(nextDate);

      _displayedMonth = DateTime(
        nextDate.year,
        nextDate.month,
      );

      _days = _buildMockDays(
        _displayedMonth,
      );
    });
  }

  DateTime get _weekStart {
    final date = _dateOnly(_selectedDate);

    return date.subtract(
      Duration(
        days: date.weekday - 1,
      ),
    );
  }

  List<CalendarDay> get _selectedWeekDays {
    final start = _weekStart;

    return List.generate(
      7,
      (index) {
        final date = start.add(
          Duration(days: index),
        );

        return _findDay(date);
      },
    );
  }

  CalendarDay _findDay(DateTime date) {
    final month = DateTime(
      date.year,
      date.month,
    );

    final monthDays = _buildMockDays(
      month,
    );

    for (final day in monthDays) {
      if (_sameDate(
        day.date,
        date,
      )) {
        return day;
      }
    }

    return CalendarDay(
      date: date,
      payments: const [],
    );
  }

  void _selectDate(DateTime date) {
    final normalizedDate = _dateOnly(date);

    if (date.month != _displayedMonth.month ||
        date.year != _displayedMonth.year) {
      final newMonth = DateTime(
        date.year,
        date.month,
      );

      setState(() {
        _displayedMonth = newMonth;

        _days = _buildMockDays(
          newMonth,
        );

        _selectedDate = normalizedDate;
      });

      return;
    }

    setState(() {
      _selectedDate = normalizedDate;
    });
  }

  CalendarDay? get _selectedDay {
    for (final day in _days) {
      if (_sameDate(
        day.date,
        _selectedDate,
      )) {
        return day;
      }
    }

    return null;
  }

  void _onNavigationSelected(int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;

      case 1:
        return;

      case 2:
        context.go('/debts');
        break;

      case 3:
        context.go('/insights');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            top: AppSpacing.sm,
            bottom: AppSpacing.huge,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              if (_viewMode != CalendarViewMode.week)
                CalendarHeader(
                  month: _displayedMonth,
                  onPreviousMonth: () {
                    _changeMonth(-1);
                  },
                  onNextMonth: () {
                    _changeMonth(1);
                  },
                ),

              if (_viewMode != CalendarViewMode.week)
                const SizedBox(
                  height: AppSpacing.md,
                ),

              Padding(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                ),
                child: CalendarViewSwitcher(
                  selectedView: _viewMode,
                  onChanged: (view) {
                    setState(() {
                      _viewMode = view;
                    });
                  },
                ),
              ),

              const SizedBox(
                height: AppSpacing.lg,
              ),

              _buildCurrentView(),
            ],
          ),
        ),
      ),
      floatingActionButton:
          FloatingActionButton(
        onPressed: () {
          context.push('/add-debt');
        },
        backgroundColor:
            const Color(0xFF008F7A),
        foregroundColor: Colors.white,
        elevation: 4,
        child: const Icon(
          Icons.add_rounded,
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar:
          HomeBottomNavBar(
        selectedIndex: 1,
        onSelected:
            _onNavigationSelected,
      ),
    );
  }

  Widget _buildCurrentView() {
    switch (_viewMode) {
      case CalendarViewMode.month:
        return _buildMonthView();

      case CalendarViewMode.week:
        return _buildWeekView();

      case CalendarViewMode.agenda:
        return _buildAgendaView();
    }
  }

  Widget _buildMonthView() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        MonthCalendar(
          month: _displayedMonth,
          days: _days,
          selectedDate: _selectedDate,
          onDateSelected: _selectDate,
          onPreviousMonth: () {
            _changeMonth(-1);
          },
          onNextMonth: () {
            _changeMonth(1);
          },
        ),

        const SizedBox(
          height: AppSpacing.lg,
        ),

        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
          ),
          child: CalendarLegend(),
        ),

        const SizedBox(
          height: AppSpacing.xxl,
        ),

        Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
          ),
          child: SelectedDateSummary(
            day: _selectedDay,
            onPaymentTap:
                _onPaymentTap,
          ),
        ),
      ],
    );
  }

  Widget _buildWeekView() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
      ),
      child: WeekCalendar(
        weekStart: _weekStart,
        days: _selectedWeekDays,
        onPreviousWeek: () {
          _changeWeek(-1);
        },
        onNextWeek: () {
          _changeWeek(1);
        },
        onDateSelected:
            _selectDate,
      ),
    );
  }

  Widget _buildAgendaView() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
      ),
      child: AgendaView(
        month: _displayedMonth,
        days: _days,
        onPaymentTap:
            _onPaymentTap,
      ),
    );
  }

  void _onPaymentTap(
    String paymentId,
  ) {
    // Future:
    // Navigate to Debt Detail.
  }

  List<CalendarDay> _buildMockDays(
    DateTime month,
  ) {
    return [
      _createDay(
        month,
        3,
        [
          CalendarPayment(
            id:
                '${month.year}-${month.month}-3-1',
            debtId: 'debt-icici',
            debtName:
                'ICICI Credit Card',
            lender: 'ICICI Bank',
            dueDate: DateTime(
              month.year,
              month.month,
              3,
            ),
            amount: 8500,
            isPaid: false,
          ),
        ],
      ),
      _createDay(
        month,
        8,
        [
          CalendarPayment(
            id:
                '${month.year}-${month.month}-8-1',
            debtId: 'debt-hdfc',
            debtName:
                'HDFC Personal Loan',
            lender: 'HDFC Bank',
            dueDate: DateTime(
              month.year,
              month.month,
              8,
            ),
            amount: 7100,
            isPaid: true,
            paidDate: DateTime(
              month.year,
              month.month,
              7,
            ),
          ),
        ],
      ),
      _createDay(
        month,
        15,
        [
          CalendarPayment(
            id:
                '${month.year}-${month.month}-15-1',
            debtId: 'debt-vehicle',
            debtName: 'Vehicle Loan',
            lender:
                'State Bank of India',
            dueDate: DateTime(
              month.year,
              month.month,
              15,
            ),
            amount: 12500,
            isPaid: false,
          ),
        ],
      ),
      _createDay(
        month,
        22,
        [
          CalendarPayment(
            id:
                '${month.year}-${month.month}-22-1',
            debtId: 'debt-hdfc',
            debtName:
                'HDFC Personal Loan',
            lender: 'HDFC Bank',
            dueDate: DateTime(
              month.year,
              month.month,
              22,
            ),
            amount: 7100,
            isPaid: false,
          ),
          CalendarPayment(
            id:
                '${month.year}-${month.month}-22-2',
            debtId: 'debt-family',
            debtName: 'Family Loan',
            lender: 'Family',
            dueDate: DateTime(
              month.year,
              month.month,
              22,
            ),
            amount: 3000,
            isPaid: false,
          ),
        ],
      ),
    ];
  }

  CalendarDay _createDay(
    DateTime month,
    int day,
    List<CalendarPayment> payments,
  ) {
    return CalendarDay(
      date: DateTime(
        month.year,
        month.month,
        day,
      ),
      payments: payments,
    );
  }

  DateTime _dateOnly(
    DateTime date,
  ) {
    return DateTime(
      date.year,
      date.month,
      date.day,
    );
  }

  bool _sameDate(
    DateTime a,
    DateTime b,
  ) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }
}