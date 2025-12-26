import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_schedule.freezed.dart';
part 'daily_schedule.g.dart';

/// Daily schedule for a truck
@freezed
class DailySchedule with _$DailySchedule {
  const factory DailySchedule({
    @Default(false) bool isOpen,
    @Default('') String location,
    String? startTime, // "18:00"
    String? endTime,   // "23:00"
    double? latitude,
    double? longitude,
  }) = _DailySchedule;

  factory DailySchedule.fromJson(Map<String, dynamic> json) =>
      _$DailyScheduleFromJson(json);

  /// Create from Firestore map
  factory DailySchedule.fromFirestore(Map<String, dynamic> data) {
    return DailySchedule(
      isOpen: data['isOpen'] ?? false,
      location: data['location'] ?? '',
      startTime: data['startTime'] as String?,
      endTime: data['endTime'] as String?,
      latitude: (data['latitude'] as num?)?.toDouble(),
      longitude: (data['longitude'] as num?)?.toDouble(),
    );
  }

  /// Convert to Firestore map
  static Map<String, dynamic> toFirestore(DailySchedule schedule) {
    final map = <String, dynamic>{
      'isOpen': schedule.isOpen,
      'location': schedule.location,
    };
    
    if (schedule.startTime != null) map['startTime'] = schedule.startTime;
    if (schedule.endTime != null) map['endTime'] = schedule.endTime;
    if (schedule.latitude != null) map['latitude'] = schedule.latitude;
    if (schedule.longitude != null) map['longitude'] = schedule.longitude;
    
    return map;
  }
}

/// Weekly schedule (Map of day names to schedules)
typedef WeeklySchedule = Map<String, DailySchedule>;

/// Day names in Korean
const List<String> koreanDays = [
  'monday',
  'tuesday',
  'wednesday',
  'thursday',
  'friday',
  'saturday',
  'sunday',
];

const Map<String, String> dayDisplayNames = {
  'monday': '월요일',
  'tuesday': '화요일',
  'wednesday': '수요일',
  'thursday': '목요일',
  'friday': '금요일',
  'saturday': '토요일',
  'sunday': '일요일',
};





