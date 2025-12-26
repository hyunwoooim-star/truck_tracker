import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/app_logger.dart';
import '../domain/daily_schedule.dart';

part 'schedule_repository.g.dart';

/// Schedule Repository for managing daily schedules
class ScheduleRepository {
  ScheduleRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  /// Get today's schedule for a truck
  Future<DailySchedule?> getTodaySchedule(String truckId) async {
    try {
      final today = DateTime.now();
      final dateKey =
          '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      final doc = await _firestore
          .collection('trucks')
          .doc(truckId)
          .collection('schedules')
          .doc(dateKey)
          .get();

      if (!doc.exists) return null;

      return DailySchedule.fromJson(doc.data()!);
    } catch (e, stackTrace) {
      AppLogger.error('Error getting today schedule', error: e, stackTrace: stackTrace, tag: 'ScheduleRepository');
      return null;
    }
  }

  /// Get weekly schedule for a truck
  Future<WeeklySchedule> getWeeklySchedule(String truckId) async {
    try {
      final doc =
          await _firestore.collection('trucks').doc(truckId).get();

      if (!doc.exists || doc.data()?['weeklySchedule'] == null) {
        return {};
      }

      final weeklyData = doc.data()!['weeklySchedule'] as Map<String, dynamic>;
      final result = <String, DailySchedule>{};

      weeklyData.forEach((day, data) {
        if (data != null) {
          result[day] =
              DailySchedule.fromFirestore(data as Map<String, dynamic>);
        }
      });

      return result;
    } catch (e, stackTrace) {
      AppLogger.error('Error getting weekly schedule', error: e, stackTrace: stackTrace, tag: 'ScheduleRepository');
      return {};
    }
  }

  /// Update weekly schedule for a truck
  Future<void> updateWeeklySchedule(
      String truckId, WeeklySchedule schedule) async {
    try {
      final scheduleData = <String, dynamic>{};
      schedule.forEach((day, dailySchedule) {
        scheduleData[day] = DailySchedule.toFirestore(dailySchedule);
      });

      await _firestore.collection('trucks').doc(truckId).update({
        'weeklySchedule': scheduleData,
      });
    } catch (e, stackTrace) {
      AppLogger.error('Error updating weekly schedule', error: e, stackTrace: stackTrace, tag: 'ScheduleRepository');
      rethrow;
    }
  }

  /// Update schedule for a specific date
  Future<void> updateSchedule(
      String truckId, String dateKey, DailySchedule schedule) async {
    try {
      await _firestore
          .collection('trucks')
          .doc(truckId)
          .collection('schedules')
          .doc(dateKey)
          .set(DailySchedule.toFirestore(schedule));
    } catch (e, stackTrace) {
      AppLogger.error('Error updating schedule', error: e, stackTrace: stackTrace, tag: 'ScheduleRepository');
      rethrow;
    }
  }

  /// Delete a schedule
  Future<void> deleteSchedule(String truckId, String date) async {
    try {
      await _firestore
          .collection('trucks')
          .doc(truckId)
          .collection('schedules')
          .doc(date)
          .delete();
    } catch (e, stackTrace) {
      AppLogger.error('Error deleting schedule', error: e, stackTrace: stackTrace, tag: 'ScheduleRepository');
      rethrow;
    }
  }
}

@riverpod
ScheduleRepository scheduleRepository(ScheduleRepositoryRef ref) {
  return ScheduleRepository();
}

@riverpod
Future<DailySchedule?> todaySchedule(
    TodayScheduleRef ref, String truckId) async {
  final repository = ref.watch(scheduleRepositoryProvider);
  return repository.getTodaySchedule(truckId);
}
