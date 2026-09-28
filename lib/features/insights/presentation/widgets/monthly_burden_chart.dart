import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../domain/models/insight_data.dart';

class MonthlyBurdenChart extends StatelessWidget {
  const MonthlyBurdenChart({
    required this.points,
    super.key,
  });

  final List<InsightBurdenPoint> points;

  String _amount(double value) {
    if (value >= 1000) {
      return '₹${(value / 1000).toStringAsFixed(0)}K';
    }

    return '₹${value.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final maxY = points.fold<double>(
      0,
      (maximum, point) =>
          point.amount > maximum
              ? point.amount
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
          Text(
            'Monthly Debt Burden',
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
            'Amount scheduled each month',
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
            child: BarChart(
              BarChartData(
                maxY: maxY * 1.2,
                minY: 0,
                borderData: FlBorderData(
                  show: false,
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval:
                      maxY > 0 ? maxY / 4 : 1,
                ),
                barTouchData: BarTouchData(
                  enabled: true,
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
                      getTitlesWidget:
                          (value, meta) {
                        final index =
                            value.round();

                        if (index < 0 ||
                            index >=
                                points.length) {
                          return const SizedBox();
                        }

                        return Padding(
                          padding:
                              const EdgeInsets.only(
                            top: 8,
                          ),
                          child: Text(
                            points[index].label,
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
                barGroups:
                    List.generate(
                  points.length,
                  (index) {
                    final point =
                        points[index];

                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: point.amount,
                          width: 18,
                          borderRadius:
                              BorderRadius.circular(
                            5,
                          ),
                          color:
                              AppColors.blue,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}