import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../domain/models/debt.dart';
import '../../domain/models/debt_payment.dart';

class DebtDetailScreen extends StatelessWidget {
  const DebtDetailScreen({
    required this.debt,
    super.key,
  });

  final Debt debt;

  String _formatAmount(double amount) {
    return '₹${amount.toStringAsFixed(0)}';
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Color _statusColor(DebtPaymentStatus status) {
    switch (status) {
      case DebtPaymentStatus.paid:
        return AppColors.success;

      case DebtPaymentStatus.upcoming:
        return AppColors.blue;

      case DebtPaymentStatus.overdue:
        return AppColors.error;
    }
  }

  String _statusLabel(DebtPaymentStatus status) {
    switch (status) {
      case DebtPaymentStatus.paid:
        return 'Paid';

      case DebtPaymentStatus.upcoming:
        return 'Upcoming';

      case DebtPaymentStatus.overdue:
        return 'Overdue';
    }
  }

  IconData _typeIcon() {
    switch (debt.type) {
      case DebtType.personalLoan:
        return Icons.account_balance_rounded;

      case DebtType.creditCard:
        return Icons.credit_card_rounded;

      case DebtType.vehicleLoan:
        return Icons.directions_car_rounded;

      case DebtType.educationLoan:
        return Icons.school_rounded;

      case DebtType.friendFamily:
        return Icons.people_rounded;

      case DebtType.other:
        return Icons.receipt_long_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final paidPayments = debt.payments
        .where(
          (payment) => payment.isPaid,
        )
        .toList()
      ..sort(
        (a, b) => b.dueDate.compareTo(
          a.dueDate,
        ),
      );

    final nextPayment = debt.nextPayment(
      DateTime.now(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Debt Details'),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.xxxl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DebtHeader(
                debt: debt,
                icon: _typeIcon(),
                formatAmount: _formatAmount,
              ),

              const SizedBox(
                height: AppSpacing.lg,
              ),

              _RepaymentProgress(
                debt: debt,
                formatAmount: _formatAmount,
              ),

              const SizedBox(
                height: AppSpacing.lg,
              ),

              _DebtInformation(
                debt: debt,
                formatAmount: _formatAmount,
                formatDate: _formatDate,
              ),

              const SizedBox(
                height: AppSpacing.lg,
              ),

              if (nextPayment != null)
                _NextPaymentCard(
                  payment: nextPayment,
                  formatAmount: _formatAmount,
                  formatDate: _formatDate,
                  statusColor: _statusColor(
                    nextPayment.status(
                      DateTime.now(),
                    ),
                  ),
                ),

              if (nextPayment != null)
                const SizedBox(
                  height: AppSpacing.lg,
                ),

              _PaymentScheduleSection(
                payments: debt.payments,
                formatAmount: _formatAmount,
                formatDate: _formatDate,
                statusColor: _statusColor,
                statusLabel: _statusLabel,
              ),

              const SizedBox(
                height: AppSpacing.xxl,
              ),

              _PaymentHistorySection(
                payments: paidPayments,
                formatAmount: _formatAmount,
                formatDate: _formatDate,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DebtHeader extends StatelessWidget {
  const _DebtHeader({
    required this.debt,
    required this.icon,
    required this.formatAmount,
  });

  final Debt debt;
  final IconData icon;
  final String Function(double amount) formatAmount;

  @override
  Widget build(BuildContext context) {
    final isCompleted =
        debt.status == DebtStatus.completed;

    final accent = isCompleted
        ? AppColors.success
        : AppColors.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(
        AppSpacing.xl,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(
          color: AppColors.border,
        ),
        borderRadius: BorderRadius.circular(
          AppSpacing.radiusLg,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: accent.withValues(
                    alpha: 0.10,
                  ),
                  borderRadius: BorderRadius.circular(
                    AppSpacing.radiusMd,
                  ),
                ),
                child: Icon(
                  icon,
                  color: accent,
                  size: 27,
                ),
              ),

              const SizedBox(
                width: AppSpacing.md,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      debt.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      debt.lender,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                            color:
                                AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(
            height: AppSpacing.xxl,
          ),

          Text(
            isCompleted
                ? 'Debt Completed'
                : 'Outstanding Amount',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),

          const SizedBox(
            height: AppSpacing.xs,
          ),

          Text(
            formatAmount(
              debt.outstandingAmount,
            ),
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: isCompleted
                      ? AppColors.success
                      : AppColors.textPrimary,
                ),
          ),

          const SizedBox(
            height: AppSpacing.md,
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: accent.withValues(
                alpha: 0.10,
              ),
              borderRadius: BorderRadius.circular(
                AppSpacing.radiusRound,
              ),
            ),
            child: Text(
              isCompleted ? 'Completed' : 'Ongoing',
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(
                    color: accent,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RepaymentProgress extends StatelessWidget {
  const _RepaymentProgress({
    required this.debt,
    required this.formatAmount,
  });

  final Debt debt;
  final String Function(double amount) formatAmount;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Repayment Progress',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      formatAmount(
                        debt.paidAmount,
                      ),
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(
                            fontWeight:
                                FontWeight.w800,
                            color:
                                AppColors.success,
                          ),
                    ),
                    Text(
                      'Paid',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                            color:
                                AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.end,
                  children: [
                    Text(
                      formatAmount(
                        debt.outstandingAmount,
                      ),
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(
                            fontWeight:
                                FontWeight.w800,
                          ),
                    ),
                    Text(
                      'Remaining',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                            color:
                                AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(
            height: AppSpacing.lg,
          ),

          ClipRRect(
            borderRadius:
                BorderRadius.circular(
              AppSpacing.radiusRound,
            ),
            child: LinearProgressIndicator(
              value: debt.progress,
              minHeight: 9,
              backgroundColor:
                  AppColors.surfaceSoft,
              valueColor:
                  const AlwaysStoppedAnimation(
                AppColors.primary,
              ),
            ),
          ),

          const SizedBox(
            height: AppSpacing.sm,
          ),

          Row(
            children: [
              Text(
                '${(debt.progress * 100).round()}% paid',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight:
                          FontWeight.w600,
                    ),
              ),
              const Spacer(),
              Text(
                '${debt.paidPayments} of ${debt.totalPayments} payments',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DebtInformation extends StatelessWidget {
  const _DebtInformation({
    required this.debt,
    required this.formatAmount,
    required this.formatDate,
  });

  final Debt debt;
  final String Function(double amount) formatAmount;
  final String Function(DateTime date) formatDate;

  @override
  Widget build(BuildContext context) {
    final firstPayment = debt.payments.isEmpty
        ? null
        : (debt.payments.toList()
              ..sort(
                (a, b) => a.dueDate.compareTo(
                  b.dueDate,
                ),
              ))
            .first;

    return _SectionCard(
      title: 'Debt Information',
      child: Column(
        children: [
          _InfoRow(
            label: 'Debt Type',
            value: debt.typeLabel,
          ),
          _InfoRow(
            label: 'Original Amount',
            value: formatAmount(
              debt.originalAmount,
            ),
          ),
          _InfoRow(
            label: 'Start Date',
            value: formatDate(
              debt.startDate,
            ),
          ),
          _InfoRow(
            label: 'Duration',
            value: '${debt.durationMonths} months',
          ),
          _InfoRow(
            label: 'Payments',
            value: '${debt.totalPayments} scheduled',
          ),
          if (firstPayment != null)
            _InfoRow(
              label: 'First Payment',
              value: formatDate(
                firstPayment.dueDate,
              ),
              showDivider: false,
            ),
        ],
      ),
    );
  }
}

class _NextPaymentCard extends StatelessWidget {
  const _NextPaymentCard({
    required this.payment,
    required this.formatAmount,
    required this.formatDate,
    required this.statusColor,
  });

  final DebtPayment payment;
  final String Function(double amount) formatAmount;
  final String Function(DateTime date) formatDate;
  final Color statusColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(
        AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.blueLight,
        borderRadius: BorderRadius.circular(
          AppSpacing.radiusLg,
        ),
        border: Border.all(
          color: AppColors.blue.withValues(
            alpha: 0.18,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(
                alpha: 0.8,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.event_rounded,
              color: statusColor,
            ),
          ),

          const SizedBox(
            width: AppSpacing.md,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Next Payment',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                        color:
                            AppColors.textSecondary,
                      ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  formatDate(
                    payment.dueDate,
                  ),
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(
                        fontWeight:
                            FontWeight.w800,
                      ),
                ),
              ],
            ),
          ),

          Text(
            formatAmount(
              payment.amount,
            ),
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}

class _PaymentScheduleSection extends StatelessWidget {
  const _PaymentScheduleSection({
    required this.payments,
    required this.formatAmount,
    required this.formatDate,
    required this.statusColor,
    required this.statusLabel,
  });

  final List<DebtPayment> payments;
  final String Function(double amount) formatAmount;
  final String Function(DateTime date) formatDate;
  final Color Function(DebtPaymentStatus status)
      statusColor;
  final String Function(DebtPaymentStatus status)
      statusLabel;

  @override
  Widget build(BuildContext context) {
    final sortedPayments = [...payments]
      ..sort(
        (a, b) => a.dueDate.compareTo(
          b.dueDate,
        ),
      );

    return _SectionCard(
      title: 'Payment Schedule',
      child: Column(
        children: [
          for (int index = 0;
              index < sortedPayments.length;
              index++)
            _PaymentScheduleRow(
              payment: sortedPayments[index],
              formatAmount: formatAmount,
              formatDate: formatDate,
              statusColor: statusColor(
                sortedPayments[index].status(
                  DateTime.now(),
                ),
              ),
              statusLabel: statusLabel(
                sortedPayments[index].status(
                  DateTime.now(),
                ),
              ),
              showDivider:
                  index != sortedPayments.length - 1,
            ),
        ],
      ),
    );
  }
}

class _PaymentScheduleRow extends StatelessWidget {
  const _PaymentScheduleRow({
    required this.payment,
    required this.formatAmount,
    required this.formatDate,
    required this.statusColor,
    required this.statusLabel,
    required this.showDivider,
  });

  final DebtPayment payment;
  final String Function(double amount) formatAmount;
  final String Function(DateTime date) formatDate;
  final Color statusColor;
  final String statusLabel;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(
                bottom: BorderSide(
                  color: AppColors.divider,
                ),
              )
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: statusColor.withValues(
                alpha: 0.10,
              ),
              borderRadius: BorderRadius.circular(
                AppSpacing.radiusMd,
              ),
            ),
            child: Icon(
              payment.isPaid
                  ? Icons.check_rounded
                  : Icons.schedule_rounded,
              color: statusColor,
              size: 20,
            ),
          ),

          const SizedBox(
            width: AppSpacing.md,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  formatDate(
                    payment.dueDate,
                  ),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                        fontWeight:
                            FontWeight.w700,
                      ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  statusLabel,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                        color: statusColor,
                        fontWeight:
                            FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),

          Text(
            formatAmount(
              payment.amount,
            ),
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}

class _PaymentHistorySection extends StatelessWidget {
  const _PaymentHistorySection({
    required this.payments,
    required this.formatAmount,
    required this.formatDate,
  });

  final List<DebtPayment> payments;
  final String Function(double amount) formatAmount;
  final String Function(DateTime date) formatDate;

  @override
  Widget build(BuildContext context) {
    if (payments.isEmpty) {
      return _SectionCard(
        title: 'Payment History',
        child: Column(
          children: [
            const Icon(
              Icons.history_rounded,
              size: 40,
              color: AppColors.textMuted,
            ),
            const SizedBox(
              height: AppSpacing.md,
            ),
            Text(
              'No payments recorded yet',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                    color:
                        AppColors.textSecondary,
                    fontWeight:
                        FontWeight.w600,
                  ),
            ),
          ],
        ),
      );
    }

    return _SectionCard(
      title: 'Payment History',
      child: Column(
        children: [
          for (int index = 0;
              index < payments.length;
              index++)
            _PaymentHistoryRow(
              payment: payments[index],
              formatAmount: formatAmount,
              formatDate: formatDate,
              showDivider:
                  index != payments.length - 1,
            ),
        ],
      ),
    );
  }
}

class _PaymentHistoryRow extends StatelessWidget {
  const _PaymentHistoryRow({
    required this.payment,
    required this.formatAmount,
    required this.formatDate,
    required this.showDivider,
  });

  final DebtPayment payment;
  final String Function(double amount) formatAmount;
  final String Function(DateTime date) formatDate;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final paymentDate =
        payment.paidDate ?? payment.dueDate;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(
                bottom: BorderSide(
                  color: AppColors.divider,
                ),
              )
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(
                alpha: 0.10,
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: AppColors.success,
              size: 20,
            ),
          ),

          const SizedBox(
            width: AppSpacing.md,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  formatDate(
                    paymentDate,
                  ),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                        fontWeight:
                            FontWeight.w700,
                      ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  'Payment recorded',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                        color:
                            AppColors.success,
                      ),
                ),
              ],
            ),
          ),

          Text(
            formatAmount(
              payment.amount,
            ),
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(
        AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(
          color: AppColors.border,
        ),
        borderRadius: BorderRadius.circular(
          AppSpacing.radiusLg,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(
            height: AppSpacing.md,
          ),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  final String label;
  final String value;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(
                bottom: BorderSide(
                  color: AppColors.divider,
                ),
              )
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                    color:
                        AppColors.textSecondary,
                  ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                    fontWeight:
                        FontWeight.w700,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}