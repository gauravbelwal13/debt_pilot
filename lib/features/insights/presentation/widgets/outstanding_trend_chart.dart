import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../domain/models/insight_data.dart';

enum InsightRange {
  sixMonths,
  twelveMonths,
}

class OutstandingTrendChart extends StatelessWidget {
  const OutstandingTrendChart({
    required this.points,
    required this.selectedRange,
    required this.onRangeChanged,
    super.key,
  });

  final List<InsightTrendPoint> points;
  final InsightRange selectedRange;
  final ValueChanged<InsightRange> onRangeChanged;

  String _amount(double value) {
    if (value >= 100000) {
      return '₹${(value / 100000).toStringAsFixed(1)}L';
    }

    if (value >= 1000) {
      return '₹${(value / 1000).toStringAsFixed(0)}K';
    }

    return '₹${value.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final visiblePoints =
        selectedRange == InsightRange.sixMonths
            ? points.length > 6
                ? points.sublist(points.length - 6)
                : points
            : points;

    final spots = List.generate(
      visiblePoints.length,
      (index) => FlSpot(
        index.toDouble(),
        visiblePoints[index].outstanding,
      ),
    );

    final maxY = visiblePoints.fold<double>(
      0,
      (maximum, point) =>
          point.outstanding > maximum
              ? point.outstanding
              : maximum,
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
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Outstanding Debt',
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
                      'Your debt balance over time',
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
              _RangeSelector(
                selectedRange: selectedRange,
                onChanged: onRangeChanged,
              ),
            ],
          ),
          const SizedBox(
            height: AppSpacing.xl,
          ),
          SizedBox(
            height: 230,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: (visiblePoints.length - 1)
                    .toDouble(),
                minY: 0,
                maxY: maxY * 1.12,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval:
                      maxY > 0 ? maxY / 4 : 1,
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles:
                        SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles:
                        SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 42,
                      getTitlesWidget:
                          (value, meta) {
                        return Text(
                          _amount(value),
                          style: const TextStyle(
                            fontSize: 9,
                            color:
                                AppColors.textMuted,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget:
                          (value, meta) {
                        final index =
                            value.round();

                        if (index < 0 ||
                            index >=
                                visiblePoints.length) {
                          return const SizedBox();
                        }

                        return Padding(
                          padding:
                              const EdgeInsets.only(
                            top: 8,
                          ),
                          child: Text(
                            visiblePoints[index]
                                .label,
                            style:
                                const TextStyle(
                              fontSize: 9,
                              color:
                                  AppColors.textMuted,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: AppColors.primary,
                    barWidth: 3,
                    dotData: const FlDotData(
                      show: false,
                    ),
                    belowBarData:
                        BarAreaData(
                      show: true,
                      color: AppColors.primaryLight
                          .withValues(
                        alpha: 0.55,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RangeSelector extends StatelessWidget {
  const _RangeSelector({
    required this.selectedRange,
    required this.onChanged,
  });

  final InsightRange selectedRange;
  final ValueChanged<InsightRange> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        3,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(
          AppSpacing.radiusRound,
        ),
      ),
      child: Row(
        children: [
          _RangeItem(
            label: '6M',
            selected:
                selectedRange ==
                    InsightRange.sixMonths,
            onTap: () {
              onChanged(
                InsightRange.sixMonths,
              );
            },
          ),
          _RangeItem(
            label: '12M',
            selected:
                selectedRange ==
                    InsightRange.twelveMonths,
            onTap: () {
              onChanged(
                InsightRange.twelveMonths,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _RangeItem extends StatelessWidget {
  const _RangeItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 180,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.white
              : Colors.transparent,
          borderRadius: BorderRadius.circular(
            AppSpacing.radiusRound,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(
                color: selected
                    ? AppColors.primary
                    : AppColors.textSecondary,
                fontWeight:
                    FontWeight.w700,
              ),
        ),
      ),
    );
  }
}