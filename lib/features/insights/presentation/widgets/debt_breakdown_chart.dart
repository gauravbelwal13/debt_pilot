import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../domain/models/insight_data.dart';

class DebtBreakdownChart extends StatelessWidget {
  const DebtBreakdownChart({
    required this.items,
    super.key,
  });

  final List<InsightDebtCategory> items;

  List<Color> get _colors {
    return const [
      AppColors.primary,
      AppColors.blue,
      AppColors.purple,
      AppColors.orange,
      AppColors.error,
      AppColors.info,
    ];
  }

  String _amount(double amount) {
    return '₹${amount.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final total = items.fold<double>(
      0,
      (sum, item) => sum + item.amount,
    );

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
            'Debt Breakdown',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(
                  fontWeight:
                      FontWeight.w800,
                ),
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            'Outstanding balance by debt type',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(
                  color:
                      AppColors.textSecondary,
                ),
          ),
          const SizedBox(
            height: AppSpacing.xl,
          ),
          SizedBox(
            height: 230,
            child: PieChart(
              PieChartData(
                centerSpaceRadius: 55,
                sectionsSpace: 3,
                sections: List.generate(
                  items.length,
                  (index) {
                    final item =
                        items[index];

                    final percentage =
                        total <= 0
                            ? 0
                            : item.amount /
                                total *
                                100;

                    return PieChartSectionData(
                      value: item.amount,
                      color:
                          _colors[index %
                              _colors.length],
                      radius: 70,
                      title:
                          '${percentage.round()}%',
                      titleStyle:
                          const TextStyle(
                        color:
                            AppColors.white,
                        fontSize: 11,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(
            height: AppSpacing.lg,
          ),
          ...List.generate(
            items.length,
            (index) {
              final item = items[index];

              return Padding(
                padding:
                    const EdgeInsets.only(
                  bottom: AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color:
                            _colors[index %
                                _colors.length],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(
                      width: AppSpacing.sm,
                    ),
                    Expanded(
                      child: Text(
                        item.name,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                              fontWeight:
                                  FontWeight.w600,
                            ),
                      ),
                    ),
                    Text(
                      _amount(item.amount),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                            fontWeight:
                                FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}