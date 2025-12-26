import 'package:flutter/material.dart';
import 'package:truck_tracker/core/themes/app_theme.dart';
import 'package:truck_tracker/features/truck_list/domain/truck.dart';

/// 트럭 영업 상태 표시 태그 위젯
///
/// 트럭의 현재 상태(운행 중, 대기/휴식, 점검 중)를 시각적으로 표시합니다.
///
/// Example:
/// ```dart
/// StatusTag(status: truck.status)
/// ```
class StatusTag extends StatelessWidget {
  const StatusTag({
    super.key,
    required this.status,
  });

  final TruckStatus status;

  String get _label {
    switch (status) {
      case TruckStatus.onRoute:
        return '운행 중';
      case TruckStatus.resting:
        return '대기 / 휴식';
      case TruckStatus.maintenance:
        return '점검 중';
    }
  }

  Color get _bgColor {
    switch (status) {
      case TruckStatus.onRoute:
        return AppTheme.mustardYellow15; // Pre-computed 15% opacity
      case TruckStatus.resting:
        return AppTheme.grey15; // Pre-computed grey 15% opacity
      case TruckStatus.maintenance:
        return AppTheme.orange15; // Pre-computed orange 15% opacity
    }
  }

  Color get _textColor {
    switch (status) {
      case TruckStatus.onRoute:
        return AppTheme.mustardYellow;
      case TruckStatus.resting:
        return AppTheme.textTertiary;
      case TruckStatus.maintenance:
        return const Color(0xFFFF9800); // Orange
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        _label,
        style: TextStyle(
          color: _textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
