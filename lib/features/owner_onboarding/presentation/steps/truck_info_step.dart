import 'package:flutter/material.dart';

import '../../../../core/themes/app_theme.dart';
import '../../../../core/constants/food_types.dart';

/// Step 2: 트럭 정보 입력
class TruckInfoStep extends StatefulWidget {
  final String initialName;
  final String initialFoodType;
  final String? initialContact;
  final Function(String name, String foodType, String? contact) onSave;
  final VoidCallback onBack;

  const TruckInfoStep({
    super.key,
    required this.initialName,
    required this.initialFoodType,
    this.initialContact,
    required this.onSave,
    required this.onBack,
  });

  @override
  State<TruckInfoStep> createState() => _TruckInfoStepState();
}

class _TruckInfoStepState extends State<TruckInfoStep> {
  late final TextEditingController _nameController;
  late final TextEditingController _contactController;
  String _selectedFoodType = '';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _contactController = TextEditingController(text: widget.initialContact ?? '');
    _selectedFoodType = widget.initialFoodType;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  bool get _isValid =>
      _nameController.text.isNotEmpty && _selectedFoodType.isNotEmpty;

  void _handleNext() {
    if (_isValid) {
      widget.onSave(
        _nameController.text,
        _selectedFoodType,
        _contactController.text.isNotEmpty ? _contactController.text : null,
      );
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
            '트럭 정보를 입력해주세요',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '고객들에게 보여질 기본 정보입니다',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 32),

          // 트럭명 입력
          const Text(
            '트럭 이름 *',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: '예: 맛있는 타코',
              prefixIcon: const Icon(Icons.store),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            onChanged: (_) => setState(() {}),
          ),

          const SizedBox(height: 24),

          // 음식 종류 선택
          const Text(
            '음식 종류 *',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: FoodTypes.actualFoodTypes.map((type) {
              final isSelected = _selectedFoodType == type;
              return ChoiceChip(
                label: Text(type),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedFoodType = selected ? type : '';
                  });
                },
                selectedColor: AppTheme.mustardYellow.withValues(alpha: 0.2),
                labelStyle: TextStyle(
                  color: isSelected ? AppTheme.mustardYellow : Colors.grey.shade700,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                avatar: isSelected
                    ? const Icon(Icons.check, size: 18, color: AppTheme.mustardYellow)
                    : null,
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // 연락처 (선택)
          const Text(
            '연락처 (선택)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _contactController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: '010-1234-5678',
              prefixIcon: const Icon(Icons.phone),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
          ),

          const SizedBox(height: 48),

          // 버튼들
          Row(
            children: [
              // 이전 버튼
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
              // 다음 버튼
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
        ],
      ),
    );
  }
}
