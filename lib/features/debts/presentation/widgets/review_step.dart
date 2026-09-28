import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/amount_text.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/status_chip.dart';
import '../models/add_debt_draft.dart';

class ReviewStep extends StatefulWidget {
  const ReviewStep({
    required this.draft,
    required this.onPaymentUpdated,
    super.key,
  });

  final AddDebtDraft draft;
  final ValueChanged<List<ScheduledPaymentDraft>>
      onPaymentUpdated;

  @override
  State<ReviewStep> createState() => _ReviewStepState();
}

class _ReviewStepState extends State<ReviewStep> {
  late List<ScheduledPaymentDraft> _payments;

  @override
  void initState() {
    super.initState();

    _payments = List.of(
      widget.draft.paymentPlan.scheduledPayments,
    );
  }

  void _togglePaid(int index) {
    final payment = _payments[index];

    final updatedPayment = ScheduledPaymentDraft(
      date: payment.date,
      amount: payment.amount,
      isPaid: !payment.isPaid,
      paidDate: payment.isPaid ? null : DateTime.now(),
    );

    setState(() {
      _payments[index] = updatedPayment;
    });

    widget.onPaymentUpdated(
      List.unmodifiable(_payments),
    );
  }

  int get _paidCount =>
      _payments.where((payment) => payment.isPaid).length;

  @override
  Widget build(BuildContext context) {
    final details = widget.draft.details;
    final plan = widget.draft.paymentPlan;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Review your debt',
            style: Theme.of(context).textTheme.titleMedium,
          ),

          const SizedBox(height: AppSpacing.xs),

          Text(
            'Check your details and update payment status before adding.',
            style: Theme.of(context).textTheme.bodySmall,
          ),

          const SizedBox(height: AppSpacing.lg),

          _DebtSummaryCard(
            draft: widget.draft,
          ),

          const SizedBox(height: AppSpacing.lg),

          _PaymentPlanSummary(
            draft: widget.draft,
          ),

          const SizedBox(height: AppSpacing.lg),

          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Payment Schedule',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium,
                      ),
                    ),
                    if (_payments.isNotEmpty)
                      StatusChip(
                        label:
                            '$_paidCount/${_payments.length} Paid',
                        color: _paidCount == _payments.length
                            ? AppColors.success
                            : AppColors.primary,
                        icon: _paidCount == _payments.length
                            ? Icons.check_circle_rounded
                            : Icons.calendar_month_rounded,
                      ),
                  ],
                ),

                const SizedBox(
                  height: AppSpacing.lg,
                ),

                if (_payments.isEmpty)
                  Text(
                    'No payment schedule available.',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall,
                  )
                else
                  ..._payments.asMap().entries.map(
                    (entry) {
                      final index = entry.key;
                      final payment = entry.value;

                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppSpacing.sm,
                        ),
                        child: _PaymentStatusRow(
                          payment: payment,
                          onToggle: () {
                            _togglePaid(index);
                          },
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),

          const SizedBox(
            height: AppSpacing.xl,
          ),
        ],
      ),
    );
  }
}

class _DebtSummaryCard extends StatelessWidget {
  const _DebtSummaryCard({
    required this.draft,
  });

  final AddDebtDraft draft;

  @override
  Widget build(BuildContext context) {
    final details = draft.details;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const StatusChip(
                label: 'Debt Details',
                color: AppColors.primary,
                icon: Icons.account_balance_rounded,
              ),
              const Spacer(),
              Text(
                _debtTypeLabel(details.type),
                style: Theme.of(context)
                    .textTheme
                    .labelMedium,
              ),
            ],
          ),

          const SizedBox(
            height: AppSpacing.lg,
          ),

          _InfoRow(
            label: 'Amount borrowed',
            value: CurrencyFormatter.format(
              details.amountBorrowed,
            ),
          ),

          _InfoRow(
            label: 'Start date',
            value: DateFormatter.short(
              details.startDate,
            ),
          ),

          _InfoRow(
            label: 'Duration',
            value:
                '${details.durationMonths} months',
          ),

          _InfoRow(
            label: _lenderLabel(details.type),
            value: details.lender,
          ),
        ],
      ),
    );
  }
}

class _PaymentPlanSummary extends StatelessWidget {
  const _PaymentPlanSummary({
    required this.draft,
  });

  final AddDebtDraft draft;

