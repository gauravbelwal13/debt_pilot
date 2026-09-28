enum DebtType {
  personalLoan,
  creditCard,
  vehicleLoan,
  educationLoan,
  friendFamily,
  other,
}

enum PaymentPlanType {
  recurring,
  oneTime,
}

class ScheduledPaymentDraft {
  const ScheduledPaymentDraft({
    required this.date,
    required this.amount,
    this.isPaid = false,
    this.paidDate,
  });

  final DateTime date;
  final double amount;

  /// Whether the user has already made this payment.
  final bool isPaid;

  /// The date the user recorded it as paid.
  final DateTime? paidDate;
}

class DebtDetailsDraft {
  const DebtDetailsDraft({
    required this.type,
    required this.amountBorrowed,
    required this.startDate,
    required this.durationMonths,
    required this.lender,
  });

  final DebtType type;
  final double amountBorrowed;
  final DateTime startDate;
  final int durationMonths;
  final String lender;
}

class PaymentPlanDraft {
  const PaymentPlanDraft({
    required this.type,
    this.recurringAmount,
    this.startDate,
    this.endDate,
    this.scheduledPayments = const [],
    this.oneTimeAmount,
    this.oneTimeDate,
  });

  final PaymentPlanType type;

  // Recurring payment data.
  final double? recurringAmount;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<ScheduledPaymentDraft> scheduledPayments;

  // One-time payment data.
  final double? oneTimeAmount;
  final DateTime? oneTimeDate;
}

class AddDebtDraft {
  const AddDebtDraft({
    required this.details,
    required this.paymentPlan,
  });

  final DebtDetailsDraft details;
  final PaymentPlanDraft paymentPlan;

  factory AddDebtDraft.initial() {
    final today = DateTime.now();

    return AddDebtDraft(
      details: DebtDetailsDraft(
        type: DebtType.personalLoan,
        amountBorrowed: 150000,
        startDate: DateTime(
          today.year,
          today.month,
          today.day,
        ),
        durationMonths: 24,
        lender: 'KreditBee',
      ),
      paymentPlan: const PaymentPlanDraft(
        type: PaymentPlanType.recurring,
      ),
    );
  }
}