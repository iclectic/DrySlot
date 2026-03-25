// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weather_dashboard_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WeatherDashboardState {

 WeatherLocation get selectedLocation; List<SavedCommuteWindow> get commuteWindows; ExplanationMode get explanationMode; WeatherLocation? get comparisonLocation; WeatherReport? get report; WeatherGuidance? get guidance; WeatherReport? get comparisonReport; WeatherGuidance? get comparisonGuidance; String? get errorMessage; bool get isLoading; bool get isRefreshing;
/// Create a copy of WeatherDashboardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeatherDashboardStateCopyWith<WeatherDashboardState> get copyWith => _$WeatherDashboardStateCopyWithImpl<WeatherDashboardState>(this as WeatherDashboardState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeatherDashboardState&&(identical(other.selectedLocation, selectedLocation) || other.selectedLocation == selectedLocation)&&const DeepCollectionEquality().equals(other.commuteWindows, commuteWindows)&&(identical(other.explanationMode, explanationMode) || other.explanationMode == explanationMode)&&(identical(other.comparisonLocation, comparisonLocation) || other.comparisonLocation == comparisonLocation)&&(identical(other.report, report) || other.report == report)&&(identical(other.guidance, guidance) || other.guidance == guidance)&&(identical(other.comparisonReport, comparisonReport) || other.comparisonReport == comparisonReport)&&(identical(other.comparisonGuidance, comparisonGuidance) || other.comparisonGuidance == comparisonGuidance)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isRefreshing, isRefreshing) || other.isRefreshing == isRefreshing));
}


@override
int get hashCode => Object.hash(runtimeType,selectedLocation,const DeepCollectionEquality().hash(commuteWindows),explanationMode,comparisonLocation,report,guidance,comparisonReport,comparisonGuidance,errorMessage,isLoading,isRefreshing);

@override
String toString() {
  return 'WeatherDashboardState(selectedLocation: $selectedLocation, commuteWindows: $commuteWindows, explanationMode: $explanationMode, comparisonLocation: $comparisonLocation, report: $report, guidance: $guidance, comparisonReport: $comparisonReport, comparisonGuidance: $comparisonGuidance, errorMessage: $errorMessage, isLoading: $isLoading, isRefreshing: $isRefreshing)';
}


}

