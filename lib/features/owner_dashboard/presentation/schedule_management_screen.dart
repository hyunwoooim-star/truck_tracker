import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/themes/app_theme.dart';
import '../../auth/presentation/auth_provider.dart';
import '../../schedule/data/schedule_repository.dart';
import '../../schedule/domain/daily_schedule.dart';
import '../presentation/owner_status_provider.dart';

/// Screen for managing weekly schedule
class ScheduleManagementScreen extends ConsumerStatefulWidget {
  const ScheduleManagementScreen({super.key});

  @override
  ConsumerState<ScheduleManagementScreen> createState() =>
      _ScheduleManagementScreenState();
}

class _ScheduleManagementScreenState
    extends ConsumerState<ScheduleManagementScreen> {
  WeeklySchedule? _schedule;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSchedule();
  }

  Future<void> _loadSchedule() async {
    final truckId = await ref.read(currentUserTruckIdProvider.future);
    if (truckId == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final repository = ref.read(scheduleRepositoryProvider);
      final schedule = await repository.getWeeklySchedule(truckId.toString());
      setState(() {
        _schedule = schedule;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveSchedule() async {
    final truckId = await ref.read(currentUserTruckIdProvider.future);
    if (truckId == null || _schedule == null) return;

    try {
      final repository = ref.read(scheduleRepositoryProvider);
      await repository.updateWeeklySchedule(truckId.toString(), _schedule!);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('일정이 저장되었습니다'),
            backgroundColor: AppTheme.electricBlue,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('저장 실패: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_schedule == null) {
      _schedule = _getEmptySchedule();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('주간 영업 일정표'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveSchedule,
            tooltip: '저장',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: koreanDays.map((day) {
          final schedule = _schedule![day] ?? const DailySchedule();
          return _DayScheduleCard(
            day: day,
            schedule: schedule,
            onChanged: (newSchedule) {
              setState(() {
                _schedule = {
                  ..._schedule!,
                  day: newSchedule,
                };
              });
            },
          );
        }).toList(),
      ),
    );
  }

  WeeklySchedule _getEmptySchedule() {
    final schedule = <String, DailySchedule>{};
    for (final day in koreanDays) {
      schedule[day] = const DailySchedule();
    }
    return schedule;
  }
}

class _DayScheduleCard extends StatelessWidget {
  const _DayScheduleCard({
    required this.day,
    required this.schedule,
    required this.onChanged,
  });

  final String day;
  final DailySchedule schedule;
  final ValueChanged<DailySchedule> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.charcoalMedium,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(
                  value: schedule.isOpen,
                  onChanged: (value) {
                    onChanged(schedule.copyWith(isOpen: value ?? false));
                  },
                  activeColor: AppTheme.electricBlue,
                ),
                Text(
                  dayDisplayNames[day] ?? day,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
            if (schedule.isOpen) ...[
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  labelText: '영업 장소',
                  hintText: '예: 강남역 2번 출구',
                ),
                style: const TextStyle(color: AppTheme.textPrimary),
                controller: TextEditingController(text: schedule.location),
                onChanged: (value) {
                  onChanged(schedule.copyWith(location: value));
                },
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: '시작 시간',
                        hintText: '18:00',
                      ),
                      style: const TextStyle(color: AppTheme.textPrimary),
                      controller: TextEditingController(
                        text: schedule.startTime ?? '',
                      ),
                      onChanged: (value) {
                        onChanged(schedule.copyWith(startTime: value.isEmpty ? null : value));
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: '종료 시간',
                        hintText: '23:00',
                      ),
                      style: const TextStyle(color: AppTheme.textPrimary),
                      controller: TextEditingController(
                        text: schedule.endTime ?? '',
                      ),
                      onChanged: (value) {
                        onChanged(schedule.copyWith(endTime: value.isEmpty ? null : value));
                      },
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

