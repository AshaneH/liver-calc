import 'package:freezed_annotation/freezed_annotation.dart';

part 'patient_data.freezed.dart';
part 'patient_data.g.dart';

enum Units {
  us, // mg/dL
  si, // µmol/L
}

enum AscitesSeverity { none, slight, moderate }

enum EncephalopathyGrade { none, grade1_2, grade3_4 }

@freezed
abstract class PatientData with _$PatientData {
  const factory PatientData({
    @Default(Units.si) Units units,
    double? bilirubin,
    double? inr,
    double? pt, // Prothrombin Time (Patient)
    @Default(12.0) double ptControl, // Prothrombin Time (Control)
    double? creatinine,
    int? sodium,
    double? albumin,
    @Default(AscitesSeverity.none) AscitesSeverity ascites,
    @Default(EncephalopathyGrade.none) EncephalopathyGrade encephalopathy,
  }) = _PatientData;

  factory PatientData.fromJson(Map<String, dynamic> json) =>
      _$PatientDataFromJson(json);
}
