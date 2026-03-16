// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weather_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WeatherLocation {

 String get name; String get region; String get country; double get latitude; double get longitude; String get timezone;
/// Create a copy of WeatherLocation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeatherLocationCopyWith<WeatherLocation> get copyWith => _$WeatherLocationCopyWithImpl<WeatherLocation>(this as WeatherLocation, _$identity);

  /// Serializes this WeatherLocation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeatherLocation&&(identical(other.name, name) || other.name == name)&&(identical(other.region, region) || other.region == region)&&(identical(other.country, country) || other.country == country)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.timezone, timezone) || other.timezone == timezone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,region,country,latitude,longitude,timezone);

@override
String toString() {
  return 'WeatherLocation(name: $name, region: $region, country: $country, latitude: $latitude, longitude: $longitude, timezone: $timezone)';
}


}

/// @nodoc
abstract mixin class $WeatherLocationCopyWith<$Res>  {
  factory $WeatherLocationCopyWith(WeatherLocation value, $Res Function(WeatherLocation) _then) = _$WeatherLocationCopyWithImpl;
@useResult
$Res call({
 String name, String region, String country, double latitude, double longitude, String timezone
});




}
/// @nodoc
class _$WeatherLocationCopyWithImpl<$Res>
    implements $WeatherLocationCopyWith<$Res> {
  _$WeatherLocationCopyWithImpl(this._self, this._then);

  final WeatherLocation _self;
  final $Res Function(WeatherLocation) _then;

/// Create a copy of WeatherLocation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? region = null,Object? country = null,Object? latitude = null,Object? longitude = null,Object? timezone = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,region: null == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [WeatherLocation].
extension WeatherLocationPatterns on WeatherLocation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeatherLocation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeatherLocation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeatherLocation value)  $default,){
final _that = this;
switch (_that) {
case _WeatherLocation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeatherLocation value)?  $default,){
final _that = this;
switch (_that) {
case _WeatherLocation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String region,  String country,  double latitude,  double longitude,  String timezone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeatherLocation() when $default != null:
return $default(_that.name,_that.region,_that.country,_that.latitude,_that.longitude,_that.timezone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String region,  String country,  double latitude,  double longitude,  String timezone)  $default,) {final _that = this;
switch (_that) {
case _WeatherLocation():
return $default(_that.name,_that.region,_that.country,_that.latitude,_that.longitude,_that.timezone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String region,  String country,  double latitude,  double longitude,  String timezone)?  $default,) {final _that = this;
switch (_that) {
case _WeatherLocation() when $default != null:
return $default(_that.name,_that.region,_that.country,_that.latitude,_that.longitude,_that.timezone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeatherLocation extends WeatherLocation {
  const _WeatherLocation({required this.name, required this.region, required this.country, required this.latitude, required this.longitude, required this.timezone}): super._();
  factory _WeatherLocation.fromJson(Map<String, dynamic> json) => _$WeatherLocationFromJson(json);

@override final  String name;
@override final  String region;
@override final  String country;
@override final  double latitude;
@override final  double longitude;
@override final  String timezone;

/// Create a copy of WeatherLocation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeatherLocationCopyWith<_WeatherLocation> get copyWith => __$WeatherLocationCopyWithImpl<_WeatherLocation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeatherLocationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeatherLocation&&(identical(other.name, name) || other.name == name)&&(identical(other.region, region) || other.region == region)&&(identical(other.country, country) || other.country == country)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.timezone, timezone) || other.timezone == timezone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,region,country,latitude,longitude,timezone);

@override
String toString() {
  return 'WeatherLocation(name: $name, region: $region, country: $country, latitude: $latitude, longitude: $longitude, timezone: $timezone)';
}


}

/// @nodoc
abstract mixin class _$WeatherLocationCopyWith<$Res> implements $WeatherLocationCopyWith<$Res> {
  factory _$WeatherLocationCopyWith(_WeatherLocation value, $Res Function(_WeatherLocation) _then) = __$WeatherLocationCopyWithImpl;
@override @useResult
$Res call({
 String name, String region, String country, double latitude, double longitude, String timezone
});




}
/// @nodoc
class __$WeatherLocationCopyWithImpl<$Res>
    implements _$WeatherLocationCopyWith<$Res> {
  __$WeatherLocationCopyWithImpl(this._self, this._then);

  final _WeatherLocation _self;
  final $Res Function(_WeatherLocation) _then;

/// Create a copy of WeatherLocation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? region = null,Object? country = null,Object? latitude = null,Object? longitude = null,Object? timezone = null,}) {
  return _then(_WeatherLocation(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,region: null == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SavedCommuteWindow {

 String get id; String get label; int get startMinutes; int get endMinutes;
/// Create a copy of SavedCommuteWindow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavedCommuteWindowCopyWith<SavedCommuteWindow> get copyWith => _$SavedCommuteWindowCopyWithImpl<SavedCommuteWindow>(this as SavedCommuteWindow, _$identity);

  /// Serializes this SavedCommuteWindow to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavedCommuteWindow&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.startMinutes, startMinutes) || other.startMinutes == startMinutes)&&(identical(other.endMinutes, endMinutes) || other.endMinutes == endMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,startMinutes,endMinutes);

@override
String toString() {
  return 'SavedCommuteWindow(id: $id, label: $label, startMinutes: $startMinutes, endMinutes: $endMinutes)';
}


}

/// @nodoc
abstract mixin class $SavedCommuteWindowCopyWith<$Res>  {
  factory $SavedCommuteWindowCopyWith(SavedCommuteWindow value, $Res Function(SavedCommuteWindow) _then) = _$SavedCommuteWindowCopyWithImpl;
@useResult
$Res call({
 String id, String label, int startMinutes, int endMinutes
});




}
/// @nodoc
class _$SavedCommuteWindowCopyWithImpl<$Res>
    implements $SavedCommuteWindowCopyWith<$Res> {
  _$SavedCommuteWindowCopyWithImpl(this._self, this._then);

  final SavedCommuteWindow _self;
  final $Res Function(SavedCommuteWindow) _then;

/// Create a copy of SavedCommuteWindow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? label = null,Object? startMinutes = null,Object? endMinutes = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,startMinutes: null == startMinutes ? _self.startMinutes : startMinutes // ignore: cast_nullable_to_non_nullable
as int,endMinutes: null == endMinutes ? _self.endMinutes : endMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SavedCommuteWindow].
extension SavedCommuteWindowPatterns on SavedCommuteWindow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SavedCommuteWindow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SavedCommuteWindow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SavedCommuteWindow value)  $default,){
final _that = this;
switch (_that) {
case _SavedCommuteWindow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SavedCommuteWindow value)?  $default,){
final _that = this;
switch (_that) {
case _SavedCommuteWindow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String label,  int startMinutes,  int endMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SavedCommuteWindow() when $default != null:
return $default(_that.id,_that.label,_that.startMinutes,_that.endMinutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String label,  int startMinutes,  int endMinutes)  $default,) {final _that = this;
switch (_that) {
case _SavedCommuteWindow():
return $default(_that.id,_that.label,_that.startMinutes,_that.endMinutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String label,  int startMinutes,  int endMinutes)?  $default,) {final _that = this;
switch (_that) {
case _SavedCommuteWindow() when $default != null:
return $default(_that.id,_that.label,_that.startMinutes,_that.endMinutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SavedCommuteWindow extends SavedCommuteWindow {
  const _SavedCommuteWindow({this.id = '', this.label = 'Saved window', this.startMinutes = 480, this.endMinutes = 540}): super._();
  factory _SavedCommuteWindow.fromJson(Map<String, dynamic> json) => _$SavedCommuteWindowFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey() final  String label;
@override@JsonKey() final  int startMinutes;
@override@JsonKey() final  int endMinutes;

/// Create a copy of SavedCommuteWindow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavedCommuteWindowCopyWith<_SavedCommuteWindow> get copyWith => __$SavedCommuteWindowCopyWithImpl<_SavedCommuteWindow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SavedCommuteWindowToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavedCommuteWindow&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.startMinutes, startMinutes) || other.startMinutes == startMinutes)&&(identical(other.endMinutes, endMinutes) || other.endMinutes == endMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,startMinutes,endMinutes);

@override
String toString() {
  return 'SavedCommuteWindow(id: $id, label: $label, startMinutes: $startMinutes, endMinutes: $endMinutes)';
}


}

/// @nodoc
abstract mixin class _$SavedCommuteWindowCopyWith<$Res> implements $SavedCommuteWindowCopyWith<$Res> {
  factory _$SavedCommuteWindowCopyWith(_SavedCommuteWindow value, $Res Function(_SavedCommuteWindow) _then) = __$SavedCommuteWindowCopyWithImpl;
@override @useResult
$Res call({
 String id, String label, int startMinutes, int endMinutes
});




}
/// @nodoc
class __$SavedCommuteWindowCopyWithImpl<$Res>
    implements _$SavedCommuteWindowCopyWith<$Res> {
  __$SavedCommuteWindowCopyWithImpl(this._self, this._then);

  final _SavedCommuteWindow _self;
  final $Res Function(_SavedCommuteWindow) _then;

/// Create a copy of SavedCommuteWindow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = null,Object? startMinutes = null,Object? endMinutes = null,}) {
  return _then(_SavedCommuteWindow(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,startMinutes: null == startMinutes ? _self.startMinutes : startMinutes // ignore: cast_nullable_to_non_nullable
as int,endMinutes: null == endMinutes ? _self.endMinutes : endMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CurrentConditions {

 DateTime get time; double get temperatureC; double get apparentTemperatureC; int get weatherCode; bool get isDay; double get precipitationMm; double get rainMm; double get showersMm; int get cloudCover; double get windSpeedKph; double get windGustKph; double get visibilityMeters;
/// Create a copy of CurrentConditions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CurrentConditionsCopyWith<CurrentConditions> get copyWith => _$CurrentConditionsCopyWithImpl<CurrentConditions>(this as CurrentConditions, _$identity);

  /// Serializes this CurrentConditions to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CurrentConditions&&(identical(other.time, time) || other.time == time)&&(identical(other.temperatureC, temperatureC) || other.temperatureC == temperatureC)&&(identical(other.apparentTemperatureC, apparentTemperatureC) || other.apparentTemperatureC == apparentTemperatureC)&&(identical(other.weatherCode, weatherCode) || other.weatherCode == weatherCode)&&(identical(other.isDay, isDay) || other.isDay == isDay)&&(identical(other.precipitationMm, precipitationMm) || other.precipitationMm == precipitationMm)&&(identical(other.rainMm, rainMm) || other.rainMm == rainMm)&&(identical(other.showersMm, showersMm) || other.showersMm == showersMm)&&(identical(other.cloudCover, cloudCover) || other.cloudCover == cloudCover)&&(identical(other.windSpeedKph, windSpeedKph) || other.windSpeedKph == windSpeedKph)&&(identical(other.windGustKph, windGustKph) || other.windGustKph == windGustKph)&&(identical(other.visibilityMeters, visibilityMeters) || other.visibilityMeters == visibilityMeters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,time,temperatureC,apparentTemperatureC,weatherCode,isDay,precipitationMm,rainMm,showersMm,cloudCover,windSpeedKph,windGustKph,visibilityMeters);

@override
String toString() {
  return 'CurrentConditions(time: $time, temperatureC: $temperatureC, apparentTemperatureC: $apparentTemperatureC, weatherCode: $weatherCode, isDay: $isDay, precipitationMm: $precipitationMm, rainMm: $rainMm, showersMm: $showersMm, cloudCover: $cloudCover, windSpeedKph: $windSpeedKph, windGustKph: $windGustKph, visibilityMeters: $visibilityMeters)';
}


}

/// @nodoc
abstract mixin class $CurrentConditionsCopyWith<$Res>  {
  factory $CurrentConditionsCopyWith(CurrentConditions value, $Res Function(CurrentConditions) _then) = _$CurrentConditionsCopyWithImpl;
@useResult
$Res call({
 DateTime time, double temperatureC, double apparentTemperatureC, int weatherCode, bool isDay, double precipitationMm, double rainMm, double showersMm, int cloudCover, double windSpeedKph, double windGustKph, double visibilityMeters
});




}
/// @nodoc
class _$CurrentConditionsCopyWithImpl<$Res>
    implements $CurrentConditionsCopyWith<$Res> {
  _$CurrentConditionsCopyWithImpl(this._self, this._then);

  final CurrentConditions _self;
  final $Res Function(CurrentConditions) _then;

/// Create a copy of CurrentConditions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? time = null,Object? temperatureC = null,Object? apparentTemperatureC = null,Object? weatherCode = null,Object? isDay = null,Object? precipitationMm = null,Object? rainMm = null,Object? showersMm = null,Object? cloudCover = null,Object? windSpeedKph = null,Object? windGustKph = null,Object? visibilityMeters = null,}) {
  return _then(_self.copyWith(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime,temperatureC: null == temperatureC ? _self.temperatureC : temperatureC // ignore: cast_nullable_to_non_nullable
as double,apparentTemperatureC: null == apparentTemperatureC ? _self.apparentTemperatureC : apparentTemperatureC // ignore: cast_nullable_to_non_nullable
as double,weatherCode: null == weatherCode ? _self.weatherCode : weatherCode // ignore: cast_nullable_to_non_nullable
as int,isDay: null == isDay ? _self.isDay : isDay // ignore: cast_nullable_to_non_nullable
as bool,precipitationMm: null == precipitationMm ? _self.precipitationMm : precipitationMm // ignore: cast_nullable_to_non_nullable
as double,rainMm: null == rainMm ? _self.rainMm : rainMm // ignore: cast_nullable_to_non_nullable
as double,showersMm: null == showersMm ? _self.showersMm : showersMm // ignore: cast_nullable_to_non_nullable
as double,cloudCover: null == cloudCover ? _self.cloudCover : cloudCover // ignore: cast_nullable_to_non_nullable
as int,windSpeedKph: null == windSpeedKph ? _self.windSpeedKph : windSpeedKph // ignore: cast_nullable_to_non_nullable
as double,windGustKph: null == windGustKph ? _self.windGustKph : windGustKph // ignore: cast_nullable_to_non_nullable
as double,visibilityMeters: null == visibilityMeters ? _self.visibilityMeters : visibilityMeters // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [CurrentConditions].
extension CurrentConditionsPatterns on CurrentConditions {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CurrentConditions value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CurrentConditions() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CurrentConditions value)  $default,){
final _that = this;
switch (_that) {
case _CurrentConditions():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CurrentConditions value)?  $default,){
final _that = this;
switch (_that) {
case _CurrentConditions() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime time,  double temperatureC,  double apparentTemperatureC,  int weatherCode,  bool isDay,  double precipitationMm,  double rainMm,  double showersMm,  int cloudCover,  double windSpeedKph,  double windGustKph,  double visibilityMeters)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CurrentConditions() when $default != null:
return $default(_that.time,_that.temperatureC,_that.apparentTemperatureC,_that.weatherCode,_that.isDay,_that.precipitationMm,_that.rainMm,_that.showersMm,_that.cloudCover,_that.windSpeedKph,_that.windGustKph,_that.visibilityMeters);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime time,  double temperatureC,  double apparentTemperatureC,  int weatherCode,  bool isDay,  double precipitationMm,  double rainMm,  double showersMm,  int cloudCover,  double windSpeedKph,  double windGustKph,  double visibilityMeters)  $default,) {final _that = this;
switch (_that) {
case _CurrentConditions():
return $default(_that.time,_that.temperatureC,_that.apparentTemperatureC,_that.weatherCode,_that.isDay,_that.precipitationMm,_that.rainMm,_that.showersMm,_that.cloudCover,_that.windSpeedKph,_that.windGustKph,_that.visibilityMeters);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime time,  double temperatureC,  double apparentTemperatureC,  int weatherCode,  bool isDay,  double precipitationMm,  double rainMm,  double showersMm,  int cloudCover,  double windSpeedKph,  double windGustKph,  double visibilityMeters)?  $default,) {final _that = this;
switch (_that) {
case _CurrentConditions() when $default != null:
return $default(_that.time,_that.temperatureC,_that.apparentTemperatureC,_that.weatherCode,_that.isDay,_that.precipitationMm,_that.rainMm,_that.showersMm,_that.cloudCover,_that.windSpeedKph,_that.windGustKph,_that.visibilityMeters);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CurrentConditions implements CurrentConditions {
  const _CurrentConditions({required this.time, required this.temperatureC, required this.apparentTemperatureC, required this.weatherCode, required this.isDay, required this.precipitationMm, required this.rainMm, required this.showersMm, required this.cloudCover, required this.windSpeedKph, required this.windGustKph, required this.visibilityMeters});
  factory _CurrentConditions.fromJson(Map<String, dynamic> json) => _$CurrentConditionsFromJson(json);

@override final  DateTime time;
@override final  double temperatureC;
@override final  double apparentTemperatureC;
@override final  int weatherCode;
@override final  bool isDay;
@override final  double precipitationMm;
@override final  double rainMm;
@override final  double showersMm;
@override final  int cloudCover;
@override final  double windSpeedKph;
@override final  double windGustKph;
@override final  double visibilityMeters;

/// Create a copy of CurrentConditions
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CurrentConditionsCopyWith<_CurrentConditions> get copyWith => __$CurrentConditionsCopyWithImpl<_CurrentConditions>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CurrentConditionsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CurrentConditions&&(identical(other.time, time) || other.time == time)&&(identical(other.temperatureC, temperatureC) || other.temperatureC == temperatureC)&&(identical(other.apparentTemperatureC, apparentTemperatureC) || other.apparentTemperatureC == apparentTemperatureC)&&(identical(other.weatherCode, weatherCode) || other.weatherCode == weatherCode)&&(identical(other.isDay, isDay) || other.isDay == isDay)&&(identical(other.precipitationMm, precipitationMm) || other.precipitationMm == precipitationMm)&&(identical(other.rainMm, rainMm) || other.rainMm == rainMm)&&(identical(other.showersMm, showersMm) || other.showersMm == showersMm)&&(identical(other.cloudCover, cloudCover) || other.cloudCover == cloudCover)&&(identical(other.windSpeedKph, windSpeedKph) || other.windSpeedKph == windSpeedKph)&&(identical(other.windGustKph, windGustKph) || other.windGustKph == windGustKph)&&(identical(other.visibilityMeters, visibilityMeters) || other.visibilityMeters == visibilityMeters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,time,temperatureC,apparentTemperatureC,weatherCode,isDay,precipitationMm,rainMm,showersMm,cloudCover,windSpeedKph,windGustKph,visibilityMeters);

@override
String toString() {
  return 'CurrentConditions(time: $time, temperatureC: $temperatureC, apparentTemperatureC: $apparentTemperatureC, weatherCode: $weatherCode, isDay: $isDay, precipitationMm: $precipitationMm, rainMm: $rainMm, showersMm: $showersMm, cloudCover: $cloudCover, windSpeedKph: $windSpeedKph, windGustKph: $windGustKph, visibilityMeters: $visibilityMeters)';
}


}

/// @nodoc
abstract mixin class _$CurrentConditionsCopyWith<$Res> implements $CurrentConditionsCopyWith<$Res> {
  factory _$CurrentConditionsCopyWith(_CurrentConditions value, $Res Function(_CurrentConditions) _then) = __$CurrentConditionsCopyWithImpl;
@override @useResult
$Res call({
 DateTime time, double temperatureC, double apparentTemperatureC, int weatherCode, bool isDay, double precipitationMm, double rainMm, double showersMm, int cloudCover, double windSpeedKph, double windGustKph, double visibilityMeters
});




}
/// @nodoc
class __$CurrentConditionsCopyWithImpl<$Res>
    implements _$CurrentConditionsCopyWith<$Res> {
  __$CurrentConditionsCopyWithImpl(this._self, this._then);

  final _CurrentConditions _self;
  final $Res Function(_CurrentConditions) _then;

/// Create a copy of CurrentConditions
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? time = null,Object? temperatureC = null,Object? apparentTemperatureC = null,Object? weatherCode = null,Object? isDay = null,Object? precipitationMm = null,Object? rainMm = null,Object? showersMm = null,Object? cloudCover = null,Object? windSpeedKph = null,Object? windGustKph = null,Object? visibilityMeters = null,}) {
  return _then(_CurrentConditions(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime,temperatureC: null == temperatureC ? _self.temperatureC : temperatureC // ignore: cast_nullable_to_non_nullable
as double,apparentTemperatureC: null == apparentTemperatureC ? _self.apparentTemperatureC : apparentTemperatureC // ignore: cast_nullable_to_non_nullable
as double,weatherCode: null == weatherCode ? _self.weatherCode : weatherCode // ignore: cast_nullable_to_non_nullable
as int,isDay: null == isDay ? _self.isDay : isDay // ignore: cast_nullable_to_non_nullable
as bool,precipitationMm: null == precipitationMm ? _self.precipitationMm : precipitationMm // ignore: cast_nullable_to_non_nullable
as double,rainMm: null == rainMm ? _self.rainMm : rainMm // ignore: cast_nullable_to_non_nullable
as double,showersMm: null == showersMm ? _self.showersMm : showersMm // ignore: cast_nullable_to_non_nullable
as double,cloudCover: null == cloudCover ? _self.cloudCover : cloudCover // ignore: cast_nullable_to_non_nullable
as int,windSpeedKph: null == windSpeedKph ? _self.windSpeedKph : windSpeedKph // ignore: cast_nullable_to_non_nullable
as double,windGustKph: null == windGustKph ? _self.windGustKph : windGustKph // ignore: cast_nullable_to_non_nullable
as double,visibilityMeters: null == visibilityMeters ? _self.visibilityMeters : visibilityMeters // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$MinuteForecast {

 DateTime get time; double get precipitationMm; int get weatherCode; double get windSpeedKph; double get visibilityMeters; bool get isDay;
/// Create a copy of MinuteForecast
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MinuteForecastCopyWith<MinuteForecast> get copyWith => _$MinuteForecastCopyWithImpl<MinuteForecast>(this as MinuteForecast, _$identity);

  /// Serializes this MinuteForecast to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MinuteForecast&&(identical(other.time, time) || other.time == time)&&(identical(other.precipitationMm, precipitationMm) || other.precipitationMm == precipitationMm)&&(identical(other.weatherCode, weatherCode) || other.weatherCode == weatherCode)&&(identical(other.windSpeedKph, windSpeedKph) || other.windSpeedKph == windSpeedKph)&&(identical(other.visibilityMeters, visibilityMeters) || other.visibilityMeters == visibilityMeters)&&(identical(other.isDay, isDay) || other.isDay == isDay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,time,precipitationMm,weatherCode,windSpeedKph,visibilityMeters,isDay);

@override
String toString() {
  return 'MinuteForecast(time: $time, precipitationMm: $precipitationMm, weatherCode: $weatherCode, windSpeedKph: $windSpeedKph, visibilityMeters: $visibilityMeters, isDay: $isDay)';
}


}

/// @nodoc
abstract mixin class $MinuteForecastCopyWith<$Res>  {
  factory $MinuteForecastCopyWith(MinuteForecast value, $Res Function(MinuteForecast) _then) = _$MinuteForecastCopyWithImpl;
@useResult
$Res call({
 DateTime time, double precipitationMm, int weatherCode, double windSpeedKph, double visibilityMeters, bool isDay
});




}
/// @nodoc
class _$MinuteForecastCopyWithImpl<$Res>
    implements $MinuteForecastCopyWith<$Res> {
  _$MinuteForecastCopyWithImpl(this._self, this._then);

  final MinuteForecast _self;
  final $Res Function(MinuteForecast) _then;

/// Create a copy of MinuteForecast
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? time = null,Object? precipitationMm = null,Object? weatherCode = null,Object? windSpeedKph = null,Object? visibilityMeters = null,Object? isDay = null,}) {
  return _then(_self.copyWith(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime,precipitationMm: null == precipitationMm ? _self.precipitationMm : precipitationMm // ignore: cast_nullable_to_non_nullable
as double,weatherCode: null == weatherCode ? _self.weatherCode : weatherCode // ignore: cast_nullable_to_non_nullable
as int,windSpeedKph: null == windSpeedKph ? _self.windSpeedKph : windSpeedKph // ignore: cast_nullable_to_non_nullable
as double,visibilityMeters: null == visibilityMeters ? _self.visibilityMeters : visibilityMeters // ignore: cast_nullable_to_non_nullable
as double,isDay: null == isDay ? _self.isDay : isDay // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MinuteForecast].
extension MinuteForecastPatterns on MinuteForecast {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MinuteForecast value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MinuteForecast() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MinuteForecast value)  $default,){
final _that = this;
switch (_that) {
case _MinuteForecast():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MinuteForecast value)?  $default,){
final _that = this;
switch (_that) {
case _MinuteForecast() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime time,  double precipitationMm,  int weatherCode,  double windSpeedKph,  double visibilityMeters,  bool isDay)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MinuteForecast() when $default != null:
return $default(_that.time,_that.precipitationMm,_that.weatherCode,_that.windSpeedKph,_that.visibilityMeters,_that.isDay);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime time,  double precipitationMm,  int weatherCode,  double windSpeedKph,  double visibilityMeters,  bool isDay)  $default,) {final _that = this;
switch (_that) {
case _MinuteForecast():
return $default(_that.time,_that.precipitationMm,_that.weatherCode,_that.windSpeedKph,_that.visibilityMeters,_that.isDay);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime time,  double precipitationMm,  int weatherCode,  double windSpeedKph,  double visibilityMeters,  bool isDay)?  $default,) {final _that = this;
switch (_that) {
case _MinuteForecast() when $default != null:
return $default(_that.time,_that.precipitationMm,_that.weatherCode,_that.windSpeedKph,_that.visibilityMeters,_that.isDay);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MinuteForecast implements MinuteForecast {
  const _MinuteForecast({required this.time, required this.precipitationMm, required this.weatherCode, required this.windSpeedKph, required this.visibilityMeters, required this.isDay});
  factory _MinuteForecast.fromJson(Map<String, dynamic> json) => _$MinuteForecastFromJson(json);

@override final  DateTime time;
@override final  double precipitationMm;
@override final  int weatherCode;
@override final  double windSpeedKph;
@override final  double visibilityMeters;
@override final  bool isDay;

/// Create a copy of MinuteForecast
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MinuteForecastCopyWith<_MinuteForecast> get copyWith => __$MinuteForecastCopyWithImpl<_MinuteForecast>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MinuteForecastToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MinuteForecast&&(identical(other.time, time) || other.time == time)&&(identical(other.precipitationMm, precipitationMm) || other.precipitationMm == precipitationMm)&&(identical(other.weatherCode, weatherCode) || other.weatherCode == weatherCode)&&(identical(other.windSpeedKph, windSpeedKph) || other.windSpeedKph == windSpeedKph)&&(identical(other.visibilityMeters, visibilityMeters) || other.visibilityMeters == visibilityMeters)&&(identical(other.isDay, isDay) || other.isDay == isDay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,time,precipitationMm,weatherCode,windSpeedKph,visibilityMeters,isDay);

@override
String toString() {
  return 'MinuteForecast(time: $time, precipitationMm: $precipitationMm, weatherCode: $weatherCode, windSpeedKph: $windSpeedKph, visibilityMeters: $visibilityMeters, isDay: $isDay)';
}


}

/// @nodoc
abstract mixin class _$MinuteForecastCopyWith<$Res> implements $MinuteForecastCopyWith<$Res> {
  factory _$MinuteForecastCopyWith(_MinuteForecast value, $Res Function(_MinuteForecast) _then) = __$MinuteForecastCopyWithImpl;
@override @useResult
$Res call({
 DateTime time, double precipitationMm, int weatherCode, double windSpeedKph, double visibilityMeters, bool isDay
});




}
/// @nodoc
class __$MinuteForecastCopyWithImpl<$Res>
    implements _$MinuteForecastCopyWith<$Res> {
  __$MinuteForecastCopyWithImpl(this._self, this._then);

  final _MinuteForecast _self;
  final $Res Function(_MinuteForecast) _then;

/// Create a copy of MinuteForecast
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? time = null,Object? precipitationMm = null,Object? weatherCode = null,Object? windSpeedKph = null,Object? visibilityMeters = null,Object? isDay = null,}) {
  return _then(_MinuteForecast(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime,precipitationMm: null == precipitationMm ? _self.precipitationMm : precipitationMm // ignore: cast_nullable_to_non_nullable
as double,weatherCode: null == weatherCode ? _self.weatherCode : weatherCode // ignore: cast_nullable_to_non_nullable
as int,windSpeedKph: null == windSpeedKph ? _self.windSpeedKph : windSpeedKph // ignore: cast_nullable_to_non_nullable
as double,visibilityMeters: null == visibilityMeters ? _self.visibilityMeters : visibilityMeters // ignore: cast_nullable_to_non_nullable
as double,isDay: null == isDay ? _self.isDay : isDay // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$HourlyForecast {

 DateTime get time; double get temperatureC; double get apparentTemperatureC; int get precipitationProbability; double get precipitationMm; int get weatherCode; double get windSpeedKph; double get windGustKph; double get visibilityMeters; int get cloudCover; double get uvIndex; bool get isDay;
/// Create a copy of HourlyForecast
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HourlyForecastCopyWith<HourlyForecast> get copyWith => _$HourlyForecastCopyWithImpl<HourlyForecast>(this as HourlyForecast, _$identity);

  /// Serializes this HourlyForecast to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HourlyForecast&&(identical(other.time, time) || other.time == time)&&(identical(other.temperatureC, temperatureC) || other.temperatureC == temperatureC)&&(identical(other.apparentTemperatureC, apparentTemperatureC) || other.apparentTemperatureC == apparentTemperatureC)&&(identical(other.precipitationProbability, precipitationProbability) || other.precipitationProbability == precipitationProbability)&&(identical(other.precipitationMm, precipitationMm) || other.precipitationMm == precipitationMm)&&(identical(other.weatherCode, weatherCode) || other.weatherCode == weatherCode)&&(identical(other.windSpeedKph, windSpeedKph) || other.windSpeedKph == windSpeedKph)&&(identical(other.windGustKph, windGustKph) || other.windGustKph == windGustKph)&&(identical(other.visibilityMeters, visibilityMeters) || other.visibilityMeters == visibilityMeters)&&(identical(other.cloudCover, cloudCover) || other.cloudCover == cloudCover)&&(identical(other.uvIndex, uvIndex) || other.uvIndex == uvIndex)&&(identical(other.isDay, isDay) || other.isDay == isDay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,time,temperatureC,apparentTemperatureC,precipitationProbability,precipitationMm,weatherCode,windSpeedKph,windGustKph,visibilityMeters,cloudCover,uvIndex,isDay);

@override
String toString() {
  return 'HourlyForecast(time: $time, temperatureC: $temperatureC, apparentTemperatureC: $apparentTemperatureC, precipitationProbability: $precipitationProbability, precipitationMm: $precipitationMm, weatherCode: $weatherCode, windSpeedKph: $windSpeedKph, windGustKph: $windGustKph, visibilityMeters: $visibilityMeters, cloudCover: $cloudCover, uvIndex: $uvIndex, isDay: $isDay)';
}


}

/// @nodoc
abstract mixin class $HourlyForecastCopyWith<$Res>  {
  factory $HourlyForecastCopyWith(HourlyForecast value, $Res Function(HourlyForecast) _then) = _$HourlyForecastCopyWithImpl;
@useResult
$Res call({
 DateTime time, double temperatureC, double apparentTemperatureC, int precipitationProbability, double precipitationMm, int weatherCode, double windSpeedKph, double windGustKph, double visibilityMeters, int cloudCover, double uvIndex, bool isDay
});




}
/// @nodoc
class _$HourlyForecastCopyWithImpl<$Res>
    implements $HourlyForecastCopyWith<$Res> {
  _$HourlyForecastCopyWithImpl(this._self, this._then);

  final HourlyForecast _self;
  final $Res Function(HourlyForecast) _then;

/// Create a copy of HourlyForecast
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? time = null,Object? temperatureC = null,Object? apparentTemperatureC = null,Object? precipitationProbability = null,Object? precipitationMm = null,Object? weatherCode = null,Object? windSpeedKph = null,Object? windGustKph = null,Object? visibilityMeters = null,Object? cloudCover = null,Object? uvIndex = null,Object? isDay = null,}) {
  return _then(_self.copyWith(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime,temperatureC: null == temperatureC ? _self.temperatureC : temperatureC // ignore: cast_nullable_to_non_nullable
as double,apparentTemperatureC: null == apparentTemperatureC ? _self.apparentTemperatureC : apparentTemperatureC // ignore: cast_nullable_to_non_nullable
as double,precipitationProbability: null == precipitationProbability ? _self.precipitationProbability : precipitationProbability // ignore: cast_nullable_to_non_nullable
as int,precipitationMm: null == precipitationMm ? _self.precipitationMm : precipitationMm // ignore: cast_nullable_to_non_nullable
as double,weatherCode: null == weatherCode ? _self.weatherCode : weatherCode // ignore: cast_nullable_to_non_nullable
as int,windSpeedKph: null == windSpeedKph ? _self.windSpeedKph : windSpeedKph // ignore: cast_nullable_to_non_nullable
as double,windGustKph: null == windGustKph ? _self.windGustKph : windGustKph // ignore: cast_nullable_to_non_nullable
as double,visibilityMeters: null == visibilityMeters ? _self.visibilityMeters : visibilityMeters // ignore: cast_nullable_to_non_nullable
as double,cloudCover: null == cloudCover ? _self.cloudCover : cloudCover // ignore: cast_nullable_to_non_nullable
as int,uvIndex: null == uvIndex ? _self.uvIndex : uvIndex // ignore: cast_nullable_to_non_nullable
as double,isDay: null == isDay ? _self.isDay : isDay // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [HourlyForecast].
extension HourlyForecastPatterns on HourlyForecast {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HourlyForecast value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HourlyForecast() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HourlyForecast value)  $default,){
final _that = this;
switch (_that) {
case _HourlyForecast():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HourlyForecast value)?  $default,){
final _that = this;
switch (_that) {
case _HourlyForecast() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime time,  double temperatureC,  double apparentTemperatureC,  int precipitationProbability,  double precipitationMm,  int weatherCode,  double windSpeedKph,  double windGustKph,  double visibilityMeters,  int cloudCover,  double uvIndex,  bool isDay)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HourlyForecast() when $default != null:
return $default(_that.time,_that.temperatureC,_that.apparentTemperatureC,_that.precipitationProbability,_that.precipitationMm,_that.weatherCode,_that.windSpeedKph,_that.windGustKph,_that.visibilityMeters,_that.cloudCover,_that.uvIndex,_that.isDay);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime time,  double temperatureC,  double apparentTemperatureC,  int precipitationProbability,  double precipitationMm,  int weatherCode,  double windSpeedKph,  double windGustKph,  double visibilityMeters,  int cloudCover,  double uvIndex,  bool isDay)  $default,) {final _that = this;
switch (_that) {
case _HourlyForecast():
return $default(_that.time,_that.temperatureC,_that.apparentTemperatureC,_that.precipitationProbability,_that.precipitationMm,_that.weatherCode,_that.windSpeedKph,_that.windGustKph,_that.visibilityMeters,_that.cloudCover,_that.uvIndex,_that.isDay);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime time,  double temperatureC,  double apparentTemperatureC,  int precipitationProbability,  double precipitationMm,  int weatherCode,  double windSpeedKph,  double windGustKph,  double visibilityMeters,  int cloudCover,  double uvIndex,  bool isDay)?  $default,) {final _that = this;
switch (_that) {
case _HourlyForecast() when $default != null:
return $default(_that.time,_that.temperatureC,_that.apparentTemperatureC,_that.precipitationProbability,_that.precipitationMm,_that.weatherCode,_that.windSpeedKph,_that.windGustKph,_that.visibilityMeters,_that.cloudCover,_that.uvIndex,_that.isDay);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HourlyForecast implements HourlyForecast {
  const _HourlyForecast({required this.time, required this.temperatureC, required this.apparentTemperatureC, required this.precipitationProbability, required this.precipitationMm, required this.weatherCode, required this.windSpeedKph, required this.windGustKph, required this.visibilityMeters, required this.cloudCover, required this.uvIndex, required this.isDay});
  factory _HourlyForecast.fromJson(Map<String, dynamic> json) => _$HourlyForecastFromJson(json);

@override final  DateTime time;
@override final  double temperatureC;
@override final  double apparentTemperatureC;
@override final  int precipitationProbability;
@override final  double precipitationMm;
@override final  int weatherCode;
@override final  double windSpeedKph;
@override final  double windGustKph;
@override final  double visibilityMeters;
@override final  int cloudCover;
@override final  double uvIndex;
@override final  bool isDay;

/// Create a copy of HourlyForecast
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HourlyForecastCopyWith<_HourlyForecast> get copyWith => __$HourlyForecastCopyWithImpl<_HourlyForecast>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HourlyForecastToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HourlyForecast&&(identical(other.time, time) || other.time == time)&&(identical(other.temperatureC, temperatureC) || other.temperatureC == temperatureC)&&(identical(other.apparentTemperatureC, apparentTemperatureC) || other.apparentTemperatureC == apparentTemperatureC)&&(identical(other.precipitationProbability, precipitationProbability) || other.precipitationProbability == precipitationProbability)&&(identical(other.precipitationMm, precipitationMm) || other.precipitationMm == precipitationMm)&&(identical(other.weatherCode, weatherCode) || other.weatherCode == weatherCode)&&(identical(other.windSpeedKph, windSpeedKph) || other.windSpeedKph == windSpeedKph)&&(identical(other.windGustKph, windGustKph) || other.windGustKph == windGustKph)&&(identical(other.visibilityMeters, visibilityMeters) || other.visibilityMeters == visibilityMeters)&&(identical(other.cloudCover, cloudCover) || other.cloudCover == cloudCover)&&(identical(other.uvIndex, uvIndex) || other.uvIndex == uvIndex)&&(identical(other.isDay, isDay) || other.isDay == isDay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,time,temperatureC,apparentTemperatureC,precipitationProbability,precipitationMm,weatherCode,windSpeedKph,windGustKph,visibilityMeters,cloudCover,uvIndex,isDay);

@override
String toString() {
  return 'HourlyForecast(time: $time, temperatureC: $temperatureC, apparentTemperatureC: $apparentTemperatureC, precipitationProbability: $precipitationProbability, precipitationMm: $precipitationMm, weatherCode: $weatherCode, windSpeedKph: $windSpeedKph, windGustKph: $windGustKph, visibilityMeters: $visibilityMeters, cloudCover: $cloudCover, uvIndex: $uvIndex, isDay: $isDay)';
}


}

/// @nodoc
abstract mixin class _$HourlyForecastCopyWith<$Res> implements $HourlyForecastCopyWith<$Res> {
  factory _$HourlyForecastCopyWith(_HourlyForecast value, $Res Function(_HourlyForecast) _then) = __$HourlyForecastCopyWithImpl;
@override @useResult
$Res call({
 DateTime time, double temperatureC, double apparentTemperatureC, int precipitationProbability, double precipitationMm, int weatherCode, double windSpeedKph, double windGustKph, double visibilityMeters, int cloudCover, double uvIndex, bool isDay
});




}
/// @nodoc
class __$HourlyForecastCopyWithImpl<$Res>
    implements _$HourlyForecastCopyWith<$Res> {
  __$HourlyForecastCopyWithImpl(this._self, this._then);

  final _HourlyForecast _self;
  final $Res Function(_HourlyForecast) _then;

/// Create a copy of HourlyForecast
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? time = null,Object? temperatureC = null,Object? apparentTemperatureC = null,Object? precipitationProbability = null,Object? precipitationMm = null,Object? weatherCode = null,Object? windSpeedKph = null,Object? windGustKph = null,Object? visibilityMeters = null,Object? cloudCover = null,Object? uvIndex = null,Object? isDay = null,}) {
  return _then(_HourlyForecast(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime,temperatureC: null == temperatureC ? _self.temperatureC : temperatureC // ignore: cast_nullable_to_non_nullable
as double,apparentTemperatureC: null == apparentTemperatureC ? _self.apparentTemperatureC : apparentTemperatureC // ignore: cast_nullable_to_non_nullable
as double,precipitationProbability: null == precipitationProbability ? _self.precipitationProbability : precipitationProbability // ignore: cast_nullable_to_non_nullable
as int,precipitationMm: null == precipitationMm ? _self.precipitationMm : precipitationMm // ignore: cast_nullable_to_non_nullable
as double,weatherCode: null == weatherCode ? _self.weatherCode : weatherCode // ignore: cast_nullable_to_non_nullable
as int,windSpeedKph: null == windSpeedKph ? _self.windSpeedKph : windSpeedKph // ignore: cast_nullable_to_non_nullable
as double,windGustKph: null == windGustKph ? _self.windGustKph : windGustKph // ignore: cast_nullable_to_non_nullable
as double,visibilityMeters: null == visibilityMeters ? _self.visibilityMeters : visibilityMeters // ignore: cast_nullable_to_non_nullable
as double,cloudCover: null == cloudCover ? _self.cloudCover : cloudCover // ignore: cast_nullable_to_non_nullable
as int,uvIndex: null == uvIndex ? _self.uvIndex : uvIndex // ignore: cast_nullable_to_non_nullable
as double,isDay: null == isDay ? _self.isDay : isDay // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$DailyForecast {

 DateTime get date; int get weatherCode; double get maxTempC; double get minTempC; double get precipitationMm; int get precipitationProbabilityMax; double get maxWindKph; double get uvIndexMax; DateTime get sunrise; DateTime get sunset;
/// Create a copy of DailyForecast
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyForecastCopyWith<DailyForecast> get copyWith => _$DailyForecastCopyWithImpl<DailyForecast>(this as DailyForecast, _$identity);

  /// Serializes this DailyForecast to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyForecast&&(identical(other.date, date) || other.date == date)&&(identical(other.weatherCode, weatherCode) || other.weatherCode == weatherCode)&&(identical(other.maxTempC, maxTempC) || other.maxTempC == maxTempC)&&(identical(other.minTempC, minTempC) || other.minTempC == minTempC)&&(identical(other.precipitationMm, precipitationMm) || other.precipitationMm == precipitationMm)&&(identical(other.precipitationProbabilityMax, precipitationProbabilityMax) || other.precipitationProbabilityMax == precipitationProbabilityMax)&&(identical(other.maxWindKph, maxWindKph) || other.maxWindKph == maxWindKph)&&(identical(other.uvIndexMax, uvIndexMax) || other.uvIndexMax == uvIndexMax)&&(identical(other.sunrise, sunrise) || other.sunrise == sunrise)&&(identical(other.sunset, sunset) || other.sunset == sunset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,weatherCode,maxTempC,minTempC,precipitationMm,precipitationProbabilityMax,maxWindKph,uvIndexMax,sunrise,sunset);

@override
String toString() {
  return 'DailyForecast(date: $date, weatherCode: $weatherCode, maxTempC: $maxTempC, minTempC: $minTempC, precipitationMm: $precipitationMm, precipitationProbabilityMax: $precipitationProbabilityMax, maxWindKph: $maxWindKph, uvIndexMax: $uvIndexMax, sunrise: $sunrise, sunset: $sunset)';
}


}

/// @nodoc
abstract mixin class $DailyForecastCopyWith<$Res>  {
  factory $DailyForecastCopyWith(DailyForecast value, $Res Function(DailyForecast) _then) = _$DailyForecastCopyWithImpl;
@useResult
$Res call({
 DateTime date, int weatherCode, double maxTempC, double minTempC, double precipitationMm, int precipitationProbabilityMax, double maxWindKph, double uvIndexMax, DateTime sunrise, DateTime sunset
});




}
/// @nodoc
class _$DailyForecastCopyWithImpl<$Res>
    implements $DailyForecastCopyWith<$Res> {
  _$DailyForecastCopyWithImpl(this._self, this._then);

  final DailyForecast _self;
  final $Res Function(DailyForecast) _then;

/// Create a copy of DailyForecast
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? weatherCode = null,Object? maxTempC = null,Object? minTempC = null,Object? precipitationMm = null,Object? precipitationProbabilityMax = null,Object? maxWindKph = null,Object? uvIndexMax = null,Object? sunrise = null,Object? sunset = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,weatherCode: null == weatherCode ? _self.weatherCode : weatherCode // ignore: cast_nullable_to_non_nullable
as int,maxTempC: null == maxTempC ? _self.maxTempC : maxTempC // ignore: cast_nullable_to_non_nullable
as double,minTempC: null == minTempC ? _self.minTempC : minTempC // ignore: cast_nullable_to_non_nullable
as double,precipitationMm: null == precipitationMm ? _self.precipitationMm : precipitationMm // ignore: cast_nullable_to_non_nullable
as double,precipitationProbabilityMax: null == precipitationProbabilityMax ? _self.precipitationProbabilityMax : precipitationProbabilityMax // ignore: cast_nullable_to_non_nullable
as int,maxWindKph: null == maxWindKph ? _self.maxWindKph : maxWindKph // ignore: cast_nullable_to_non_nullable
as double,uvIndexMax: null == uvIndexMax ? _self.uvIndexMax : uvIndexMax // ignore: cast_nullable_to_non_nullable
as double,sunrise: null == sunrise ? _self.sunrise : sunrise // ignore: cast_nullable_to_non_nullable
as DateTime,sunset: null == sunset ? _self.sunset : sunset // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyForecast].
extension DailyForecastPatterns on DailyForecast {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyForecast value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyForecast() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyForecast value)  $default,){
final _that = this;
switch (_that) {
case _DailyForecast():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyForecast value)?  $default,){
final _that = this;
switch (_that) {
case _DailyForecast() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  int weatherCode,  double maxTempC,  double minTempC,  double precipitationMm,  int precipitationProbabilityMax,  double maxWindKph,  double uvIndexMax,  DateTime sunrise,  DateTime sunset)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyForecast() when $default != null:
return $default(_that.date,_that.weatherCode,_that.maxTempC,_that.minTempC,_that.precipitationMm,_that.precipitationProbabilityMax,_that.maxWindKph,_that.uvIndexMax,_that.sunrise,_that.sunset);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  int weatherCode,  double maxTempC,  double minTempC,  double precipitationMm,  int precipitationProbabilityMax,  double maxWindKph,  double uvIndexMax,  DateTime sunrise,  DateTime sunset)  $default,) {final _that = this;
switch (_that) {
case _DailyForecast():
return $default(_that.date,_that.weatherCode,_that.maxTempC,_that.minTempC,_that.precipitationMm,_that.precipitationProbabilityMax,_that.maxWindKph,_that.uvIndexMax,_that.sunrise,_that.sunset);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  int weatherCode,  double maxTempC,  double minTempC,  double precipitationMm,  int precipitationProbabilityMax,  double maxWindKph,  double uvIndexMax,  DateTime sunrise,  DateTime sunset)?  $default,) {final _that = this;
switch (_that) {
case _DailyForecast() when $default != null:
return $default(_that.date,_that.weatherCode,_that.maxTempC,_that.minTempC,_that.precipitationMm,_that.precipitationProbabilityMax,_that.maxWindKph,_that.uvIndexMax,_that.sunrise,_that.sunset);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DailyForecast implements DailyForecast {
  const _DailyForecast({required this.date, required this.weatherCode, required this.maxTempC, required this.minTempC, required this.precipitationMm, required this.precipitationProbabilityMax, required this.maxWindKph, required this.uvIndexMax, required this.sunrise, required this.sunset});
  factory _DailyForecast.fromJson(Map<String, dynamic> json) => _$DailyForecastFromJson(json);

@override final  DateTime date;
@override final  int weatherCode;
@override final  double maxTempC;
@override final  double minTempC;
@override final  double precipitationMm;
@override final  int precipitationProbabilityMax;
@override final  double maxWindKph;
@override final  double uvIndexMax;
@override final  DateTime sunrise;
@override final  DateTime sunset;

/// Create a copy of DailyForecast
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyForecastCopyWith<_DailyForecast> get copyWith => __$DailyForecastCopyWithImpl<_DailyForecast>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailyForecastToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyForecast&&(identical(other.date, date) || other.date == date)&&(identical(other.weatherCode, weatherCode) || other.weatherCode == weatherCode)&&(identical(other.maxTempC, maxTempC) || other.maxTempC == maxTempC)&&(identical(other.minTempC, minTempC) || other.minTempC == minTempC)&&(identical(other.precipitationMm, precipitationMm) || other.precipitationMm == precipitationMm)&&(identical(other.precipitationProbabilityMax, precipitationProbabilityMax) || other.precipitationProbabilityMax == precipitationProbabilityMax)&&(identical(other.maxWindKph, maxWindKph) || other.maxWindKph == maxWindKph)&&(identical(other.uvIndexMax, uvIndexMax) || other.uvIndexMax == uvIndexMax)&&(identical(other.sunrise, sunrise) || other.sunrise == sunrise)&&(identical(other.sunset, sunset) || other.sunset == sunset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,weatherCode,maxTempC,minTempC,precipitationMm,precipitationProbabilityMax,maxWindKph,uvIndexMax,sunrise,sunset);

@override
String toString() {
  return 'DailyForecast(date: $date, weatherCode: $weatherCode, maxTempC: $maxTempC, minTempC: $minTempC, precipitationMm: $precipitationMm, precipitationProbabilityMax: $precipitationProbabilityMax, maxWindKph: $maxWindKph, uvIndexMax: $uvIndexMax, sunrise: $sunrise, sunset: $sunset)';
}


}

/// @nodoc
abstract mixin class _$DailyForecastCopyWith<$Res> implements $DailyForecastCopyWith<$Res> {
  factory _$DailyForecastCopyWith(_DailyForecast value, $Res Function(_DailyForecast) _then) = __$DailyForecastCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, int weatherCode, double maxTempC, double minTempC, double precipitationMm, int precipitationProbabilityMax, double maxWindKph, double uvIndexMax, DateTime sunrise, DateTime sunset
});




}
/// @nodoc
class __$DailyForecastCopyWithImpl<$Res>
    implements _$DailyForecastCopyWith<$Res> {
  __$DailyForecastCopyWithImpl(this._self, this._then);

  final _DailyForecast _self;
  final $Res Function(_DailyForecast) _then;

/// Create a copy of DailyForecast
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? weatherCode = null,Object? maxTempC = null,Object? minTempC = null,Object? precipitationMm = null,Object? precipitationProbabilityMax = null,Object? maxWindKph = null,Object? uvIndexMax = null,Object? sunrise = null,Object? sunset = null,}) {
  return _then(_DailyForecast(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,weatherCode: null == weatherCode ? _self.weatherCode : weatherCode // ignore: cast_nullable_to_non_nullable
as int,maxTempC: null == maxTempC ? _self.maxTempC : maxTempC // ignore: cast_nullable_to_non_nullable
as double,minTempC: null == minTempC ? _self.minTempC : minTempC // ignore: cast_nullable_to_non_nullable
as double,precipitationMm: null == precipitationMm ? _self.precipitationMm : precipitationMm // ignore: cast_nullable_to_non_nullable
as double,precipitationProbabilityMax: null == precipitationProbabilityMax ? _self.precipitationProbabilityMax : precipitationProbabilityMax // ignore: cast_nullable_to_non_nullable
as int,maxWindKph: null == maxWindKph ? _self.maxWindKph : maxWindKph // ignore: cast_nullable_to_non_nullable
as double,uvIndexMax: null == uvIndexMax ? _self.uvIndexMax : uvIndexMax // ignore: cast_nullable_to_non_nullable
as double,sunrise: null == sunrise ? _self.sunrise : sunrise // ignore: cast_nullable_to_non_nullable
as DateTime,sunset: null == sunset ? _self.sunset : sunset // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$OfficialWarning {

 String get title; String get summary; String get severityLabel; String get sourceLabel; String? get link;
/// Create a copy of OfficialWarning
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OfficialWarningCopyWith<OfficialWarning> get copyWith => _$OfficialWarningCopyWithImpl<OfficialWarning>(this as OfficialWarning, _$identity);

  /// Serializes this OfficialWarning to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OfficialWarning&&(identical(other.title, title) || other.title == title)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.severityLabel, severityLabel) || other.severityLabel == severityLabel)&&(identical(other.sourceLabel, sourceLabel) || other.sourceLabel == sourceLabel)&&(identical(other.link, link) || other.link == link));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,summary,severityLabel,sourceLabel,link);

@override
String toString() {
  return 'OfficialWarning(title: $title, summary: $summary, severityLabel: $severityLabel, sourceLabel: $sourceLabel, link: $link)';
}


}

/// @nodoc
abstract mixin class $OfficialWarningCopyWith<$Res>  {
  factory $OfficialWarningCopyWith(OfficialWarning value, $Res Function(OfficialWarning) _then) = _$OfficialWarningCopyWithImpl;
@useResult
$Res call({
 String title, String summary, String severityLabel, String sourceLabel, String? link
});




}
/// @nodoc
class _$OfficialWarningCopyWithImpl<$Res>
    implements $OfficialWarningCopyWith<$Res> {
  _$OfficialWarningCopyWithImpl(this._self, this._then);

  final OfficialWarning _self;
  final $Res Function(OfficialWarning) _then;

/// Create a copy of OfficialWarning
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? summary = null,Object? severityLabel = null,Object? sourceLabel = null,Object? link = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,severityLabel: null == severityLabel ? _self.severityLabel : severityLabel // ignore: cast_nullable_to_non_nullable
as String,sourceLabel: null == sourceLabel ? _self.sourceLabel : sourceLabel // ignore: cast_nullable_to_non_nullable
as String,link: freezed == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OfficialWarning].
extension OfficialWarningPatterns on OfficialWarning {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OfficialWarning value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OfficialWarning() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OfficialWarning value)  $default,){
final _that = this;
switch (_that) {
case _OfficialWarning():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OfficialWarning value)?  $default,){
final _that = this;
switch (_that) {
case _OfficialWarning() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String summary,  String severityLabel,  String sourceLabel,  String? link)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OfficialWarning() when $default != null:
return $default(_that.title,_that.summary,_that.severityLabel,_that.sourceLabel,_that.link);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String summary,  String severityLabel,  String sourceLabel,  String? link)  $default,) {final _that = this;
switch (_that) {
case _OfficialWarning():
return $default(_that.title,_that.summary,_that.severityLabel,_that.sourceLabel,_that.link);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String summary,  String severityLabel,  String sourceLabel,  String? link)?  $default,) {final _that = this;
switch (_that) {
case _OfficialWarning() when $default != null:
return $default(_that.title,_that.summary,_that.severityLabel,_that.sourceLabel,_that.link);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OfficialWarning implements OfficialWarning {
  const _OfficialWarning({required this.title, required this.summary, required this.severityLabel, required this.sourceLabel, this.link});
  factory _OfficialWarning.fromJson(Map<String, dynamic> json) => _$OfficialWarningFromJson(json);

@override final  String title;
@override final  String summary;
@override final  String severityLabel;
@override final  String sourceLabel;
@override final  String? link;

/// Create a copy of OfficialWarning
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OfficialWarningCopyWith<_OfficialWarning> get copyWith => __$OfficialWarningCopyWithImpl<_OfficialWarning>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OfficialWarningToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OfficialWarning&&(identical(other.title, title) || other.title == title)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.severityLabel, severityLabel) || other.severityLabel == severityLabel)&&(identical(other.sourceLabel, sourceLabel) || other.sourceLabel == sourceLabel)&&(identical(other.link, link) || other.link == link));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,summary,severityLabel,sourceLabel,link);

@override
String toString() {
  return 'OfficialWarning(title: $title, summary: $summary, severityLabel: $severityLabel, sourceLabel: $sourceLabel, link: $link)';
}


}

/// @nodoc
abstract mixin class _$OfficialWarningCopyWith<$Res> implements $OfficialWarningCopyWith<$Res> {
  factory _$OfficialWarningCopyWith(_OfficialWarning value, $Res Function(_OfficialWarning) _then) = __$OfficialWarningCopyWithImpl;
@override @useResult
$Res call({
 String title, String summary, String severityLabel, String sourceLabel, String? link
});




}
/// @nodoc
class __$OfficialWarningCopyWithImpl<$Res>
    implements _$OfficialWarningCopyWith<$Res> {
  __$OfficialWarningCopyWithImpl(this._self, this._then);

  final _OfficialWarning _self;
  final $Res Function(_OfficialWarning) _then;

/// Create a copy of OfficialWarning
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? summary = null,Object? severityLabel = null,Object? sourceLabel = null,Object? link = freezed,}) {
  return _then(_OfficialWarning(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,severityLabel: null == severityLabel ? _self.severityLabel : severityLabel // ignore: cast_nullable_to_non_nullable
as String,sourceLabel: null == sourceLabel ? _self.sourceLabel : sourceLabel // ignore: cast_nullable_to_non_nullable
as String,link: freezed == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$WeatherReport {

 WeatherLocation get location; DateTime get fetchedAt; CurrentConditions get current; List<MinuteForecast> get minutely; List<HourlyForecast> get hourly; DailyForecast get today; List<DailyForecast> get daily; bool get usingFallback; String get sourceLabel; List<OfficialWarning> get officialWarnings; String? get sourceNote;
/// Create a copy of WeatherReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeatherReportCopyWith<WeatherReport> get copyWith => _$WeatherReportCopyWithImpl<WeatherReport>(this as WeatherReport, _$identity);

  /// Serializes this WeatherReport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeatherReport&&(identical(other.location, location) || other.location == location)&&(identical(other.fetchedAt, fetchedAt) || other.fetchedAt == fetchedAt)&&(identical(other.current, current) || other.current == current)&&const DeepCollectionEquality().equals(other.minutely, minutely)&&const DeepCollectionEquality().equals(other.hourly, hourly)&&(identical(other.today, today) || other.today == today)&&const DeepCollectionEquality().equals(other.daily, daily)&&(identical(other.usingFallback, usingFallback) || other.usingFallback == usingFallback)&&(identical(other.sourceLabel, sourceLabel) || other.sourceLabel == sourceLabel)&&const DeepCollectionEquality().equals(other.officialWarnings, officialWarnings)&&(identical(other.sourceNote, sourceNote) || other.sourceNote == sourceNote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,location,fetchedAt,current,const DeepCollectionEquality().hash(minutely),const DeepCollectionEquality().hash(hourly),today,const DeepCollectionEquality().hash(daily),usingFallback,sourceLabel,const DeepCollectionEquality().hash(officialWarnings),sourceNote);

@override
String toString() {
  return 'WeatherReport(location: $location, fetchedAt: $fetchedAt, current: $current, minutely: $minutely, hourly: $hourly, today: $today, daily: $daily, usingFallback: $usingFallback, sourceLabel: $sourceLabel, officialWarnings: $officialWarnings, sourceNote: $sourceNote)';
}


}

/// @nodoc
abstract mixin class $WeatherReportCopyWith<$Res>  {
  factory $WeatherReportCopyWith(WeatherReport value, $Res Function(WeatherReport) _then) = _$WeatherReportCopyWithImpl;
@useResult
$Res call({
 WeatherLocation location, DateTime fetchedAt, CurrentConditions current, List<MinuteForecast> minutely, List<HourlyForecast> hourly, DailyForecast today, List<DailyForecast> daily, bool usingFallback, String sourceLabel, List<OfficialWarning> officialWarnings, String? sourceNote
});


$WeatherLocationCopyWith<$Res> get location;$CurrentConditionsCopyWith<$Res> get current;$DailyForecastCopyWith<$Res> get today;

}
/// @nodoc
class _$WeatherReportCopyWithImpl<$Res>
    implements $WeatherReportCopyWith<$Res> {
  _$WeatherReportCopyWithImpl(this._self, this._then);

  final WeatherReport _self;
  final $Res Function(WeatherReport) _then;

/// Create a copy of WeatherReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? location = null,Object? fetchedAt = null,Object? current = null,Object? minutely = null,Object? hourly = null,Object? today = null,Object? daily = null,Object? usingFallback = null,Object? sourceLabel = null,Object? officialWarnings = null,Object? sourceNote = freezed,}) {
  return _then(_self.copyWith(
location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as WeatherLocation,fetchedAt: null == fetchedAt ? _self.fetchedAt : fetchedAt // ignore: cast_nullable_to_non_nullable
as DateTime,current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as CurrentConditions,minutely: null == minutely ? _self.minutely : minutely // ignore: cast_nullable_to_non_nullable
as List<MinuteForecast>,hourly: null == hourly ? _self.hourly : hourly // ignore: cast_nullable_to_non_nullable
as List<HourlyForecast>,today: null == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as DailyForecast,daily: null == daily ? _self.daily : daily // ignore: cast_nullable_to_non_nullable
as List<DailyForecast>,usingFallback: null == usingFallback ? _self.usingFallback : usingFallback // ignore: cast_nullable_to_non_nullable
as bool,sourceLabel: null == sourceLabel ? _self.sourceLabel : sourceLabel // ignore: cast_nullable_to_non_nullable
as String,officialWarnings: null == officialWarnings ? _self.officialWarnings : officialWarnings // ignore: cast_nullable_to_non_nullable
as List<OfficialWarning>,sourceNote: freezed == sourceNote ? _self.sourceNote : sourceNote // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of WeatherReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeatherLocationCopyWith<$Res> get location {
  
  return $WeatherLocationCopyWith<$Res>(_self.location, (value) {
    return _then(_self.copyWith(location: value));
  });
}/// Create a copy of WeatherReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CurrentConditionsCopyWith<$Res> get current {
  
  return $CurrentConditionsCopyWith<$Res>(_self.current, (value) {
    return _then(_self.copyWith(current: value));
  });
}/// Create a copy of WeatherReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DailyForecastCopyWith<$Res> get today {
  
  return $DailyForecastCopyWith<$Res>(_self.today, (value) {
    return _then(_self.copyWith(today: value));
  });
}
}


/// Adds pattern-matching-related methods to [WeatherReport].
extension WeatherReportPatterns on WeatherReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeatherReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeatherReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeatherReport value)  $default,){
final _that = this;
switch (_that) {
case _WeatherReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeatherReport value)?  $default,){
final _that = this;
switch (_that) {
case _WeatherReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( WeatherLocation location,  DateTime fetchedAt,  CurrentConditions current,  List<MinuteForecast> minutely,  List<HourlyForecast> hourly,  DailyForecast today,  List<DailyForecast> daily,  bool usingFallback,  String sourceLabel,  List<OfficialWarning> officialWarnings,  String? sourceNote)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeatherReport() when $default != null:
return $default(_that.location,_that.fetchedAt,_that.current,_that.minutely,_that.hourly,_that.today,_that.daily,_that.usingFallback,_that.sourceLabel,_that.officialWarnings,_that.sourceNote);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( WeatherLocation location,  DateTime fetchedAt,  CurrentConditions current,  List<MinuteForecast> minutely,  List<HourlyForecast> hourly,  DailyForecast today,  List<DailyForecast> daily,  bool usingFallback,  String sourceLabel,  List<OfficialWarning> officialWarnings,  String? sourceNote)  $default,) {final _that = this;
switch (_that) {
case _WeatherReport():
return $default(_that.location,_that.fetchedAt,_that.current,_that.minutely,_that.hourly,_that.today,_that.daily,_that.usingFallback,_that.sourceLabel,_that.officialWarnings,_that.sourceNote);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( WeatherLocation location,  DateTime fetchedAt,  CurrentConditions current,  List<MinuteForecast> minutely,  List<HourlyForecast> hourly,  DailyForecast today,  List<DailyForecast> daily,  bool usingFallback,  String sourceLabel,  List<OfficialWarning> officialWarnings,  String? sourceNote)?  $default,) {final _that = this;
switch (_that) {
case _WeatherReport() when $default != null:
return $default(_that.location,_that.fetchedAt,_that.current,_that.minutely,_that.hourly,_that.today,_that.daily,_that.usingFallback,_that.sourceLabel,_that.officialWarnings,_that.sourceNote);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeatherReport implements WeatherReport {
  const _WeatherReport({required this.location, required this.fetchedAt, required this.current, required final  List<MinuteForecast> minutely, required final  List<HourlyForecast> hourly, required this.today, required final  List<DailyForecast> daily, required this.usingFallback, required this.sourceLabel, final  List<OfficialWarning> officialWarnings = const <OfficialWarning>[], this.sourceNote}): _minutely = minutely,_hourly = hourly,_daily = daily,_officialWarnings = officialWarnings;
  factory _WeatherReport.fromJson(Map<String, dynamic> json) => _$WeatherReportFromJson(json);

@override final  WeatherLocation location;
@override final  DateTime fetchedAt;
@override final  CurrentConditions current;
 final  List<MinuteForecast> _minutely;
@override List<MinuteForecast> get minutely {
  if (_minutely is EqualUnmodifiableListView) return _minutely;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_minutely);
}

 final  List<HourlyForecast> _hourly;
@override List<HourlyForecast> get hourly {
  if (_hourly is EqualUnmodifiableListView) return _hourly;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_hourly);
}

@override final  DailyForecast today;
 final  List<DailyForecast> _daily;
@override List<DailyForecast> get daily {
  if (_daily is EqualUnmodifiableListView) return _daily;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_daily);
}

@override final  bool usingFallback;
@override final  String sourceLabel;
 final  List<OfficialWarning> _officialWarnings;
@override@JsonKey() List<OfficialWarning> get officialWarnings {
  if (_officialWarnings is EqualUnmodifiableListView) return _officialWarnings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_officialWarnings);
}

@override final  String? sourceNote;

/// Create a copy of WeatherReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeatherReportCopyWith<_WeatherReport> get copyWith => __$WeatherReportCopyWithImpl<_WeatherReport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeatherReportToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeatherReport&&(identical(other.location, location) || other.location == location)&&(identical(other.fetchedAt, fetchedAt) || other.fetchedAt == fetchedAt)&&(identical(other.current, current) || other.current == current)&&const DeepCollectionEquality().equals(other._minutely, _minutely)&&const DeepCollectionEquality().equals(other._hourly, _hourly)&&(identical(other.today, today) || other.today == today)&&const DeepCollectionEquality().equals(other._daily, _daily)&&(identical(other.usingFallback, usingFallback) || other.usingFallback == usingFallback)&&(identical(other.sourceLabel, sourceLabel) || other.sourceLabel == sourceLabel)&&const DeepCollectionEquality().equals(other._officialWarnings, _officialWarnings)&&(identical(other.sourceNote, sourceNote) || other.sourceNote == sourceNote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,location,fetchedAt,current,const DeepCollectionEquality().hash(_minutely),const DeepCollectionEquality().hash(_hourly),today,const DeepCollectionEquality().hash(_daily),usingFallback,sourceLabel,const DeepCollectionEquality().hash(_officialWarnings),sourceNote);

@override
String toString() {
  return 'WeatherReport(location: $location, fetchedAt: $fetchedAt, current: $current, minutely: $minutely, hourly: $hourly, today: $today, daily: $daily, usingFallback: $usingFallback, sourceLabel: $sourceLabel, officialWarnings: $officialWarnings, sourceNote: $sourceNote)';
}


}

/// @nodoc
abstract mixin class _$WeatherReportCopyWith<$Res> implements $WeatherReportCopyWith<$Res> {
  factory _$WeatherReportCopyWith(_WeatherReport value, $Res Function(_WeatherReport) _then) = __$WeatherReportCopyWithImpl;
@override @useResult
$Res call({
 WeatherLocation location, DateTime fetchedAt, CurrentConditions current, List<MinuteForecast> minutely, List<HourlyForecast> hourly, DailyForecast today, List<DailyForecast> daily, bool usingFallback, String sourceLabel, List<OfficialWarning> officialWarnings, String? sourceNote
});


@override $WeatherLocationCopyWith<$Res> get location;@override $CurrentConditionsCopyWith<$Res> get current;@override $DailyForecastCopyWith<$Res> get today;

}
/// @nodoc
class __$WeatherReportCopyWithImpl<$Res>
    implements _$WeatherReportCopyWith<$Res> {
  __$WeatherReportCopyWithImpl(this._self, this._then);

  final _WeatherReport _self;
  final $Res Function(_WeatherReport) _then;

/// Create a copy of WeatherReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? location = null,Object? fetchedAt = null,Object? current = null,Object? minutely = null,Object? hourly = null,Object? today = null,Object? daily = null,Object? usingFallback = null,Object? sourceLabel = null,Object? officialWarnings = null,Object? sourceNote = freezed,}) {
  return _then(_WeatherReport(
location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as WeatherLocation,fetchedAt: null == fetchedAt ? _self.fetchedAt : fetchedAt // ignore: cast_nullable_to_non_nullable
as DateTime,current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as CurrentConditions,minutely: null == minutely ? _self._minutely : minutely // ignore: cast_nullable_to_non_nullable
as List<MinuteForecast>,hourly: null == hourly ? _self._hourly : hourly // ignore: cast_nullable_to_non_nullable
as List<HourlyForecast>,today: null == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as DailyForecast,daily: null == daily ? _self._daily : daily // ignore: cast_nullable_to_non_nullable
as List<DailyForecast>,usingFallback: null == usingFallback ? _self.usingFallback : usingFallback // ignore: cast_nullable_to_non_nullable
as bool,sourceLabel: null == sourceLabel ? _self.sourceLabel : sourceLabel // ignore: cast_nullable_to_non_nullable
as String,officialWarnings: null == officialWarnings ? _self._officialWarnings : officialWarnings // ignore: cast_nullable_to_non_nullable
as List<OfficialWarning>,sourceNote: freezed == sourceNote ? _self.sourceNote : sourceNote // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of WeatherReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeatherLocationCopyWith<$Res> get location {
  
  return $WeatherLocationCopyWith<$Res>(_self.location, (value) {
    return _then(_self.copyWith(location: value));
  });
}/// Create a copy of WeatherReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CurrentConditionsCopyWith<$Res> get current {
  
  return $CurrentConditionsCopyWith<$Res>(_self.current, (value) {
    return _then(_self.copyWith(current: value));
  });
}/// Create a copy of WeatherReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DailyForecastCopyWith<$Res> get today {
  
  return $DailyForecastCopyWith<$Res>(_self.today, (value) {
    return _then(_self.copyWith(today: value));
  });
}
}

/// @nodoc
mixin _$GuidanceHeadline {

 String get title; String get detail; AdviceTone get tone; String get callToAction;
/// Create a copy of GuidanceHeadline
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GuidanceHeadlineCopyWith<GuidanceHeadline> get copyWith => _$GuidanceHeadlineCopyWithImpl<GuidanceHeadline>(this as GuidanceHeadline, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GuidanceHeadline&&(identical(other.title, title) || other.title == title)&&(identical(other.detail, detail) || other.detail == detail)&&(identical(other.tone, tone) || other.tone == tone)&&(identical(other.callToAction, callToAction) || other.callToAction == callToAction));
}


@override
int get hashCode => Object.hash(runtimeType,title,detail,tone,callToAction);

@override
String toString() {
  return 'GuidanceHeadline(title: $title, detail: $detail, tone: $tone, callToAction: $callToAction)';
}


}

/// @nodoc
abstract mixin class $GuidanceHeadlineCopyWith<$Res>  {
  factory $GuidanceHeadlineCopyWith(GuidanceHeadline value, $Res Function(GuidanceHeadline) _then) = _$GuidanceHeadlineCopyWithImpl;
@useResult
$Res call({
 String title, String detail, AdviceTone tone, String callToAction
});




}
/// @nodoc
class _$GuidanceHeadlineCopyWithImpl<$Res>
    implements $GuidanceHeadlineCopyWith<$Res> {
  _$GuidanceHeadlineCopyWithImpl(this._self, this._then);

  final GuidanceHeadline _self;
  final $Res Function(GuidanceHeadline) _then;

/// Create a copy of GuidanceHeadline
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? detail = null,Object? tone = null,Object? callToAction = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String,tone: null == tone ? _self.tone : tone // ignore: cast_nullable_to_non_nullable
as AdviceTone,callToAction: null == callToAction ? _self.callToAction : callToAction // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GuidanceHeadline].
extension GuidanceHeadlinePatterns on GuidanceHeadline {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GuidanceHeadline value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GuidanceHeadline() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GuidanceHeadline value)  $default,){
final _that = this;
switch (_that) {
case _GuidanceHeadline():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GuidanceHeadline value)?  $default,){
final _that = this;
switch (_that) {
case _GuidanceHeadline() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String detail,  AdviceTone tone,  String callToAction)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GuidanceHeadline() when $default != null:
return $default(_that.title,_that.detail,_that.tone,_that.callToAction);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String detail,  AdviceTone tone,  String callToAction)  $default,) {final _that = this;
switch (_that) {
case _GuidanceHeadline():
return $default(_that.title,_that.detail,_that.tone,_that.callToAction);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String detail,  AdviceTone tone,  String callToAction)?  $default,) {final _that = this;
switch (_that) {
case _GuidanceHeadline() when $default != null:
return $default(_that.title,_that.detail,_that.tone,_that.callToAction);case _:
  return null;

}
}

}

/// @nodoc


class _GuidanceHeadline implements GuidanceHeadline {
  const _GuidanceHeadline({required this.title, required this.detail, required this.tone, required this.callToAction});
  

@override final  String title;
@override final  String detail;
@override final  AdviceTone tone;
@override final  String callToAction;

/// Create a copy of GuidanceHeadline
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GuidanceHeadlineCopyWith<_GuidanceHeadline> get copyWith => __$GuidanceHeadlineCopyWithImpl<_GuidanceHeadline>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GuidanceHeadline&&(identical(other.title, title) || other.title == title)&&(identical(other.detail, detail) || other.detail == detail)&&(identical(other.tone, tone) || other.tone == tone)&&(identical(other.callToAction, callToAction) || other.callToAction == callToAction));
}


@override
int get hashCode => Object.hash(runtimeType,title,detail,tone,callToAction);

@override
String toString() {
  return 'GuidanceHeadline(title: $title, detail: $detail, tone: $tone, callToAction: $callToAction)';
}


}

/// @nodoc
abstract mixin class _$GuidanceHeadlineCopyWith<$Res> implements $GuidanceHeadlineCopyWith<$Res> {
  factory _$GuidanceHeadlineCopyWith(_GuidanceHeadline value, $Res Function(_GuidanceHeadline) _then) = __$GuidanceHeadlineCopyWithImpl;
@override @useResult
$Res call({
 String title, String detail, AdviceTone tone, String callToAction
});




}
/// @nodoc
class __$GuidanceHeadlineCopyWithImpl<$Res>
    implements _$GuidanceHeadlineCopyWith<$Res> {
  __$GuidanceHeadlineCopyWithImpl(this._self, this._then);

  final _GuidanceHeadline _self;
  final $Res Function(_GuidanceHeadline) _then;

/// Create a copy of GuidanceHeadline
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? detail = null,Object? tone = null,Object? callToAction = null,}) {
  return _then(_GuidanceHeadline(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String,tone: null == tone ? _self.tone : tone // ignore: cast_nullable_to_non_nullable
as AdviceTone,callToAction: null == callToAction ? _self.callToAction : callToAction // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$NextHourInsight {

 String get title; String get detail; String get departureAdvice; AdviceTone get tone; double get maxPrecipitationMm; int? get minutesUntilRain;
/// Create a copy of NextHourInsight
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NextHourInsightCopyWith<NextHourInsight> get copyWith => _$NextHourInsightCopyWithImpl<NextHourInsight>(this as NextHourInsight, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NextHourInsight&&(identical(other.title, title) || other.title == title)&&(identical(other.detail, detail) || other.detail == detail)&&(identical(other.departureAdvice, departureAdvice) || other.departureAdvice == departureAdvice)&&(identical(other.tone, tone) || other.tone == tone)&&(identical(other.maxPrecipitationMm, maxPrecipitationMm) || other.maxPrecipitationMm == maxPrecipitationMm)&&(identical(other.minutesUntilRain, minutesUntilRain) || other.minutesUntilRain == minutesUntilRain));
}


@override
int get hashCode => Object.hash(runtimeType,title,detail,departureAdvice,tone,maxPrecipitationMm,minutesUntilRain);

@override
String toString() {
  return 'NextHourInsight(title: $title, detail: $detail, departureAdvice: $departureAdvice, tone: $tone, maxPrecipitationMm: $maxPrecipitationMm, minutesUntilRain: $minutesUntilRain)';
}


}

/// @nodoc
abstract mixin class $NextHourInsightCopyWith<$Res>  {
  factory $NextHourInsightCopyWith(NextHourInsight value, $Res Function(NextHourInsight) _then) = _$NextHourInsightCopyWithImpl;
@useResult
$Res call({
 String title, String detail, String departureAdvice, AdviceTone tone, double maxPrecipitationMm, int? minutesUntilRain
});




}
/// @nodoc
class _$NextHourInsightCopyWithImpl<$Res>
    implements $NextHourInsightCopyWith<$Res> {
  _$NextHourInsightCopyWithImpl(this._self, this._then);

  final NextHourInsight _self;
  final $Res Function(NextHourInsight) _then;

/// Create a copy of NextHourInsight
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? detail = null,Object? departureAdvice = null,Object? tone = null,Object? maxPrecipitationMm = null,Object? minutesUntilRain = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String,departureAdvice: null == departureAdvice ? _self.departureAdvice : departureAdvice // ignore: cast_nullable_to_non_nullable
as String,tone: null == tone ? _self.tone : tone // ignore: cast_nullable_to_non_nullable
as AdviceTone,maxPrecipitationMm: null == maxPrecipitationMm ? _self.maxPrecipitationMm : maxPrecipitationMm // ignore: cast_nullable_to_non_nullable
as double,minutesUntilRain: freezed == minutesUntilRain ? _self.minutesUntilRain : minutesUntilRain // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [NextHourInsight].
extension NextHourInsightPatterns on NextHourInsight {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NextHourInsight value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NextHourInsight() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NextHourInsight value)  $default,){
final _that = this;
switch (_that) {
case _NextHourInsight():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NextHourInsight value)?  $default,){
final _that = this;
switch (_that) {
case _NextHourInsight() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String detail,  String departureAdvice,  AdviceTone tone,  double maxPrecipitationMm,  int? minutesUntilRain)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NextHourInsight() when $default != null:
return $default(_that.title,_that.detail,_that.departureAdvice,_that.tone,_that.maxPrecipitationMm,_that.minutesUntilRain);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String detail,  String departureAdvice,  AdviceTone tone,  double maxPrecipitationMm,  int? minutesUntilRain)  $default,) {final _that = this;
switch (_that) {
case _NextHourInsight():
return $default(_that.title,_that.detail,_that.departureAdvice,_that.tone,_that.maxPrecipitationMm,_that.minutesUntilRain);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String detail,  String departureAdvice,  AdviceTone tone,  double maxPrecipitationMm,  int? minutesUntilRain)?  $default,) {final _that = this;
switch (_that) {
case _NextHourInsight() when $default != null:
return $default(_that.title,_that.detail,_that.departureAdvice,_that.tone,_that.maxPrecipitationMm,_that.minutesUntilRain);case _:
  return null;

}
}

}

/// @nodoc


class _NextHourInsight implements NextHourInsight {
  const _NextHourInsight({required this.title, required this.detail, required this.departureAdvice, required this.tone, required this.maxPrecipitationMm, this.minutesUntilRain});
  

@override final  String title;
@override final  String detail;
@override final  String departureAdvice;
@override final  AdviceTone tone;
@override final  double maxPrecipitationMm;
@override final  int? minutesUntilRain;

/// Create a copy of NextHourInsight
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NextHourInsightCopyWith<_NextHourInsight> get copyWith => __$NextHourInsightCopyWithImpl<_NextHourInsight>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NextHourInsight&&(identical(other.title, title) || other.title == title)&&(identical(other.detail, detail) || other.detail == detail)&&(identical(other.departureAdvice, departureAdvice) || other.departureAdvice == departureAdvice)&&(identical(other.tone, tone) || other.tone == tone)&&(identical(other.maxPrecipitationMm, maxPrecipitationMm) || other.maxPrecipitationMm == maxPrecipitationMm)&&(identical(other.minutesUntilRain, minutesUntilRain) || other.minutesUntilRain == minutesUntilRain));
}


@override
int get hashCode => Object.hash(runtimeType,title,detail,departureAdvice,tone,maxPrecipitationMm,minutesUntilRain);

@override
String toString() {
  return 'NextHourInsight(title: $title, detail: $detail, departureAdvice: $departureAdvice, tone: $tone, maxPrecipitationMm: $maxPrecipitationMm, minutesUntilRain: $minutesUntilRain)';
}


}

/// @nodoc
abstract mixin class _$NextHourInsightCopyWith<$Res> implements $NextHourInsightCopyWith<$Res> {
  factory _$NextHourInsightCopyWith(_NextHourInsight value, $Res Function(_NextHourInsight) _then) = __$NextHourInsightCopyWithImpl;
@override @useResult
$Res call({
 String title, String detail, String departureAdvice, AdviceTone tone, double maxPrecipitationMm, int? minutesUntilRain
});




}
/// @nodoc
class __$NextHourInsightCopyWithImpl<$Res>
    implements _$NextHourInsightCopyWith<$Res> {
  __$NextHourInsightCopyWithImpl(this._self, this._then);

  final _NextHourInsight _self;
  final $Res Function(_NextHourInsight) _then;

/// Create a copy of NextHourInsight
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? detail = null,Object? departureAdvice = null,Object? tone = null,Object? maxPrecipitationMm = null,Object? minutesUntilRain = freezed,}) {
  return _then(_NextHourInsight(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String,departureAdvice: null == departureAdvice ? _self.departureAdvice : departureAdvice // ignore: cast_nullable_to_non_nullable
as String,tone: null == tone ? _self.tone : tone // ignore: cast_nullable_to_non_nullable
as AdviceTone,maxPrecipitationMm: null == maxPrecipitationMm ? _self.maxPrecipitationMm : maxPrecipitationMm // ignore: cast_nullable_to_non_nullable
as double,minutesUntilRain: freezed == minutesUntilRain ? _self.minutesUntilRain : minutesUntilRain // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc
mixin _$DryWindowInsight {

 String get headline; bool get isAvailable; DateTime? get start; DateTime? get end; Duration get duration; String get note; String get confidenceLabel; AdviceTone get tone;
/// Create a copy of DryWindowInsight
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DryWindowInsightCopyWith<DryWindowInsight> get copyWith => _$DryWindowInsightCopyWithImpl<DryWindowInsight>(this as DryWindowInsight, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DryWindowInsight&&(identical(other.headline, headline) || other.headline == headline)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.note, note) || other.note == note)&&(identical(other.confidenceLabel, confidenceLabel) || other.confidenceLabel == confidenceLabel)&&(identical(other.tone, tone) || other.tone == tone));
}


@override
int get hashCode => Object.hash(runtimeType,headline,isAvailable,start,end,duration,note,confidenceLabel,tone);

@override
String toString() {
  return 'DryWindowInsight(headline: $headline, isAvailable: $isAvailable, start: $start, end: $end, duration: $duration, note: $note, confidenceLabel: $confidenceLabel, tone: $tone)';
}


}

/// @nodoc
abstract mixin class $DryWindowInsightCopyWith<$Res>  {
  factory $DryWindowInsightCopyWith(DryWindowInsight value, $Res Function(DryWindowInsight) _then) = _$DryWindowInsightCopyWithImpl;
@useResult
$Res call({
 String headline, bool isAvailable, DateTime? start, DateTime? end, Duration duration, String note, String confidenceLabel, AdviceTone tone
});




}
/// @nodoc
class _$DryWindowInsightCopyWithImpl<$Res>
    implements $DryWindowInsightCopyWith<$Res> {
  _$DryWindowInsightCopyWithImpl(this._self, this._then);

  final DryWindowInsight _self;
  final $Res Function(DryWindowInsight) _then;

/// Create a copy of DryWindowInsight
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? headline = null,Object? isAvailable = null,Object? start = freezed,Object? end = freezed,Object? duration = null,Object? note = null,Object? confidenceLabel = null,Object? tone = null,}) {
  return _then(_self.copyWith(
headline: null == headline ? _self.headline : headline // ignore: cast_nullable_to_non_nullable
as String,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,start: freezed == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime?,end: freezed == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime?,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,confidenceLabel: null == confidenceLabel ? _self.confidenceLabel : confidenceLabel // ignore: cast_nullable_to_non_nullable
as String,tone: null == tone ? _self.tone : tone // ignore: cast_nullable_to_non_nullable
as AdviceTone,
  ));
}

}


/// Adds pattern-matching-related methods to [DryWindowInsight].
extension DryWindowInsightPatterns on DryWindowInsight {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DryWindowInsight value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DryWindowInsight() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DryWindowInsight value)  $default,){
final _that = this;
switch (_that) {
case _DryWindowInsight():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DryWindowInsight value)?  $default,){
final _that = this;
switch (_that) {
case _DryWindowInsight() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String headline,  bool isAvailable,  DateTime? start,  DateTime? end,  Duration duration,  String note,  String confidenceLabel,  AdviceTone tone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DryWindowInsight() when $default != null:
return $default(_that.headline,_that.isAvailable,_that.start,_that.end,_that.duration,_that.note,_that.confidenceLabel,_that.tone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String headline,  bool isAvailable,  DateTime? start,  DateTime? end,  Duration duration,  String note,  String confidenceLabel,  AdviceTone tone)  $default,) {final _that = this;
switch (_that) {
case _DryWindowInsight():
return $default(_that.headline,_that.isAvailable,_that.start,_that.end,_that.duration,_that.note,_that.confidenceLabel,_that.tone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String headline,  bool isAvailable,  DateTime? start,  DateTime? end,  Duration duration,  String note,  String confidenceLabel,  AdviceTone tone)?  $default,) {final _that = this;
switch (_that) {
case _DryWindowInsight() when $default != null:
return $default(_that.headline,_that.isAvailable,_that.start,_that.end,_that.duration,_that.note,_that.confidenceLabel,_that.tone);case _:
  return null;

}
}

}

/// @nodoc


class _DryWindowInsight implements DryWindowInsight {
  const _DryWindowInsight({required this.headline, required this.isAvailable, required this.start, required this.end, required this.duration, required this.note, required this.confidenceLabel, required this.tone});
  

@override final  String headline;
@override final  bool isAvailable;
@override final  DateTime? start;
@override final  DateTime? end;
@override final  Duration duration;
@override final  String note;
@override final  String confidenceLabel;
@override final  AdviceTone tone;

/// Create a copy of DryWindowInsight
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DryWindowInsightCopyWith<_DryWindowInsight> get copyWith => __$DryWindowInsightCopyWithImpl<_DryWindowInsight>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DryWindowInsight&&(identical(other.headline, headline) || other.headline == headline)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.note, note) || other.note == note)&&(identical(other.confidenceLabel, confidenceLabel) || other.confidenceLabel == confidenceLabel)&&(identical(other.tone, tone) || other.tone == tone));
}


@override
int get hashCode => Object.hash(runtimeType,headline,isAvailable,start,end,duration,note,confidenceLabel,tone);

@override
String toString() {
  return 'DryWindowInsight(headline: $headline, isAvailable: $isAvailable, start: $start, end: $end, duration: $duration, note: $note, confidenceLabel: $confidenceLabel, tone: $tone)';
}


}

/// @nodoc
abstract mixin class _$DryWindowInsightCopyWith<$Res> implements $DryWindowInsightCopyWith<$Res> {
  factory _$DryWindowInsightCopyWith(_DryWindowInsight value, $Res Function(_DryWindowInsight) _then) = __$DryWindowInsightCopyWithImpl;
@override @useResult
$Res call({
 String headline, bool isAvailable, DateTime? start, DateTime? end, Duration duration, String note, String confidenceLabel, AdviceTone tone
});




}
/// @nodoc
class __$DryWindowInsightCopyWithImpl<$Res>
    implements _$DryWindowInsightCopyWith<$Res> {
  __$DryWindowInsightCopyWithImpl(this._self, this._then);

  final _DryWindowInsight _self;
  final $Res Function(_DryWindowInsight) _then;

/// Create a copy of DryWindowInsight
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? headline = null,Object? isAvailable = null,Object? start = freezed,Object? end = freezed,Object? duration = null,Object? note = null,Object? confidenceLabel = null,Object? tone = null,}) {
  return _then(_DryWindowInsight(
headline: null == headline ? _self.headline : headline // ignore: cast_nullable_to_non_nullable
as String,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,start: freezed == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime?,end: freezed == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime?,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,confidenceLabel: null == confidenceLabel ? _self.confidenceLabel : confidenceLabel // ignore: cast_nullable_to_non_nullable
as String,tone: null == tone ? _self.tone : tone // ignore: cast_nullable_to_non_nullable
as AdviceTone,
  ));
}


}

