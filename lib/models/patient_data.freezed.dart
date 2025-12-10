// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'patient_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PatientData {

 Units get units; double? get bilirubinSi;// Stored in µmol/L
 double? get inr; double? get pt;// Seconds
 double get ptControl; double? get creatinineSi;// Stored in µmol/L
 int? get sodium; double? get albuminGl;// Stored in g/L
 AscitesSeverity get ascites; EncephalopathyGrade get encephalopathy;
/// Create a copy of PatientData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PatientDataCopyWith<PatientData> get copyWith => _$PatientDataCopyWithImpl<PatientData>(this as PatientData, _$identity);

  /// Serializes this PatientData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PatientData&&(identical(other.units, units) || other.units == units)&&(identical(other.bilirubinSi, bilirubinSi) || other.bilirubinSi == bilirubinSi)&&(identical(other.inr, inr) || other.inr == inr)&&(identical(other.pt, pt) || other.pt == pt)&&(identical(other.ptControl, ptControl) || other.ptControl == ptControl)&&(identical(other.creatinineSi, creatinineSi) || other.creatinineSi == creatinineSi)&&(identical(other.sodium, sodium) || other.sodium == sodium)&&(identical(other.albuminGl, albuminGl) || other.albuminGl == albuminGl)&&(identical(other.ascites, ascites) || other.ascites == ascites)&&(identical(other.encephalopathy, encephalopathy) || other.encephalopathy == encephalopathy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,units,bilirubinSi,inr,pt,ptControl,creatinineSi,sodium,albuminGl,ascites,encephalopathy);

@override
String toString() {
  return 'PatientData(units: $units, bilirubinSi: $bilirubinSi, inr: $inr, pt: $pt, ptControl: $ptControl, creatinineSi: $creatinineSi, sodium: $sodium, albuminGl: $albuminGl, ascites: $ascites, encephalopathy: $encephalopathy)';
}


}

/// @nodoc
abstract mixin class $PatientDataCopyWith<$Res>  {
  factory $PatientDataCopyWith(PatientData value, $Res Function(PatientData) _then) = _$PatientDataCopyWithImpl;
@useResult
$Res call({
 Units units, double? bilirubinSi, double? inr, double? pt, double ptControl, double? creatinineSi, int? sodium, double? albuminGl, AscitesSeverity ascites, EncephalopathyGrade encephalopathy
});




}
/// @nodoc
class _$PatientDataCopyWithImpl<$Res>
    implements $PatientDataCopyWith<$Res> {
  _$PatientDataCopyWithImpl(this._self, this._then);

  final PatientData _self;
  final $Res Function(PatientData) _then;

/// Create a copy of PatientData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? units = null,Object? bilirubinSi = freezed,Object? inr = freezed,Object? pt = freezed,Object? ptControl = null,Object? creatinineSi = freezed,Object? sodium = freezed,Object? albuminGl = freezed,Object? ascites = null,Object? encephalopathy = null,}) {
  return _then(_self.copyWith(
units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as Units,bilirubinSi: freezed == bilirubinSi ? _self.bilirubinSi : bilirubinSi // ignore: cast_nullable_to_non_nullable
as double?,inr: freezed == inr ? _self.inr : inr // ignore: cast_nullable_to_non_nullable
as double?,pt: freezed == pt ? _self.pt : pt // ignore: cast_nullable_to_non_nullable
as double?,ptControl: null == ptControl ? _self.ptControl : ptControl // ignore: cast_nullable_to_non_nullable
as double,creatinineSi: freezed == creatinineSi ? _self.creatinineSi : creatinineSi // ignore: cast_nullable_to_non_nullable
as double?,sodium: freezed == sodium ? _self.sodium : sodium // ignore: cast_nullable_to_non_nullable
as int?,albuminGl: freezed == albuminGl ? _self.albuminGl : albuminGl // ignore: cast_nullable_to_non_nullable
as double?,ascites: null == ascites ? _self.ascites : ascites // ignore: cast_nullable_to_non_nullable
as AscitesSeverity,encephalopathy: null == encephalopathy ? _self.encephalopathy : encephalopathy // ignore: cast_nullable_to_non_nullable
as EncephalopathyGrade,
  ));
}

}


