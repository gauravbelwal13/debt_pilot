import 'debt_payment.dart';

enum DebtStatus {
  ongoing,
  completed,
}

enum DebtType {
  personalLoan,
  creditCard,
  vehicleLoan,
  educationLoan,
  friendFamily,
  other,
}

class Debt {
  const Debt({
    required this.id,
    required this.name,
    required this.lender,
    required this.type,
    required this.originalAmount,
    required this.outstandingAmount,
    required this.startDate,
    required this.durationMonths,
    required this.payments,
  });

  final String id;
  final String name;
  final String lender;
  final DebtType type;
  final double originalAmount;
  final double outstandingAmount;
  final DateTime startDate;
  final int durationMonths;
  final List<DebtPayment> payments;

  DebtStatus get status {
    if (outstandingAmount <= 0) {
      return DebtStatus.completed;
    }

    return DebtStatus.ongoing;
  }

  double get paidAmount {
    final amount = originalAmount - outstandingAmount;

    if (amount < 0) {
      return 0;
    }

    if (amount > originalAmount) {
      return originalAmount;
    }

    return amount;
  }

  double get progress {
    if (originalAmount <= 0) {
      return 0;
    }

    final value = paidAmount / originalAmount;

    if (value < 0) {
      return 0;
    }

    if (value > 1) {
      return 1;
    }

    return value;
  }

  int get totalPayments => payments.length;

  int get paidPayments {
    return payments.where(
      (payment) => payment.isPaid,
    ).length;
  }

  int get remainingPayments {
    return payments.where(
      (payment) => !payment.isPaid,
    ).length;
  }

  double get scheduledAmount {
    return payments.fold(
      0,
      (total, payment) => total + payment.amount,
    );
  }

  double get paidScheduledAmount {
    return payments
        .where(
          (payment) => payment.isPaid,
        )
        .fold(
          0,
          (total, payment) => total + payment.amount,
        );
  }

  DebtPayment? nextPayment(DateTime referenceDate) {
    final unpaidPayments = payments
        .where(
          (payment) => !payment.isPaid,
        )
        .toList()
      ..sort(
        (a, b) => a.dueDate.compareTo(
          b.dueDate,
        ),
      );

    if (unpaidPayments.isEmpty) {
      return null;
    }

    return unpaidPayments.first;
  }

  DebtPayment? lastPaidPayment() {
    final paid = payments
        .where(
          (payment) => payment.isPaid,
        )
        .toList()
      ..sort(
        (a, b) {
          final aDate = a.paidDate ?? a.dueDate;
          final bDate = b.paidDate ?? b.dueDate;

          return bDate.compareTo(aDate);
        },
      );

    if (paid.isEmpty) {
      return null;
    }

    return paid.first;
  }

  String get typeLabel {
    switch (type) {
      case DebtType.personalLoan:
        return 'Personal Loan';

      case DebtType.creditCard:
        return 'Credit Card';

      case DebtType.vehicleLoan:
        return 'Vehicle Loan';

      case DebtType.educationLoan:
        return 'Education Loan';

      case DebtType.friendFamily:
        return 'Friend / Family';

      case DebtType.other:
        return 'Other';
    }
  }

  Debt copyWith({
    String? id,
    String? name,
    String? lender,
    DebtType? type,
    double? originalAmount,
    double? outstandingAmount,
    DateTime? startDate,
    int? durationMonths,
    List<DebtPayment>? payments,
  }) {
    return Debt(
      id: id ?? this.id,
      name: name ?? this.name,
      lender: lender ?? this.lender,
      type: type ?? this.type,
      originalAmount: originalAmount ?? this.originalAmount,
      outstandingAmount:
          outstandingAmount ?? this.outstandingAmount,
      startDate: startDate ?? this.startDate,
      durationMonths:
          durationMonths ?? this.durationMonths,
      payments: payments ?? this.payments,
    );
  }
}