/// @nodoc
mixin _$CommuteLeg {

 String get id; String get label; DateTime get start; DateTime get end; AdviceTone get tone; String get detail; String get summary; int get score;
/// Create a copy of CommuteLeg
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommuteLegCopyWith<CommuteLeg> get copyWith => _$CommuteLegCopyWithImpl<CommuteLeg>(this as CommuteLeg, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommuteLeg&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.tone, tone) || other.tone == tone)&&(identical(other.detail, detail) || other.detail == detail)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.score, score) || other.score == score));
}


@override
int get hashCode => Object.hash(runtimeType,id,label,start,end,tone,detail,summary,score);

@override
String toString() {
  return 'CommuteLeg(id: $id, label: $label, start: $start, end: $end, tone: $tone, detail: $detail, summary: $summary, score: $score)';
}


}

/// @nodoc
abstract mixin class $CommuteLegCopyWith<$Res>  {
  factory $CommuteLegCopyWith(CommuteLeg value, $Res Function(CommuteLeg) _then) = _$CommuteLegCopyWithImpl;
@useResult
$Res call({
 String id, String label, DateTime start, DateTime end, AdviceTone tone, String detail, String summary, int score
});




}
/// @nodoc
class _$CommuteLegCopyWithImpl<$Res>
    implements $CommuteLegCopyWith<$Res> {
  _$CommuteLegCopyWithImpl(this._self, this._then);

  final CommuteLeg _self;
  final $Res Function(CommuteLeg) _then;

/// Create a copy of CommuteLeg
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? label = null,Object? start = null,Object? end = null,Object? tone = null,Object? detail = null,Object? summary = null,Object? score = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,tone: null == tone ? _self.tone : tone // ignore: cast_nullable_to_non_nullable
as AdviceTone,detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CommuteLeg].
extension CommuteLegPatterns on CommuteLeg {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommuteLeg value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommuteLeg() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommuteLeg value)  $default,){
final _that = this;
switch (_that) {
case _CommuteLeg():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommuteLeg value)?  $default,){
final _that = this;
switch (_that) {
case _CommuteLeg() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String label,  DateTime start,  DateTime end,  AdviceTone tone,  String detail,  String summary,  int score)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommuteLeg() when $default != null:
return $default(_that.id,_that.label,_that.start,_that.end,_that.tone,_that.detail,_that.summary,_that.score);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String label,  DateTime start,  DateTime end,  AdviceTone tone,  String detail,  String summary,  int score)  $default,) {final _that = this;
switch (_that) {
case _CommuteLeg():
return $default(_that.id,_that.label,_that.start,_that.end,_that.tone,_that.detail,_that.summary,_that.score);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String label,  DateTime start,  DateTime end,  AdviceTone tone,  String detail,  String summary,  int score)?  $default,) {final _that = this;
switch (_that) {
case _CommuteLeg() when $default != null:
return $default(_that.id,_that.label,_that.start,_that.end,_that.tone,_that.detail,_that.summary,_that.score);case _:
  return null;

}
}

}

