// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PatientData _$PatientDataFromJson(Map<String, dynamic> json) => _PatientData(
  units: $enumDecodeNullable(_$UnitsEnumMap, json['units']) ?? Units.si,
  bilirubin: (json['bilirubin'] as num?)?.toDouble(),
  inr: (json['inr'] as num?)?.toDouble(),
  pt: (json['pt'] as num?)?.toDouble(),
  ptControl: (json['ptControl'] as num?)?.toDouble() ?? 12.0,
  creatinine: (json['creatinine'] as num?)?.toDouble(),
  sodium: (json['sodium'] as num?)?.toInt(),
  albumin: (json['albumin'] as num?)?.toDouble(),
  ascites:
      $enumDecodeNullable(_$AscitesSeverityEnumMap, json['ascites']) ??
      AscitesSeverity.none,
  encephalopathy:
      $enumDecodeNullable(
        _$EncephalopathyGradeEnumMap,
        json['encephalopathy'],
      ) ??
      EncephalopathyGrade.none,
);

Map<String, dynamic> _$PatientDataToJson(_PatientData instance) =>
    <String, dynamic>{
      'units': _$UnitsEnumMap[instance.units]!,
      'bilirubin': instance.bilirubin,
      'inr': instance.inr,
      'pt': instance.pt,
      'ptControl': instance.ptControl,
      'creatinine': instance.creatinine,
      'sodium': instance.sodium,
      'albumin': instance.albumin,
      'ascites': _$AscitesSeverityEnumMap[instance.ascites]!,
      'encephalopathy': _$EncephalopathyGradeEnumMap[instance.encephalopathy]!,
    };

const _$UnitsEnumMap = {Units.us: 'us', Units.si: 'si'};

const _$AscitesSeverityEnumMap = {
  AscitesSeverity.none: 'none',
  AscitesSeverity.slight: 'slight',
  AscitesSeverity.moderate: 'moderate',
};

const _$EncephalopathyGradeEnumMap = {
  EncephalopathyGrade.none: 'none',
  EncephalopathyGrade.grade1_2: 'grade1_2',
  EncephalopathyGrade.grade3_4: 'grade3_4',
};
