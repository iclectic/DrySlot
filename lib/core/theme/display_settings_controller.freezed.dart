// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'display_settings_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DisplaySettingsState {

 ThemeMode get themeMode; bool get largeText; bool get highContrast;
/// Create a copy of DisplaySettingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DisplaySettingsStateCopyWith<DisplaySettingsState> get copyWith => _$DisplaySettingsStateCopyWithImpl<DisplaySettingsState>(this as DisplaySettingsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DisplaySettingsState&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.largeText, largeText) || other.largeText == largeText)&&(identical(other.highContrast, highContrast) || other.highContrast == highContrast));
}


@override
int get hashCode => Object.hash(runtimeType,themeMode,largeText,highContrast);

@override
String toString() {
  return 'DisplaySettingsState(themeMode: $themeMode, largeText: $largeText, highContrast: $highContrast)';
}


}

/// @nodoc
abstract mixin class $DisplaySettingsStateCopyWith<$Res>  {
  factory $DisplaySettingsStateCopyWith(DisplaySettingsState value, $Res Function(DisplaySettingsState) _then) = _$DisplaySettingsStateCopyWithImpl;
@useResult
$Res call({
 ThemeMode themeMode, bool largeText, bool highContrast
});




}
/// @nodoc
class _$DisplaySettingsStateCopyWithImpl<$Res>
    implements $DisplaySettingsStateCopyWith<$Res> {
  _$DisplaySettingsStateCopyWithImpl(this._self, this._then);

  final DisplaySettingsState _self;
  final $Res Function(DisplaySettingsState) _then;

/// Create a copy of DisplaySettingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? themeMode = null,Object? largeText = null,Object? highContrast = null,}) {
  return _then(_self.copyWith(
themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as ThemeMode,largeText: null == largeText ? _self.largeText : largeText // ignore: cast_nullable_to_non_nullable
as bool,highContrast: null == highContrast ? _self.highContrast : highContrast // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DisplaySettingsState].
extension DisplaySettingsStatePatterns on DisplaySettingsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DisplaySettingsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DisplaySettingsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DisplaySettingsState value)  $default,){
final _that = this;
switch (_that) {
case _DisplaySettingsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DisplaySettingsState value)?  $default,){
final _that = this;
switch (_that) {
case _DisplaySettingsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ThemeMode themeMode,  bool largeText,  bool highContrast)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DisplaySettingsState() when $default != null:
return $default(_that.themeMode,_that.largeText,_that.highContrast);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ThemeMode themeMode,  bool largeText,  bool highContrast)  $default,) {final _that = this;
switch (_that) {
case _DisplaySettingsState():
return $default(_that.themeMode,_that.largeText,_that.highContrast);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ThemeMode themeMode,  bool largeText,  bool highContrast)?  $default,) {final _that = this;
switch (_that) {
case _DisplaySettingsState() when $default != null:
return $default(_that.themeMode,_that.largeText,_that.highContrast);case _:
  return null;

}
}

}

/// @nodoc


class _DisplaySettingsState extends DisplaySettingsState {
  const _DisplaySettingsState({required this.themeMode, required this.largeText, required this.highContrast}): super._();
  

@override final  ThemeMode themeMode;
@override final  bool largeText;
@override final  bool highContrast;

/// Create a copy of DisplaySettingsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DisplaySettingsStateCopyWith<_DisplaySettingsState> get copyWith => __$DisplaySettingsStateCopyWithImpl<_DisplaySettingsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DisplaySettingsState&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.largeText, largeText) || other.largeText == largeText)&&(identical(other.highContrast, highContrast) || other.highContrast == highContrast));
}


@override
int get hashCode => Object.hash(runtimeType,themeMode,largeText,highContrast);

@override
String toString() {
  return 'DisplaySettingsState(themeMode: $themeMode, largeText: $largeText, highContrast: $highContrast)';
}


}

/// @nodoc
abstract mixin class _$DisplaySettingsStateCopyWith<$Res> implements $DisplaySettingsStateCopyWith<$Res> {
  factory _$DisplaySettingsStateCopyWith(_DisplaySettingsState value, $Res Function(_DisplaySettingsState) _then) = __$DisplaySettingsStateCopyWithImpl;
@override @useResult
$Res call({
 ThemeMode themeMode, bool largeText, bool highContrast
});




}
/// @nodoc
class __$DisplaySettingsStateCopyWithImpl<$Res>
    implements _$DisplaySettingsStateCopyWith<$Res> {
  __$DisplaySettingsStateCopyWithImpl(this._self, this._then);

  final _DisplaySettingsState _self;
  final $Res Function(_DisplaySettingsState) _then;

/// Create a copy of DisplaySettingsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? themeMode = null,Object? largeText = null,Object? highContrast = null,}) {
  return _then(_DisplaySettingsState(
themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as ThemeMode,largeText: null == largeText ? _self.largeText : largeText // ignore: cast_nullable_to_non_nullable
as bool,highContrast: null == highContrast ? _self.highContrast : highContrast // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