/// @nodoc


class _CommuteLeg implements CommuteLeg {
  const _CommuteLeg({required this.id, required this.label, required this.start, required this.end, required this.tone, required this.detail, required this.summary, required this.score});
  

@override final  String id;
@override final  String label;
@override final  DateTime start;
@override final  DateTime end;
@override final  AdviceTone tone;
@override final  String detail;
@override final  String summary;
@override final  int score;

/// Create a copy of CommuteLeg
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommuteLegCopyWith<_CommuteLeg> get copyWith => __$CommuteLegCopyWithImpl<_CommuteLeg>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommuteLeg&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.tone, tone) || other.tone == tone)&&(identical(other.detail, detail) || other.detail == detail)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.score, score) || other.score == score));
}


@override
int get hashCode => Object.hash(runtimeType,id,label,start,end,tone,detail,summary,score);

@override
String toString() {
  return 'CommuteLeg(id: $id, label: $label, start: $start, end: $end, tone: $tone, detail: $detail, summary: $summary, score: $score)';
}


}

/// @nodoc
abstract mixin class _$CommuteLegCopyWith<$Res> implements $CommuteLegCopyWith<$Res> {
  factory _$CommuteLegCopyWith(_CommuteLeg value, $Res Function(_CommuteLeg) _then) = __$CommuteLegCopyWithImpl;
@override @useResult
$Res call({
 String id, String label, DateTime start, DateTime end, AdviceTone tone, String detail, String summary, int score
});




}
/// @nodoc
class __$CommuteLegCopyWithImpl<$Res>
    implements _$CommuteLegCopyWith<$Res> {
  __$CommuteLegCopyWithImpl(this._self, this._then);

  final _CommuteLeg _self;
  final $Res Function(_CommuteLeg) _then;

/// Create a copy of CommuteLeg
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = null,Object? start = null,Object? end = null,Object? tone = null,Object? detail = null,Object? summary = null,Object? score = null,}) {
  return _then(_CommuteLeg(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,tone: null == tone ? _self.tone : tone // ignore: cast_nullable_to_non_nullable
as AdviceTone,detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$CommuteOverview {

 List<CommuteLeg> get windows; String get summary;
/// Create a copy of CommuteOverview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommuteOverviewCopyWith<CommuteOverview> get copyWith => _$CommuteOverviewCopyWithImpl<CommuteOverview>(this as CommuteOverview, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommuteOverview&&const DeepCollectionEquality().equals(other.windows, windows)&&(identical(other.summary, summary) || other.summary == summary));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(windows),summary);

@override
String toString() {
  return 'CommuteOverview(windows: $windows, summary: $summary)';
}


}

/// @nodoc
abstract mixin class $CommuteOverviewCopyWith<$Res>  {
  factory $CommuteOverviewCopyWith(CommuteOverview value, $Res Function(CommuteOverview) _then) = _$CommuteOverviewCopyWithImpl;
@useResult
$Res call({
 List<CommuteLeg> windows, String summary
});




}
/// @nodoc
class _$CommuteOverviewCopyWithImpl<$Res>
    implements $CommuteOverviewCopyWith<$Res> {
  _$CommuteOverviewCopyWithImpl(this._self, this._then);

  final CommuteOverview _self;
  final $Res Function(CommuteOverview) _then;

/// Create a copy of CommuteOverview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? windows = null,Object? summary = null,}) {
  return _then(_self.copyWith(
windows: null == windows ? _self.windows : windows // ignore: cast_nullable_to_non_nullable
as List<CommuteLeg>,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CommuteOverview].
extension CommuteOverviewPatterns on CommuteOverview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommuteOverview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommuteOverview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommuteOverview value)  $default,){
final _that = this;
switch (_that) {
case _CommuteOverview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommuteOverview value)?  $default,){
final _that = this;
switch (_that) {
case _CommuteOverview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CommuteLeg> windows,  String summary)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommuteOverview() when $default != null:
return $default(_that.windows,_that.summary);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CommuteLeg> windows,  String summary)  $default,) {final _that = this;
switch (_that) {
case _CommuteOverview():
return $default(_that.windows,_that.summary);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CommuteLeg> windows,  String summary)?  $default,) {final _that = this;
switch (_that) {
case _CommuteOverview() when $default != null:
return $default(_that.windows,_that.summary);case _:
  return null;

}
}

}

/// @nodoc


class _CommuteOverview implements CommuteOverview {
  const _CommuteOverview({required final  List<CommuteLeg> windows, required this.summary}): _windows = windows;
  

 final  List<CommuteLeg> _windows;
@override List<CommuteLeg> get windows {
  if (_windows is EqualUnmodifiableListView) return _windows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_windows);
}

@override final  String summary;

/// Create a copy of CommuteOverview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommuteOverviewCopyWith<_CommuteOverview> get copyWith => __$CommuteOverviewCopyWithImpl<_CommuteOverview>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommuteOverview&&const DeepCollectionEquality().equals(other._windows, _windows)&&(identical(other.summary, summary) || other.summary == summary));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_windows),summary);

@override
String toString() {
  return 'CommuteOverview(windows: $windows, summary: $summary)';
}


}

