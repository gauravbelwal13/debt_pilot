class InsightData {
  const InsightData({
    required this.totalOriginalDebt,
    required this.totalOutstandingDebt,
    required this.totalPaidDebt,
    required this.ongoingDebts,
    required this.completedDebts,
    required this.monthlyDebtPayment,
    required this.upcomingThisMonth,
    required this.paidThisMonth,
    required this.overdueThisMonth,
    required this.debtBreakdown,
    required this.monthlyTrend,
    required this.monthlyBurden,
  });

  final double totalOriginalDebt;
  final double totalOutstandingDebt;
  final double totalPaidDebt;

  final int ongoingDebts;
  final int completedDebts;

  final double monthlyDebtPayment;

  final double upcomingThisMonth;
  final double paidThisMonth;
  final double overdueThisMonth;

  final List<InsightDebtCategory> debtBreakdown;
  final List<InsightTrendPoint> monthlyTrend;
  final List<InsightBurdenPoint> monthlyBurden;

  double get repaymentProgress {
    if (totalOriginalDebt <= 0) {
      return 0;
    }

    final progress =
        totalPaidDebt / totalOriginalDebt;

    return progress.clamp(0, 1).toDouble();
  }

  double get remainingProgress {
    return 1 - repaymentProgress;
  }

  int projectedDebtFreeDays({
    double extraMonthlyPayment = 0,
  }) {
    if (totalOutstandingDebt <= 0) {
      return 0;
    }

    final monthlyPayment =
        monthlyDebtPayment + extraMonthlyPayment;

    if (monthlyPayment <= 0) {
      return 0;
    }

    final months =
        totalOutstandingDebt / monthlyPayment;

    const averageDaysPerMonth = 30.4375;

    return (months * averageDaysPerMonth).ceil();
  }

  DateTime projectedDebtFreeDate({
    DateTime? from,
    double extraMonthlyPayment = 0,
  }) {
    final start = from ?? DateTime.now();

    return start.add(
      Duration(
        days: projectedDebtFreeDays(
          extraMonthlyPayment: extraMonthlyPayment,
        ),
      ),
    );
  }

  InsightData copyWith({
    double? totalOriginalDebt,
    double? totalOutstandingDebt,
    double? totalPaidDebt,
    int? ongoingDebts,
    int? completedDebts,
    double? monthlyDebtPayment,
    double? upcomingThisMonth,
    double? paidThisMonth,
    double? overdueThisMonth,
    List<InsightDebtCategory>? debtBreakdown,
    List<InsightTrendPoint>? monthlyTrend,
    List<InsightBurdenPoint>? monthlyBurden,
  }) {
    return InsightData(
      totalOriginalDebt:
          totalOriginalDebt ?? this.totalOriginalDebt,
      totalOutstandingDebt:
          totalOutstandingDebt ?? this.totalOutstandingDebt,
      totalPaidDebt:
          totalPaidDebt ?? this.totalPaidDebt,
      ongoingDebts:
          ongoingDebts ?? this.ongoingDebts,
      completedDebts:
          completedDebts ?? this.completedDebts,
      monthlyDebtPayment:
          monthlyDebtPayment ?? this.monthlyDebtPayment,
      upcomingThisMonth:
          upcomingThisMonth ?? this.upcomingThisMonth,
      paidThisMonth:
          paidThisMonth ?? this.paidThisMonth,
      overdueThisMonth:
          overdueThisMonth ?? this.overdueThisMonth,
      debtBreakdown:
          debtBreakdown ?? this.debtBreakdown,
      monthlyTrend:
          monthlyTrend ?? this.monthlyTrend,
      monthlyBurden:
          monthlyBurden ?? this.monthlyBurden,
    );
  }
}

class InsightDebtCategory {
  const InsightDebtCategory({
    required this.name,
    required this.amount,
  });

  final String name;
  final double amount;
}

class InsightTrendPoint {
  const InsightTrendPoint({
    required this.label,
    required this.outstanding,
    required this.paid,
  });

  final String label;
  final double outstanding;
  final double paid;
}

class InsightBurdenPoint {
  const InsightBurdenPoint({
    required this.label,
    required this.amount,
  });

  final String label;
  final double amount;
}