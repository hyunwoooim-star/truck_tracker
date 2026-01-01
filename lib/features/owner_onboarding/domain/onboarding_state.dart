import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_state.freezed.dart';

/// 사장님 온보딩 단계
enum OnboardingStep {
  welcome,
  truckInfo,
  menu,
  schedule,
  complete,
}

/// 사장님 온보딩 상태
@freezed
sealed class OwnerOnboardingState with _$OwnerOnboardingState {
  const OwnerOnboardingState._();

  const factory OwnerOnboardingState({
    @Default(OnboardingStep.welcome) OnboardingStep currentStep,
    @Default('') String truckName,
    @Default('') String foodType,
    String? truckImageUrl,
    String? contactNumber,
    @Default([]) List<MenuItemData> menus,
    @Default({}) Map<String, ScheduleData> schedules,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _OwnerOnboardingState;

  /// 현재 단계 인덱스 (0-4)
  int get stepIndex => OnboardingStep.values.indexOf(currentStep);

  /// 총 단계 수
  int get totalSteps => OnboardingStep.values.length;

  /// 진행률 (0.0 ~ 1.0)
  double get progress => (stepIndex + 1) / totalSteps;

  /// 트럭 정보가 유효한지
  bool get isTruckInfoValid => truckName.isNotEmpty && foodType.isNotEmpty;

  /// 메뉴가 유효한지 (최소 1개)
  bool get isMenuValid => menus.isNotEmpty;

  /// 일정이 유효한지 (최소 1개 요일)
  bool get isScheduleValid => schedules.values.any((s) => s.isOpen);

  /// 다음 단계로 이동 가능한지
  bool get canProceed {
    switch (currentStep) {
      case OnboardingStep.welcome:
        return true;
      case OnboardingStep.truckInfo:
        return isTruckInfoValid;
      case OnboardingStep.menu:
        return isMenuValid;
      case OnboardingStep.schedule:
        return isScheduleValid;
      case OnboardingStep.complete:
        return true;
    }
  }
}

/// 메뉴 아이템 데이터
@freezed
sealed class MenuItemData with _$MenuItemData {
  const factory MenuItemData({
    required String name,
    required int price,
    @Default('') String description,
    String? imageUrl,
  }) = _MenuItemData;
}

/// 일정 데이터
@freezed
sealed class ScheduleData with _$ScheduleData {
  const factory ScheduleData({
    required String dayOfWeek,
    @Default(false) bool isOpen,
    @Default('17:00') String startTime,
    @Default('23:00') String endTime,
  }) = _ScheduleData;
}