/// @nodoc
abstract mixin class _$CommuteOverviewCopyWith<$Res> implements $CommuteOverviewCopyWith<$Res> {
  factory _$CommuteOverviewCopyWith(_CommuteOverview value, $Res Function(_CommuteOverview) _then) = __$CommuteOverviewCopyWithImpl;
@override @useResult
$Res call({
 List<CommuteLeg> windows, String summary
});




}
/// @nodoc
class __$CommuteOverviewCopyWithImpl<$Res>
    implements _$CommuteOverviewCopyWith<$Res> {
  __$CommuteOverviewCopyWithImpl(this._self, this._then);

  final _CommuteOverview _self;
  final $Res Function(_CommuteOverview) _then;

/// Create a copy of CommuteOverview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? windows = null,Object? summary = null,}) {
  return _then(_CommuteOverview(
windows: null == windows ? _self._windows : windows // ignore: cast_nullable_to_non_nullable
as List<CommuteLeg>,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$WearTip {

 String get title; String get detail; IconData get icon;
/// Create a copy of WearTip
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WearTipCopyWith<WearTip> get copyWith => _$WearTipCopyWithImpl<WearTip>(this as WearTip, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WearTip&&(identical(other.title, title) || other.title == title)&&(identical(other.detail, detail) || other.detail == detail)&&(identical(other.icon, icon) || other.icon == icon));
}


@override
int get hashCode => Object.hash(runtimeType,title,detail,icon);

@override
String toString() {
  return 'WearTip(title: $title, detail: $detail, icon: $icon)';
}


}

/// @nodoc
abstract mixin class $WearTipCopyWith<$Res>  {
  factory $WearTipCopyWith(WearTip value, $Res Function(WearTip) _then) = _$WearTipCopyWithImpl;
@useResult
$Res call({
 String title, String detail, IconData icon
});




}
/// @nodoc
class _$WearTipCopyWithImpl<$Res>
    implements $WearTipCopyWith<$Res> {
  _$WearTipCopyWithImpl(this._self, this._then);

  final WearTip _self;
  final $Res Function(WearTip) _then;

/// Create a copy of WearTip
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? detail = null,Object? icon = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,
  ));
}

}


