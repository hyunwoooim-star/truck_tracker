import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/themes/app_theme.dart';
import '../data/onboarding_repository.dart';
import '../domain/onboarding_state.dart';
import 'steps/welcome_step.dart';
import 'steps/truck_info_step.dart';
import 'steps/menu_step.dart';
import 'steps/schedule_step.dart';
import 'steps/complete_step.dart';
import 'widgets/step_indicator.dart';

/// 사장님 온보딩 화면
/// 트럭 등록 후 필수 정보를 입력하는 5단계 온보딩 플로우
class OwnerOnboardingScreen extends ConsumerStatefulWidget {
  final String truckId;
  final VoidCallback onComplete;

  const OwnerOnboardingScreen({
    super.key,
    required this.truckId,
    required this.onComplete,
  });

  @override
  ConsumerState<OwnerOnboardingScreen> createState() =>
      _OwnerOnboardingScreenState();
}

class _OwnerOnboardingScreenState extends ConsumerState<OwnerOnboardingScreen> {
  late OwnerOnboardingState _state;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _state = const OwnerOnboardingState();
  }

  void _nextStep() {
    setState(() {
      final currentIndex = OnboardingStep.values.indexOf(_state.currentStep);
      if (currentIndex < OnboardingStep.values.length - 1) {
        _state = _state.copyWith(
          currentStep: OnboardingStep.values[currentIndex + 1],
        );
      }
    });
  }

  void _previousStep() {
    setState(() {
      final currentIndex = OnboardingStep.values.indexOf(_state.currentStep);
      if (currentIndex > 0) {
        _state = _state.copyWith(
          currentStep: OnboardingStep.values[currentIndex - 1],
        );
      }
    });
  }

  Future<void> _saveTruckInfo(
      String name, String foodType, String? contact) async {
    setState(() => _isLoading = true);

    try {
      final repository = ref.read(ownerOnboardingRepositoryProvider);
      await repository.saveTruckInfo(
        truckId: widget.truckId,
        truckName: name,
        foodType: foodType,
        contactNumber: contact,
      );

      setState(() {
        _state = _state.copyWith(
          truckName: name,
          foodType: foodType,
          contactNumber: contact,
        );
        _isLoading = false;
      });

      _nextStep();
    } catch (e) {
      setState(() {
        _state = _state.copyWith(errorMessage: e.toString());
        _isLoading = false;
      });
      _showError('트럭 정보 저장에 실패했습니다');
    }
  }

  Future<void> _saveMenus(List<MenuItemData> menus) async {
    setState(() => _isLoading = true);

    try {
      final repository = ref.read(ownerOnboardingRepositoryProvider);
      await repository.saveMenus(
        truckId: widget.truckId,
        menus: menus,
      );

      setState(() {
        _state = _state.copyWith(menus: menus);
        _isLoading = false;
      });

      _nextStep();
    } catch (e) {
      setState(() {
        _state = _state.copyWith(errorMessage: e.toString());
        _isLoading = false;
      });
      _showError('메뉴 저장에 실패했습니다');
    }
  }

  Future<void> _saveSchedules(Map<String, ScheduleData> schedules) async {
    setState(() => _isLoading = true);

    try {
      final repository = ref.read(ownerOnboardingRepositoryProvider);
      await repository.saveSchedules(
        truckId: widget.truckId,
        schedules: schedules,
      );

      setState(() {
        _state = _state.copyWith(schedules: schedules);
        _isLoading = false;
      });

      _nextStep();
    } catch (e) {
      setState(() {
        _state = _state.copyWith(errorMessage: e.toString());
        _isLoading = false;
      });
      _showError('일정 저장에 실패했습니다');
    }
  }

  Future<void> _completeOnboarding() async {
    setState(() => _isLoading = true);

    try {
      final repository = ref.read(ownerOnboardingRepositoryProvider);
      await repository.completeOnboarding(truckId: widget.truckId);

      setState(() => _isLoading = false);
      widget.onComplete();
    } catch (e) {
      setState(() {
        _state = _state.copyWith(errorMessage: e.toString());
        _isLoading = false;
      });
      _showError('온보딩 완료 처리에 실패했습니다');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _state.currentStep != OnboardingStep.welcome &&
              _state.currentStep != OnboardingStep.complete
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () {
                  // 나가기 확인 다이얼로그
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('온보딩 나가기'),
                      content: const Text('진행 상태는 저장됩니다.\n나중에 이어서 진행할 수 있습니다.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('취소'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            widget.onComplete();
                          },
                          child: const Text('나가기'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              title: const Text(
                '트럭 설정',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            )
          : null,
      body: Stack(
        children: [
          Column(
            children: [
              // 단계 표시 (환영/완료 제외)
              if (_state.currentStep != OnboardingStep.welcome &&
                  _state.currentStep != OnboardingStep.complete)
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 16),
                  child: StepIndicator(
                    currentStep: _state.stepIndex,
                    totalSteps: _state.totalSteps,
                  ),
                ),

              // 현재 단계 화면
              Expanded(
                child: _buildCurrentStep(),
              ),
            ],
          ),

          // 로딩 오버레이
          if (_isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppTheme.mustardYellow,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_state.currentStep) {
      case OnboardingStep.welcome:
        return WelcomeStep(onNext: _nextStep);

      case OnboardingStep.truckInfo:
        return TruckInfoStep(
          initialName: _state.truckName,
          initialFoodType: _state.foodType,
          initialContact: _state.contactNumber,
          onSave: _saveTruckInfo,
          onBack: _previousStep,
        );

      case OnboardingStep.menu:
        return MenuStep(
          initialMenus: _state.menus,
          onSave: _saveMenus,
          onBack: _previousStep,
        );

      case OnboardingStep.schedule:
        return ScheduleStep(
          initialSchedules: _state.schedules,
          onSave: _saveSchedules,
          onBack: _previousStep,
        );

      case OnboardingStep.complete:
        return CompleteStep(
          truckName: _state.truckName,
          onComplete: _completeOnboarding,
        );
    }
  }
}
