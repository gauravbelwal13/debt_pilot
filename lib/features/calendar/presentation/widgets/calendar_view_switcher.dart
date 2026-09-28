import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';

enum CalendarViewMode {
  month,
  week,
  agenda,
}

class CalendarViewSwitcher extends StatelessWidget {
  const CalendarViewSwitcher({
    required this.selectedView,
    required this.onChanged,
    super.key,
  });

  final CalendarViewMode selectedView;
  final ValueChanged<CalendarViewMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
      ),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(
          AppSpacing.radiusRound,
        ),
      ),
      child: Row(
        children: [
          _ViewItem(
            label: 'Month',
            value: CalendarViewMode.month,
            selectedView: selectedView,
            onChanged: onChanged,
          ),
          _ViewItem(
            label: 'Week',
            value: CalendarViewMode.week,
            selectedView: selectedView,
            onChanged: onChanged,
          ),
          _ViewItem(
            label: 'Agenda',
            value: CalendarViewMode.agenda,
            selectedView: selectedView,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _ViewItem extends StatelessWidget {
  const _ViewItem({
    required this.label,
    required this.value,
    required this.selectedView,
    required this.onChanged,
  });

  final String label;
  final CalendarViewMode value;
  final CalendarViewMode selectedView;
  final ValueChanged<CalendarViewMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final selected = value == selectedView;

    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(value),
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 180,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.surface
                : Colors.transparent,
            borderRadius: BorderRadius.circular(
              AppSpacing.radiusRound,
            ),
            boxShadow: selected
                ? const [
                    BoxShadow(
                      color: Color(0x0A15211E),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: selected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  fontWeight: selected
                      ? FontWeight.w800
                      : FontWeight.w600,
                ),
          ),
        ),
      ),
    );
  }
}