/// Adds pattern-matching-related methods to [WearTip].
extension WearTipPatterns on WearTip {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WearTip value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WearTip() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WearTip value)  $default,){
final _that = this;
switch (_that) {
case _WearTip():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WearTip value)?  $default,){
final _that = this;
switch (_that) {
case _WearTip() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String detail,  IconData icon)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WearTip() when $default != null:
return $default(_that.title,_that.detail,_that.icon);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String detail,  IconData icon)  $default,) {final _that = this;
switch (_that) {
case _WearTip():
return $default(_that.title,_that.detail,_that.icon);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String detail,  IconData icon)?  $default,) {final _that = this;
switch (_that) {
case _WearTip() when $default != null:
return $default(_that.title,_that.detail,_that.icon);case _:
  return null;

}
}

}

/// @nodoc


class _WearTip implements WearTip {
  const _WearTip({required this.title, required this.detail, required this.icon});
  

@override final  String title;
@override final  String detail;
@override final  IconData icon;

/// Create a copy of WearTip
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WearTipCopyWith<_WearTip> get copyWith => __$WearTipCopyWithImpl<_WearTip>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WearTip&&(identical(other.title, title) || other.title == title)&&(identical(other.detail, detail) || other.detail == detail)&&(identical(other.icon, icon) || other.icon == icon));
}


