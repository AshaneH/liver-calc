import 'package:flutter_test/flutter_test.dart';
import 'package:liver_calc/models/patient_data.dart';
import 'package:liver_calc/logic/liver_calculator.dart';

void main() {
  group('MELD 3.0 Logic', () {
    test('MELD 3.0 Calculation (Female, Standard Values)', () {
      // Manual Calc:
      // Female (+1.33), Bili 2.0, Na 130, INR 1.5, Creat 1.2, Alb 3.0
      // 1.33(1) + 4.56(0.693) + 0.82(7) - 0.24(7)(0.693) + 9.09(0.405) + 11.14(0.182) + 1.85(0.5) - 1.83(0.5)(0.182) + 6
      // = 1.33 + 3.16 + 5.74 - 1.16 + 3.68 + 2.03 + 0.92 + -0.16 + 6
      // ~ 21.5

      const data = PatientData(
        units: Units.us,
        bilirubinSi: 2.0 * 17.1,
        sodium: 130,
        inr: 1.5,
        creatinineSi: 1.2 * 88.4,
        albuminGl: 3.0 * 10,
        sex: Gender.female,
      );

      final result = LiverCalculator.calculateMeldCombined(data);
      expect(result.type, MeldType.meld3);
      expect(result.score, closeTo(21.5, 0.5));
    });

    test('Dialysis Override (Sets Creatinine to 4.0)', () {
      // Dialysis = True -> Creat 4.0
      // Female, Bili 1.0, Na 137 (Term 0), INR 1.0, Creat 0.5 (Should be 4.0), Alb 3.5 (Term 0)
      // Eq: 1.33(1) + 4.56(0) + 0 + 0 + 9.09(0) + 11.14*ln(4.0) + 0 + 0 + 6
      // = 7.33 + 11.14(1.386) = 7.33 + 15.44 = 22.77 -> 22.8

      const data = PatientData(
        units: Units.us,
        bilirubinSi: 1.0 * 17.1,
        sodium: 137,
        inr: 1.0,
        creatinineSi: 0.5 * 88.4,
        albuminGl: 3.5 * 10,
        sex: Gender.female,
        onDialysis: true,
      );

      final result = LiverCalculator.calculateMeldCombined(data);
      expect(result.score, closeTo(22.8, 0.5));
    });

    test('MELD 3.0 Creatinine Cap (3.0 if NOT on Dialysis)', () {
      // Creat 4.0 provided, NOT on dialysis. Should cap at 3.0.
      // Female, Bili 1.0, Na 137, INR 1.0, Creat 4.0 -> Caps to 3.0
      // Eq: 7.33 + 11.14*ln(3.0) = 7.33 + 11.14(1.098) = 7.33 + 12.23 = 19.56 -> 19.6

      const data = PatientData(
        units: Units.us,
        bilirubinSi: 1.0 * 17.1,
        sodium: 137,
        inr: 1.0,
        creatinineSi: 4.0 * 88.4,
        albuminGl: 3.5 * 10,
        sex: Gender.female,
        onDialysis: false,
      );

      final result = LiverCalculator.calculateMeldCombined(data);
      expect(result.score, closeTo(19.6, 0.5));
    });

    test('Cascade: Fallback to MELD-Na if Gender Missing', () {
      // Same values as Test 1 but NO SEX.
      // Bili 2.0 (MELD=15.3). Na 130.
      // MELD-Na = 15.3 + 1.32(7) - 0.033(15.3)(7)
      // = 15.3 + 9.24 - 3.53 = 21.01 -> 21.0

      const data = PatientData(
        units: Units.us,
        bilirubinSi: 2.0 * 17.1,
        sodium: 130,
        inr: 1.5,
        creatinineSi: 1.2 * 88.4,
        albuminGl: 3.0 * 10,
        sex: null, // MISSING
      );

      final result = LiverCalculator.calculateMeldCombined(data);
      expect(result.type, MeldType.meldNa);
      expect(result.score, closeTo(21.0, 0.5));
    });

    test('Cascade: Fallback to Standard MELD if Sodium Missing', () {
      // Bili 2.0, INR 1.5, Creat 1.2. MELD = 15.3
      const data = PatientData(
        units: Units.us,
        bilirubinSi: 2.0 * 17.1,
        inr: 1.5,
        creatinineSi: 1.2 * 88.4,
        sodium: null, // MISSING
      );

      final result = LiverCalculator.calculateMeldCombined(data);
      expect(result.type, MeldType.meld);
      expect(result.score, closeTo(15.3, 0.5));
    });

    test('MELD-Na Threshold: If MELD <= 11, do not use Na', () {
      // Bili 1.0, INR 1.0, Creat 1.0 -> MELD = 6.4 (Standard lower bound 6)
      // Sodium = 120 (Very low, would normally trigger Na boost)
      // Since MELD (6.4) <= 11, should return Standard MELD (6.4) and type MeldType.meld

      const data = PatientData(
        units: Units.us,
        bilirubinSi: 1.0 * 17.1,
        inr: 1.0,
        creatinineSi: 1.0 * 88.4,
        sodium: 120, // Should be ignored
        sex: null, // Force MELD-Na check path
      );

      final result = LiverCalculator.calculateMeldCombined(data);
      expect(result.type, MeldType.meld); // Not MeldType.meldNa
      expect(result.score, closeTo(6.4, 0.1));
    });
  });
}
