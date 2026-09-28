import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_dropdown.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../models/add_debt_draft.dart';
import '../widgets/debt_type_grid.dart';
import '../widgets/lender_selector.dart';

class AddDebtDetailsStep extends StatefulWidget {
  const AddDebtDetailsStep({
    required this.initial,
    required this.onChanged,
    super.key,
  });

  final DebtDetailsDraft initial;
  final ValueChanged<DebtDetailsDraft> onChanged;

  @override
  State<AddDebtDetailsStep> createState() =>
      _AddDebtDetailsStepState();
}

class _AddDebtDetailsStepState
    extends State<AddDebtDetailsStep> {
  late DebtType _type;
  late DateTime _startDate;
  late String _lender;

  late final TextEditingController _amountController;
  late final TextEditingController _durationController;
  late final TextEditingController _dateController;

  @override
  void initState() {
    super.initState();

    _type = widget.initial.type;
    _startDate = widget.initial.startDate;
    _lender = widget.initial.lender;

    _amountController = TextEditingController(
      text: CurrencyFormatter.format(
        widget.initial.amountBorrowed,
      ),
    );

    _durationController = TextEditingController(
      text: widget.initial.durationMonths.toString(),
    );

    _dateController = TextEditingController(
      text: DateFormatter.short(_startDate),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _durationController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _notifyChanged() {
    widget.onChanged(
      DebtDetailsDraft(
        type: _type,
        amountBorrowed: _parseAmount(),
        startDate: _startDate,
        durationMonths:
            int.tryParse(
              _durationController.text,
            ) ??
            0,
        lender: _lender,
      ),
    );
  }

  double _parseAmount() {
    return double.tryParse(
          _amountController.text
              .replaceAll('₹', '')
              .replaceAll(',', '')
              .trim(),
        ) ??
        0;
  }

  Future<void> _selectDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selected == null) return;

    setState(() {
      _startDate = selected;
      _dateController.text = DateFormatter.short(selected);
    });

    _notifyChanged();
  }

  void _changeType(DebtType type) {
    setState(() {
      _type = type;
      _lender = '';
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What kind of debt?',
            style: Theme.of(context).textTheme.titleMedium,
          ),

          const SizedBox(
            height: AppSpacing.md,
          ),

          DebtTypeGrid(
            selected: _type,
            onSelected: _changeType,
          ),

          const SizedBox(
            height: AppSpacing.lg,
          ),

          AppTextField(
            controller: _amountController,
            label: 'Amount borrowed',
            keyboardType:
                const TextInputType.numberWithOptions(
              decimal: true,
            ),
            onChanged: (_) => _notifyChanged(),
          ),

          const SizedBox(
            height: AppSpacing.md,
          ),

          AppTextField(
            controller: _dateController,
            label: 'Start date',
            readOnly: true,
            onTap: _selectDate,
            suffixIcon: const Icon(
              Icons.calendar_today_outlined,
              size: 18,
            ),
          ),

          const SizedBox(
            height: AppSpacing.md,
          ),

          AppDropdown<int>(
            label: 'Duration',
            value: int.tryParse(
              _durationController.text,
            ),
            items: const [
              DropdownMenuItem(
                value: 6,
                child: Text('6 Months'),
              ),
              DropdownMenuItem(
                value: 12,
                child: Text('12 Months'),
              ),
              DropdownMenuItem(
                value: 18,
                child: Text('18 Months'),
              ),
              DropdownMenuItem(
                value: 24,
                child: Text('24 Months'),
              ),
              DropdownMenuItem(
                value: 36,
                child: Text('36 Months'),
              ),
              DropdownMenuItem(
                value: 48,
                child: Text('48 Months'),
              ),
              DropdownMenuItem(
                value: 60,
                child: Text('60 Months'),
              ),
            ],
            onChanged: (value) {
              if (value == null) return;

              setState(() {
                _durationController.text =
                    value.toString();
              });

              _notifyChanged();
            },
          ),

          const SizedBox(
            height: AppSpacing.md,
          ),

          LenderSelector(
            type: _type,
            value: _lender,
            onChanged: (value) {
              setState(() {
                _lender = value;
              });

              _notifyChanged();
            },
          ),

          const SizedBox(
            height: AppSpacing.xl,
          ),
        ],
      ),
    );
  }
}