@override
int get hashCode => Object.hash(runtimeType,title,detail,icon);

@override
String toString() {
  return 'WearTip(title: $title, detail: $detail, icon: $icon)';
}


}

/// @nodoc
abstract mixin class _$WearTipCopyWith<$Res> implements $WearTipCopyWith<$Res> {
  factory _$WearTipCopyWith(_WearTip value, $Res Function(_WearTip) _then) = __$WearTipCopyWithImpl;
@override @useResult
$Res call({
 String title, String detail, IconData icon
});




}
/// @nodoc
class __$WearTipCopyWithImpl<$Res>
    implements _$WearTipCopyWith<$Res> {
  __$WearTipCopyWithImpl(this._self, this._then);

  final _WearTip _self;
  final $Res Function(_WearTip) _then;

/// Create a copy of WearTip
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? detail = null,Object? icon = null,}) {
  return _then(_WearTip(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,
  ));
}


}

/// @nodoc
mixin _$ActivityRecommendation {

 String get name; int get score; String get detail; ActivitySuitability get suitability; IconData get icon;
/// Create a copy of ActivityRecommendation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityRecommendationCopyWith<ActivityRecommendation> get copyWith => _$ActivityRecommendationCopyWithImpl<ActivityRecommendation>(this as ActivityRecommendation, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityRecommendation&&(identical(other.name, name) || other.name == name)&&(identical(other.score, score) || other.score == score)&&(identical(other.detail, detail) || other.detail == detail)&&(identical(other.suitability, suitability) || other.suitability == suitability)&&(identical(other.icon, icon) || other.icon == icon));
}


@override
int get hashCode => Object.hash(runtimeType,name,score,detail,suitability,icon);

@override
String toString() {
  return 'ActivityRecommendation(name: $name, score: $score, detail: $detail, suitability: $suitability, icon: $icon)';
}


}

/// @nodoc
abstract mixin class $ActivityRecommendationCopyWith<$Res>  {
  factory $ActivityRecommendationCopyWith(ActivityRecommendation value, $Res Function(ActivityRecommendation) _then) = _$ActivityRecommendationCopyWithImpl;
@useResult
$Res call({
 String name, int score, String detail, ActivitySuitability suitability, IconData icon
});




}
/// @nodoc
class _$ActivityRecommendationCopyWithImpl<$Res>
    implements $ActivityRecommendationCopyWith<$Res> {
  _$ActivityRecommendationCopyWithImpl(this._self, this._then);

  final ActivityRecommendation _self;
  final $Res Function(ActivityRecommendation) _then;

/// Create a copy of ActivityRecommendation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? score = null,Object? detail = null,Object? suitability = null,Object? icon = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String,suitability: null == suitability ? _self.suitability : suitability // ignore: cast_nullable_to_non_nullable
as ActivitySuitability,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivityRecommendation].
extension ActivityRecommendationPatterns on ActivityRecommendation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivityRecommendation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivityRecommendation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivityRecommendation value)  $default,){
final _that = this;
switch (_that) {
case _ActivityRecommendation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivityRecommendation value)?  $default,){
final _that = this;
switch (_that) {
case _ActivityRecommendation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  int score,  String detail,  ActivitySuitability suitability,  IconData icon)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivityRecommendation() when $default != null:
return $default(_that.name,_that.score,_that.detail,_that.suitability,_that.icon);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  int score,  String detail,  ActivitySuitability suitability,  IconData icon)  $default,) {final _that = this;
switch (_that) {
case _ActivityRecommendation():
return $default(_that.name,_that.score,_that.detail,_that.suitability,_that.icon);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  int score,  String detail,  ActivitySuitability suitability,  IconData icon)?  $default,) {final _that = this;
switch (_that) {
case _ActivityRecommendation() when $default != null:
return $default(_that.name,_that.score,_that.detail,_that.suitability,_that.icon);case _:
  return null;

}
}

}

/// @nodoc


class _ActivityRecommendation implements ActivityRecommendation {
  const _ActivityRecommendation({required this.name, required this.score, required this.detail, required this.suitability, required this.icon});
  

@override final  String name;
@override final  int score;
@override final  String detail;
@override final  ActivitySuitability suitability;
@override final  IconData icon;

/// Create a copy of ActivityRecommendation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityRecommendationCopyWith<_ActivityRecommendation> get copyWith => __$ActivityRecommendationCopyWithImpl<_ActivityRecommendation>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityRecommendation&&(identical(other.name, name) || other.name == name)&&(identical(other.score, score) || other.score == score)&&(identical(other.detail, detail) || other.detail == detail)&&(identical(other.suitability, suitability) || other.suitability == suitability)&&(identical(other.icon, icon) || other.icon == icon));
}


@override
int get hashCode => Object.hash(runtimeType,name,score,detail,suitability,icon);

@override
String toString() {
  return 'ActivityRecommendation(name: $name, score: $score, detail: $detail, suitability: $suitability, icon: $icon)';
}


}

/// @nodoc
abstract mixin class _$ActivityRecommendationCopyWith<$Res> implements $ActivityRecommendationCopyWith<$Res> {
  factory _$ActivityRecommendationCopyWith(_ActivityRecommendation value, $Res Function(_ActivityRecommendation) _then) = __$ActivityRecommendationCopyWithImpl;
@override @useResult
$Res call({
 String name, int score, String detail, ActivitySuitability suitability, IconData icon
});




}
/// @nodoc
class __$ActivityRecommendationCopyWithImpl<$Res>
    implements _$ActivityRecommendationCopyWith<$Res> {
  __$ActivityRecommendationCopyWithImpl(this._self, this._then);

  final _ActivityRecommendation _self;
  final $Res Function(_ActivityRecommendation) _then;

/// Create a copy of ActivityRecommendation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? score = null,Object? detail = null,Object? suitability = null,Object? icon = null,}) {
  return _then(_ActivityRecommendation(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String,suitability: null == suitability ? _self.suitability : suitability // ignore: cast_nullable_to_non_nullable
as ActivitySuitability,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,
  ));
}


}

/// @nodoc
mixin _$RiskNote {

 String get title; String get detail; RiskLevel get level; IconData get icon; AlertSource get source; String get sourceLabel; String? get link;
/// Create a copy of RiskNote
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RiskNoteCopyWith<RiskNote> get copyWith => _$RiskNoteCopyWithImpl<RiskNote>(this as RiskNote, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RiskNote&&(identical(other.title, title) || other.title == title)&&(identical(other.detail, detail) || other.detail == detail)&&(identical(other.level, level) || other.level == level)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.source, source) || other.source == source)&&(identical(other.sourceLabel, sourceLabel) || other.sourceLabel == sourceLabel)&&(identical(other.link, link) || other.link == link));
}


@override
int get hashCode => Object.hash(runtimeType,title,detail,level,icon,source,sourceLabel,link);

@override
String toString() {
  return 'RiskNote(title: $title, detail: $detail, level: $level, icon: $icon, source: $source, sourceLabel: $sourceLabel, link: $link)';
}


}

/// @nodoc
abstract mixin class $RiskNoteCopyWith<$Res>  {
  factory $RiskNoteCopyWith(RiskNote value, $Res Function(RiskNote) _then) = _$RiskNoteCopyWithImpl;
@useResult
$Res call({
 String title, String detail, RiskLevel level, IconData icon, AlertSource source, String sourceLabel, String? link
});




}
/// @nodoc
class _$RiskNoteCopyWithImpl<$Res>
    implements $RiskNoteCopyWith<$Res> {
  _$RiskNoteCopyWithImpl(this._self, this._then);

  final RiskNote _self;
  final $Res Function(RiskNote) _then;

/// Create a copy of RiskNote
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? detail = null,Object? level = null,Object? icon = null,Object? source = null,Object? sourceLabel = null,Object? link = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as RiskLevel,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as AlertSource,sourceLabel: null == sourceLabel ? _self.sourceLabel : sourceLabel // ignore: cast_nullable_to_non_nullable
as String,link: freezed == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RiskNote].
extension RiskNotePatterns on RiskNote {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RiskNote value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RiskNote() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RiskNote value)  $default,){
final _that = this;
switch (_that) {
case _RiskNote():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RiskNote value)?  $default,){
final _that = this;
switch (_that) {
case _RiskNote() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String detail,  RiskLevel level,  IconData icon,  AlertSource source,  String sourceLabel,  String? link)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RiskNote() when $default != null:
return $default(_that.title,_that.detail,_that.level,_that.icon,_that.source,_that.sourceLabel,_that.link);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String detail,  RiskLevel level,  IconData icon,  AlertSource source,  String sourceLabel,  String? link)  $default,) {final _that = this;
switch (_that) {
case _RiskNote():
return $default(_that.title,_that.detail,_that.level,_that.icon,_that.source,_that.sourceLabel,_that.link);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String detail,  RiskLevel level,  IconData icon,  AlertSource source,  String sourceLabel,  String? link)?  $default,) {final _that = this;
switch (_that) {
case _RiskNote() when $default != null:
return $default(_that.title,_that.detail,_that.level,_that.icon,_that.source,_that.sourceLabel,_that.link);case _:
  return null;

}
}

}

/// @nodoc


class _RiskNote implements RiskNote {
  const _RiskNote({required this.title, required this.detail, required this.level, required this.icon, this.source = AlertSource.forecast, this.sourceLabel = 'Forecast signal', this.link});
  

@override final  String title;
@override final  String detail;
@override final  RiskLevel level;
@override final  IconData icon;
@override@JsonKey() final  AlertSource source;
@override@JsonKey() final  String sourceLabel;
@override final  String? link;

/// Create a copy of RiskNote
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RiskNoteCopyWith<_RiskNote> get copyWith => __$RiskNoteCopyWithImpl<_RiskNote>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RiskNote&&(identical(other.title, title) || other.title == title)&&(identical(other.detail, detail) || other.detail == detail)&&(identical(other.level, level) || other.level == level)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.source, source) || other.source == source)&&(identical(other.sourceLabel, sourceLabel) || other.sourceLabel == sourceLabel)&&(identical(other.link, link) || other.link == link));
}


@override
int get hashCode => Object.hash(runtimeType,title,detail,level,icon,source,sourceLabel,link);

@override
String toString() {
  return 'RiskNote(title: $title, detail: $detail, level: $level, icon: $icon, source: $source, sourceLabel: $sourceLabel, link: $link)';
}


}

