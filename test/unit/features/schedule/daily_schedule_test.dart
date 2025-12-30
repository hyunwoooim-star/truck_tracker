import 'package:flutter_test/flutter_test.dart';
import 'package:truck_tracker/features/schedule/domain/daily_schedule.dart';

void main() {
  group('DailySchedule Model', () {
    late DailySchedule schedule;

    setUp(() {
      schedule = DailySchedule(
        isOpen: true,
        location: '강남역 2번 출구',
        startTime: '18:00',
        endTime: '23:00',
        latitude: 37.4979,
        longitude: 127.0276,
      );
    });

    test('should create DailySchedule with all fields', () {
      expect(schedule.isOpen, isTrue);
      expect(schedule.location, '강남역 2번 출구');
      expect(schedule.startTime, '18:00');
      expect(schedule.endTime, '23:00');
      expect(schedule.latitude, 37.4979);
      expect(schedule.longitude, 127.0276);
    });

    test('should have default values', () {
      const defaultSchedule = DailySchedule();

      expect(defaultSchedule.isOpen, isFalse);
      expect(defaultSchedule.location, '');
      expect(defaultSchedule.startTime, isNull);
      expect(defaultSchedule.endTime, isNull);
      expect(defaultSchedule.latitude, isNull);
      expect(defaultSchedule.longitude, isNull);
    });

    test('should create closed schedule', () {
      const closedSchedule = DailySchedule(
        isOpen: false,
        location: '',
      );

      expect(closedSchedule.isOpen, isFalse);
      expect(closedSchedule.location, isEmpty);
    });

    test('should create schedule with location only', () {
      const locationOnly = DailySchedule(
        isOpen: true,
        location: '홍대입구역 앞',
      );

      expect(locationOnly.isOpen, isTrue);
      expect(locationOnly.location, '홍대입구역 앞');
      expect(locationOnly.startTime, isNull);
      expect(locationOnly.latitude, isNull);
    });

    group('fromFirestore', () {
      test('should parse complete Firestore data', () {
        final data = {
          'isOpen': true,
          'location': '서울역 앞',
          'startTime': '17:00',
          'endTime': '22:00',
          'latitude': 37.5563,
          'longitude': 126.9723,
        };

        final parsed = DailySchedule.fromFirestore(data);

        expect(parsed.isOpen, isTrue);
        expect(parsed.location, '서울역 앞');
        expect(parsed.startTime, '17:00');
        expect(parsed.endTime, '22:00');
        expect(parsed.latitude, 37.5563);
        expect(parsed.longitude, 126.9723);
      });

      test('should handle missing optional fields', () {
        final data = {
          'isOpen': true,
          'location': '판교역',
        };

        final parsed = DailySchedule.fromFirestore(data);

        expect(parsed.isOpen, isTrue);
        expect(parsed.location, '판교역');
        expect(parsed.startTime, isNull);
        expect(parsed.endTime, isNull);
        expect(parsed.latitude, isNull);
        expect(parsed.longitude, isNull);
      });

      test('should handle empty data with defaults', () {
        final parsed = DailySchedule.fromFirestore({});

        expect(parsed.isOpen, isFalse);
        expect(parsed.location, '');
        expect(parsed.startTime, isNull);
      });

      test('should handle integer latitude/longitude', () {
        final data = {
          'latitude': 37,
          'longitude': 127,
        };

        final parsed = DailySchedule.fromFirestore(data);

        expect(parsed.latitude, 37.0);
        expect(parsed.longitude, 127.0);
      });
    });

    group('toFirestore', () {
      test('should convert complete schedule to Map', () {
        final map = DailySchedule.toFirestore(schedule);

        expect(map['isOpen'], isTrue);
        expect(map['location'], '강남역 2번 출구');
        expect(map['startTime'], '18:00');
        expect(map['endTime'], '23:00');
        expect(map['latitude'], 37.4979);
        expect(map['longitude'], 127.0276);
      });

      test('should not include null optional fields', () {
        const minimalSchedule = DailySchedule(
          isOpen: false,
          location: '정자역',
        );

        final map = DailySchedule.toFirestore(minimalSchedule);

        expect(map.containsKey('startTime'), isFalse);
        expect(map.containsKey('endTime'), isFalse);
        expect(map.containsKey('latitude'), isFalse);
        expect(map.containsKey('longitude'), isFalse);
        expect(map['isOpen'], isFalse);
        expect(map['location'], '정자역');
      });
    });

    test('copyWith should create new schedule with updated fields', () {
      final updated = schedule.copyWith(
        isOpen: false,
        location: '새로운 위치',
      );

      expect(updated.isOpen, isFalse);
      expect(updated.location, '새로운 위치');
      expect(updated.startTime, schedule.startTime); // unchanged
      expect(updated.latitude, schedule.latitude); // unchanged
    });
  });

  group('koreanDays constant', () {
    test('should have 7 days', () {
      expect(koreanDays.length, 7);
    });

    test('should start with monday', () {
      expect(koreanDays.first, 'monday');
    });

    test('should end with sunday', () {
      expect(koreanDays.last, 'sunday');
    });

    test('should contain all weekdays', () {
      expect(koreanDays, contains('monday'));
      expect(koreanDays, contains('tuesday'));
      expect(koreanDays, contains('wednesday'));
      expect(koreanDays, contains('thursday'));
      expect(koreanDays, contains('friday'));
      expect(koreanDays, contains('saturday'));
      expect(koreanDays, contains('sunday'));
    });
  });

  group('dayDisplayNames constant', () {
    test('should have 7 entries', () {
      expect(dayDisplayNames.length, 7);
    });

    test('should have correct Korean translations', () {
      expect(dayDisplayNames['monday'], '월요일');
      expect(dayDisplayNames['tuesday'], '화요일');
      expect(dayDisplayNames['wednesday'], '수요일');
      expect(dayDisplayNames['thursday'], '목요일');
      expect(dayDisplayNames['friday'], '금요일');
      expect(dayDisplayNames['saturday'], '토요일');
      expect(dayDisplayNames['sunday'], '일요일');
    });
  });
}
