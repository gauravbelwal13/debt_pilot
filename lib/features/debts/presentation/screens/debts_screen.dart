import 'package:debt_pilot/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../domain/models/debt.dart';
import '../../domain/models/debt_payment.dart';

enum DebtFilter {
  all,
  ongoing,
  completed,
}

class DebtsScreen extends StatefulWidget {
  const DebtsScreen({
    super.key,
  });

  @override
  State<DebtsScreen> createState() =>
      _DebtsScreenState();
}

class _DebtsScreenState
    extends State<DebtsScreen> {
  DebtFilter _selectedFilter =
      DebtFilter.all;

  late final List<Debt> _debts;

  @override
  void initState() {
    super.initState();
    _debts = _buildMockDebts();
  }

  List<Debt> get _filteredDebts {
    switch (_selectedFilter) {
      case DebtFilter.all:
        return _debts;

      case DebtFilter.ongoing:
        return _debts
            .where(
              (debt) =>
                  debt.status ==
                  DebtStatus.ongoing,
            )
            .toList();

      case DebtFilter.completed:
        return _debts
            .where(
              (debt) =>
                  debt.status ==
                  DebtStatus.completed,
            )
            .toList();
    }
  }

  double get _totalOutstanding {
    return _debts.fold(
      0,
      (total, debt) =>
          total + debt.outstandingAmount,
    );
  }

  double get _totalOriginal {
    return _debts.fold(
      0,
      (total, debt) =>
          total + debt.originalAmount,
    );
  }

  int get _ongoingCount {
    return _debts
        .where(
          (debt) =>
              debt.status ==
              DebtStatus.ongoing,
        )
        .length;
  }

  int get _completedCount {
    return _debts
        .where(
          (debt) =>
              debt.status ==
              DebtStatus.completed,
        )
        .length;
  }

  void _onNavigationSelected(int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;

      case 1:
        context.go('/calendar');
        break;

      case 2:
        return;

      case 3:
        context.go('/insights');
        break;
    }
  }

  void _openDebt(Debt debt) {
    context.push(
      '/debts/${debt.id}',
      extra: debt,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            110,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              _DebtOverview(
                totalOutstanding:
                    _totalOutstanding,
                totalOriginal: _totalOriginal,
                ongoingCount:
                    _ongoingCount,
                completedCount:
                    _completedCount,
              ),

              const SizedBox(
                height: AppSpacing.xxl,
              ),

              _DebtFilterTabs(
                selectedFilter:
                    _selectedFilter,
                onChanged: (filter) {
                  setState(() {
                    _selectedFilter =
                        filter;
                  });
                },
                allCount:
                    _debts.length,
                ongoingCount:
                    _ongoingCount,
                completedCount:
                    _completedCount,
              ),

              const SizedBox(
                height: AppSpacing.lg,
              ),

              ..._filteredDebts.map(
                (debt) => Padding(
                  padding:
                      const EdgeInsets.only(
                    bottom:
                        AppSpacing.md,
                  ),
                  child: _DebtCard(
                    debt: debt,
                    onTap: () {
                      _openDebt(debt);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton:
          FloatingActionButton(
        onPressed: () {
          context.push('/add-debt');
        },
        backgroundColor:
            AppColors.primary,
        foregroundColor:
            AppColors.white,
        elevation: 4,
        child: const Icon(
          Icons.add_rounded,
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation
              .centerDocked,
      bottomNavigationBar:
          HomeBottomNavBar(
        selectedIndex: 2,
        onSelected:
            _onNavigationSelected,
      ),
    );
  }

  List<Debt> _buildMockDebts() {
    final today = DateTime.now();

    return [
      Debt(
        id: 'debt-hdfc-personal',
        name: 'HDFC Personal Loan',
        lender: 'HDFC Bank',
        type: DebtType.personalLoan,
        originalAmount: 150000,
        outstandingAmount: 124500,
        startDate:
            DateTime(2026, 1, 12),
        durationMonths: 24,
        payments: [
          DebtPayment(
            id: 'hdfc-aug',
            debtId:
                'debt-hdfc-personal',
            dueDate:
                DateTime(2026, 8, 8),
            amount: 7100,
            isPaid: true,
            paidDate:
                DateTime(2026, 8, 8),
          ),
          DebtPayment(
            id: 'hdfc-sep',
            debtId:
                'debt-hdfc-personal',
            dueDate:
                DateTime(2026, 9, 8),
            amount: 7100,
            isPaid: true,
            paidDate:
                DateTime(2026, 9, 8),
          ),
          DebtPayment(
            id: 'hdfc-oct',
            debtId:
                'debt-hdfc-personal',
            dueDate:
                DateTime(2026, 10, 8),
            amount: 7100,
            isPaid: false,
          ),
          DebtPayment(
            id: 'hdfc-nov',
            debtId:
                'debt-hdfc-personal',
            dueDate:
                DateTime(2026, 11, 8),
            amount: 7100,
            isPaid: false,
          ),
          DebtPayment(
            id: 'hdfc-dec',
            debtId:
                'debt-hdfc-personal',
            dueDate:
                DateTime(2026, 12, 8),
            amount: 7100,
            isPaid: false,
          ),
        ],
      ),
      Debt(
        id: 'debt-icici-card',
        name: 'ICICI Credit Card',
        lender: 'ICICI Bank',
        type: DebtType.creditCard,
        originalAmount: 85000,
        outstandingAmount: 8500,
        startDate:
            DateTime(2026, 4, 3),
        durationMonths: 12,
        payments: [
          DebtPayment(
            id: 'icici-aug',
            debtId:
                'debt-icici-card',
            dueDate:
                DateTime(2026, 8, 3),
            amount: 8500,
            isPaid: true,
            paidDate:
                DateTime(2026, 8, 3),
          ),
          DebtPayment(
            id: 'icici-sep',
            debtId:
                'debt-icici-card',
            dueDate:
                DateTime(2026, 9, 3),
            amount: 8500,
            isPaid: false,
          ),
          DebtPayment(
            id: 'icici-oct',
            debtId:
                'debt-icici-card',
            dueDate:
                DateTime(2026, 10, 3),
            amount: 8500,
            isPaid: false,
          ),
        ],
      ),
      Debt(
        id: 'debt-bajaj-vehicle',
        name: 'Bajaj Vehicle Finance',
        lender: 'Bajaj Finance',
        type: DebtType.vehicleLoan,
        originalAmount: 350000,
        outstandingAmount: 210000,
        startDate:
            DateTime(2025, 12, 15),
        durationMonths: 36,
        payments: [
          DebtPayment(
            id: 'bajaj-aug',
            debtId:
                'debt-bajaj-vehicle',
            dueDate:
                DateTime(2026, 8, 15),
            amount: 12500,
            isPaid: true,
            paidDate:
                DateTime(2026, 8, 15),
          ),
          DebtPayment(
            id: 'bajaj-sep',
            debtId:
                'debt-bajaj-vehicle',
            dueDate:
                DateTime(2026, 9, 15),
            amount: 12500,
            isPaid: true,
            paidDate:
                DateTime(2026, 9, 15),
          ),
          DebtPayment(
            id: 'bajaj-oct',
            debtId:
                'debt-bajaj-vehicle',
            dueDate:
                DateTime(2026, 10, 15),
            amount: 12500,
            isPaid: false,
          ),
          DebtPayment(
            id: 'bajaj-nov',
            debtId:
                'debt-bajaj-vehicle',
            dueDate:
                DateTime(2026, 11, 15),
            amount: 12500,
            isPaid: false,
          ),
        ],
      ),
      Debt(
        id: 'debt-family',
        name: 'Family Loan',
        lender: 'Family',
        type: DebtType.friendFamily,
        originalAmount: 50000,
        outstandingAmount: 0,
        startDate:
            DateTime(2026, 1, 10),
        durationMonths: 5,
        payments: [
          DebtPayment(
            id: 'family-jan',
            debtId: 'debt-family',
            dueDate:
                DateTime(2026, 1, 10),
            amount: 10000,
            isPaid: true,
            paidDate:
                DateTime(2026, 1, 10),
          ),
          DebtPayment(
            id: 'family-feb',
            debtId: 'debt-family',
            dueDate:
                DateTime(2026, 2, 10),
            amount: 10000,
            isPaid: true,
            paidDate:
                DateTime(2026, 2, 10),
          ),
          DebtPayment(
            id: 'family-mar',
            debtId: 'debt-family',
            dueDate:
                DateTime(2026, 3, 10),
            amount: 10000,
            isPaid: true,
            paidDate:
                DateTime(2026, 3, 10),
          ),
          DebtPayment(
            id: 'family-apr',
            debtId: 'debt-family',
            dueDate:
                DateTime(2026, 4, 10),
            amount: 10000,
            isPaid: true,
            paidDate:
                DateTime(2026, 4, 10),
          ),
          DebtPayment(
            id: 'family-may',
            debtId: 'debt-family',
            dueDate:
                DateTime(2026, 5, 10),
            amount: 10000,
            isPaid: true,
            paidDate:
                DateTime(2026, 5, 10),
          ),
        ],
      ),
      Debt(
        id: 'debt-education',
        name: 'Education Loan',
        lender: 'SBI',
        type: DebtType.educationLoan,
        originalAmount: 200000,
        outstandingAmount: 175000,
        startDate:
            DateTime(2026, 3, 20),
        durationMonths: 30,
        payments: [
          DebtPayment(
            id: 'education-jul',
            debtId:
                'debt-education',
            dueDate:
                DateTime(2026, 7, 20),
            amount: 9000,
            isPaid: true,
            paidDate:
                DateTime(2026, 7, 20),
          ),
          DebtPayment(
            id: 'education-aug',
            debtId:
                'debt-education',
            dueDate:
                DateTime(2026, 8, 20),
            amount: 9000,
            isPaid: true,
            paidDate:
                DateTime(2026, 8, 20),
          ),
          DebtPayment(
            id: 'education-sep',
            debtId:
                'debt-education',
            dueDate: DateTime(
              today.year,
              today.month,
              20,
            ),
            amount: 9000,
            isPaid: false,
          ),
          DebtPayment(
            id: 'education-oct',
            debtId:
                'debt-education',
            dueDate:
                DateTime(2026, 10, 20),
            amount: 9000,
            isPaid: false,
          ),
        ],
      ),
    ];
  }
}

class _DebtOverview extends StatelessWidget {
  const _DebtOverview({
    required this.totalOutstanding,
    required this.totalOriginal,
    required this.ongoingCount,
    required this.completedCount,
  });

  final double totalOutstanding;
  final double totalOriginal;
  final int ongoingCount;
  final int completedCount;

  String _formatAmount(double amount) {
    return '₹${amount.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final paidAmount =
        totalOriginal - totalOutstanding;

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius:
            BorderRadius.circular(
          AppSpacing.radiusLg,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            'Total Outstanding',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(
                  color:
                      AppColors.white.withValues(
                    alpha: 0.78,
                  ),
                ),
          ),
          const SizedBox(
            height: AppSpacing.xs,
          ),
          Text(
            _formatAmount(
              totalOutstanding,
            ),
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(
                  color: AppColors.white,
                  fontWeight:
                      FontWeight.w800,
                ),
          ),
          const SizedBox(
            height: AppSpacing.xs,
          ),
          Text(
            '${_formatAmount(paidAmount)} already paid',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(
                  color:
                      AppColors.white.withValues(
                    alpha: 0.72,
                  ),
                ),
          ),
          const SizedBox(
            height: AppSpacing.xl,
          ),
          Row(
            children: [
              Expanded(
                child: _OverviewMetric(
                  label: 'Ongoing',
                  value:
                      '$ongoingCount',
                ),
              ),
              Expanded(
                child: _OverviewMetric(
                  label: 'Completed',
                  value:
                      '$completedCount',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OverviewMetric
    extends StatelessWidget {
  const _OverviewMetric({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color:
                AppColors.white.withValues(
              alpha: 0.15,
            ),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.account_balance_wallet_rounded,
            size: 18,
            color: AppColors.white,
          ),
        ),
        const SizedBox(
          width: AppSpacing.sm,
        ),
        Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                    color:
                        AppColors.white,
                    fontWeight:
                        FontWeight.w800,
                  ),
            ),
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                    color:
                        AppColors.white.withValues(
                      alpha: 0.70,
                    ),
                  ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DebtFilterTabs
    extends StatelessWidget {
  const _DebtFilterTabs({
    required this.selectedFilter,
    required this.onChanged,
    required this.allCount,
    required this.ongoingCount,
    required this.completedCount,
  });

  final DebtFilter selectedFilter;
  final ValueChanged<DebtFilter>
      onChanged;

  final int allCount;
  final int ongoingCount;
  final int completedCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.all(
        AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color:
            AppColors.surfaceSoft,
        borderRadius:
            BorderRadius.circular(
          AppSpacing.radiusMd,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _FilterItem(
              label: 'All',
              count: allCount,
              selected:
                  selectedFilter ==
                      DebtFilter.all,
              onTap: () {
                onChanged(
                  DebtFilter.all,
                );
              },
            ),
          ),
          Expanded(
            child: _FilterItem(
              label: 'Ongoing',
              count: ongoingCount,
              selected:
                  selectedFilter ==
                      DebtFilter.ongoing,
              onTap: () {
                onChanged(
                  DebtFilter.ongoing,
                );
              },
            ),
          ),
          Expanded(
            child: _FilterItem(
              label: 'Completed',
              count:
                  completedCount,
              selected:
                  selectedFilter ==
                      DebtFilter.completed,
              onTap: () {
                onChanged(
                  DebtFilter.completed,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterItem
    extends StatelessWidget {
  const _FilterItem({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration:
            const Duration(
          milliseconds: 200,
        ),
        padding:
            const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
        ),
        decoration:
            BoxDecoration(
          color: selected
              ? AppColors.surface
              : Colors.transparent,
          borderRadius:
              BorderRadius.circular(
            AppSpacing.radiusSm,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color:
                        AppColors.black
                            .withValues(
                      alpha: 0.05,
                    ),
                    blurRadius: 8,
                    offset:
                        const Offset(
                      0,
                      2,
                    ),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                    color: selected
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    fontWeight:
                        selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                  ),
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              '$count',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                    color: selected
                        ? AppColors.primary
                        : AppColors.textMuted,
                    fontWeight:
                        FontWeight.w700,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DebtCard
    extends StatelessWidget {
  const _DebtCard({
    required this.debt,
    required this.onTap,
  });

  final Debt debt;
  final VoidCallback onTap;

  String _formatAmount(
    double amount,
  ) {
    return '₹${amount.toStringAsFixed(0)}';
  }

  String _formatDate(
    DateTime date,
  ) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${date.day} '
        '${months[date.month - 1]}';
  }

  Color get _statusColor {
    return debt.status ==
            DebtStatus.completed
        ? AppColors.success
        : AppColors.primary;
  }

  String get _statusLabel {
    return debt.status ==
            DebtStatus.completed
        ? 'Completed'
        : 'Ongoing';
  }

  @override
  Widget build(BuildContext context) {
    final nextPayment =
        debt.nextPayment(
      DateTime.now(),
    );

    return Material(
      color: AppColors.surface,
      borderRadius:
          BorderRadius.circular(
        AppSpacing.radiusLg,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(
          AppSpacing.radiusLg,
        ),
        child: Container(
          padding:
              const EdgeInsets.all(
            AppSpacing.lg,
          ),
          decoration:
              BoxDecoration(
            border: Border.all(
              color: AppColors.border,
            ),
            borderRadius:
                BorderRadius.circular(
              AppSpacing.radiusLg,
            ),
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration:
                        BoxDecoration(
                      color: _statusColor
                          .withValues(
                        alpha: 0.10,
                      ),
                      borderRadius:
                          BorderRadius.circular(
                        AppSpacing.radiusMd,
                      ),
                    ),
                    child: Icon(
                      debt.type ==
                              DebtType.creditCard
                          ? Icons
                              .credit_card_rounded
                          : debt.type ==
                                  DebtType
                                      .vehicleLoan
                              ? Icons
                                  .directions_car_rounded
                              : debt.type ==
                                      DebtType
                                          .friendFamily
                                  ? Icons
                                      .people_rounded
                                  : Icons
                                      .account_balance_rounded,
                      color:
                          _statusColor,
                    ),
                  ),
                  const SizedBox(
                    width: AppSpacing.md,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Text(
                          debt.name,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                fontWeight:
                                    FontWeight.w800,
                              ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          debt.lender,
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
                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal:
                          AppSpacing.sm,
                      vertical:
                          AppSpacing.xs,
                    ),
                    decoration:
                        BoxDecoration(
                      color: _statusColor
                          .withValues(
                        alpha: 0.10,
                      ),
                      borderRadius:
                          BorderRadius.circular(
                        AppSpacing.radiusRound,
                      ),
                    ),
                    child: Text(
                      _statusLabel,
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(
                            color:
                                _statusColor,
                            fontWeight:
                                FontWeight.w700,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: AppSpacing.xl,
              ),
              Text(
                'Outstanding',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(
                      color:
                          AppColors.textSecondary,
                    ),
              ),
              const SizedBox(
                height: 2,
              ),
              Text(
                _formatAmount(
                  debt.outstandingAmount,
                ),
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(
                      fontWeight:
                          FontWeight.w800,
                    ),
              ),
              const SizedBox(
                height: AppSpacing.md,
              ),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(
                        AppSpacing.radiusRound,
                      ),
                      child:
                          LinearProgressIndicator(
                        value: debt.progress,
                        minHeight: 7,
                        backgroundColor:
                            AppColors.surfaceSoft,
                        valueColor:
                            AlwaysStoppedAnimation(
                          _statusColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: AppSpacing.sm,
                  ),
                  Text(
                    '${(debt.progress * 100).round()}%',
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
              const SizedBox(
                height: AppSpacing.md,
              ),
              Row(
                children: [
                  Expanded(
                    child: _DebtMeta(
                      label: 'Original',
                      value:
                          _formatAmount(
                        debt.originalAmount,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _DebtMeta(
                      label: 'Paid',
                      value:
                          _formatAmount(
                        debt.paidAmount,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _DebtMeta(
                      label: 'Type',
                      value: debt.typeLabel,
                    ),
                  ),
                ],
              ),
              if (nextPayment !=
                  null) ...[
                const SizedBox(
                  height: AppSpacing.lg,
                ),
                const Divider(
                  color:
                      AppColors.divider,
                ),
                const SizedBox(
                  height: AppSpacing.md,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.event_rounded,
                      size: 18,
                      color:
                          AppColors.textSecondary,
                    ),
                    const SizedBox(
                      width: AppSpacing.sm,
                    ),
                    Text(
                      'Next payment',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                            color:
                                AppColors.textSecondary,
                          ),
                    ),
                    const Spacer(),
                    Text(
                      '${_formatAmount(nextPayment.amount)} · ${_formatDate(nextPayment.dueDate)}',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                            fontWeight:
                                FontWeight.w700,
                          ),
                    ),
                    const SizedBox(
                      width: AppSpacing.xs,
                    ),
                    const Icon(
                      Icons
                          .chevron_right_rounded,
                      size: 20,
                      color:
                          AppColors.textMuted,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DebtMeta
    extends StatelessWidget {
  const _DebtMeta({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(
                color:
                    AppColors.textMuted,
              ),
        ),
        const SizedBox(
          height: 2,
        ),
        Text(
          value,
          maxLines: 1,
          overflow:
              TextOverflow.ellipsis,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(
                fontWeight:
                    FontWeight.w700,
              ),
        ),
      ],
    );
  }
}