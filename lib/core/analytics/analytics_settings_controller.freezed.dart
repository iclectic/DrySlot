// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics_settings_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AnalyticsSettingsState {

 bool get enabled;
/// Create a copy of AnalyticsSettingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalyticsSettingsStateCopyWith<AnalyticsSettingsState> get copyWith => _$AnalyticsSettingsStateCopyWithImpl<AnalyticsSettingsState>(this as AnalyticsSettingsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsSettingsState&&(identical(other.enabled, enabled) || other.enabled == enabled));
}


@override
int get hashCode => Object.hash(runtimeType,enabled);

@override
String toString() {
  return 'AnalyticsSettingsState(enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class $AnalyticsSettingsStateCopyWith<$Res>  {
  factory $AnalyticsSettingsStateCopyWith(AnalyticsSettingsState value, $Res Function(AnalyticsSettingsState) _then) = _$AnalyticsSettingsStateCopyWithImpl;
@useResult
$Res call({
 bool enabled
});




}
/// @nodoc
class _$AnalyticsSettingsStateCopyWithImpl<$Res>
    implements $AnalyticsSettingsStateCopyWith<$Res> {
  _$AnalyticsSettingsStateCopyWithImpl(this._self, this._then);

  final AnalyticsSettingsState _self;
  final $Res Function(AnalyticsSettingsState) _then;

/// Create a copy of AnalyticsSettingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? enabled = null,}) {
  return _then(_self.copyWith(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AnalyticsSettingsState].
extension AnalyticsSettingsStatePatterns on AnalyticsSettingsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalyticsSettingsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalyticsSettingsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalyticsSettingsState value)  $default,){
final _that = this;
switch (_that) {
case _AnalyticsSettingsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalyticsSettingsState value)?  $default,){
final _that = this;
switch (_that) {
case _AnalyticsSettingsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool enabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalyticsSettingsState() when $default != null:
return $default(_that.enabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool enabled)  $default,) {final _that = this;
switch (_that) {
case _AnalyticsSettingsState():
return $default(_that.enabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool enabled)?  $default,) {final _that = this;
switch (_that) {
case _AnalyticsSettingsState() when $default != null:
return $default(_that.enabled);case _:
  return null;

}
}

}

/// @nodoc


class _AnalyticsSettingsState implements AnalyticsSettingsState {
  const _AnalyticsSettingsState({required this.enabled});
  

@override final  bool enabled;

/// Create a copy of AnalyticsSettingsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalyticsSettingsStateCopyWith<_AnalyticsSettingsState> get copyWith => __$AnalyticsSettingsStateCopyWithImpl<_AnalyticsSettingsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalyticsSettingsState&&(identical(other.enabled, enabled) || other.enabled == enabled));
}


@override
int get hashCode => Object.hash(runtimeType,enabled);

@override
String toString() {
  return 'AnalyticsSettingsState(enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class _$AnalyticsSettingsStateCopyWith<$Res> implements $AnalyticsSettingsStateCopyWith<$Res> {
  factory _$AnalyticsSettingsStateCopyWith(_AnalyticsSettingsState value, $Res Function(_AnalyticsSettingsState) _then) = __$AnalyticsSettingsStateCopyWithImpl;
@override @useResult
$Res call({
 bool enabled
});




}
/// @nodoc
class __$AnalyticsSettingsStateCopyWithImpl<$Res>
    implements _$AnalyticsSettingsStateCopyWith<$Res> {
  __$AnalyticsSettingsStateCopyWithImpl(this._self, this._then);

  final _AnalyticsSettingsState _self;
  final $Res Function(_AnalyticsSettingsState) _then;

/// Create a copy of AnalyticsSettingsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? enabled = null,}) {
  return _then(_AnalyticsSettingsState(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