/// @nodoc
abstract mixin class _$RiskNoteCopyWith<$Res> implements $RiskNoteCopyWith<$Res> {
  factory _$RiskNoteCopyWith(_RiskNote value, $Res Function(_RiskNote) _then) = __$RiskNoteCopyWithImpl;
@override @useResult
$Res call({
 String title, String detail, RiskLevel level, IconData icon, AlertSource source, String sourceLabel, String? link
});




}
/// @nodoc
class __$RiskNoteCopyWithImpl<$Res>
    implements _$RiskNoteCopyWith<$Res> {
  __$RiskNoteCopyWithImpl(this._self, this._then);

  final _RiskNote _self;
  final $Res Function(_RiskNote) _then;

/// Create a copy of RiskNote
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? detail = null,Object? level = null,Object? icon = null,Object? source = null,Object? sourceLabel = null,Object? link = freezed,}) {
  return _then(_RiskNote(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as RiskLevel,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as AlertSource,sourceLabel: null == sourceLabel ? _self.sourceLabel : sourceLabel // ignore: cast_nullable_to_non_nullable
as String,link: freezed == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$HomeSummaryCard {

 String get title; String get value; String get detail; IconData get icon; AdviceTone get tone;
/// Create a copy of HomeSummaryCard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeSummaryCardCopyWith<HomeSummaryCard> get copyWith => _$HomeSummaryCardCopyWithImpl<HomeSummaryCard>(this as HomeSummaryCard, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeSummaryCard&&(identical(other.title, title) || other.title == title)&&(identical(other.value, value) || other.value == value)&&(identical(other.detail, detail) || other.detail == detail)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.tone, tone) || other.tone == tone));
}


@override
int get hashCode => Object.hash(runtimeType,title,value,detail,icon,tone);

@override
String toString() {
  return 'HomeSummaryCard(title: $title, value: $value, detail: $detail, icon: $icon, tone: $tone)';
}


}

/// @nodoc
abstract mixin class $HomeSummaryCardCopyWith<$Res>  {
  factory $HomeSummaryCardCopyWith(HomeSummaryCard value, $Res Function(HomeSummaryCard) _then) = _$HomeSummaryCardCopyWithImpl;
@useResult
$Res call({
 String title, String value, String detail, IconData icon, AdviceTone tone
});




}
/// @nodoc
class _$HomeSummaryCardCopyWithImpl<$Res>
    implements $HomeSummaryCardCopyWith<$Res> {
  _$HomeSummaryCardCopyWithImpl(this._self, this._then);

  final HomeSummaryCard _self;
  final $Res Function(HomeSummaryCard) _then;

/// Create a copy of HomeSummaryCard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? value = null,Object? detail = null,Object? icon = null,Object? tone = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,tone: null == tone ? _self.tone : tone // ignore: cast_nullable_to_non_nullable
as AdviceTone,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeSummaryCard].
extension HomeSummaryCardPatterns on HomeSummaryCard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeSummaryCard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeSummaryCard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeSummaryCard value)  $default,){
final _that = this;
switch (_that) {
case _HomeSummaryCard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeSummaryCard value)?  $default,){
final _that = this;
switch (_that) {
case _HomeSummaryCard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String value,  String detail,  IconData icon,  AdviceTone tone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeSummaryCard() when $default != null:
return $default(_that.title,_that.value,_that.detail,_that.icon,_that.tone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String value,  String detail,  IconData icon,  AdviceTone tone)  $default,) {final _that = this;
switch (_that) {
case _HomeSummaryCard():
return $default(_that.title,_that.value,_that.detail,_that.icon,_that.tone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String value,  String detail,  IconData icon,  AdviceTone tone)?  $default,) {final _that = this;
switch (_that) {
case _HomeSummaryCard() when $default != null:
return $default(_that.title,_that.value,_that.detail,_that.icon,_that.tone);case _:
  return null;

}
}

}

/// @nodoc


class _HomeSummaryCard implements HomeSummaryCard {
  const _HomeSummaryCard({required this.title, required this.value, required this.detail, required this.icon, required this.tone});
  

@override final  String title;
@override final  String value;
@override final  String detail;
@override final  IconData icon;
@override final  AdviceTone tone;

/// Create a copy of HomeSummaryCard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeSummaryCardCopyWith<_HomeSummaryCard> get copyWith => __$HomeSummaryCardCopyWithImpl<_HomeSummaryCard>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeSummaryCard&&(identical(other.title, title) || other.title == title)&&(identical(other.value, value) || other.value == value)&&(identical(other.detail, detail) || other.detail == detail)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.tone, tone) || other.tone == tone));
}


@override
int get hashCode => Object.hash(runtimeType,title,value,detail,icon,tone);

@override
String toString() {
  return 'HomeSummaryCard(title: $title, value: $value, detail: $detail, icon: $icon, tone: $tone)';
}


}

/// @nodoc
abstract mixin class _$HomeSummaryCardCopyWith<$Res> implements $HomeSummaryCardCopyWith<$Res> {
  factory _$HomeSummaryCardCopyWith(_HomeSummaryCard value, $Res Function(_HomeSummaryCard) _then) = __$HomeSummaryCardCopyWithImpl;
@override @useResult
$Res call({
 String title, String value, String detail, IconData icon, AdviceTone tone
});




}
/// @nodoc
class __$HomeSummaryCardCopyWithImpl<$Res>
    implements _$HomeSummaryCardCopyWith<$Res> {
  __$HomeSummaryCardCopyWithImpl(this._self, this._then);

  final _HomeSummaryCard _self;
  final $Res Function(_HomeSummaryCard) _then;

/// Create a copy of HomeSummaryCard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? value = null,Object? detail = null,Object? icon = null,Object? tone = null,}) {
  return _then(_HomeSummaryCard(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,tone: null == tone ? _self.tone : tone // ignore: cast_nullable_to_non_nullable
as AdviceTone,
  ));
}


}

/// @nodoc
mixin _$WeekendDayPlan {

 String get label; DateTime get date; String get summary; String get headline; double get maxTempC; double get minTempC; double get precipitationMm; int get precipitationProbabilityMax; double get maxWindKph; IconData get icon; AdviceTone get tone;
/// Create a copy of WeekendDayPlan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeekendDayPlanCopyWith<WeekendDayPlan> get copyWith => _$WeekendDayPlanCopyWithImpl<WeekendDayPlan>(this as WeekendDayPlan, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeekendDayPlan&&(identical(other.label, label) || other.label == label)&&(identical(other.date, date) || other.date == date)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.headline, headline) || other.headline == headline)&&(identical(other.maxTempC, maxTempC) || other.maxTempC == maxTempC)&&(identical(other.minTempC, minTempC) || other.minTempC == minTempC)&&(identical(other.precipitationMm, precipitationMm) || other.precipitationMm == precipitationMm)&&(identical(other.precipitationProbabilityMax, precipitationProbabilityMax) || other.precipitationProbabilityMax == precipitationProbabilityMax)&&(identical(other.maxWindKph, maxWindKph) || other.maxWindKph == maxWindKph)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.tone, tone) || other.tone == tone));
}


@override
int get hashCode => Object.hash(runtimeType,label,date,summary,headline,maxTempC,minTempC,precipitationMm,precipitationProbabilityMax,maxWindKph,icon,tone);

@override
String toString() {
  return 'WeekendDayPlan(label: $label, date: $date, summary: $summary, headline: $headline, maxTempC: $maxTempC, minTempC: $minTempC, precipitationMm: $precipitationMm, precipitationProbabilityMax: $precipitationProbabilityMax, maxWindKph: $maxWindKph, icon: $icon, tone: $tone)';
}


}

/// @nodoc
abstract mixin class $WeekendDayPlanCopyWith<$Res>  {
  factory $WeekendDayPlanCopyWith(WeekendDayPlan value, $Res Function(WeekendDayPlan) _then) = _$WeekendDayPlanCopyWithImpl;
@useResult
$Res call({
 String label, DateTime date, String summary, String headline, double maxTempC, double minTempC, double precipitationMm, int precipitationProbabilityMax, double maxWindKph, IconData icon, AdviceTone tone
});




}
/// @nodoc
class _$WeekendDayPlanCopyWithImpl<$Res>
    implements $WeekendDayPlanCopyWith<$Res> {
  _$WeekendDayPlanCopyWithImpl(this._self, this._then);

  final WeekendDayPlan _self;
  final $Res Function(WeekendDayPlan) _then;

/// Create a copy of WeekendDayPlan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? date = null,Object? summary = null,Object? headline = null,Object? maxTempC = null,Object? minTempC = null,Object? precipitationMm = null,Object? precipitationProbabilityMax = null,Object? maxWindKph = null,Object? icon = null,Object? tone = null,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,headline: null == headline ? _self.headline : headline // ignore: cast_nullable_to_non_nullable
as String,maxTempC: null == maxTempC ? _self.maxTempC : maxTempC // ignore: cast_nullable_to_non_nullable
as double,minTempC: null == minTempC ? _self.minTempC : minTempC // ignore: cast_nullable_to_non_nullable
as double,precipitationMm: null == precipitationMm ? _self.precipitationMm : precipitationMm // ignore: cast_nullable_to_non_nullable
as double,precipitationProbabilityMax: null == precipitationProbabilityMax ? _self.precipitationProbabilityMax : precipitationProbabilityMax // ignore: cast_nullable_to_non_nullable
as int,maxWindKph: null == maxWindKph ? _self.maxWindKph : maxWindKph // ignore: cast_nullable_to_non_nullable
as double,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,tone: null == tone ? _self.tone : tone // ignore: cast_nullable_to_non_nullable
as AdviceTone,
  ));
}

}


/// Adds pattern-matching-related methods to [WeekendDayPlan].
extension WeekendDayPlanPatterns on WeekendDayPlan {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeekendDayPlan value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeekendDayPlan() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeekendDayPlan value)  $default,){
final _that = this;
switch (_that) {
case _WeekendDayPlan():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeekendDayPlan value)?  $default,){
final _that = this;
switch (_that) {
case _WeekendDayPlan() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  DateTime date,  String summary,  String headline,  double maxTempC,  double minTempC,  double precipitationMm,  int precipitationProbabilityMax,  double maxWindKph,  IconData icon,  AdviceTone tone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeekendDayPlan() when $default != null:
return $default(_that.label,_that.date,_that.summary,_that.headline,_that.maxTempC,_that.minTempC,_that.precipitationMm,_that.precipitationProbabilityMax,_that.maxWindKph,_that.icon,_that.tone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  DateTime date,  String summary,  String headline,  double maxTempC,  double minTempC,  double precipitationMm,  int precipitationProbabilityMax,  double maxWindKph,  IconData icon,  AdviceTone tone)  $default,) {final _that = this;
switch (_that) {
case _WeekendDayPlan():
return $default(_that.label,_that.date,_that.summary,_that.headline,_that.maxTempC,_that.minTempC,_that.precipitationMm,_that.precipitationProbabilityMax,_that.maxWindKph,_that.icon,_that.tone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  DateTime date,  String summary,  String headline,  double maxTempC,  double minTempC,  double precipitationMm,  int precipitationProbabilityMax,  double maxWindKph,  IconData icon,  AdviceTone tone)?  $default,) {final _that = this;
switch (_that) {
case _WeekendDayPlan() when $default != null:
return $default(_that.label,_that.date,_that.summary,_that.headline,_that.maxTempC,_that.minTempC,_that.precipitationMm,_that.precipitationProbabilityMax,_that.maxWindKph,_that.icon,_that.tone);case _:
  return null;

}
}

}

/// @nodoc


class _WeekendDayPlan implements WeekendDayPlan {
  const _WeekendDayPlan({required this.label, required this.date, required this.summary, required this.headline, required this.maxTempC, required this.minTempC, required this.precipitationMm, required this.precipitationProbabilityMax, required this.maxWindKph, required this.icon, required this.tone});
  

@override final  String label;
@override final  DateTime date;
@override final  String summary;
@override final  String headline;
@override final  double maxTempC;
@override final  double minTempC;
@override final  double precipitationMm;
@override final  int precipitationProbabilityMax;
@override final  double maxWindKph;
@override final  IconData icon;
@override final  AdviceTone tone;

/// Create a copy of WeekendDayPlan
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeekendDayPlanCopyWith<_WeekendDayPlan> get copyWith => __$WeekendDayPlanCopyWithImpl<_WeekendDayPlan>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeekendDayPlan&&(identical(other.label, label) || other.label == label)&&(identical(other.date, date) || other.date == date)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.headline, headline) || other.headline == headline)&&(identical(other.maxTempC, maxTempC) || other.maxTempC == maxTempC)&&(identical(other.minTempC, minTempC) || other.minTempC == minTempC)&&(identical(other.precipitationMm, precipitationMm) || other.precipitationMm == precipitationMm)&&(identical(other.precipitationProbabilityMax, precipitationProbabilityMax) || other.precipitationProbabilityMax == precipitationProbabilityMax)&&(identical(other.maxWindKph, maxWindKph) || other.maxWindKph == maxWindKph)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.tone, tone) || other.tone == tone));
}


@override
int get hashCode => Object.hash(runtimeType,label,date,summary,headline,maxTempC,minTempC,precipitationMm,precipitationProbabilityMax,maxWindKph,icon,tone);

@override
String toString() {
  return 'WeekendDayPlan(label: $label, date: $date, summary: $summary, headline: $headline, maxTempC: $maxTempC, minTempC: $minTempC, precipitationMm: $precipitationMm, precipitationProbabilityMax: $precipitationProbabilityMax, maxWindKph: $maxWindKph, icon: $icon, tone: $tone)';
}


}

/// @nodoc
abstract mixin class _$WeekendDayPlanCopyWith<$Res> implements $WeekendDayPlanCopyWith<$Res> {
  factory _$WeekendDayPlanCopyWith(_WeekendDayPlan value, $Res Function(_WeekendDayPlan) _then) = __$WeekendDayPlanCopyWithImpl;
@override @useResult
$Res call({
 String label, DateTime date, String summary, String headline, double maxTempC, double minTempC, double precipitationMm, int precipitationProbabilityMax, double maxWindKph, IconData icon, AdviceTone tone
});




}
/// @nodoc
class __$WeekendDayPlanCopyWithImpl<$Res>
    implements _$WeekendDayPlanCopyWith<$Res> {
  __$WeekendDayPlanCopyWithImpl(this._self, this._then);

  final _WeekendDayPlan _self;
  final $Res Function(_WeekendDayPlan) _then;

/// Create a copy of WeekendDayPlan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? date = null,Object? summary = null,Object? headline = null,Object? maxTempC = null,Object? minTempC = null,Object? precipitationMm = null,Object? precipitationProbabilityMax = null,Object? maxWindKph = null,Object? icon = null,Object? tone = null,}) {
  return _then(_WeekendDayPlan(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,headline: null == headline ? _self.headline : headline // ignore: cast_nullable_to_non_nullable
as String,maxTempC: null == maxTempC ? _self.maxTempC : maxTempC // ignore: cast_nullable_to_non_nullable
as double,minTempC: null == minTempC ? _self.minTempC : minTempC // ignore: cast_nullable_to_non_nullable
as double,precipitationMm: null == precipitationMm ? _self.precipitationMm : precipitationMm // ignore: cast_nullable_to_non_nullable
as double,precipitationProbabilityMax: null == precipitationProbabilityMax ? _self.precipitationProbabilityMax : precipitationProbabilityMax // ignore: cast_nullable_to_non_nullable
as int,maxWindKph: null == maxWindKph ? _self.maxWindKph : maxWindKph // ignore: cast_nullable_to_non_nullable
as double,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,tone: null == tone ? _self.tone : tone // ignore: cast_nullable_to_non_nullable
as AdviceTone,
  ));
}


}

/// @nodoc
mixin _$WeekendPlanner {

 String get title; String get summary; List<WeekendDayPlan> get days; AdviceTone get tone;
/// Create a copy of WeekendPlanner
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeekendPlannerCopyWith<WeekendPlanner> get copyWith => _$WeekendPlannerCopyWithImpl<WeekendPlanner>(this as WeekendPlanner, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeekendPlanner&&(identical(other.title, title) || other.title == title)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.days, days)&&(identical(other.tone, tone) || other.tone == tone));
}


@override
int get hashCode => Object.hash(runtimeType,title,summary,const DeepCollectionEquality().hash(days),tone);

@override
String toString() {
  return 'WeekendPlanner(title: $title, summary: $summary, days: $days, tone: $tone)';
}


}

/// @nodoc
abstract mixin class $WeekendPlannerCopyWith<$Res>  {
  factory $WeekendPlannerCopyWith(WeekendPlanner value, $Res Function(WeekendPlanner) _then) = _$WeekendPlannerCopyWithImpl;
@useResult
$Res call({
 String title, String summary, List<WeekendDayPlan> days, AdviceTone tone
});




}
/// @nodoc
class _$WeekendPlannerCopyWithImpl<$Res>
    implements $WeekendPlannerCopyWith<$Res> {
  _$WeekendPlannerCopyWithImpl(this._self, this._then);

  final WeekendPlanner _self;
  final $Res Function(WeekendPlanner) _then;

/// Create a copy of WeekendPlanner
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? summary = null,Object? days = null,Object? tone = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as List<WeekendDayPlan>,tone: null == tone ? _self.tone : tone // ignore: cast_nullable_to_non_nullable
as AdviceTone,
  ));
}

}


/// Adds pattern-matching-related methods to [WeekendPlanner].
extension WeekendPlannerPatterns on WeekendPlanner {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeekendPlanner value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeekendPlanner() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeekendPlanner value)  $default,){
final _that = this;
switch (_that) {
case _WeekendPlanner():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeekendPlanner value)?  $default,){
final _that = this;
switch (_that) {
case _WeekendPlanner() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String summary,  List<WeekendDayPlan> days,  AdviceTone tone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeekendPlanner() when $default != null:
return $default(_that.title,_that.summary,_that.days,_that.tone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String summary,  List<WeekendDayPlan> days,  AdviceTone tone)  $default,) {final _that = this;
switch (_that) {
case _WeekendPlanner():
return $default(_that.title,_that.summary,_that.days,_that.tone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String summary,  List<WeekendDayPlan> days,  AdviceTone tone)?  $default,) {final _that = this;
switch (_that) {
case _WeekendPlanner() when $default != null:
return $default(_that.title,_that.summary,_that.days,_that.tone);case _:
  return null;

}
}

}

/// @nodoc


class _WeekendPlanner implements WeekendPlanner {
  const _WeekendPlanner({required this.title, required this.summary, required final  List<WeekendDayPlan> days, required this.tone}): _days = days;
  

@override final  String title;
@override final  String summary;
 final  List<WeekendDayPlan> _days;
@override List<WeekendDayPlan> get days {
  if (_days is EqualUnmodifiableListView) return _days;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_days);
}

@override final  AdviceTone tone;

/// Create a copy of WeekendPlanner
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeekendPlannerCopyWith<_WeekendPlanner> get copyWith => __$WeekendPlannerCopyWithImpl<_WeekendPlanner>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeekendPlanner&&(identical(other.title, title) || other.title == title)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other._days, _days)&&(identical(other.tone, tone) || other.tone == tone));
}


