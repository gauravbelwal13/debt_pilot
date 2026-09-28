enum CalendarPaymentStatus {
  paid,
  upcoming,
  overdue,
}

class CalendarPayment {
  const CalendarPayment({
    required this.id,
    required this.debtId,
    required this.debtName,
    required this.lender,
    required this.dueDate,
    required this.amount,
    required this.isPaid,
    this.paidDate,
  });

  final String id;
  final String debtId;
  final String debtName;
  final String lender;
  final DateTime dueDate;
  final double amount;
  final bool isPaid;
  final DateTime? paidDate;

  CalendarPaymentStatus status(DateTime referenceDate) {
    if (isPaid) {
      return CalendarPaymentStatus.paid;
    }

    final due = DateTime(
      dueDate.year,
      dueDate.month,
      dueDate.day,
    );

    final reference = DateTime(
      referenceDate.year,
      referenceDate.month,
      referenceDate.day,
    );

    if (due.isBefore(reference)) {
      return CalendarPaymentStatus.overdue;
    }

    return CalendarPaymentStatus.upcoming;
  }
}