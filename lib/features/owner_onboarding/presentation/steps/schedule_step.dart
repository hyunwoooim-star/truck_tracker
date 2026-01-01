import 'package:flutter/material.dart';

import '../../../../core/themes/app_theme.dart';
import '../../domain/onboarding_state.dart';

/// Step 4: 일정 설정
class ScheduleStep extends StatefulWidget {
  final Map<String, ScheduleData> initialSchedules;
  final Function(Map<String, ScheduleData> schedules) onSave;
  final VoidCallback onBack;

  const ScheduleStep({
    super.key,
    required this.initialSchedules,
    required this.onSave,
    required this.onBack,
  });

  @override
  State<ScheduleStep> createState() => _ScheduleStepState();
}

class _ScheduleStepState extends State<ScheduleStep> {
  static const List<String> _days = ['월', '화', '수', '목', '금', '토', '일'];
  static const List<String> _dayKeys = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];

  late Map<String, ScheduleData> _schedules;

  @override
  void initState() {
    super.initState();
    // 초기값 설정 (평일 17:00-23:00 기본)
    _schedules = {};
    for (int i = 0; i < _dayKeys.length; i++) {
      final key = _dayKeys[i];
      if (widget.initialSchedules.containsKey(key)) {
        _schedules[key] = widget.initialSchedules[key]!;
      } else {
        _schedules[key] = ScheduleData(
          dayOfWeek: key,
          isOpen: i < 5, // 평일만 기본 영업
          startTime: '17:00',
          endTime: '23:00',
        );
      }
    }
  }

  bool get _isValid => _schedules.values.any((s) => s.isOpen);

  void _toggleDay(String key) {
    setState(() {
      final current = _schedules[key]!;
      _schedules[key] = ScheduleData(
        dayOfWeek: key,
        isOpen: !current.isOpen,
        startTime: current.startTime,
        endTime: current.endTime,
      );
    });
  }

  Future<void> _selectTime(String key, bool isStart) async {
    final current = _schedules[key]!;
    final initialTime = _parseTime(isStart ? current.startTime : current.endTime);

    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        final timeStr = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
        _schedules[key] = ScheduleData(
          dayOfWeek: key,
          isOpen: current.isOpen,
          startTime: isStart ? timeStr : current.startTime,
          endTime: isStart ? current.endTime : timeStr,
        );
      });
    }
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 17,
      minute: int.tryParse(parts[1]) ?? 0,
    );
  }

  void _handleNext() {
    if (_isValid) {
      widget.onSave(_schedules);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목
          const Text(
            '영업 시간을 설정해주세요',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '최소 1일 이상 영업일을 설정해주세요',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 24),

          // 요일별 설정
          ...List.generate(_days.length, (index) {
            final key = _dayKeys[index];
            final schedule = _schedules[key]!;
            return _buildDayRow(key, _days[index], schedule);
          }),

          const SizedBox(height: 24),

          // 안내 메시지
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '영업 시간은 나중에 대시보드에서 언제든 수정할 수 있습니다.',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // 버튼들
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onBack,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('이전'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _isValid ? _handleNext : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.mustardYellow,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '다음',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildDayRow(String key, String dayName, ScheduleData schedule) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: schedule.isOpen ? AppTheme.mustardYellow.withValues(alpha: 0.05) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: schedule.isOpen ? AppTheme.mustardYellow.withValues(alpha: 0.3) : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            // 요일
            SizedBox(
              width: 36,
              child: Text(
                dayName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: schedule.isOpen ? AppTheme.mustardYellow : Colors.grey,
                ),
              ),
            ),

            // 토글
            Switch(
              value: schedule.isOpen,
              onChanged: (_) => _toggleDay(key),
              activeColor: AppTheme.mustardYellow,
            ),

            const Spacer(),

            // 시간 선택 (영업일만)
            if (schedule.isOpen) ...[
              // 시작 시간
              GestureDetector(
                onTap: () => _selectTime(key, true),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    schedule.startTime,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text('~'),
              ),
              // 종료 시간
              GestureDetector(
                onTap: () => _selectTime(key, false),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    schedule.endTime,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ] else
              Text(
                '휴무',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 14,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
