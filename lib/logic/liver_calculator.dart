import 'dart:math';
import 'package:liver_calc/models/patient_data.dart';

class LiverCalculator {
  // Conversion factors
  static const double bilirubinMgToUmol = 17.1;
  static const double creatinineMgToUmol = 88.4;
  static const double albuminGToDl = 10.0; // g/dL to g/L is *10? Wait.
  // Albumin US: g/dL. SI: g/L. Factor is 10. 3.5 g/dL = 35 g/L.

  // Helper to get Bilirubin in mg/dL
  static double _getBilirubinMg(PatientData data) {
    if (data.bilirubin == null) return 0.0;
    if (data.units == Units.us) return data.bilirubin!;
    return data.bilirubin! / bilirubinMgToUmol;
  }

  // Helper to get Bilirubin in µmol/L (for ALBI)
  static double _getBilirubinUmol(PatientData data) {
    if (data.bilirubin == null) return 0.0;
    if (data.units == Units.si) return data.bilirubin!;
    return data.bilirubin! * bilirubinMgToUmol;
  }

  // Helper to get Creatinine in mg/dL
  static double _getCreatinineMg(PatientData data) {
    if (data.creatinine == null) return 0.0;
    if (data.units == Units.us) return data.creatinine!;
    return data.creatinine! / creatinineMgToUmol;
  }

  // Helper to get Albumin in g/dL
  static double _getAlbuminGdl(PatientData data) {
    if (data.albumin == null) return 0.0;
    if (data.units == Units.us) return data.albumin!;
    return data.albumin! / 10.0; // g/L -> g/dL
  }

  // Helper to get Albumin in g/L (for ALBI)
  static double _getAlbuminGl(PatientData data) {
    if (data.albumin == null) return 0.0;
    if (data.units == Units.si) return data.albumin!;
    return data.albumin! * 10.0; // g/dL -> g/L
  }

  static double? calculateMeld(PatientData data) {
    if (data.bilirubin == null || data.inr == null || data.creatinine == null) {
      return null;
    }

    double bili = _getBilirubinMg(data);
    double creat = _getCreatinineMg(data);
    double inr = data.inr!;

    // MELD lower bounds
    if (bili < 1.0) bili = 1.0;
    if (creat < 1.0) creat = 1.0;
    if (inr < 1.0) inr = 1.0;

    // Cap creatinine at 4.0 mg/dL for MELD
    if (creat > 4.0) creat = 4.0;
    // Wait, usually if dialysed, it is set to 4.0. We don't have dialysis input.
    // Standard MELD calc just clamps <1.0. For >4.0 it's usually just used as is unless dialysis.
    // I'll stick to basic clamping.

    final score = 3.78 * log(bili) + 11.2 * log(inr) + 9.57 * log(creat) + 6.43;
    return double.parse(score.toStringAsFixed(1));
  }

  static double? calculateMeldNa(PatientData data) {
    double? meld = calculateMeld(data);
    if (meld == null || data.sodium == null) return null;

    if (meld <= 11) return meld;

    double na = data.sodium!.toDouble();
    // Sodium clamp 125-137
    if (na < 125) na = 125;
    if (na > 137) na = 137;

    final score = meld + 1.32 * (137 - na) - (0.033 * meld * (137 - na));
    return double.parse(score.toStringAsFixed(1));
  }

  static Map<String, dynamic>? calculateChildPugh(PatientData data) {
    if (data.bilirubin == null || data.albumin == null || data.inr == null) {
      return null;
    }

    int score = 0;

    // Bilirubin
    double bili = _getBilirubinMg(data);
    if (bili < 2) {
      score += 1;
    } else if (bili <= 3)
      score += 2;
    else
      score += 3;

    // Albumin
    double alb = _getAlbuminGdl(data);
    if (alb > 3.5) {
      score += 1;
    } else if (alb >= 2.8)
      score += 2;
    else
      score += 3;

    // INR
    double inr = data.inr!;
    if (inr < 1.7) {
      score += 1;
    } else if (inr <= 2.3)
      score += 2;
    else
      score += 3;

    // Ascites
    if (data.ascites == AscitesSeverity.none) {
      score += 1;
    } else if (data.ascites == AscitesSeverity.slight)
      score += 2;
    else
      score += 3;

    // Encephalopathy
    if (data.encephalopathy == EncephalopathyGrade.none) {
      score += 1;
    } else if (data.encephalopathy == EncephalopathyGrade.grade1_2)
      score += 2;
    else
      score += 3;

    String grade;
    if (score <= 6) {
      grade = 'A';
    } else if (score <= 9)
      grade = 'B';
    else
      grade = 'C';

    return {'score': score, 'grade': grade};
  }

  static double? calculateMaddreyDf(PatientData data) {
    if (data.pt == null || data.bilirubin == null) return null;

    double bili = _getBilirubinMg(data);
    double ptControl = data.ptControl; // Default 12 used if not changed

    // Formula: 4.6 * (PT - Control) + Bilirubin
    double val = 4.6 * (data.pt! - ptControl) + bili;
    return double.parse(val.toStringAsFixed(1));
  }

  static Map<String, dynamic>? calculateAlbi(PatientData data) {
    if (data.bilirubin == null || data.albumin == null) return null;

    double biliUmol = _getBilirubinUmol(data);
    double albGl = _getAlbuminGl(data);

    // Formula: (log10(bilirubin µmol/L) × 0.66) + (albumin g/L × -0.085)
    // Dart's log is ln. log10(x) = log(x) / ln(10)
    double log10Bili = log(biliUmol) / log(10);

    double score = (log10Bili * 0.66) + (albGl * -0.085);

    String grade;
    if (score <= -2.60) {
      grade = '1';
    } else if (score <= -1.39)
      grade = '2';
    else
      grade = '3';

    return {'score': double.parse(score.toStringAsFixed(2)), 'grade': grade};
  }
}
