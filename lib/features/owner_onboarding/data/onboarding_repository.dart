import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/onboarding_state.dart';

part 'onboarding_repository.g.dart';

/// 사장님 온보딩 Repository
class OwnerOnboardingRepository {
  final FirebaseFirestore _firestore;

  OwnerOnboardingRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// 트럭 정보 저장
  Future<void> saveTruckInfo({
    required String truckId,
    required String truckName,
    required String foodType,
    String? imageUrl,
    String? contactNumber,
  }) async {
    await _firestore.collection('trucks').doc(truckId).update({
      'truckNumber': truckName,
      'foodType': foodType,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (contactNumber != null) 'contactNumber': contactNumber,
      'onboardingStep': 1,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// 메뉴 저장
  Future<void> saveMenus({
    required String truckId,
    required List<MenuItemData> menus,
  }) async {
    final menuList = menus
        .map((m) => {
              'name': m.name,
              'price': m.price,
              'description': m.description,
              if (m.imageUrl != null) 'imageUrl': m.imageUrl,
            })
        .toList();

    await _firestore.collection('trucks').doc(truckId).update({
      'menus': menuList,
      'onboardingStep': 2,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// 일정 저장
  Future<void> saveSchedules({
    required String truckId,
    required Map<String, ScheduleData> schedules,
  }) async {
    final scheduleMap = <String, dynamic>{};
    schedules.forEach((day, schedule) {
      scheduleMap[day] = {
        'isOpen': schedule.isOpen,
        'startTime': schedule.startTime,
        'endTime': schedule.endTime,
      };
    });

    await _firestore.collection('trucks').doc(truckId).update({
      'weeklySchedule': scheduleMap,
      'onboardingStep': 3,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// 온보딩 완료 처리
  Future<void> completeOnboarding({
    required String truckId,
  }) async {
    await _firestore.collection('trucks').doc(truckId).update({
      'onboardingCompleted': true,
      'onboardingCompletedAt': FieldValue.serverTimestamp(),
      'onboardingStep': 4,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// 온보딩 상태 확인
  Future<int> getOnboardingStep(String truckId) async {
    final doc = await _firestore.collection('trucks').doc(truckId).get();
    if (!doc.exists) return 0;
    return doc.data()?['onboardingStep'] as int? ?? 0;
  }

  /// 온보딩 완료 여부 확인
  Future<bool> isOnboardingCompleted(String truckId) async {
    final doc = await _firestore.collection('trucks').doc(truckId).get();
    if (!doc.exists) return false;
    return doc.data()?['onboardingCompleted'] as bool? ?? false;
  }
}

@riverpod
OwnerOnboardingRepository ownerOnboardingRepository(Ref ref) {
  return OwnerOnboardingRepository();
}
