import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:liver_calc/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const LiverCalcApp());

    // Verify that the title is present (verifies app built successfully)
    expect(find.text('Liver Calc'), findsOneWidget);
  });
}
