import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_calculator.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/amount_text.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../models/add_debt_draft.dart';

class PaymentPlanStep extends StatefulWidget {
  const PaymentPlanStep({
    required this.details,
    required this.initial,
    required this.onChanged,
    super.key,
  });

  final DebtDetailsDraft details;
  final PaymentPlanDraft initial;
  final ValueChanged<PaymentPlanDraft> onChanged;

  @override
  State<PaymentPlanStep> createState() =>
      _PaymentPlanStepState();
}

class _PaymentPlanStepState
    extends State<PaymentPlanStep> {
  late PaymentPlanType _type;

  late final TextEditingController _recurringAmountController;
  late final TextEditingController _recurringStartController;
  late final TextEditingController _recurringEndController;

  late final TextEditingController _oneTimeAmountController;
  late final TextEditingController _oneTimeDateController;

  late DateTime _recurringStartDate;
  late DateTime _recurringEndDate;

  late DateTime _oneTimeDate;

  late List<ScheduledPaymentDraft>
      _scheduledPayments;

  @override
  void initState() {
    super.initState();

    _type = widget.initial.type;

    _recurringStartDate =
        widget.initial.startDate ??
        widget.details.startDate;

    _recurringEndDate =
        widget.initial.endDate ??
        DateCalculator.addMonthsClamped(
          _recurringStartDate,
          widget.details.durationMonths - 1,
        );

    final defaultRecurringAmount =
        widget.details.durationMonths <= 0
            ? widget.details.amountBorrowed
            : widget.details.amountBorrowed /
                widget.details.durationMonths;

    final recurringAmount =
        widget.initial.recurringAmount ??
        defaultRecurringAmount;

    _recurringAmountController =
        TextEditingController(
      text: CurrencyFormatter.format(
        recurringAmount,
      ),
    );

    _recurringStartController =
        TextEditingController(
      text: DateFormatter.short(
        _recurringStartDate,
      ),
    );

    _recurringEndController =
        TextEditingController(
      text: DateFormatter.short(
        _recurringEndDate,
      ),
    );

    _scheduledPayments =
        widget.initial.scheduledPayments.isNotEmpty
            ? List.of(
                widget.initial.scheduledPayments,
              )
            : _generateSchedule(
                amount: recurringAmount,
                start: _recurringStartDate,
                end: _recurringEndDate,
              );

    final oneTimeAmount =
        widget.initial.oneTimeAmount ??
        widget.details.amountBorrowed;

    _oneTimeDate =
        widget.initial.oneTimeDate ??
        widget.details.startDate;

    _oneTimeAmountController =
        TextEditingController(
      text: CurrencyFormatter.format(
        oneTimeAmount,
      ),
    );

    _oneTimeDateController =
        TextEditingController(
      text: DateFormatter.short(
        _oneTimeDate,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _notifyChanged(),
    );
  }

  @override
  void dispose() {
    _recurringAmountController.dispose();
    _recurringStartController.dispose();
    _recurringEndController.dispose();
    _oneTimeAmountController.dispose();
    _oneTimeDateController.dispose();
    super.dispose();
  }

  double _parseAmount(
    String value,
  ) {
    return double.tryParse(
          value
              .replaceAll('₹', '')
              .replaceAll(',', '')
              .trim(),
        ) ??
        0;
  }

  List<ScheduledPaymentDraft> _generateSchedule({
    required double amount,
    required DateTime start,
    required DateTime end,
  }) {
    return DateCalculator.monthlyDates(
      start: start,
      end: end,
    )
        .map(
          (date) => ScheduledPaymentDraft(
            date: date,
            amount: amount,
          ),
        )
        .toList();
  }

  void _notifyChanged() {
    widget.onChanged(
      PaymentPlanDraft(
        type: _type,
        recurringAmount:
            _type == PaymentPlanType.recurring
                ? _parseAmount(
                    _recurringAmountController.text,
                  )
                : null,
        startDate:
            _type == PaymentPlanType.recurring
                ? _recurringStartDate
                : null,
        endDate:
            _type == PaymentPlanType.recurring
                ? _recurringEndDate
                : null,
        scheduledPayments:
            _type == PaymentPlanType.recurring
                ? List.unmodifiable(
                    _scheduledPayments,
                  )
                : const [],
        oneTimeAmount:
            _type == PaymentPlanType.oneTime
                ? _parseAmount(
                    _oneTimeAmountController.text,
                  )
                : null,
        oneTimeDate:
            _type == PaymentPlanType.oneTime
                ? _oneTimeDate
                : null,
      ),
    );
  }

  void _selectPlan(PaymentPlanType type) {
    setState(() {
      _type = type;
    });

    _notifyChanged();
  }

  void _updateRecurringAmount(
    String value,
  ) {
    final amount = _parseAmount(value);

    setState(() {
      _scheduledPayments =
          _scheduledPayments
              .map(
                (payment) =>
                    ScheduledPaymentDraft(
                  date: payment.date,
                  amount: amount,
                ),
              )
              .toList();
    });

    _notifyChanged();
  }

  Future<void> _selectRecurringStartDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _recurringStartDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selected == null) return;

    final duration =
        DateCalculator.monthsInclusive(
      _recurringStartDate,
      _recurringEndDate,
    );

    setState(() {
      _recurringStartDate = selected;

      _recurringEndDate =
          DateCalculator.addMonthsClamped(
        selected,
        duration > 0 ? duration - 1 : 0
      );

      _recurringStartController.text =
          DateFormatter.short(selected);

      _recurringEndController.text =
          DateFormatter.short(
        _recurringEndDate,
      );

      _scheduledPayments =
          _generateSchedule(
        amount: _parseAmount(
          _recurringAmountController.text,
        ),
        start: _recurringStartDate,
        end: _recurringEndDate,
      );
    });

    _notifyChanged();
  }

  Future<void> _selectRecurringEndDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _recurringEndDate,
      firstDate: _recurringStartDate,
      lastDate: DateTime(2100),
    );

    if (selected == null) return;

    setState(() {
      _recurringEndDate = selected;

      _recurringEndController.text =
          DateFormatter.short(selected);

      _scheduledPayments =
          _generateSchedule(
        amount: _parseAmount(
          _recurringAmountController.text,
        ),
        start: _recurringStartDate,
        end: _recurringEndDate,
      );
    });

    _notifyChanged();
  }

  Future<void> _selectOneTimeDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _oneTimeDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selected == null) return;

    setState(() {
      _oneTimeDate = selected;
      _oneTimeDateController.text =
          DateFormatter.short(selected);
    });

    _notifyChanged();
  }

  Future<void> _editPayment(
    int index,
  ) async {
    final payment =
        _scheduledPayments[index];

    final amountController =
        TextEditingController(
      text: payment.amount.toStringAsFixed(0),
    );

    var selectedDate = payment.date;

    final result =
        await showModalBottomSheet<
            ScheduledPaymentDraft>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                MediaQuery.viewInsetsOf(
                      context,
                    ).bottom +
                    AppSpacing.lg,
              ),
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius:
                    BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Column(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  Text(
                    'Edit Payment',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge,
                  ),
                  const SizedBox(
                    height: AppSpacing.lg,
                  ),
                  AppTextField(
                    controller:
                        amountController,
                    label: 'Amount',
                    keyboardType:
                        TextInputType.number,
                  ),
                  const SizedBox(
                    height: AppSpacing.md,
                  ),
                  AppTextField(
                    controller:
                        TextEditingController(
                      text: DateFormatter
                          .short(selectedDate),
                    ),
                    label: 'Date',
                    readOnly: true,
                    onTap: () async {
                      final date =
                          await showDatePicker(
                        context: context,
                        initialDate:
                            selectedDate,
                        firstDate:
                            DateTime(2000),
                        lastDate:
                            DateTime(2100),
                      );

                      if (date != null) {
                        setModalState(() {
                          selectedDate =
                              date;
                        });
                      }
                    },
                    suffixIcon:
                        const Icon(
                      Icons
                          .calendar_today_outlined,
                      size: 18,
                    ),
                  ),
                  const SizedBox(
                    height: AppSpacing.lg,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        final amount =
                            double.tryParse(
                              amountController
                                  .text
                                  .trim(),
                            );

                        if (amount == null ||
                            amount <= 0) {
                          return;
                        }

                        Navigator.of(
                          context,
                        ).pop(
                          ScheduledPaymentDraft(
                            date: selectedDate,
                            amount:
                                amount,
                          ),
                        );
                      },
                      child: const Text(
                        'Save Payment',
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    amountController.dispose();

    if (!mounted || result == null) {
      return;
    }

    setState(() {
      _scheduledPayments[index] =
          result;
    });

    _notifyChanged();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            'How will you pay this debt?',
            style: Theme.of(context)
                .textTheme
                .titleMedium,
          ),

          const SizedBox(
            height: AppSpacing.md,
          ),

          _PlanOption(
            title: 'Fixed recurring payment',
            subtitle:
                'Same amount every month',
            selected:
                _type ==
                    PaymentPlanType.recurring,
            onTap: () => _selectPlan(
              PaymentPlanType.recurring,
            ),
          ),

          const SizedBox(
            height: AppSpacing.sm,
          ),

          _PlanOption(
            title: 'One-time payment',
            subtitle: 'Single payment',
            selected:
                _type ==
                    PaymentPlanType.oneTime,
            onTap: () => _selectPlan(
              PaymentPlanType.oneTime,
            ),
          ),

          const SizedBox(
            height: AppSpacing.xl,
          ),

          if (_type ==
              PaymentPlanType.recurring)
            _RecurringSection(
              amountController:
                  _recurringAmountController,
              startController:
                  _recurringStartController,
              endController:
                  _recurringEndController,
              payments:
                  _scheduledPayments,
              onAmountChanged:
                  _updateRecurringAmount,
              onStartDateTap:
                  _selectRecurringStartDate,
              onEndDateTap:
                  _selectRecurringEndDate,
              onEditPayment:
                  _editPayment,
            ),

          if (_type ==
              PaymentPlanType.oneTime)
            _OneTimeSection(
              amountController:
                  _oneTimeAmountController,
              dateController:
                  _oneTimeDateController,
              onAmountChanged: (_) =>
                  _notifyChanged(),
              onDateTap:
                  _selectOneTimeDate,
            ),

          const SizedBox(
            height: AppSpacing.xl,
          ),
        ],
      ),
    );
  }
}

