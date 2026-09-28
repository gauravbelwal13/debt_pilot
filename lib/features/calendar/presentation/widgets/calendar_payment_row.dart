import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/amount_text.dart';
import '../../domain/models/calendar_payment.dart';

class CalendarPaymentRow extends StatelessWidget {
  const CalendarPaymentRow({
    required this.payment,
    required this.onTap,
    super.key,
  });

  final CalendarPayment payment;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final status = payment.status(
      DateTime.now(),
    );

    final color = _statusColor(status);
    final icon = _statusIcon(status);
    final label = _statusLabel(status);

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(
        AppSpacing.radiusMd,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          AppSpacing.radiusMd,
        ),
        child: Container(
          padding: const EdgeInsets.all(
            AppSpacing.md,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              AppSpacing.radiusMd,
            ),
            border: Border.all(
              color: AppColors.border,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 19,
                  color: color,
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
                      payment.debtName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                            fontSize: 13,
                          ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      payment.lender,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      label,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                            color: color,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: AppSpacing.sm,
              ),
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.end,
                children: [
                  AmountText(
                    payment.amount,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: AppColors.textMuted,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _statusColor(
    CalendarPaymentStatus status,
  ) {
    switch (status) {
      case CalendarPaymentStatus.paid:
        return AppColors.success;
      case CalendarPaymentStatus.upcoming:
        return AppColors.blue;
      case CalendarPaymentStatus.overdue:
        return AppColors.error;
    }
  }

  IconData _statusIcon(
    CalendarPaymentStatus status,
  ) {
    switch (status) {
      case CalendarPaymentStatus.paid:
        return Icons.check_rounded;
      case CalendarPaymentStatus.upcoming:
        return Icons.schedule_rounded;
      case CalendarPaymentStatus.overdue:
        return Icons.warning_amber_rounded;
    }
  }

  String _statusLabel(
    CalendarPaymentStatus status,
  ) {
    switch (status) {
      case CalendarPaymentStatus.paid:
        return 'Paid';
      case CalendarPaymentStatus.upcoming:
        return 'Upcoming';
      case CalendarPaymentStatus.overdue:
        return 'Overdue';
    }
  }
}