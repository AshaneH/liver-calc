import 'dart:math';
import 'package:liver_calc/models/patient_data.dart';

class LiverCalculator {
  // Helpers now assume SI input (because that is what is stored)
  // But some formulas might need mg/dL (MELD).

  static double _getBilirubinMg(PatientData data) {
    if (data.bilirubinSi == null) return 0.0;
    return data.bilirubinSi! / 17.1;
  }

  static double _getBilirubinUmol(PatientData data) {
    return data.bilirubinSi ?? 0.0;
  }

  static double _getCreatinineMg(PatientData data) {
    if (data.creatinineSi == null) return 0.0;
    return data.creatinineSi! / 88.4;
  }

  static double _getAlbuminGdl(PatientData data) {
    if (data.albuminGl == null) return 0.0;
    return data.albuminGl! / 10.0;
  }

  static double _getAlbuminGl(PatientData data) {
    return data.albuminGl ?? 0.0;
  }

  static double? calculateMeld(PatientData data) {
    if (data.bilirubinSi == null ||
        data.inr == null ||
        data.creatinineSi == null) {
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
    if (data.bilirubinSi == null ||
        data.albuminGl == null ||
        data.inr == null) {
      return null;
    }

    int score = 0;

    // Bilirubin
    double bili = _getBilirubinMg(data);
    double alb = _getAlbuminGdl(data);
    // ... logic same ...

    // Bilirubin logic
    if (bili < 2) {
      score += 1;
    } else if (bili <= 3) {
      score += 2;
    } else {
      score += 3;
    }

    // Albumin
    if (alb > 3.5) {
      score += 1;
    } else if (alb >= 2.8) {
      score += 2;
    } else {
      score += 3;
    }

    // INR
    double inr = data.inr!;
    if (inr < 1.7) {
      score += 1;
    } else if (inr <= 2.3) {
      score += 2;
    } else {
      score += 3;
    }

    // Ascites
    if (data.ascites == AscitesSeverity.none) {
      score += 1;
    } else if (data.ascites == AscitesSeverity.slight) {
      score += 2;
    } else {
      score += 3;
    }

    // Encephalopathy
    if (data.encephalopathy == EncephalopathyGrade.none) {
      score += 1;
    } else if (data.encephalopathy == EncephalopathyGrade.grade1_2) {
      score += 2;
    } else {
      score += 3;
    }

    String grade;
    if (score <= 6) {
      grade = 'A';
    } else if (score <= 9) {
      grade = 'B';
    } else {
      grade = 'C';
    }

    return {'score': score, 'grade': grade};
  }

  static double? calculateMaddreyDf(PatientData data) {
    if (data.pt == null || data.bilirubinSi == null) return null;

    double bili = _getBilirubinMg(data);
    double ptControl = data.ptControl;

    double val = 4.6 * (data.pt! - ptControl) + bili;
    return double.parse(val.toStringAsFixed(1));
  }

  static Map<String, dynamic>? calculateAlbi(PatientData data) {
    if (data.bilirubinSi == null || data.albuminGl == null) return null;

    double biliUmol = _getBilirubinUmol(data);
    double albGl = _getAlbuminGl(data);

    // Formula: (log10(bilirubin µmol/L) × 0.66) + (albumin g/L × -0.085)
    // Dart's log is ln. log10(x) = log(x) / ln(10)
    double log10Bili = log(biliUmol) / log(10);

    double score = (log10Bili * 0.66) + (albGl * -0.085);

    String grade;
    if (score <= -2.60) {
      grade = '1';
    } else if (score <= -1.39) {
      grade = '2';
    } else {
      grade = '3';
    }

    return {'score': double.parse(score.toStringAsFixed(2)), 'grade': grade};
  }
}
