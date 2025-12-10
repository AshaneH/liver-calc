import 'package:freezed_annotation/freezed_annotation.dart';

part 'patient_data.freezed.dart';
part 'patient_data.g.dart';

enum Units {
  us, // mg/dL
  si, // µmol/L
}

enum AscitesSeverity { none, slight, moderate }

enum EncephalopathyGrade { none, grade1_2, grade3_4 }

enum Gender { male, female }

@freezed
abstract class PatientData with _$PatientData {
  const PatientData._(); // Added for custom getters

  const factory PatientData({
    @Default(Units.si) Units units,
    double? bilirubinSi, // Stored in µmol/L
    double? inr,
    double? pt, // Seconds
    @Default(12.0) double ptControl,
    double? creatinineSi, // Stored in µmol/L
    int? sodium,
    double? albuminGl, // Stored in g/L
    Gender? sex,
    @Default(false) bool onDialysis,
    @Default(AscitesSeverity.none) AscitesSeverity ascites,
    @Default(EncephalopathyGrade.none) EncephalopathyGrade encephalopathy,
  }) = _PatientData;

  factory PatientData.fromJson(Map<String, dynamic> json) =>
      _$PatientDataFromJson(json);

  // Helper Getters for Display
  double? get bilirubinDisplay {
    if (bilirubinSi == null) return null;
    if (units == Units.si) return bilirubinSi;
    return double.parse((bilirubinSi! / 17.1).toStringAsFixed(1));
  }

  double? get creatinineDisplay {
    if (creatinineSi == null) return null;
    if (units == Units.si) return creatinineSi;
    return double.parse((creatinineSi! / 88.4).toStringAsFixed(1));
  }

  double? get albuminDisplay {
    if (albuminGl == null) return null;
    if (units == Units.si) return albuminGl;
    return double.parse((albuminGl! / 10.0).toStringAsFixed(1));
  }
}
