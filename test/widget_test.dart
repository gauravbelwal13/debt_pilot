import 'package:flutter_test/flutter_test.dart';

import 'package:debt_pilot/app/app.dart';

void main() {
  testWidgets('DebtPilot app starts successfully', (tester) async {
    await tester.pumpWidget(const DebtPilotApp());

    // Allow the first frame to render.
    await tester.pump();

    expect(find.text('DebtPilot'), findsOneWidget);
  });
}