/// Adds pattern-matching-related methods to [PatientData].
extension PatientDataPatterns on PatientData {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PatientData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PatientData() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PatientData value)  $default,){
final _that = this;
switch (_that) {
case _PatientData():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PatientData value)?  $default,){
final _that = this;
switch (_that) {
case _PatientData() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Units units,  double? bilirubinSi,  double? inr,  double? pt,  double ptControl,  double? creatinineSi,  int? sodium,  double? albuminGl,  AscitesSeverity ascites,  EncephalopathyGrade encephalopathy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PatientData() when $default != null:
return $default(_that.units,_that.bilirubinSi,_that.inr,_that.pt,_that.ptControl,_that.creatinineSi,_that.sodium,_that.albuminGl,_that.ascites,_that.encephalopathy);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Units units,  double? bilirubinSi,  double? inr,  double? pt,  double ptControl,  double? creatinineSi,  int? sodium,  double? albuminGl,  AscitesSeverity ascites,  EncephalopathyGrade encephalopathy)  $default,) {final _that = this;
switch (_that) {
case _PatientData():
return $default(_that.units,_that.bilirubinSi,_that.inr,_that.pt,_that.ptControl,_that.creatinineSi,_that.sodium,_that.albuminGl,_that.ascites,_that.encephalopathy);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Units units,  double? bilirubinSi,  double? inr,  double? pt,  double ptControl,  double? creatinineSi,  int? sodium,  double? albuminGl,  AscitesSeverity ascites,  EncephalopathyGrade encephalopathy)?  $default,) {final _that = this;
switch (_that) {
case _PatientData() when $default != null:
return $default(_that.units,_that.bilirubinSi,_that.inr,_that.pt,_that.ptControl,_that.creatinineSi,_that.sodium,_that.albuminGl,_that.ascites,_that.encephalopathy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PatientData extends PatientData {
  const _PatientData({this.units = Units.si, this.bilirubinSi, this.inr, this.pt, this.ptControl = 12.0, this.creatinineSi, this.sodium, this.albuminGl, this.ascites = AscitesSeverity.none, this.encephalopathy = EncephalopathyGrade.none}): super._();
  factory _PatientData.fromJson(Map<String, dynamic> json) => _$PatientDataFromJson(json);

@override@JsonKey() final  Units units;
@override final  double? bilirubinSi;
// Stored in µmol/L
@override final  double? inr;
@override final  double? pt;
// Seconds
@override@JsonKey() final  double ptControl;
@override final  double? creatinineSi;
// Stored in µmol/L
@override final  int? sodium;
@override final  double? albuminGl;
// Stored in g/L
@override@JsonKey() final  AscitesSeverity ascites;
@override@JsonKey() final  EncephalopathyGrade encephalopathy;

/// Create a copy of PatientData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PatientDataCopyWith<_PatientData> get copyWith => __$PatientDataCopyWithImpl<_PatientData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PatientDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PatientData&&(identical(other.units, units) || other.units == units)&&(identical(other.bilirubinSi, bilirubinSi) || other.bilirubinSi == bilirubinSi)&&(identical(other.inr, inr) || other.inr == inr)&&(identical(other.pt, pt) || other.pt == pt)&&(identical(other.ptControl, ptControl) || other.ptControl == ptControl)&&(identical(other.creatinineSi, creatinineSi) || other.creatinineSi == creatinineSi)&&(identical(other.sodium, sodium) || other.sodium == sodium)&&(identical(other.albuminGl, albuminGl) || other.albuminGl == albuminGl)&&(identical(other.ascites, ascites) || other.ascites == ascites)&&(identical(other.encephalopathy, encephalopathy) || other.encephalopathy == encephalopathy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,units,bilirubinSi,inr,pt,ptControl,creatinineSi,sodium,albuminGl,ascites,encephalopathy);

@override
String toString() {
  return 'PatientData(units: $units, bilirubinSi: $bilirubinSi, inr: $inr, pt: $pt, ptControl: $ptControl, creatinineSi: $creatinineSi, sodium: $sodium, albuminGl: $albuminGl, ascites: $ascites, encephalopathy: $encephalopathy)';
}


}

/// @nodoc
abstract mixin class _$PatientDataCopyWith<$Res> implements $PatientDataCopyWith<$Res> {
  factory _$PatientDataCopyWith(_PatientData value, $Res Function(_PatientData) _then) = __$PatientDataCopyWithImpl;
@override @useResult
$Res call({
 Units units, double? bilirubinSi, double? inr, double? pt, double ptControl, double? creatinineSi, int? sodium, double? albuminGl, AscitesSeverity ascites, EncephalopathyGrade encephalopathy
});




}
/// @nodoc
class __$PatientDataCopyWithImpl<$Res>
    implements _$PatientDataCopyWith<$Res> {
  __$PatientDataCopyWithImpl(this._self, this._then);

  final _PatientData _self;
  final $Res Function(_PatientData) _then;

/// Create a copy of PatientData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? units = null,Object? bilirubinSi = freezed,Object? inr = freezed,Object? pt = freezed,Object? ptControl = null,Object? creatinineSi = freezed,Object? sodium = freezed,Object? albuminGl = freezed,Object? ascites = null,Object? encephalopathy = null,}) {
  return _then(_PatientData(
units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as Units,bilirubinSi: freezed == bilirubinSi ? _self.bilirubinSi : bilirubinSi // ignore: cast_nullable_to_non_nullable
as double?,inr: freezed == inr ? _self.inr : inr // ignore: cast_nullable_to_non_nullable
as double?,pt: freezed == pt ? _self.pt : pt // ignore: cast_nullable_to_non_nullable
as double?,ptControl: null == ptControl ? _self.ptControl : ptControl // ignore: cast_nullable_to_non_nullable
as double,creatinineSi: freezed == creatinineSi ? _self.creatinineSi : creatinineSi // ignore: cast_nullable_to_non_nullable
as double?,sodium: freezed == sodium ? _self.sodium : sodium // ignore: cast_nullable_to_non_nullable
as int?,albuminGl: freezed == albuminGl ? _self.albuminGl : albuminGl // ignore: cast_nullable_to_non_nullable
as double?,ascites: null == ascites ? _self.ascites : ascites // ignore: cast_nullable_to_non_nullable
as AscitesSeverity,encephalopathy: null == encephalopathy ? _self.encephalopathy : encephalopathy // ignore: cast_nullable_to_non_nullable
as EncephalopathyGrade,
  ));
}


}

// dart format on
