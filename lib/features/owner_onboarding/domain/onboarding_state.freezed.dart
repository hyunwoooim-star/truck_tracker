// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OwnerOnboardingState {

 OnboardingStep get currentStep; String get truckName; String get foodType; String? get truckImageUrl; String? get contactNumber; List<MenuItemData> get menus; Map<String, ScheduleData> get schedules; bool get isLoading; String? get errorMessage;
/// Create a copy of OwnerOnboardingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OwnerOnboardingStateCopyWith<OwnerOnboardingState> get copyWith => _$OwnerOnboardingStateCopyWithImpl<OwnerOnboardingState>(this as OwnerOnboardingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OwnerOnboardingState&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep)&&(identical(other.truckName, truckName) || other.truckName == truckName)&&(identical(other.foodType, foodType) || other.foodType == foodType)&&(identical(other.truckImageUrl, truckImageUrl) || other.truckImageUrl == truckImageUrl)&&(identical(other.contactNumber, contactNumber) || other.contactNumber == contactNumber)&&const DeepCollectionEquality().equals(other.menus, menus)&&const DeepCollectionEquality().equals(other.schedules, schedules)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,currentStep,truckName,foodType,truckImageUrl,contactNumber,const DeepCollectionEquality().hash(menus),const DeepCollectionEquality().hash(schedules),isLoading,errorMessage);