/// @nodoc
abstract mixin class $WeatherDashboardStateCopyWith<$Res>  {
  factory $WeatherDashboardStateCopyWith(WeatherDashboardState value, $Res Function(WeatherDashboardState) _then) = _$WeatherDashboardStateCopyWithImpl;
@useResult
$Res call({
 WeatherLocation selectedLocation, List<SavedCommuteWindow> commuteWindows, ExplanationMode explanationMode, WeatherLocation? comparisonLocation, WeatherReport? report, WeatherGuidance? guidance, WeatherReport? comparisonReport, WeatherGuidance? comparisonGuidance, String? errorMessage, bool isLoading, bool isRefreshing
});


$WeatherLocationCopyWith<$Res> get selectedLocation;$WeatherLocationCopyWith<$Res>? get comparisonLocation;$WeatherReportCopyWith<$Res>? get report;$WeatherGuidanceCopyWith<$Res>? get guidance;$WeatherReportCopyWith<$Res>? get comparisonReport;$WeatherGuidanceCopyWith<$Res>? get comparisonGuidance;

}
/// @nodoc
class _$WeatherDashboardStateCopyWithImpl<$Res>
    implements $WeatherDashboardStateCopyWith<$Res> {
  _$WeatherDashboardStateCopyWithImpl(this._self, this._then);

  final WeatherDashboardState _self;
  final $Res Function(WeatherDashboardState) _then;

/// Create a copy of WeatherDashboardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectedLocation = null,Object? commuteWindows = null,Object? explanationMode = null,Object? comparisonLocation = freezed,Object? report = freezed,Object? guidance = freezed,Object? comparisonReport = freezed,Object? comparisonGuidance = freezed,Object? errorMessage = freezed,Object? isLoading = null,Object? isRefreshing = null,}) {
  return _then(_self.copyWith(
selectedLocation: null == selectedLocation ? _self.selectedLocation : selectedLocation // ignore: cast_nullable_to_non_nullable
as WeatherLocation,commuteWindows: null == commuteWindows ? _self.commuteWindows : commuteWindows // ignore: cast_nullable_to_non_nullable
as List<SavedCommuteWindow>,explanationMode: null == explanationMode ? _self.explanationMode : explanationMode // ignore: cast_nullable_to_non_nullable
as ExplanationMode,comparisonLocation: freezed == comparisonLocation ? _self.comparisonLocation : comparisonLocation // ignore: cast_nullable_to_non_nullable
as WeatherLocation?,report: freezed == report ? _self.report : report // ignore: cast_nullable_to_non_nullable
as WeatherReport?,guidance: freezed == guidance ? _self.guidance : guidance // ignore: cast_nullable_to_non_nullable
as WeatherGuidance?,comparisonReport: freezed == comparisonReport ? _self.comparisonReport : comparisonReport // ignore: cast_nullable_to_non_nullable
as WeatherReport?,comparisonGuidance: freezed == comparisonGuidance ? _self.comparisonGuidance : comparisonGuidance // ignore: cast_nullable_to_non_nullable
as WeatherGuidance?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isRefreshing: null == isRefreshing ? _self.isRefreshing : isRefreshing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of WeatherDashboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeatherLocationCopyWith<$Res> get selectedLocation {
  
  return $WeatherLocationCopyWith<$Res>(_self.selectedLocation, (value) {
    return _then(_self.copyWith(selectedLocation: value));
  });
}/// Create a copy of WeatherDashboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeatherLocationCopyWith<$Res>? get comparisonLocation {
    if (_self.comparisonLocation == null) {
    return null;
  }

  return $WeatherLocationCopyWith<$Res>(_self.comparisonLocation!, (value) {
    return _then(_self.copyWith(comparisonLocation: value));
  });
}/// Create a copy of WeatherDashboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeatherReportCopyWith<$Res>? get report {
    if (_self.report == null) {
    return null;
  }

  return $WeatherReportCopyWith<$Res>(_self.report!, (value) {
    return _then(_self.copyWith(report: value));
  });
}/// Create a copy of WeatherDashboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeatherGuidanceCopyWith<$Res>? get guidance {
    if (_self.guidance == null) {
    return null;
  }

  return $WeatherGuidanceCopyWith<$Res>(_self.guidance!, (value) {
    return _then(_self.copyWith(guidance: value));
  });
}/// Create a copy of WeatherDashboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeatherReportCopyWith<$Res>? get comparisonReport {
    if (_self.comparisonReport == null) {
    return null;
  }

  return $WeatherReportCopyWith<$Res>(_self.comparisonReport!, (value) {
    return _then(_self.copyWith(comparisonReport: value));
  });
}/// Create a copy of WeatherDashboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeatherGuidanceCopyWith<$Res>? get comparisonGuidance {
    if (_self.comparisonGuidance == null) {
    return null;
  }

  return $WeatherGuidanceCopyWith<$Res>(_self.comparisonGuidance!, (value) {
    return _then(_self.copyWith(comparisonGuidance: value));
  });
}
}


