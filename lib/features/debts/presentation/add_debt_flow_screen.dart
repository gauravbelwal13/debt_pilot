import 'package:debt_pilot/features/debts/presentation/models/add_debt_draft.dart';
import 'package:debt_pilot/features/debts/presentation/widgets/add_debt_details_step.dart';
import 'package:debt_pilot/features/debts/presentation/widgets/add_debt_step_indicator.dart';
import 'package:debt_pilot/features/debts/presentation/widgets/flow_navigation_bar.dart';
import 'package:debt_pilot/features/debts/presentation/widgets/payment_plan_step.dart';
import 'package:debt_pilot/features/debts/presentation/widgets/review_step.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_icon_button.dart';

class AddDebtFlowScreen extends StatefulWidget {
  const AddDebtFlowScreen({
    super.key,
  });

  @override
  State<AddDebtFlowScreen> createState() => _AddDebtFlowScreenState();
}

class _AddDebtFlowScreenState extends State<AddDebtFlowScreen> {
  int _currentStep = 0;

  AddDebtDraft _draft = AddDebtDraft.initial();

  void _goBack() {
    if (_currentStep == 0) {
      context.pop();
      return;
    }

    setState(() {
      _currentStep--;
    });
  }

  void _goNext() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
      return;
    }

    _finish();
  }

  void _finish() {
    // Future:
    // await debtRepository.create(_draft);

    context.go('/home');
  }

  String get _title {
    switch (_currentStep) {
      case 0:
        return 'Add Debt';
      case 1:
        return 'Payment Plan';
      case 2:
        return 'Review';
      default:
        return 'Add Debt';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.sm,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.md,
              ),
              child: Row(
                children: [
                  AppIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onPressed: _goBack,
                    backgroundColor: Colors.transparent,
                  ),
                  Expanded(
                    child: Text(
                      _title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(
                    width: 44,
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
              ),
              child: AddDebtStepIndicator(
                currentStep: _currentStep,
              ),
            ),

            const SizedBox(
              height: AppSpacing.lg,
            ),

            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(
                  milliseconds: 250,
                ),
                child: _buildCurrentStep(),
              ),
            ),

            FlowNavigationBar(
              onBack: _goBack,
              onNext: _goNext,
              isFirstStep: _currentStep == 0,
              isLastStep: _currentStep == 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return AddDebtDetailsStep(
          key: const ValueKey('details'),
          initial: _draft.details,
          onChanged: (details) {
            _draft = AddDebtDraft(
              details: details,
              paymentPlan: _draft.paymentPlan,
            );
          },
        );

      case 1:
        return PaymentPlanStep(
          key: const ValueKey('payment-plan'),
          details: _draft.details,
          initial: _draft.paymentPlan,
          onChanged: (paymentPlan) {
            _draft = AddDebtDraft(
              details: _draft.details,
              paymentPlan: paymentPlan,
            );
          },
        );

      case 2:
        return ReviewStep(
            draft: _draft,
            onPaymentUpdated: (payments) {
              setState(() {
                _draft = AddDebtDraft(
                  details: _draft.details,
                  paymentPlan: PaymentPlanDraft(
                    type: _draft.paymentPlan.type,
                    recurringAmount: _draft.paymentPlan.recurringAmount,
                    startDate: _draft.paymentPlan.startDate,
                    endDate: _draft.paymentPlan.endDate,
                    scheduledPayments: payments,
                    oneTimeAmount: _draft.paymentPlan.oneTimeAmount,
                    oneTimeDate: _draft.paymentPlan.oneTimeDate,
                  ),
                );
              });
            },
          );

        default:
        return const SizedBox.shrink();
    }
  }
}