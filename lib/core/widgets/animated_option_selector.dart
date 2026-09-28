import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';

class AnimatedOptionSelector<T> extends StatefulWidget {
  const AnimatedOptionSelector({
    required this.options,
    required this.labelBuilder,
    required this.iconBuilder,
    required this.onSelected,
    super.key,
    this.initialValue,
    this.collapseAfterSelection = true,
  });

  final List<T> options;
  final String Function(T option) labelBuilder;
  final IconData Function(T option) iconBuilder;
  final ValueChanged<T> onSelected;

  final T? initialValue;

  final bool collapseAfterSelection;

  @override
  State<AnimatedOptionSelector<T>> createState() =>
      _AnimatedOptionSelectorState<T>();
}

class _AnimatedOptionSelectorState<T> extends State<AnimatedOptionSelector<T>> {
  T? selected;
  bool expanded = true;

  @override
  void initState() {
    super.initState();
    selected = widget.initialValue;
    expanded = selected == null;
  }

  void _select(T option) {
    setState(() {
      selected = option;
      expanded = false;
    });

    widget.onSelected(option);
  }

  void _toggle() {
    if (!widget.collapseAfterSelection || selected == null) {
      return;
    }

    setState(() {
      expanded = !expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOut,
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        alignment: WrapAlignment.center,
        children: widget.options.map((option) {
          final isSelected = option == selected;

          final visible = expanded || isSelected;

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 260),
            switchInCurve: Curves.easeOutBack,
            switchOutCurve: Curves.easeIn,
            child: visible
                ? _OptionButton<T>(
                    key: ValueKey(option),
                    option: option,
                    label: widget.labelBuilder(option),
                    icon: widget.iconBuilder(option),
                    selected: isSelected,
                    onTap: isSelected ? _toggle : () => _select(option),
                  )
                : const SizedBox.shrink(key: ValueKey('hidden')),
          );
        }).toList(),
      ),
    );
  }
}

class _OptionButton<T> extends StatelessWidget {
  const _OptionButton({
    required this.option,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final T option;
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutBack,
      width: selected ? 150 : 108,
      height: selected ? 86 : 72,
      decoration: BoxDecoration(
        color: selected ? AppColors.primaryLight : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.border,
          width: selected ? 1.5 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                width: selected ? 36 : 30,
                height: selected ? 36 : 30,
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : AppColors.surfaceSoft,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: selected ? 20 : 17,
                  color: selected ? Colors.white : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: selected
                      ? AppColors.primaryDark
                      : AppColors.textSecondary,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