class _PlanOption extends StatelessWidget {
  const _PlanOption({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? AppColors.primaryLight
          : AppColors.surface,
      borderRadius: BorderRadius.circular(
        AppSpacing.radiusMd,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          AppSpacing.radiusMd,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(
              AppSpacing.radiusMd,
            ),
            border: Border.all(
              color: selected
                  ? AppColors.primary
                  : AppColors.border,
            ),
          ),
          child: Row(
            children: [
              Icon(
                selected
                    ? Icons.check_circle_rounded
                    : Icons
                        .radio_button_unchecked_rounded,
                color: selected
                    ? AppColors.primary
                    : AppColors.textSecondary,
                size: 21,
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
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecurringSection
    extends StatelessWidget {
  const _RecurringSection({
    required this.amountController,
    required this.startController,
    required this.endController,
    required this.payments,
    required this.onAmountChanged,
    required this.onStartDateTap,
    required this.onEndDateTap,
    required this.onEditPayment,
  });

  final TextEditingController
      amountController;
  final TextEditingController
      startController;
  final TextEditingController
      endController;
  final List<ScheduledPaymentDraft>
      payments;
  final ValueChanged<String>
      onAmountChanged;
  final VoidCallback onStartDateTap;
  final VoidCallback onEndDateTap;
  final Future<void> Function(int)
      onEditPayment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        AppTextField(
          controller: amountController,
          label: 'Monthly payment',
          keyboardType:
              const TextInputType.numberWithOptions(
            decimal: true,
          ),
          onChanged:
              onAmountChanged,
        ),

        const SizedBox(
          height: AppSpacing.md,
        ),

        AppTextField(
          controller: startController,
          label: 'Start date',
          readOnly: true,
          onTap: onStartDateTap,
          suffixIcon: const Icon(
            Icons.calendar_today_outlined,
            size: 18,
          ),
        ),

        const SizedBox(
          height: AppSpacing.md,
        ),

        AppTextField(
          controller: endController,
          label: 'End date',
          readOnly: true,
          onTap: onEndDateTap,
          suffixIcon: const Icon(
            Icons.calendar_today_outlined,
            size: 18,
          ),
        ),

        const SizedBox(
          height: AppSpacing.xl,
        ),

        Text(
          'Monthly Schedule',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(
                fontSize: 13,
              ),
        ),

        const SizedBox(
          height: AppSpacing.sm,
        ),

        ...payments.asMap().entries.map(
          (entry) {
            final index = entry.key;
            final payment = entry.value;

            return Padding(
              padding:
                  const EdgeInsets.only(
                bottom: AppSpacing.sm,
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal:
                      AppSpacing.md,
                  vertical: 10,
                ),
                decoration:
                    BoxDecoration(
                  color:
                      AppColors.surface,
                  borderRadius:
                      BorderRadius.circular(
                    AppSpacing.radiusMd,
                  ),
                  border: Border.all(
                    color:
                        AppColors.border,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration:
                          const BoxDecoration(
                        color:
                            AppColors.primary,
                        shape:
                            BoxShape.circle,
                      ),
                    ),
                    const SizedBox(
                      width:
                          AppSpacing.sm,
                    ),
                    Expanded(
                      child: Text(
                        DateFormatter
                            .short(
                          payment.date,
                        ),
                        style:
                            Theme.of(
                          context,
                        ).textTheme.bodySmall,
                      ),
                    ),
                    AmountText(
                      payment.amount,
                      style:
                          const TextStyle(
                        fontSize: 14,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),
                    IconButton(
                      onPressed: () =>
                          onEditPayment(
                        index,
                      ),
                      icon:
                          const Icon(
                        Icons
                            .edit_outlined,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _OneTimeSection
    extends StatelessWidget {
  const _OneTimeSection({
    required this.amountController,
    required this.dateController,
    required this.onAmountChanged,
    required this.onDateTap,
  });

  final TextEditingController
      amountController;
  final TextEditingController
      dateController;
  final ValueChanged<String>
      onAmountChanged;
  final VoidCallback onDateTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          controller:
              amountController,
          label: 'Payment amount',
          keyboardType:
              const TextInputType.numberWithOptions(
            decimal: true,
          ),
          onChanged:
              onAmountChanged,
        ),
        const SizedBox(
          height: AppSpacing.md,
        ),
        AppTextField(
          controller:
              dateController,
          label: 'Payment date',
          readOnly: true,
          onTap: onDateTap,
          suffixIcon: const Icon(
            Icons
                .calendar_today_outlined,
            size: 18,
          ),
        ),
      ],
    );
  }
}