  @override
  Widget build(BuildContext context) {
    final plan = draft.paymentPlan;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Plan',
            style: Theme.of(context)
                .textTheme
                .titleMedium,
          ),

          const SizedBox(
            height: AppSpacing.lg,
          ),

          _InfoRow(
            label: 'Plan',
            value: _paymentPlanLabel(
              plan.type,
            ),
          ),

          if (plan.type == PaymentPlanType.recurring) ...[
            if (plan.recurringAmount != null)
              _InfoRow(
                label: 'Monthly payment',
                value: CurrencyFormatter.format(
                  plan.recurringAmount!,
                ),
              ),

            if (plan.startDate != null)
              _InfoRow(
                label: 'Start date',
                value: DateFormatter.short(
                  plan.startDate!,
                ),
              ),

            if (plan.endDate != null)
              _InfoRow(
                label: 'End date',
                value: DateFormatter.short(
                  plan.endDate!,
                ),
              ),

            const _InfoRow(
              label: 'Frequency',
              value: 'Monthly',
            ),
          ],

          if (plan.type == PaymentPlanType.oneTime) ...[
            if (plan.oneTimeAmount != null)
              _InfoRow(
                label: 'Payment amount',
                value: CurrencyFormatter.format(
                  plan.oneTimeAmount!,
                ),
              ),

            if (plan.oneTimeDate != null)
              _InfoRow(
                label: 'Payment date',
                value: DateFormatter.short(
                  plan.oneTimeDate!,
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _PaymentStatusRow extends StatelessWidget {
  const _PaymentStatusRow({
    required this.payment,
    required this.onToggle,
  });

  final ScheduledPaymentDraft payment;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final paid = payment.isPaid;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: paid
            ? AppColors.success.withValues(
                alpha: 0.08,
              )
            : AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(
          AppSpacing.radiusMd,
        ),
        border: Border.all(
          color: paid
              ? AppColors.success.withValues(
                  alpha: 0.35,
                )
              : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: paid
                  ? AppColors.success.withValues(
                      alpha: 0.14,
                    )
                  : AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              paid
                  ? Icons.check_rounded
                  : Icons.calendar_today_rounded,
              size: 18,
              color: paid
                  ? AppColors.success
                  : AppColors.primary,
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
                  DateFormatter.short(
                    payment.date,
                  ),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                        fontSize: 13,
                        color: paid
                            ? AppColors.success
                            : AppColors.textPrimary,
                      ),
                ),
                const SizedBox(height: 3),
                if (paid && payment.paidDate != null)
                  Text(
                    'Paid ${DateFormatter.short(payment.paidDate!)}',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall,
                  )
                else
                  Text(
                    'Scheduled payment',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall,
                  ),
              ],
            ),
          ),

          AmountText(
            payment.amount,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(
            width: AppSpacing.sm,
          ),

          _MarkPaidButton(
            paid: paid,
            onPressed: onToggle,
          ),
        ],
      ),
    );
  }
}

class _MarkPaidButton extends StatelessWidget {
  const _MarkPaidButton({
    required this.paid,
    required this.onPressed,
  });

  final bool paid;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: paid
          ? AppColors.success
          : AppColors.primaryLight,
      borderRadius: BorderRadius.circular(
        AppSpacing.radiusRound,
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(
          AppSpacing.radiusRound,
        ),
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 180,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                paid
                    ? Icons.check_rounded
                    : Icons.check_circle_outline_rounded,
                size: 15,
                color: paid
                    ? Colors.white
                    : AppColors.primary,
              ),
              const SizedBox(width: 4),
              Text(
                paid ? 'Paid' : 'Mark Paid',
                style: TextStyle(
                  color: paid
                      ? Colors.white
                      : AppColors.primaryDark,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

String _debtTypeLabel(DebtType type) {
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

String _lenderLabel(DebtType type) {
  switch (type) {
    case DebtType.personalLoan:
      return 'Loan App';

    case DebtType.creditCard:
    case DebtType.vehicleLoan:
    case DebtType.educationLoan:
      return 'Bank';

    case DebtType.friendFamily:
      return 'Person';

    case DebtType.other:
      return 'Provider';
  }
}

String _paymentPlanLabel(
  PaymentPlanType type,
) {
  switch (type) {
    case PaymentPlanType.recurring:
      return 'Fixed recurring payment';

    case PaymentPlanType.oneTime:
      return 'One-time payment';
  }
}