/// Adds pattern-matching-related methods to [WeatherDashboardState].
extension WeatherDashboardStatePatterns on WeatherDashboardState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeatherDashboardState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeatherDashboardState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeatherDashboardState value)  $default,){
final _that = this;
switch (_that) {
case _WeatherDashboardState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeatherDashboardState value)?  $default,){
final _that = this;
switch (_that) {
case _WeatherDashboardState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( WeatherLocation selectedLocation,  List<SavedCommuteWindow> commuteWindows,  ExplanationMode explanationMode,  WeatherLocation? comparisonLocation,  WeatherReport? report,  WeatherGuidance? guidance,  WeatherReport? comparisonReport,  WeatherGuidance? comparisonGuidance,  String? errorMessage,  bool isLoading,  bool isRefreshing)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeatherDashboardState() when $default != null:
return $default(_that.selectedLocation,_that.commuteWindows,_that.explanationMode,_that.comparisonLocation,_that.report,_that.guidance,_that.comparisonReport,_that.comparisonGuidance,_that.errorMessage,_that.isLoading,_that.isRefreshing);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( WeatherLocation selectedLocation,  List<SavedCommuteWindow> commuteWindows,  ExplanationMode explanationMode,  WeatherLocation? comparisonLocation,  WeatherReport? report,  WeatherGuidance? guidance,  WeatherReport? comparisonReport,  WeatherGuidance? comparisonGuidance,  String? errorMessage,  bool isLoading,  bool isRefreshing)  $default,) {final _that = this;
switch (_that) {
case _WeatherDashboardState():
return $default(_that.selectedLocation,_that.commuteWindows,_that.explanationMode,_that.comparisonLocation,_that.report,_that.guidance,_that.comparisonReport,_that.comparisonGuidance,_that.errorMessage,_that.isLoading,_that.isRefreshing);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( WeatherLocation selectedLocation,  List<SavedCommuteWindow> commuteWindows,  ExplanationMode explanationMode,  WeatherLocation? comparisonLocation,  WeatherReport? report,  WeatherGuidance? guidance,  WeatherReport? comparisonReport,  WeatherGuidance? comparisonGuidance,  String? errorMessage,  bool isLoading,  bool isRefreshing)?  $default,) {final _that = this;
switch (_that) {
case _WeatherDashboardState() when $default != null:
return $default(_that.selectedLocation,_that.commuteWindows,_that.explanationMode,_that.comparisonLocation,_that.report,_that.guidance,_that.comparisonReport,_that.comparisonGuidance,_that.errorMessage,_that.isLoading,_that.isRefreshing);case _:
  return null;

}
}

}

/// @nodoc


class _WeatherDashboardState extends WeatherDashboardState {
  const _WeatherDashboardState({required this.selectedLocation, required final  List<SavedCommuteWindow> commuteWindows, required this.explanationMode, required this.comparisonLocation, required this.report, required this.guidance, required this.comparisonReport, required this.comparisonGuidance, required this.errorMessage, required this.isLoading, required this.isRefreshing}): _commuteWindows = commuteWindows,super._();
  

@override final  WeatherLocation selectedLocation;
 final  List<SavedCommuteWindow> _commuteWindows;
@override List<SavedCommuteWindow> get commuteWindows {
  if (_commuteWindows is EqualUnmodifiableListView) return _commuteWindows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_commuteWindows);
}

@override final  ExplanationMode explanationMode;
@override final  WeatherLocation? comparisonLocation;
@override final  WeatherReport? report;
@override final  WeatherGuidance? guidance;
@override final  WeatherReport? comparisonReport;
@override final  WeatherGuidance? comparisonGuidance;
@override final  String? errorMessage;
@override final  bool isLoading;
@override final  bool isRefreshing;

/// Create a copy of WeatherDashboardState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeatherDashboardStateCopyWith<_WeatherDashboardState> get copyWith => __$WeatherDashboardStateCopyWithImpl<_WeatherDashboardState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeatherDashboardState&&(identical(other.selectedLocation, selectedLocation) || other.selectedLocation == selectedLocation)&&const DeepCollectionEquality().equals(other._commuteWindows, _commuteWindows)&&(identical(other.explanationMode, explanationMode) || other.explanationMode == explanationMode)&&(identical(other.comparisonLocation, comparisonLocation) || other.comparisonLocation == comparisonLocation)&&(identical(other.report, report) || other.report == report)&&(identical(other.guidance, guidance) || other.guidance == guidance)&&(identical(other.comparisonReport, comparisonReport) || other.comparisonReport == comparisonReport)&&(identical(other.comparisonGuidance, comparisonGuidance) || other.comparisonGuidance == comparisonGuidance)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isRefreshing, isRefreshing) || other.isRefreshing == isRefreshing));
}


@override
int get hashCode => Object.hash(runtimeType,selectedLocation,const DeepCollectionEquality().hash(_commuteWindows),explanationMode,comparisonLocation,report,guidance,comparisonReport,comparisonGuidance,errorMessage,isLoading,isRefreshing);

@override
String toString() {
  return 'WeatherDashboardState(selectedLocation: $selectedLocation, commuteWindows: $commuteWindows, explanationMode: $explanationMode, comparisonLocation: $comparisonLocation, report: $report, guidance: $guidance, comparisonReport: $comparisonReport, comparisonGuidance: $comparisonGuidance, errorMessage: $errorMessage, isLoading: $isLoading, isRefreshing: $isRefreshing)';
}


}