@override
String toString() {
  return 'OwnerOnboardingState(currentStep: $currentStep, truckName: $truckName, foodType: $foodType, truckImageUrl: $truckImageUrl, contactNumber: $contactNumber, menus: $menus, schedules: $schedules, isLoading: $isLoading, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $OwnerOnboardingStateCopyWith<$Res>  {
  factory $OwnerOnboardingStateCopyWith(OwnerOnboardingState value, $Res Function(OwnerOnboardingState) _then) = _$OwnerOnboardingStateCopyWithImpl;
@useResult
$Res call({
 OnboardingStep currentStep, String truckName, String foodType, String? truckImageUrl, String? contactNumber, List<MenuItemData> menus, Map<String, ScheduleData> schedules, bool isLoading, String? errorMessage
});




}
/// @nodoc
class _$OwnerOnboardingStateCopyWithImpl<$Res>
    implements $OwnerOnboardingStateCopyWith<$Res> {
  _$OwnerOnboardingStateCopyWithImpl(this._self, this._then);

  final OwnerOnboardingState _self;
  final $Res Function(OwnerOnboardingState) _then;

/// Create a copy of OwnerOnboardingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentStep = null,Object? truckName = null,Object? foodType = null,Object? truckImageUrl = freezed,Object? contactNumber = freezed,Object? menus = null,Object? schedules = null,Object? isLoading = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as OnboardingStep,truckName: null == truckName ? _self.truckName : truckName // ignore: cast_nullable_to_non_nullable
as String,foodType: null == foodType ? _self.foodType : foodType // ignore: cast_nullable_to_non_nullable
as String,truckImageUrl: freezed == truckImageUrl ? _self.truckImageUrl : truckImageUrl // ignore: cast_nullable_to_non_nullable
as String?,contactNumber: freezed == contactNumber ? _self.contactNumber : contactNumber // ignore: cast_nullable_to_non_nullable
as String?,menus: null == menus ? _self.menus : menus // ignore: cast_nullable_to_non_nullable
as List<MenuItemData>,schedules: null == schedules ? _self.schedules : schedules // ignore: cast_nullable_to_non_nullable
as Map<String, ScheduleData>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OwnerOnboardingState].
extension OwnerOnboardingStatePatterns on OwnerOnboardingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OwnerOnboardingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OwnerOnboardingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OwnerOnboardingState value)  $default,){
final _that = this;
switch (_that) {
case _OwnerOnboardingState():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OwnerOnboardingState value)?  $default,){
final _that = this;
switch (_that) {
case _OwnerOnboardingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( OnboardingStep currentStep,  String truckName,  String foodType,  String? truckImageUrl,  String? contactNumber,  List<MenuItemData> menus,  Map<String, ScheduleData> schedules,  bool isLoading,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OwnerOnboardingState() when $default != null:
return $default(_that.currentStep,_that.truckName,_that.foodType,_that.truckImageUrl,_that.contactNumber,_that.menus,_that.schedules,_that.isLoading,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( OnboardingStep currentStep,  String truckName,  String foodType,  String? truckImageUrl,  String? contactNumber,  List<MenuItemData> menus,  Map<String, ScheduleData> schedules,  bool isLoading,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _OwnerOnboardingState():
return $default(_that.currentStep,_that.truckName,_that.foodType,_that.truckImageUrl,_that.contactNumber,_that.menus,_that.schedules,_that.isLoading,_that.errorMessage);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( OnboardingStep currentStep,  String truckName,  String foodType,  String? truckImageUrl,  String? contactNumber,  List<MenuItemData> menus,  Map<String, ScheduleData> schedules,  bool isLoading,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _OwnerOnboardingState() when $default != null:
return $default(_that.currentStep,_that.truckName,_that.foodType,_that.truckImageUrl,_that.contactNumber,_that.menus,_that.schedules,_that.isLoading,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _OwnerOnboardingState extends OwnerOnboardingState {
  const _OwnerOnboardingState({this.currentStep = OnboardingStep.welcome, this.truckName = '', this.foodType = '', this.truckImageUrl, this.contactNumber, final  List<MenuItemData> menus = const [], final  Map<String, ScheduleData> schedules = const {}, this.isLoading = false, this.errorMessage}): _menus = menus,_schedules = schedules,super._();
  

@override@JsonKey() final  OnboardingStep currentStep;
@override@JsonKey() final  String truckName;
@override@JsonKey() final  String foodType;
@override final  String? truckImageUrl;
@override final  String? contactNumber;
 final  List<MenuItemData> _menus;
@override@JsonKey() List<MenuItemData> get menus {
  if (_menus is EqualUnmodifiableListView) return _menus;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_menus);
}

 final  Map<String, ScheduleData> _schedules;
@override@JsonKey() Map<String, ScheduleData> get schedules {
  if (_schedules is EqualUnmodifiableMapView) return _schedules;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_schedules);
}

@override@JsonKey() final  bool isLoading;
@override final  String? errorMessage;

/// Create a copy of OwnerOnboardingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OwnerOnboardingStateCopyWith<_OwnerOnboardingState> get copyWith => __$OwnerOnboardingStateCopyWithImpl<_OwnerOnboardingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OwnerOnboardingState&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep)&&(identical(other.truckName, truckName) || other.truckName == truckName)&&(identical(other.foodType, foodType) || other.foodType == foodType)&&(identical(other.truckImageUrl, truckImageUrl) || other.truckImageUrl == truckImageUrl)&&(identical(other.contactNumber, contactNumber) || other.contactNumber == contactNumber)&&const DeepCollectionEquality().equals(other._menus, _menus)&&const DeepCollectionEquality().equals(other._schedules, _schedules)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,currentStep,truckName,foodType,truckImageUrl,contactNumber,const DeepCollectionEquality().hash(_menus),const DeepCollectionEquality().hash(_schedules),isLoading,errorMessage);

@override
String toString() {
  return 'OwnerOnboardingState(currentStep: $currentStep, truckName: $truckName, foodType: $foodType, truckImageUrl: $truckImageUrl, contactNumber: $contactNumber, menus: $menus, schedules: $schedules, isLoading: $isLoading, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$OwnerOnboardingStateCopyWith<$Res> implements $OwnerOnboardingStateCopyWith<$Res> {
  factory _$OwnerOnboardingStateCopyWith(_OwnerOnboardingState value, $Res Function(_OwnerOnboardingState) _then) = __$OwnerOnboardingStateCopyWithImpl;
@override @useResult
$Res call({
 OnboardingStep currentStep, String truckName, String foodType, String? truckImageUrl, String? contactNumber, List<MenuItemData> menus, Map<String, ScheduleData> schedules, bool isLoading, String? errorMessage
});




}
/// @nodoc
class __$OwnerOnboardingStateCopyWithImpl<$Res>
    implements _$OwnerOnboardingStateCopyWith<$Res> {
  __$OwnerOnboardingStateCopyWithImpl(this._self, this._then);

  final _OwnerOnboardingState _self;
  final $Res Function(_OwnerOnboardingState) _then;

/// Create a copy of OwnerOnboardingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentStep = null,Object? truckName = null,Object? foodType = null,Object? truckImageUrl = freezed,Object? contactNumber = freezed,Object? menus = null,Object? schedules = null,Object? isLoading = null,Object? errorMessage = freezed,}) {
  return _then(_OwnerOnboardingState(
currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as OnboardingStep,truckName: null == truckName ? _self.truckName : truckName // ignore: cast_nullable_to_non_nullable
as String,foodType: null == foodType ? _self.foodType : foodType // ignore: cast_nullable_to_non_nullable
as String,truckImageUrl: freezed == truckImageUrl ? _self.truckImageUrl : truckImageUrl // ignore: cast_nullable_to_non_nullable
as String?,contactNumber: freezed == contactNumber ? _self.contactNumber : contactNumber // ignore: cast_nullable_to_non_nullable
as String?,menus: null == menus ? _self._menus : menus // ignore: cast_nullable_to_non_nullable
as List<MenuItemData>,schedules: null == schedules ? _self._schedules : schedules // ignore: cast_nullable_to_non_nullable
as Map<String, ScheduleData>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$MenuItemData {

 String get name; int get price; String get description; String? get imageUrl;
/// Create a copy of MenuItemData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MenuItemDataCopyWith<MenuItemData> get copyWith => _$MenuItemDataCopyWithImpl<MenuItemData>(this as MenuItemData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MenuItemData&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}


@override
int get hashCode => Object.hash(runtimeType,name,price,description,imageUrl);

@override
String toString() {
  return 'MenuItemData(name: $name, price: $price, description: $description, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $MenuItemDataCopyWith<$Res>  {
  factory $MenuItemDataCopyWith(MenuItemData value, $Res Function(MenuItemData) _then) = _$MenuItemDataCopyWithImpl;
@useResult
$Res call({
 String name, int price, String description, String? imageUrl
});




}
/// @nodoc
class _$MenuItemDataCopyWithImpl<$Res>
    implements $MenuItemDataCopyWith<$Res> {
  _$MenuItemDataCopyWithImpl(this._self, this._then);

  final MenuItemData _self;
  final $Res Function(MenuItemData) _then;

/// Create a copy of MenuItemData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? price = null,Object? description = null,Object? imageUrl = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MenuItemData].
extension MenuItemDataPatterns on MenuItemData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MenuItemData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MenuItemData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MenuItemData value)  $default,){
final _that = this;
switch (_that) {
case _MenuItemData():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MenuItemData value)?  $default,){
final _that = this;
switch (_that) {
case _MenuItemData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  int price,  String description,  String? imageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MenuItemData() when $default != null:
return $default(_that.name,_that.price,_that.description,_that.imageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  int price,  String description,  String? imageUrl)  $default,) {final _that = this;
switch (_that) {
case _MenuItemData():
return $default(_that.name,_that.price,_that.description,_that.imageUrl);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  int price,  String description,  String? imageUrl)?  $default,) {final _that = this;
switch (_that) {
case _MenuItemData() when $default != null:
return $default(_that.name,_that.price,_that.description,_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc


class _MenuItemData implements MenuItemData {
  const _MenuItemData({required this.name, required this.price, this.description = '', this.imageUrl});
  

@override final  String name;
@override final  int price;
@override@JsonKey() final  String description;
@override final  String? imageUrl;

/// Create a copy of MenuItemData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MenuItemDataCopyWith<_MenuItemData> get copyWith => __$MenuItemDataCopyWithImpl<_MenuItemData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MenuItemData&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}


@override
int get hashCode => Object.hash(runtimeType,name,price,description,imageUrl);

@override
String toString() {
  return 'MenuItemData(name: $name, price: $price, description: $description, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$MenuItemDataCopyWith<$Res> implements $MenuItemDataCopyWith<$Res> {
  factory _$MenuItemDataCopyWith(_MenuItemData value, $Res Function(_MenuItemData) _then) = __$MenuItemDataCopyWithImpl;
@override @useResult
$Res call({
 String name, int price, String description, String? imageUrl
});




}
/// @nodoc
class __$MenuItemDataCopyWithImpl<$Res>
    implements _$MenuItemDataCopyWith<$Res> {
  __$MenuItemDataCopyWithImpl(this._self, this._then);

  final _MenuItemData _self;
  final $Res Function(_MenuItemData) _then;

/// Create a copy of MenuItemData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? price = null,Object? description = null,Object? imageUrl = freezed,}) {
  return _then(_MenuItemData(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$ScheduleData {

 String get dayOfWeek; bool get isOpen; String get startTime; String get endTime;
/// Create a copy of ScheduleData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleDataCopyWith<ScheduleData> get copyWith => _$ScheduleDataCopyWithImpl<ScheduleData>(this as ScheduleData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleData&&(identical(other.dayOfWeek, dayOfWeek) || other.dayOfWeek == dayOfWeek)&&(identical(other.isOpen, isOpen) || other.isOpen == isOpen)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime));
}


@override
int get hashCode => Object.hash(runtimeType,dayOfWeek,isOpen,startTime,endTime);

@override
String toString() {
  return 'ScheduleData(dayOfWeek: $dayOfWeek, isOpen: $isOpen, startTime: $startTime, endTime: $endTime)';
}


}

/// @nodoc
abstract mixin class $ScheduleDataCopyWith<$Res>  {
  factory $ScheduleDataCopyWith(ScheduleData value, $Res Function(ScheduleData) _then) = _$ScheduleDataCopyWithImpl;
@useResult
$Res call({
 String dayOfWeek, bool isOpen, String startTime, String endTime
});




}
/// @nodoc
class _$ScheduleDataCopyWithImpl<$Res>
    implements $ScheduleDataCopyWith<$Res> {
  _$ScheduleDataCopyWithImpl(this._self, this._then);

  final ScheduleData _self;
  final $Res Function(ScheduleData) _then;

/// Create a copy of ScheduleData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dayOfWeek = null,Object? isOpen = null,Object? startTime = null,Object? endTime = null,}) {
  return _then(_self.copyWith(
dayOfWeek: null == dayOfWeek ? _self.dayOfWeek : dayOfWeek // ignore: cast_nullable_to_non_nullable
as String,isOpen: null == isOpen ? _self.isOpen : isOpen // ignore: cast_nullable_to_non_nullable
as bool,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleData].
extension ScheduleDataPatterns on ScheduleData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleData value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleData():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleData value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String dayOfWeek,  bool isOpen,  String startTime,  String endTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleData() when $default != null:
return $default(_that.dayOfWeek,_that.isOpen,_that.startTime,_that.endTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String dayOfWeek,  bool isOpen,  String startTime,  String endTime)  $default,) {final _that = this;
switch (_that) {
case _ScheduleData():
return $default(_that.dayOfWeek,_that.isOpen,_that.startTime,_that.endTime);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String dayOfWeek,  bool isOpen,  String startTime,  String endTime)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleData() when $default != null:
return $default(_that.dayOfWeek,_that.isOpen,_that.startTime,_that.endTime);case _:
  return null;

}
}

}

/// @nodoc


class _ScheduleData implements ScheduleData {
  const _ScheduleData({required this.dayOfWeek, this.isOpen = false, this.startTime = '17:00', this.endTime = '23:00'});
  

@override final  String dayOfWeek;
@override@JsonKey() final  bool isOpen;
@override@JsonKey() final  String startTime;
@override@JsonKey() final  String endTime;

/// Create a copy of ScheduleData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleDataCopyWith<_ScheduleData> get copyWith => __$ScheduleDataCopyWithImpl<_ScheduleData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleData&&(identical(other.dayOfWeek, dayOfWeek) || other.dayOfWeek == dayOfWeek)&&(identical(other.isOpen, isOpen) || other.isOpen == isOpen)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime));
}


@override
int get hashCode => Object.hash(runtimeType,dayOfWeek,isOpen,startTime,endTime);

@override
String toString() {
  return 'ScheduleData(dayOfWeek: $dayOfWeek, isOpen: $isOpen, startTime: $startTime, endTime: $endTime)';
}


}

/// @nodoc
abstract mixin class _$ScheduleDataCopyWith<$Res> implements $ScheduleDataCopyWith<$Res> {
  factory _$ScheduleDataCopyWith(_ScheduleData value, $Res Function(_ScheduleData) _then) = __$ScheduleDataCopyWithImpl;
@override @useResult
$Res call({
 String dayOfWeek, bool isOpen, String startTime, String endTime
});




}
/// @nodoc
class __$ScheduleDataCopyWithImpl<$Res>
    implements _$ScheduleDataCopyWith<$Res> {
  __$ScheduleDataCopyWithImpl(this._self, this._then);

  final _ScheduleData _self;
  final $Res Function(_ScheduleData) _then;

/// Create a copy of ScheduleData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dayOfWeek = null,Object? isOpen = null,Object? startTime = null,Object? endTime = null,}) {
  return _then(_ScheduleData(
dayOfWeek: null == dayOfWeek ? _self.dayOfWeek : dayOfWeek // ignore: cast_nullable_to_non_nullable
as String,isOpen: null == isOpen ? _self.isOpen : isOpen // ignore: cast_nullable_to_non_nullable
as bool,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
