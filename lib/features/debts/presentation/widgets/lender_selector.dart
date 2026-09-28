import 'package:debt_pilot/features/debts/presentation/models/lender_catalog.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/app_dropdown.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../models/add_debt_draft.dart';

class LenderSelector extends StatefulWidget {
  const LenderSelector({
    required this.type,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final DebtType type;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  State<LenderSelector> createState() => _LenderSelectorState();
}

class _LenderSelectorState extends State<LenderSelector> {
  late List<String> _options;

  static const _addNewValue = '__add_new__';

  @override
  void initState() {
    super.initState();
    _options = LenderCatalog.optionsFor(widget.type);
  }

  @override
  void didUpdateWidget(covariant LenderSelector oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.type != widget.type) {
      _options = LenderCatalog.optionsFor(widget.type);
    }
  }

  Future<void> _addNewLender() async {
    final controller = TextEditingController();

    final value = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add new lender'),
          content: AppTextField(
            controller: controller,
            label: 'Name',
            hint: 'Enter lender or provider name',
            textInputAction: TextInputAction.done,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final name = controller.text.trim();

                if (name.isEmpty) return;

                Navigator.pop(context, name);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (!mounted || value == null) return;

    final name = value.trim();

    if (name.isEmpty) return;

    setState(() {
      if (!_options.contains(name)) {
        _options = [
          ..._options,
          name,
        ];
      }
    });

    widget.onChanged(name);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == DebtType.friendFamily) {
      return AppTextField(
        label: 'Person / Family member',
        hint: 'e.g. Rahul',
        prefixIcon: const Icon(
          Icons.person_outline_rounded,
        ),
        onChanged: widget.onChanged,
      );
    }

    if (widget.type == DebtType.other) {
      return AppTextField(
        label: 'Lender / Provider',
        hint: 'Enter name',
        prefixIcon: const Icon(
          Icons.business_outlined,
        ),
        onChanged: widget.onChanged,
      );
    }

    final selectedValue =
        _options.contains(widget.value)
            ? widget.value
            : null;

    return AppDropdown<String>(
      label: _labelFor(widget.type),
      value: selectedValue,
      prefixIcon: const Icon(
        Icons.account_balance_rounded,
      ),
      items: [
        ..._options.map(
          (name) => DropdownMenuItem<String>(
            value: name,
            child: Text(name),
          ),
        ),
        const DropdownMenuItem<String>(
          value: _addNewValue,
          child: Row(
            children: [
              Icon(
                Icons.add_rounded,
                size: 18,
              ),
              SizedBox(width: 8),
              Text('Add New'),
            ],
          ),
        ),
      ],
      onChanged: (value) {
        if (value == _addNewValue) {
          _addNewLender();
          return;
        }

        if (value != null) {
          widget.onChanged(value);
        }
      },
    );
  }

  String _labelFor(DebtType type) {
    switch (type) {
      case DebtType.personalLoan:
        return 'Loan App';

      case DebtType.creditCard:
      case DebtType.vehicleLoan:
      case DebtType.educationLoan:
        return 'Bank Name';

      case DebtType.friendFamily:
        return 'Person / Family member';

      case DebtType.other:
        return 'Lender / Provider';
    }
  }
}