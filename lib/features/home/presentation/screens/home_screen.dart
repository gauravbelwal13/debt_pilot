import 'package:debt_pilot/features/home/presentation/widgets/avatar_selector_sheet.dart';
import 'package:debt_pilot/features/home/presentation/widgets/debt_overview_card.dart';
import 'package:debt_pilot/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:debt_pilot/features/home/presentation/widgets/home_header.dart';
import 'package:debt_pilot/features/home/presentation/widgets/quick_actions.dart';
import 'package:debt_pilot/features/home/presentation/widgets/upcoming_payment_card.dart';
import 'package:debt_pilot/features/home/presentation/widgets/user_drawer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../presentation/widgets/profile_avatar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {
  final GlobalKey<ScaffoldState>
      _scaffoldKey =
      GlobalKey<ScaffoldState>();

  int _selectedIndex = 0;

  String _userName = 'Gaurav';

  AppAvatar _selectedAvatar =
      AppAvatar.nova;

  // Temporary UI data.
  // This will come from Drift + Riverpod later.
  final List<_UpcomingPayment>
      _upcomingPayments = [
    _UpcomingPayment(
      title: 'HDFC Personal Loan',
      date:
          DateTime(2026, 9, 24),
      amount: 12450,
      icon:
          Icons.account_balance_rounded,
    ),
    _UpcomingPayment(
      title: 'Bajaj Finance',
      date:
          DateTime(2026, 9, 28),
      amount: 4200,
      icon:
          Icons.directions_car_rounded,
    ),
    _UpcomingPayment(
      title: 'ICICI Credit Card',
      date:
          DateTime(2026, 10, 2),
      amount: 8600,
      icon:
          Icons.credit_card_rounded,
    ),
  ];

  void _onNavigationSelected(
    int index,
  ) {
    if (index == _selectedIndex) {
      return;
    }

    switch (index) {
      case 0:
        context.go('/home');
        break;

      case 1:
        context.go('/calendar');
        break;

      case 2:
        context.go('/debts');
        break;

      case 3:
        context.go('/insights');
        break;
    }
  }

  void _showSettingsMessage() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      const SnackBar(
        content: Text(
          'Settings will be connected to the profile system next.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      drawer: UserDrawer(
        userName: _userName,
        avatar: _selectedAvatar,
        onNameChanged: (name) {
          setState(() {
            _userName = name;
          });
        },
        onAvatarChanged: (avatar) {
          setState(() {
            _selectedAvatar = avatar;
          });
        },
        onSettings:
           () {
                context.push('/settings');
              },
      ),

      drawerScrimColor:
          AppColors.black.withValues(
        alpha: 0.35,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            110,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              HomeHeader(
                userName: _userName,
                onMenuTap: () {
                  _scaffoldKey
                      .currentState
                      ?.openDrawer();
                },
              ),

              const SizedBox(
                height: AppSpacing.lg,
              ),

              const DebtOverviewCard(),

              const SizedBox(
                height: AppSpacing.lg,
              ),

              HomeQuickActions(
                onAddDebt: () =>
                    context.push(
                  '/add-debt',
                ),
                onCalendar: () =>
                    context.go(
                  '/calendar',
                ),
                onScanReceipt: () {},
                onReports: () {},
              ),

              const SizedBox(
                height: AppSpacing.xxxl,
              ),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Upcoming Payments',
                      style: Theme.of(
                        context,
                      )
                          .textTheme
                          .titleMedium,
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                        context.go(
                      '/calendar',
                    ),
                    child:
                        const Text(
                      'See All',
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: AppSpacing.md,
              ),

              ..._upcomingPayments.map(
                (payment) =>
                    Padding(
                  padding:
                      const EdgeInsets.only(
                    bottom:
                        AppSpacing.md,
                  ),
                  child:
                      UpcomingPaymentCard(
                    title:
                        payment.title,
                    date:
                        payment.date,
                    amount:
                        payment.amount,
                    icon:
                        payment.icon,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton:
          FloatingActionButton(
        onPressed: () =>
            context.push(
          '/add-debt',
        ),
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
        selectedIndex:
            _selectedIndex,
        onSelected:
            _onNavigationSelected,
      ),
    );
  }
}

/// Temporary display model for the UI.
///
/// Later this will be replaced by the real payment/domain model.
class _UpcomingPayment {
  const _UpcomingPayment({
    required this.title,
    required this.date,
    required this.amount,
    required this.icon,
  });

  final String title;
  final DateTime date;
  final num amount;
  final IconData icon;
}