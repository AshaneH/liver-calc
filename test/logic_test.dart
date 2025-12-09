import 'package:flutter_test/flutter_test.dart';
import 'package:liver_calc/models/patient_data.dart';
import 'package:liver_calc/logic/liver_calculator.dart';

void main() {
  group('LiverCalculator Logic', () {
    test('MELD Score Calculation (Standard)', () {
      // Test case: Bili=2.0 (mg/dL), INR=1.5, Creat=1.2 (mg/dL)
      // MELD = 3.78ln(2) + 11.2ln(1.5) + 9.57ln(1.2) + 6.43
      // = 3.78(0.693) + 11.2(0.405) + 9.57(0.182) + 6.43
      // = 2.62 + 4.54 + 1.74 + 6.43 = 15.33 -> 15.3

      const data = PatientData(
        units: Units.us,
        bilirubin: 2.0,
        inr: 1.5,
        creatinine: 1.2,
        sodium: 135,
        albumin: 3.5,
      );

      final meld = LiverCalculator.calculateMeld(data);
      expect(meld, closeTo(15.3, 0.2));
    });

    test('MELD Score - Lower Bounds (Values < 1.0)', () {
      // Test case: Bili=0.5, INR=0.9, Creat=0.6 (All should be clamped to 1.0)
      // MELD = 3.78(0) + 11.2(0) + 9.57(0) + 6.43 = 6.4
      const data = PatientData(
        units: Units.us,
        bilirubin: 0.5,
        inr: 0.9,
        creatinine: 0.6,
      );

      final meld = LiverCalculator.calculateMeld(data);
      expect(meld, 6.4);
    });

    test('MELD-Na Calculation', () {
      // MELD > 11 for Na correction to apply
      // Let's use previous case: MELD ~15.3
      // Na = 125.
      // MELD-Na = MELD + 1.32(137-Na) - [0.033*MELD*(137-Na)]
      // = 15.3 + 1.32(12) - [0.033*15.3*12]
      // = 15.3 + 15.84 - [6.0588]
      // = 25.08 -> 25.1

      const data = PatientData(
        units: Units.us,
        bilirubin: 2.0,
        inr: 1.5,
        creatinine: 1.2,
        sodium: 125,
      );

      final meldNa = LiverCalculator.calculateMeldNa(data);
      expect(meldNa, closeTo(25.1, 0.5));
    });

    test('Child-Pugh Score Calculation', () {
      // Bili=2.5 (2pts), Alb=2.5 (3pts), INR=1.8 (2pts), Ascites=None (1pt), Enceph=Grade1 (2pts)
      // Total = 2+3+2+1+2 = 10 -> Class C

      const data = PatientData(
        units: Units.us,
        bilirubin: 2.5,
        albumin: 2.5,
        inr: 1.8,
        ascites: AscitesSeverity.none,
        encephalopathy: EncephalopathyGrade.grade1_2,
      );

      final cp = LiverCalculator.calculateChildPugh(data);
      expect(cp!['score'], 10);
      expect(cp['grade'], 'C');
    });

    test('Unit Conversion (SI Inputs)', () {
      // Bili 171 umol/L = 10 mg/dL
      // Creat 176.8 umol/L = 2.0 mg/dL
      // Alb 35 g/L = 3.5 g/dL

      // MELD should be same as US equivalents:
      // MELD = 3.78ln(10) + 11.2ln(1.0) + 9.57ln(2.0) + 6.43
      // = 3.78(2.3) + 0 + 9.57(0.693) + 6.43
      // = 8.69 + 6.63 + 6.43 = 21.75

      const data = PatientData(
        units: Units.si,
        bilirubin: 171,
        inr: 1.0,
        creatinine: 176.8,
      );

      final meld = LiverCalculator.calculateMeld(data);
      expect(meld, closeTo(21.7, 0.5));
    });

    test('Maddrey DF Calculation', () {
      // 4.6 * (PT - Control) + Bili(mg/dL)
      // PT=20, Control=12 -> Diff=8.
      // 4.6 * 8 = 36.8
      // Bili = 3.2 mg/dL
      // Total = 36.8 + 3.2 = 40.0

      const data = PatientData(
        units: Units.us,
        bilirubin: 3.2,
        pt: 20,
        ptControl: 12,
      );

      final df = LiverCalculator.calculateMaddreyDf(data);
      expect(df, closeTo(40.0, 0.1));
    });
  });
}
