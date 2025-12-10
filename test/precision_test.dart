import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liver_calc/models/patient_data.dart';
import 'package:liver_calc/providers/patient_provider.dart';

void main() {
  group('Precision Stability Tests', () {
    test('Round Trip Conversion does not drift values', () {
      final container = ProviderContainer();
      final notifier = container.read(patientDataProvider.notifier);

      // 1. Set simple US value: Bilirubin 1.2 mg/dL
      notifier.updateUnits(Units.us);
      notifier.updateBilirubin('1.2');

      // Verify initial state
      // 1.2 mg/dL * 17.1 = 20.52 umol/L stored
      var state = container.read(patientDataProvider);
      expect(state.units, Units.us);
      expect(state.bilirubinDisplay, 1.2);
      expect(state.bilirubinSi, closeTo(20.52, 0.001));

      // 2. Switch to SI
      notifier.updateUnits(Units.si);
      // Read new state
      state = container.read(patientDataProvider);

      // Display logic: 20.52 (canonical)
      expect(state.bilirubinDisplay, closeTo(20.52, 0.001));

      // 3. Switch back to US
      notifier.updateUnits(Units.us);
      state = container.read(patientDataProvider);

      // Display getter: 20.52 / 17.1 = 1.2
      expect(state.bilirubinDisplay, closeTo(1.2, 0.001));

      // 4. Repeated Toggle
      for (int i = 0; i < 10; i++) {
        notifier.updateUnits(Units.si);
        notifier.updateUnits(Units.us);
      }

      state = container.read(patientDataProvider);
      // Value should NOT have drifted
      expect(state.bilirubinDisplay, closeTo(1.2, 0.001));

      addTearDown(container.dispose);
    });

    test('Inputting value in SI stores correctly', () {
      final container = ProviderContainer();
      final notifier = container.read(patientDataProvider.notifier);

      notifier.updateUnits(Units.si);

      // Enter 20.5 umol/L
      notifier.updateBilirubin('20.5');

      var state = container.read(patientDataProvider);
      expect(state.bilirubinSi, 20.5);

      // Switch to US
      notifier.updateUnits(Units.us);
      state = container.read(patientDataProvider);

      // 20.5 / 17.1 = 1.1988... -> 1.2 (via toStringAsFixed(1) inside getter)
      expect(state.bilirubinDisplay, 1.2);

      addTearDown(container.dispose);
    });
  });
}
