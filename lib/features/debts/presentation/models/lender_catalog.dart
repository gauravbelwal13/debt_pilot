import 'add_debt_draft.dart';

abstract final class LenderCatalog {
  static const personalLoanApps = [
    'KreditBee',
    'Moneyview',
    'Navi',
    'Fibe',
    'CASHe',
    'PaySense',
  ];

  static const bankNames = [
    'HDFC Bank',
    'ICICI Bank',
    'State Bank of India',
    'Axis Bank',
    'Kotak Mahindra Bank',
    'Bank of Baroda',
  ];

  static List<String> optionsFor(DebtType type) {
    switch (type) {
      case DebtType.personalLoan:
        return List.unmodifiable(personalLoanApps);

      case DebtType.creditCard:
      case DebtType.vehicleLoan:
      case DebtType.educationLoan:
        return List.unmodifiable(bankNames);

      case DebtType.friendFamily:
      case DebtType.other:
        return const [];
    }
  }
}