@override
int get hashCode => Object.hash(runtimeType,title,summary,const DeepCollectionEquality().hash(_days),tone);

@override
String toString() {
  return 'WeekendPlanner(title: $title, summary: $summary, days: $days, tone: $tone)';
}


}

/// @nodoc
abstract mixin class _$WeekendPlannerCopyWith<$Res> implements $WeekendPlannerCopyWith<$Res> {
  factory _$WeekendPlannerCopyWith(_WeekendPlanner value, $Res Function(_WeekendPlanner) _then) = __$WeekendPlannerCopyWithImpl;
@override @useResult
$Res call({
 String title, String summary, List<WeekendDayPlan> days, AdviceTone tone
});




}
/// @nodoc
class __$WeekendPlannerCopyWithImpl<$Res>
    implements _$WeekendPlannerCopyWith<$Res> {
  __$WeekendPlannerCopyWithImpl(this._self, this._then);

  final _WeekendPlanner _self;
  final $Res Function(_WeekendPlanner) _then;

/// Create a copy of WeekendPlanner
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? summary = null,Object? days = null,Object? tone = null,}) {
  return _then(_WeekendPlanner(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,days: null == days ? _self._days : days // ignore: cast_nullable_to_non_nullable
as List<WeekendDayPlan>,tone: null == tone ? _self.tone : tone // ignore: cast_nullable_to_non_nullable
as AdviceTone,
  ));
}


}

/// @nodoc
mixin _$WeatherGuidance {

 GuidanceHeadline get headline; NextHourInsight get nextHour; DryWindowInsight get dryWindow; CommuteOverview get commute; List<WearTip> get wearTips; List<ActivityRecommendation> get activities; List<RiskNote> get risks; String get simpleSummary; List<HourlyForecast> get highlightHours; List<HomeSummaryCard> get homeCards; WeekendPlanner? get weekendPlanner;
/// Create a copy of WeatherGuidance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeatherGuidanceCopyWith<WeatherGuidance> get copyWith => _$WeatherGuidanceCopyWithImpl<WeatherGuidance>(this as WeatherGuidance, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeatherGuidance&&(identical(other.headline, headline) || other.headline == headline)&&(identical(other.nextHour, nextHour) || other.nextHour == nextHour)&&(identical(other.dryWindow, dryWindow) || other.dryWindow == dryWindow)&&(identical(other.commute, commute) || other.commute == commute)&&const DeepCollectionEquality().equals(other.wearTips, wearTips)&&const DeepCollectionEquality().equals(other.activities, activities)&&const DeepCollectionEquality().equals(other.risks, risks)&&(identical(other.simpleSummary, simpleSummary) || other.simpleSummary == simpleSummary)&&const DeepCollectionEquality().equals(other.highlightHours, highlightHours)&&const DeepCollectionEquality().equals(other.homeCards, homeCards)&&(identical(other.weekendPlanner, weekendPlanner) || other.weekendPlanner == weekendPlanner));
}


@override
int get hashCode => Object.hash(runtimeType,headline,nextHour,dryWindow,commute,const DeepCollectionEquality().hash(wearTips),const DeepCollectionEquality().hash(activities),const DeepCollectionEquality().hash(risks),simpleSummary,const DeepCollectionEquality().hash(highlightHours),const DeepCollectionEquality().hash(homeCards),weekendPlanner);

@override
String toString() {
  return 'WeatherGuidance(headline: $headline, nextHour: $nextHour, dryWindow: $dryWindow, commute: $commute, wearTips: $wearTips, activities: $activities, risks: $risks, simpleSummary: $simpleSummary, highlightHours: $highlightHours, homeCards: $homeCards, weekendPlanner: $weekendPlanner)';
}


}

/// @nodoc
abstract mixin class $WeatherGuidanceCopyWith<$Res>  {
  factory $WeatherGuidanceCopyWith(WeatherGuidance value, $Res Function(WeatherGuidance) _then) = _$WeatherGuidanceCopyWithImpl;
@useResult
$Res call({
 GuidanceHeadline headline, NextHourInsight nextHour, DryWindowInsight dryWindow, CommuteOverview commute, List<WearTip> wearTips, List<ActivityRecommendation> activities, List<RiskNote> risks, String simpleSummary, List<HourlyForecast> highlightHours, List<HomeSummaryCard> homeCards, WeekendPlanner? weekendPlanner
});


$GuidanceHeadlineCopyWith<$Res> get headline;$NextHourInsightCopyWith<$Res> get nextHour;$DryWindowInsightCopyWith<$Res> get dryWindow;$CommuteOverviewCopyWith<$Res> get commute;$WeekendPlannerCopyWith<$Res>? get weekendPlanner;

}
/// @nodoc
class _$WeatherGuidanceCopyWithImpl<$Res>
    implements $WeatherGuidanceCopyWith<$Res> {
  _$WeatherGuidanceCopyWithImpl(this._self, this._then);

  final WeatherGuidance _self;
  final $Res Function(WeatherGuidance) _then;

/// Create a copy of WeatherGuidance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? headline = null,Object? nextHour = null,Object? dryWindow = null,Object? commute = null,Object? wearTips = null,Object? activities = null,Object? risks = null,Object? simpleSummary = null,Object? highlightHours = null,Object? homeCards = null,Object? weekendPlanner = freezed,}) {
  return _then(_self.copyWith(
headline: null == headline ? _self.headline : headline // ignore: cast_nullable_to_non_nullable
as GuidanceHeadline,nextHour: null == nextHour ? _self.nextHour : nextHour // ignore: cast_nullable_to_non_nullable
as NextHourInsight,dryWindow: null == dryWindow ? _self.dryWindow : dryWindow // ignore: cast_nullable_to_non_nullable
as DryWindowInsight,commute: null == commute ? _self.commute : commute // ignore: cast_nullable_to_non_nullable
as CommuteOverview,wearTips: null == wearTips ? _self.wearTips : wearTips // ignore: cast_nullable_to_non_nullable
as List<WearTip>,activities: null == activities ? _self.activities : activities // ignore: cast_nullable_to_non_nullable
as List<ActivityRecommendation>,risks: null == risks ? _self.risks : risks // ignore: cast_nullable_to_non_nullable
as List<RiskNote>,simpleSummary: null == simpleSummary ? _self.simpleSummary : simpleSummary // ignore: cast_nullable_to_non_nullable
as String,highlightHours: null == highlightHours ? _self.highlightHours : highlightHours // ignore: cast_nullable_to_non_nullable
as List<HourlyForecast>,homeCards: null == homeCards ? _self.homeCards : homeCards // ignore: cast_nullable_to_non_nullable
as List<HomeSummaryCard>,weekendPlanner: freezed == weekendPlanner ? _self.weekendPlanner : weekendPlanner // ignore: cast_nullable_to_non_nullable
as WeekendPlanner?,
  ));
}
/// Create a copy of WeatherGuidance
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GuidanceHeadlineCopyWith<$Res> get headline {
  
  return $GuidanceHeadlineCopyWith<$Res>(_self.headline, (value) {
    return _then(_self.copyWith(headline: value));
  });
}/// Create a copy of WeatherGuidance
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NextHourInsightCopyWith<$Res> get nextHour {
  
  return $NextHourInsightCopyWith<$Res>(_self.nextHour, (value) {
    return _then(_self.copyWith(nextHour: value));
  });
}/// Create a copy of WeatherGuidance
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DryWindowInsightCopyWith<$Res> get dryWindow {
  
  return $DryWindowInsightCopyWith<$Res>(_self.dryWindow, (value) {
    return _then(_self.copyWith(dryWindow: value));
  });
}/// Create a copy of WeatherGuidance
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CommuteOverviewCopyWith<$Res> get commute {
  
  return $CommuteOverviewCopyWith<$Res>(_self.commute, (value) {
    return _then(_self.copyWith(commute: value));
  });
}/// Create a copy of WeatherGuidance
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeekendPlannerCopyWith<$Res>? get weekendPlanner {
    if (_self.weekendPlanner == null) {
    return null;
  }

  return $WeekendPlannerCopyWith<$Res>(_self.weekendPlanner!, (value) {
    return _then(_self.copyWith(weekendPlanner: value));
  });
}
}


/// Adds pattern-matching-related methods to [WeatherGuidance].
extension WeatherGuidancePatterns on WeatherGuidance {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeatherGuidance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeatherGuidance() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeatherGuidance value)  $default,){
final _that = this;
switch (_that) {
case _WeatherGuidance():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeatherGuidance value)?  $default,){
final _that = this;
switch (_that) {
case _WeatherGuidance() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( GuidanceHeadline headline,  NextHourInsight nextHour,  DryWindowInsight dryWindow,  CommuteOverview commute,  List<WearTip> wearTips,  List<ActivityRecommendation> activities,  List<RiskNote> risks,  String simpleSummary,  List<HourlyForecast> highlightHours,  List<HomeSummaryCard> homeCards,  WeekendPlanner? weekendPlanner)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeatherGuidance() when $default != null:
return $default(_that.headline,_that.nextHour,_that.dryWindow,_that.commute,_that.wearTips,_that.activities,_that.risks,_that.simpleSummary,_that.highlightHours,_that.homeCards,_that.weekendPlanner);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( GuidanceHeadline headline,  NextHourInsight nextHour,  DryWindowInsight dryWindow,  CommuteOverview commute,  List<WearTip> wearTips,  List<ActivityRecommendation> activities,  List<RiskNote> risks,  String simpleSummary,  List<HourlyForecast> highlightHours,  List<HomeSummaryCard> homeCards,  WeekendPlanner? weekendPlanner)  $default,) {final _that = this;
switch (_that) {
case _WeatherGuidance():
return $default(_that.headline,_that.nextHour,_that.dryWindow,_that.commute,_that.wearTips,_that.activities,_that.risks,_that.simpleSummary,_that.highlightHours,_that.homeCards,_that.weekendPlanner);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( GuidanceHeadline headline,  NextHourInsight nextHour,  DryWindowInsight dryWindow,  CommuteOverview commute,  List<WearTip> wearTips,  List<ActivityRecommendation> activities,  List<RiskNote> risks,  String simpleSummary,  List<HourlyForecast> highlightHours,  List<HomeSummaryCard> homeCards,  WeekendPlanner? weekendPlanner)?  $default,) {final _that = this;
switch (_that) {
case _WeatherGuidance() when $default != null:
return $default(_that.headline,_that.nextHour,_that.dryWindow,_that.commute,_that.wearTips,_that.activities,_that.risks,_that.simpleSummary,_that.highlightHours,_that.homeCards,_that.weekendPlanner);case _:
  return null;

}
}

}

/// @nodoc


class _WeatherGuidance implements WeatherGuidance {
  const _WeatherGuidance({required this.headline, required this.nextHour, required this.dryWindow, required this.commute, required final  List<WearTip> wearTips, required final  List<ActivityRecommendation> activities, required final  List<RiskNote> risks, required this.simpleSummary, required final  List<HourlyForecast> highlightHours, required final  List<HomeSummaryCard> homeCards, required this.weekendPlanner}): _wearTips = wearTips,_activities = activities,_risks = risks,_highlightHours = highlightHours,_homeCards = homeCards;
  

@override final  GuidanceHeadline headline;
@override final  NextHourInsight nextHour;
@override final  DryWindowInsight dryWindow;
@override final  CommuteOverview commute;
 final  List<WearTip> _wearTips;
@override List<WearTip> get wearTips {
  if (_wearTips is EqualUnmodifiableListView) return _wearTips;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_wearTips);
}

 final  List<ActivityRecommendation> _activities;
@override List<ActivityRecommendation> get activities {
  if (_activities is EqualUnmodifiableListView) return _activities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_activities);
}

 final  List<RiskNote> _risks;
@override List<RiskNote> get risks {
  if (_risks is EqualUnmodifiableListView) return _risks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_risks);
}

@override final  String simpleSummary;
 final  List<HourlyForecast> _highlightHours;
@override List<HourlyForecast> get highlightHours {
  if (_highlightHours is EqualUnmodifiableListView) return _highlightHours;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_highlightHours);
}

 final  List<HomeSummaryCard> _homeCards;
@override List<HomeSummaryCard> get homeCards {
  if (_homeCards is EqualUnmodifiableListView) return _homeCards;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_homeCards);
}

@override final  WeekendPlanner? weekendPlanner;

/// Create a copy of WeatherGuidance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeatherGuidanceCopyWith<_WeatherGuidance> get copyWith => __$WeatherGuidanceCopyWithImpl<_WeatherGuidance>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeatherGuidance&&(identical(other.headline, headline) || other.headline == headline)&&(identical(other.nextHour, nextHour) || other.nextHour == nextHour)&&(identical(other.dryWindow, dryWindow) || other.dryWindow == dryWindow)&&(identical(other.commute, commute) || other.commute == commute)&&const DeepCollectionEquality().equals(other._wearTips, _wearTips)&&const DeepCollectionEquality().equals(other._activities, _activities)&&const DeepCollectionEquality().equals(other._risks, _risks)&&(identical(other.simpleSummary, simpleSummary) || other.simpleSummary == simpleSummary)&&const DeepCollectionEquality().equals(other._highlightHours, _highlightHours)&&const DeepCollectionEquality().equals(other._homeCards, _homeCards)&&(identical(other.weekendPlanner, weekendPlanner) || other.weekendPlanner == weekendPlanner));
}


@override
int get hashCode => Object.hash(runtimeType,headline,nextHour,dryWindow,commute,const DeepCollectionEquality().hash(_wearTips),const DeepCollectionEquality().hash(_activities),const DeepCollectionEquality().hash(_risks),simpleSummary,const DeepCollectionEquality().hash(_highlightHours),const DeepCollectionEquality().hash(_homeCards),weekendPlanner);

@override
String toString() {
  return 'WeatherGuidance(headline: $headline, nextHour: $nextHour, dryWindow: $dryWindow, commute: $commute, wearTips: $wearTips, activities: $activities, risks: $risks, simpleSummary: $simpleSummary, highlightHours: $highlightHours, homeCards: $homeCards, weekendPlanner: $weekendPlanner)';
}


}

/// @nodoc
abstract mixin class _$WeatherGuidanceCopyWith<$Res> implements $WeatherGuidanceCopyWith<$Res> {
  factory _$WeatherGuidanceCopyWith(_WeatherGuidance value, $Res Function(_WeatherGuidance) _then) = __$WeatherGuidanceCopyWithImpl;
@override @useResult
$Res call({
 GuidanceHeadline headline, NextHourInsight nextHour, DryWindowInsight dryWindow, CommuteOverview commute, List<WearTip> wearTips, List<ActivityRecommendation> activities, List<RiskNote> risks, String simpleSummary, List<HourlyForecast> highlightHours, List<HomeSummaryCard> homeCards, WeekendPlanner? weekendPlanner
});


@override $GuidanceHeadlineCopyWith<$Res> get headline;@override $NextHourInsightCopyWith<$Res> get nextHour;@override $DryWindowInsightCopyWith<$Res> get dryWindow;@override $CommuteOverviewCopyWith<$Res> get commute;@override $WeekendPlannerCopyWith<$Res>? get weekendPlanner;

}
/// @nodoc
class __$WeatherGuidanceCopyWithImpl<$Res>
    implements _$WeatherGuidanceCopyWith<$Res> {
  __$WeatherGuidanceCopyWithImpl(this._self, this._then);

  final _WeatherGuidance _self;
  final $Res Function(_WeatherGuidance) _then;

/// Create a copy of WeatherGuidance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? headline = null,Object? nextHour = null,Object? dryWindow = null,Object? commute = null,Object? wearTips = null,Object? activities = null,Object? risks = null,Object? simpleSummary = null,Object? highlightHours = null,Object? homeCards = null,Object? weekendPlanner = freezed,}) {
  return _then(_WeatherGuidance(
headline: null == headline ? _self.headline : headline // ignore: cast_nullable_to_non_nullable
as GuidanceHeadline,nextHour: null == nextHour ? _self.nextHour : nextHour // ignore: cast_nullable_to_non_nullable
as NextHourInsight,dryWindow: null == dryWindow ? _self.dryWindow : dryWindow // ignore: cast_nullable_to_non_nullable
as DryWindowInsight,commute: null == commute ? _self.commute : commute // ignore: cast_nullable_to_non_nullable
as CommuteOverview,wearTips: null == wearTips ? _self._wearTips : wearTips // ignore: cast_nullable_to_non_nullable
as List<WearTip>,activities: null == activities ? _self._activities : activities // ignore: cast_nullable_to_non_nullable
as List<ActivityRecommendation>,risks: null == risks ? _self._risks : risks // ignore: cast_nullable_to_non_nullable
as List<RiskNote>,simpleSummary: null == simpleSummary ? _self.simpleSummary : simpleSummary // ignore: cast_nullable_to_non_nullable
as String,highlightHours: null == highlightHours ? _self._highlightHours : highlightHours // ignore: cast_nullable_to_non_nullable
as List<HourlyForecast>,homeCards: null == homeCards ? _self._homeCards : homeCards // ignore: cast_nullable_to_non_nullable
as List<HomeSummaryCard>,weekendPlanner: freezed == weekendPlanner ? _self.weekendPlanner : weekendPlanner // ignore: cast_nullable_to_non_nullable
as WeekendPlanner?,
  ));
}

/// Create a copy of WeatherGuidance
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GuidanceHeadlineCopyWith<$Res> get headline {
  
  return $GuidanceHeadlineCopyWith<$Res>(_self.headline, (value) {
    return _then(_self.copyWith(headline: value));
  });
}/// Create a copy of WeatherGuidance
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NextHourInsightCopyWith<$Res> get nextHour {
  
  return $NextHourInsightCopyWith<$Res>(_self.nextHour, (value) {
    return _then(_self.copyWith(nextHour: value));
  });
}/// Create a copy of WeatherGuidance
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DryWindowInsightCopyWith<$Res> get dryWindow {
  
  return $DryWindowInsightCopyWith<$Res>(_self.dryWindow, (value) {
    return _then(_self.copyWith(dryWindow: value));
  });
}/// Create a copy of WeatherGuidance
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CommuteOverviewCopyWith<$Res> get commute {
  
  return $CommuteOverviewCopyWith<$Res>(_self.commute, (value) {
    return _then(_self.copyWith(commute: value));
  });
}/// Create a copy of WeatherGuidance
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeekendPlannerCopyWith<$Res>? get weekendPlanner {
    if (_self.weekendPlanner == null) {
    return null;
  }

  return $WeekendPlannerCopyWith<$Res>(_self.weekendPlanner!, (value) {
    return _then(_self.copyWith(weekendPlanner: value));
  });
}
}

// dart format on
