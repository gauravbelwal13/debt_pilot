import 'package:debt_pilot/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../domain/models/insight_data.dart';
import '../widgets/debt_breakdown_chart.dart';
import '../widgets/debt_free_card.dart';
import '../widgets/extra_payment_calculator.dart';
import '../widgets/insights_overview_card.dart';
import '../widgets/monthly_burden_chart.dart';
import '../widgets/outstanding_trend_chart.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({
    super.key,
  });

  @override
  State<InsightsScreen> createState() =>
      _InsightsScreenState();
}

class _InsightsScreenState
    extends State<InsightsScreen> {
  late final InsightData _data;

  InsightRange _selectedRange =
      InsightRange.sixMonths;

  double _extraPayment = 0;

  @override
  void initState() {
    super.initState();

    _data = _buildMockData();
  }

  int get _baseDebtFreeDays {
    return _data.projectedDebtFreeDays();
  }

  int get _projectedDebtFreeDays {
    return _data.projectedDebtFreeDays(
      extraMonthlyPayment: _extraPayment,
    );
  }

  DateTime get _projectedDebtFreeDate {
    return _data.projectedDebtFreeDate(
      extraMonthlyPayment: _extraPayment,
    );
  }

  void _onNavigationSelected(int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;

      case 1:
        context.go('/calendar');
        break;

      case 2:
        context.go('/debts');
        break;

      case 3:
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            110,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              DebtFreeCard(
                days: _projectedDebtFreeDays,
                debtFreeDate:
                    _projectedDebtFreeDate,
                progress:
                    _data.repaymentProgress,
              ),

              const SizedBox(
                height: AppSpacing.lg,
              ),

              InsightsOverviewCard(
                totalOutstanding:
                    _data.totalOutstandingDebt,
                totalPaid:
                    _data.totalPaidDebt,
                monthlyPayment:
                    _data.monthlyDebtPayment,
                upcoming:
                    _data.upcomingThisMonth,
              ),

              const SizedBox(
                height: AppSpacing.lg,
              ),

              OutstandingTrendChart(
                points: _data.monthlyTrend,
                selectedRange:
                    _selectedRange,
                onRangeChanged: (range) {
                  setState(() {
                    _selectedRange = range;
                  });
                },
              ),

              const SizedBox(
                height: AppSpacing.lg,
              ),

              MonthlyBurdenChart(
                points: _data.monthlyBurden,
              ),

              const SizedBox(
                height: AppSpacing.lg,
              ),

              DebtBreakdownChart(
                items:
                    _data.debtBreakdown,
              ),

              const SizedBox(
                height: AppSpacing.lg,
              ),

              ExtraPaymentCalculator(
                extraPayment:
                    _extraPayment,
                onChanged: (value) {
                  setState(() {
                    _extraPayment = value;
                  });
                },
                currentMonthlyPayment:
                    _data.monthlyDebtPayment,
                baseDays:
                    _baseDebtFreeDays,
                projectedDays:
                    _projectedDebtFreeDays,
                projectedDate:
                    _projectedDebtFreeDate,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/add-debt');
        },
        child: const Icon(
          Icons.add_rounded,
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: HomeBottomNavBar(
        selectedIndex: 3,
        onSelected:
            _onNavigationSelected,
      ),
    );
  }

  InsightData _buildMockData() {
    return const InsightData(
      totalOriginalDebt: 835000,
      totalOutstandingDebt: 518000,
      totalPaidDebt: 317000,
      ongoingDebts: 4,
      completedDebts: 1,
      monthlyDebtPayment: 37100,
      upcomingThisMonth: 31100,
      paidThisMonth: 21200,
      overdueThisMonth: 0,
      debtBreakdown: [
        InsightDebtCategory(
          name: 'Personal Loan',
          amount: 124500,
        ),
        InsightDebtCategory(
          name: 'Vehicle Loan',
          amount: 210000,
        ),
        InsightDebtCategory(
          name: 'Credit Card',
          amount: 8500,
        ),
        InsightDebtCategory(
          name: 'Education Loan',
          amount: 175000,
        ),
      ],
      monthlyTrend: [
        InsightTrendPoint(
          label: 'Apr',
          outstanding: 739000,
          paid: 96000,
        ),
        InsightTrendPoint(
          label: 'May',
          outstanding: 702000,
          paid: 133000,
        ),
        InsightTrendPoint(
          label: 'Jun',
          outstanding: 665000,
          paid: 170000,
        ),
        InsightTrendPoint(
          label: 'Jul',
          outstanding: 628000,
          paid: 207000,
        ),
        InsightTrendPoint(
          label: 'Aug',
          outstanding: 591000,
          paid: 244000,
        ),
        InsightTrendPoint(
          label: 'Sep',
          outstanding: 518000,
          paid: 317000,
        ),
        InsightTrendPoint(
          label: 'Oct',
          outstanding: 481000,
          paid: 354000,
        ),
        InsightTrendPoint(
          label: 'Nov',
          outstanding: 444000,
          paid: 391000,
        ),
        InsightTrendPoint(
          label: 'Dec',
          outstanding: 407000,
          paid: 428000,
        ),
        InsightTrendPoint(
          label: 'Jan',
          outstanding: 370000,
          paid: 465000,
        ),
        InsightTrendPoint(
          label: 'Feb',
          outstanding: 333000,
          paid: 502000,
        ),
        InsightTrendPoint(
          label: 'Mar',
          outstanding: 296000,
          paid: 539000,
        ),
      ],
      monthlyBurden: [
        InsightBurdenPoint(
          label: 'Apr',
          amount: 28500,
        ),
        InsightBurdenPoint(
          label: 'May',
          amount: 30200,
        ),
        InsightBurdenPoint(
          label: 'Jun',
          amount: 32100,
        ),
        InsightBurdenPoint(
          label: 'Jul',
          amount: 33800,
        ),
        InsightBurdenPoint(
          label: 'Aug',
          amount: 35100,
        ),
        InsightBurdenPoint(
          label: 'Sep',
          amount: 37100,
        ),
        InsightBurdenPoint(
          label: 'Oct',
          amount: 37100,
        ),
        InsightBurdenPoint(
          label: 'Nov',
          amount: 37100,
        ),
        InsightBurdenPoint(
          label: 'Dec',
          amount: 37100,
        ),
        InsightBurdenPoint(
          label: 'Jan',
          amount: 37100,
        ),
        InsightBurdenPoint(
          label: 'Feb',
          amount: 37100,
        ),
        InsightBurdenPoint(
          label: 'Mar',
          amount: 37100,
        ),
      ],
    );
  }
}