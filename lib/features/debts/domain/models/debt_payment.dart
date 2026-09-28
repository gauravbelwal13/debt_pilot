import 'package:flutter/foundation.dart';

enum DebtPaymentStatus {
  paid,
  upcoming,
  overdue,
}

class DebtPayment {
  const DebtPayment({
    required this.id,
    required this.debtId,
    required this.dueDate,
    required this.amount,
    required this.isPaid,
    this.paidDate,
  });

  final String id;
  final String debtId;
  final DateTime dueDate;
  final double amount;
  final bool isPaid;
  final DateTime? paidDate;

  DebtPaymentStatus status(DateTime referenceDate) {
    if (isPaid) {
      return DebtPaymentStatus.paid;
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
      return DebtPaymentStatus.overdue;
    }

    return DebtPaymentStatus.upcoming;
  }

  DebtPayment copyWith({
    String? id,
    String? debtId,
    DateTime? dueDate,
    double? amount,
    bool? isPaid,
    DateTime? paidDate,
    bool clearPaidDate = false,
  }) {
    return DebtPayment(
      id: id ?? this.id,
      debtId: debtId ?? this.debtId,
      dueDate: dueDate ?? this.dueDate,
      amount: amount ?? this.amount,
      isPaid: isPaid ?? this.isPaid,
      paidDate: clearPaidDate
          ? null
          : paidDate ?? this.paidDate,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is DebtPayment &&
            other.id == id &&
            other.debtId == debtId &&
            other.dueDate == dueDate &&
            other.amount == amount &&
            other.isPaid == isPaid &&
            other.paidDate == paidDate;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      debtId,
      dueDate,
      amount,
      isPaid,
      paidDate,
    );
  }
}