/// @nodoc
abstract mixin class _$WeatherDashboardStateCopyWith<$Res> implements $WeatherDashboardStateCopyWith<$Res> {
  factory _$WeatherDashboardStateCopyWith(_WeatherDashboardState value, $Res Function(_WeatherDashboardState) _then) = __$WeatherDashboardStateCopyWithImpl;
@override @useResult
$Res call({
 WeatherLocation selectedLocation, List<SavedCommuteWindow> commuteWindows, ExplanationMode explanationMode, WeatherLocation? comparisonLocation, WeatherReport? report, WeatherGuidance? guidance, WeatherReport? comparisonReport, WeatherGuidance? comparisonGuidance, String? errorMessage, bool isLoading, bool isRefreshing
});


@override $WeatherLocationCopyWith<$Res> get selectedLocation;@override $WeatherLocationCopyWith<$Res>? get comparisonLocation;@override $WeatherReportCopyWith<$Res>? get report;@override $WeatherGuidanceCopyWith<$Res>? get guidance;@override $WeatherReportCopyWith<$Res>? get comparisonReport;@override $WeatherGuidanceCopyWith<$Res>? get comparisonGuidance;

}
/// @nodoc
class __$WeatherDashboardStateCopyWithImpl<$Res>
    implements _$WeatherDashboardStateCopyWith<$Res> {
  __$WeatherDashboardStateCopyWithImpl(this._self, this._then);

  final _WeatherDashboardState _self;
  final $Res Function(_WeatherDashboardState) _then;

/// Create a copy of WeatherDashboardState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectedLocation = null,Object? commuteWindows = null,Object? explanationMode = null,Object? comparisonLocation = freezed,Object? report = freezed,Object? guidance = freezed,Object? comparisonReport = freezed,Object? comparisonGuidance = freezed,Object? errorMessage = freezed,Object? isLoading = null,Object? isRefreshing = null,}) {
  return _then(_WeatherDashboardState(
selectedLocation: null == selectedLocation ? _self.selectedLocation : selectedLocation // ignore: cast_nullable_to_non_nullable
as WeatherLocation,commuteWindows: null == commuteWindows ? _self._commuteWindows : commuteWindows // ignore: cast_nullable_to_non_nullable
as List<SavedCommuteWindow>,explanationMode: null == explanationMode ? _self.explanationMode : explanationMode // ignore: cast_nullable_to_non_nullable
as ExplanationMode,comparisonLocation: freezed == comparisonLocation ? _self.comparisonLocation : comparisonLocation // ignore: cast_nullable_to_non_nullable
as WeatherLocation?,report: freezed == report ? _self.report : report // ignore: cast_nullable_to_non_nullable
as WeatherReport?,guidance: freezed == guidance ? _self.guidance : guidance // ignore: cast_nullable_to_non_nullable
as WeatherGuidance?,comparisonReport: freezed == comparisonReport ? _self.comparisonReport : comparisonReport // ignore: cast_nullable_to_non_nullable
as WeatherReport?,comparisonGuidance: freezed == comparisonGuidance ? _self.comparisonGuidance : comparisonGuidance // ignore: cast_nullable_to_non_nullable
as WeatherGuidance?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isRefreshing: null == isRefreshing ? _self.isRefreshing : isRefreshing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of WeatherDashboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeatherLocationCopyWith<$Res> get selectedLocation {
  
  return $WeatherLocationCopyWith<$Res>(_self.selectedLocation, (value) {
    return _then(_self.copyWith(selectedLocation: value));
  });
}/// Create a copy of WeatherDashboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeatherLocationCopyWith<$Res>? get comparisonLocation {
    if (_self.comparisonLocation == null) {
    return null;
  }

  return $WeatherLocationCopyWith<$Res>(_self.comparisonLocation!, (value) {
    return _then(_self.copyWith(comparisonLocation: value));
  });
}/// Create a copy of WeatherDashboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeatherReportCopyWith<$Res>? get report {
    if (_self.report == null) {
    return null;
  }

  return $WeatherReportCopyWith<$Res>(_self.report!, (value) {
    return _then(_self.copyWith(report: value));
  });
}/// Create a copy of WeatherDashboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeatherGuidanceCopyWith<$Res>? get guidance {
    if (_self.guidance == null) {
    return null;
  }

  return $WeatherGuidanceCopyWith<$Res>(_self.guidance!, (value) {
    return _then(_self.copyWith(guidance: value));
  });
}/// Create a copy of WeatherDashboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeatherReportCopyWith<$Res>? get comparisonReport {
    if (_self.comparisonReport == null) {
    return null;
  }

  return $WeatherReportCopyWith<$Res>(_self.comparisonReport!, (value) {
    return _then(_self.copyWith(comparisonReport: value));
  });
}/// Create a copy of WeatherDashboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeatherGuidanceCopyWith<$Res>? get comparisonGuidance {
    if (_self.comparisonGuidance == null) {
    return null;
  }

  return $WeatherGuidanceCopyWith<$Res>(_self.comparisonGuidance!, (value) {
    return _then(_self.copyWith(comparisonGuidance: value));
  });
}
}

// dart format on
