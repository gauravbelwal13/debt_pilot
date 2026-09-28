import 'package:debt_pilot/features/about/presentation/screens/about_screen.dart';
import 'package:debt_pilot/features/calendar/presentation/screens/calendar_screen.dart';
import 'package:debt_pilot/features/debts/domain/models/debt.dart';
import 'package:debt_pilot/features/debts/presentation/add_debt_flow_screen.dart';
import 'package:debt_pilot/features/debts/presentation/screens/debt_detail_screen.dart';
import 'package:debt_pilot/features/debts/presentation/screens/debts_screen.dart';
import 'package:debt_pilot/features/home/presentation/screens/home_screen.dart';
import 'package:debt_pilot/features/insights/presentation/screens/insights_screen.dart';
import 'package:debt_pilot/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:debt_pilot/features/onboarding/presentation/screens/welcome_screen.dart';
import 'package:debt_pilot/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

CustomTransitionPage<void> _rightToLeftTransition({
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    child: child,
    transitionDuration: const Duration(
      milliseconds: 350,
    ),
    reverseTransitionDuration: const Duration(
      milliseconds: 300,
    ),
    transitionsBuilder: (
      context,
      animation,
      secondaryAnimation,
      child,
    ) {
      final offsetAnimation = Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        ),
      );

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      pageBuilder: (context, state) {
        return _rightToLeftTransition(
          child: const SplashScreen(),
        );
      },
    ),

    GoRoute(
      path: '/welcome',
      name: 'welcome',
      pageBuilder: (context, state) {
        return _rightToLeftTransition(
          child: const WelcomeScreen(),
        );
      },
    ),

    GoRoute(
      path: '/home',
      name: 'home',
      pageBuilder: (context, state) {
        return _rightToLeftTransition(
          child: const HomeScreen(),
        );
      },
    ),

    GoRoute(
      path: '/calendar',
      name: 'calendar',
      pageBuilder: (context, state) {
        return _rightToLeftTransition(
          child: const CalendarScreen(),
        );
      },
    ),

    GoRoute(
      path: '/debts',
      name: 'debts',
      pageBuilder: (context, state) {
        return _rightToLeftTransition(
          child: const DebtsScreen(),
        );
      },
    ),

    GoRoute(
      path: '/debts/:debtId',
      name: 'debt-detail',
      pageBuilder: (context, state) {
        final debt = state.extra! as Debt;

        return _rightToLeftTransition(
          child: DebtDetailScreen(
            debt: debt,
          ),
        );
      },
    ),

    GoRoute(
      path: '/insights',
      name: 'insights',
      pageBuilder: (context, state) {
        return _rightToLeftTransition(
          child: const InsightsScreen(),
        );
      },
    ),

    GoRoute(
      path: '/settings',
      name: 'settings',
      pageBuilder: (context, state) {
        return _rightToLeftTransition(
          child: const SettingsScreen(),
        );
      },
    ),

    GoRoute(
      path: '/about',
      name: 'about',
      pageBuilder: (context, state) {
        return _rightToLeftTransition(
          child: const AboutScreen(),
        );
      },
    ),

    GoRoute(
      path: '/add-debt',
      name: 'add-debt',
      pageBuilder: (context, state) {
        return _rightToLeftTransition(
          child: const AddDebtFlowScreen(),
        );
      },
    ),
  ],
);