import 'dart:math';
import 'package:liver_calc/models/patient_data.dart';

enum MeldType { meld3, meldNa, meld, none }

class MeldResult {
  final double? score;
  final MeldType type;

  MeldResult({this.score, required this.type});
}

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

  static MeldResult calculateMeldCombined(PatientData data) {
    // 1. Check Prereqs for MELD 3.0
    bool canDoMeld3 =
        (data.sex != null) && (data.sodium != null) && (data.albuminGl != null);

    // 2. Check Prereqs for MELD-Na
    bool canDoMeldNa = (data.sodium != null);

    // 3. Execution Cascade
    if (canDoMeld3) {
      return _calculateMeld3(data);
    } else if (canDoMeldNa) {
      return _calculateMeldNaResult(data);
    } else {
      return _calculateStandardMeldResult(data);
    }
  }

  // --- Private Calculations ---

  static MeldResult _calculateMeld3(PatientData data) {
    // 1. Prepare Variables (Convert to US units for formula)
    double bili = _getBilirubinMg(data);
    double creat = _getCreatinineMg(data);
    double inr = data.inr ?? 1.0;
    double na = data.sodium!.toDouble();
    double alb = _getAlbuminGdl(data);
    bool isFemale = (data.sex == Gender.female);
    bool dialysis = data.onDialysis;

    // 2. Apply Bounds

    // Na: Cap 125-137
    if (na < 125) na = 125;
    if (na > 137) na = 137;

    // Alb: Cap 1.5-3.5
    if (alb < 1.5) alb = 1.5;
    if (alb > 3.5) alb = 3.5;

    // Creatinine Dialysis Rule
    if (dialysis) {
      creat = 4.0;
    } else {
      // MELD 3.0 Cap for Creatinine is 3.0
      if (creat > 3.0) creat = 3.0;
    }

    // Lower Bounds (Floor at 1.0)
    if (bili < 1.0) bili = 1.0;
    if (inr < 1.0) inr = 1.0;
    if (creat < 1.0) creat = 1.0;

    // 3. The Formula
    // 1.33 * Female + 4.56 * ln(bili) + 0.82*(137-Na) - 0.24*(137-Na)*ln(bili)
    // + 9.09*ln(INR) + 11.14*ln(creat) + 1.85*(3.5-alb) - 1.83*(3.5-alb)*ln(creat) + 6
    double score =
        1.33 * (isFemale ? 1.0 : 0.0) +
        4.56 * log(bili) +
        0.82 * (137 - na) -
        0.24 * (137 - na) * log(bili) +
        9.09 * log(inr) +
        11.14 * log(creat) +
        1.85 * (3.5 - alb) -
        1.83 * (3.5 - alb) * log(creat) +
        6;

    return MeldResult(
      score: double.parse(score.toStringAsFixed(1)),
      type: MeldType.meld3,
    );
  }

  static MeldResult _calculateMeldNaResult(PatientData data) {
    double? standardMeld = calculateMeld(data);
    if (standardMeld == null || data.sodium == null) {
      return _calculateStandardMeldResult(data);
    }

    if (standardMeld <= 11) {
      return MeldResult(score: standardMeld, type: MeldType.meld);
    }

    double na = data.sodium!.toDouble();
    if (na < 125) na = 125;
    if (na > 137) na = 137;

    final score =
        standardMeld + 1.32 * (137 - na) - (0.033 * standardMeld * (137 - na));
    return MeldResult(
      score: double.parse(score.toStringAsFixed(1)),
      type: MeldType.meldNa,
    );
  }

  static MeldResult _calculateStandardMeldResult(PatientData data) {
    double? score = calculateMeld(data);
    return MeldResult(
      score: score,
      type: score != null ? MeldType.meld : MeldType.none,
    );
  }

  // Legacy/Helper for shared usage (Standard MELD)
  static double? calculateMeld(PatientData data) {
    if (data.bilirubinSi == null ||
        data.inr == null ||
        data.creatinineSi == null) {
      return null;
    }

    double bili = _getBilirubinMg(data);
    double creat = _getCreatinineMg(data);
    double inr = data.inr!;
    bool dialysis = data.onDialysis;

    // Dialysis Override (Standard MELD also typically caps at 4.0)
    if (dialysis) {
      creat = 4.0;
    } else {
      // Standard MELD Cap is 4.0
      if (creat > 4.0) creat = 4.0;
    }

    // Lower bounds
    if (bili < 1.0) bili = 1.0;
    if (creat < 1.0) creat = 1.0;
    if (inr < 1.0) inr = 1.0;

    final score = 3.78 * log(bili) + 11.2 * log(inr) + 9.57 * log(creat) + 6.43;
    return double.parse(score.toStringAsFixed(1));
  }

  // Deprecated direct MELD-Na call (kept for existing tests if needed, but updated logic)
  static double? calculateMeldNa(PatientData data) {
    MeldResult res = _calculateMeldNaResult(data);
    if (res.type == MeldType.none) return null;
    return res.score;
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
