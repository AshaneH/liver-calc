import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liver_calc/widgets/input_form.dart';

void main() {
  testWidgets('InputForm updates values when units toggle', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(body: SingleChildScrollView(child: InputForm())),
        ),
      ),
    );

    // Initial state: SI Units (default)
    // Find Bilirubin input (suffix umol/L)
    final biliFinder = find.widgetWithText(TextFormField, 'Bilirubin');
    // Suffix check might be tricky with simple text finders, but "SI Units" is selected.
    expect(find.text('SI'), findsOneWidget);

    // Switch to US Units first to set a baseline (since default is SI, let's switch to US)
    await tester.tap(find.text('US'));
    await tester.pumpAndSettle();

    // Enter 2.0 for Bilirubin (mg/dL)
    await tester.enterText(biliFinder, '2.0');
    await tester.pump();

    // Verify text is 2.0
    expect(find.text('2.0'), findsOneWidget);

    // Switch back to SI Units
    await tester.tap(find.text('SI'));
    await tester.pumpAndSettle();

    // Verify text changed. 2.0 mg/dL * 17.1 = 34.2 umol/L
    // The input should now say "34.2"
    expect(find.text('34.2'), findsOneWidget);

    // Switch back to US Units
    await tester.tap(find.text('US'));
    await tester.pumpAndSettle();

    // Verify text changed back to 2.0
    expect(find.text('2.0'), findsOneWidget);
  });
}
