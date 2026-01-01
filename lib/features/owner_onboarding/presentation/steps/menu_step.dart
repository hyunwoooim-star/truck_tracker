import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/themes/app_theme.dart';
import '../../domain/onboarding_state.dart';

/// Step 3: 메뉴 등록
class MenuStep extends StatefulWidget {
  final List<MenuItemData> initialMenus;
  final Function(List<MenuItemData> menus) onSave;
  final VoidCallback onBack;

  const MenuStep({
    super.key,
    required this.initialMenus,
    required this.onSave,
    required this.onBack,
  });

  @override
  State<MenuStep> createState() => _MenuStepState();
}

class _MenuStepState extends State<MenuStep> {
  late List<_MenuEntry> _menus;

  @override
  void initState() {
    super.initState();
    if (widget.initialMenus.isNotEmpty) {
      _menus = widget.initialMenus
          .map((m) => _MenuEntry(
                nameController: TextEditingController(text: m.name),
                priceController: TextEditingController(text: m.price.toString()),
                descController: TextEditingController(text: m.description),
              ))
          .toList();
    } else {
      _menus = [_MenuEntry()];
    }
  }

  @override
  void dispose() {
    for (final menu in _menus) {
      menu.dispose();
    }
    super.dispose();
  }

  bool get _isValid => _menus.any((m) => m.isValid);

  void _addMenu() {
    setState(() {
      _menus.add(_MenuEntry());
    });
  }

  void _removeMenu(int index) {
    if (_menus.length > 1) {
      setState(() {
        _menus[index].dispose();
        _menus.removeAt(index);
      });
    }
  }

  void _handleNext() {
    if (_isValid) {
      final menuList = _menus
          .where((m) => m.isValid)
          .map((m) => MenuItemData(
                name: m.nameController.text,
                price: int.tryParse(m.priceController.text) ?? 0,
                description: m.descController.text,
              ))
          .toList();
      widget.onSave(menuList);
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
            '메뉴를 등록해주세요',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '최소 1개 이상의 메뉴가 필요합니다',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 24),

          // 메뉴 목록
          ...List.generate(_menus.length, (index) {
            return _buildMenuCard(index);
          }),

          // 메뉴 추가 버튼
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _addMenu,
              icon: const Icon(Icons.add),
              label: const Text('메뉴 추가'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(
                  color: AppTheme.mustardYellow.withValues(alpha: 0.5),
                  style: BorderStyle.solid,
                ),
              ),
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

  Widget _buildMenuCard(int index) {
    final menu = _menus[index];
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '메뉴 ${index + 1}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_menus.length > 1)
                  IconButton(
                    onPressed: () => _removeMenu(index),
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    tooltip: '삭제',
                  ),
              ],
            ),

            const SizedBox(height: 12),

            // 메뉴명
            TextField(
              controller: menu.nameController,
              decoration: InputDecoration(
                labelText: '메뉴명 *',
                hintText: '예: 숯불닭꼬치',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 12),

            // 가격
            TextField(
              controller: menu.priceController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: '가격 (원) *',
                hintText: '예: 5000',
                prefixText: '₩ ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 12),

            // 설명 (선택)
            TextField(
              controller: menu.descController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: '설명 (선택)',
                hintText: '메뉴에 대한 간단한 설명',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuEntry {
  final TextEditingController nameController;
  final TextEditingController priceController;
  final TextEditingController descController;

  _MenuEntry({
    TextEditingController? nameController,
    TextEditingController? priceController,
    TextEditingController? descController,
  })  : nameController = nameController ?? TextEditingController(),
        priceController = priceController ?? TextEditingController(),
        descController = descController ?? TextEditingController();

  bool get isValid =>
      nameController.text.isNotEmpty &&
      priceController.text.isNotEmpty &&
      (int.tryParse(priceController.text) ?? 0) > 0;

  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descController.dispose();
  }
}
