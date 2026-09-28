import 'calendar_payment.dart';

class CalendarDay {
  const CalendarDay({
    required this.date,
    required this.payments,
  });

  final DateTime date;
  final List<CalendarPayment> payments;

  bool get hasPayments => payments.isNotEmpty;

  bool get hasMultiplePayments => payments.length > 1;

  int get paymentCount => payments.length;

  double get totalAmount {
    return payments.fold(
      0,
      (total, payment) => total + payment.amount,
    );
  }

  double get paidAmount {
    return payments
        .where((payment) => payment.isPaid)
        .fold(
          0,
          (total, payment) => total + payment.amount,
        );
  }

  double get unpaidAmount {
    return totalAmount - paidAmount;
  }

  bool hasStatus(
    CalendarPaymentStatus status,
    DateTime referenceDate,
  ) {
    return payments.any(
      (payment) => payment.status(referenceDate) == status,
    );
  }

  bool get isAllPaid {
    return payments.isNotEmpty &&
        payments.every((payment) => payment.isPaid);
  }
}