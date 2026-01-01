import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/themes/app_theme.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../auth/presentation/auth_provider.dart';
import 'owner_dashboard_screen.dart';

/// 사장님 온보딩 화면 (5단계 통합)
/// 0: 환영 → 1: 기본정보 → 2: 위치 → 3: 메뉴 → 4: 일정 → 완료
class OwnerOnboardingScreen extends ConsumerStatefulWidget {
  const OwnerOnboardingScreen({
    super.key,
    required this.truckId,
  });

  final int truckId;

  @override
  ConsumerState<OwnerOnboardingScreen> createState() =>
      _OwnerOnboardingScreenState();
}

class _OwnerOnboardingScreenState extends ConsumerState<OwnerOnboardingScreen>
    with SingleTickerProviderStateMixin {
  final _pageController = PageController();

  static const int _totalSteps = 5;
  int _currentStep = 0;
  bool _isLoading = false;

  // Step 1: Basic Info
  final _truckNameController = TextEditingController();
  final _driverNameController = TextEditingController();
  final _phoneController = TextEditingController();
  String _selectedFoodType = '';

  final List<Map<String, dynamic>> _foodTypes = [
    {'name': '닭꼬치', 'icon': Icons.kebab_dining},
    {'name': '호떡', 'icon': Icons.breakfast_dining},
    {'name': '어묵', 'icon': Icons.ramen_dining},
    {'name': '타코야키', 'icon': Icons.egg},
    {'name': '붕어빵', 'icon': Icons.cookie},
    {'name': '핫도그', 'icon': Icons.lunch_dining},
    {'name': '떡볶이', 'icon': Icons.rice_bowl},
    {'name': '라멘', 'icon': Icons.soup_kitchen},
    {'name': '커피/음료', 'icon': Icons.coffee},
    {'name': '기타', 'icon': Icons.restaurant},
  ];

  // Step 2: Location
  double? _latitude;
  double? _longitude;
  final _locationDescController = TextEditingController();
  bool _isGettingLocation = false;

  // Step 3: Menu
  final List<_MenuEntry> _menus = [_MenuEntry()];

  // Step 4: Schedule
  static const List<String> _days = ['월', '화', '수', '목', '금', '토', '일'];
  static const List<String> _dayKeys = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
  late Map<String, _ScheduleEntry> _schedules;

  // Complete animation
  late AnimationController _completeAnimController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize schedules (weekdays 17:00-23:00 default)
    _schedules = {};
    for (int i = 0; i < _dayKeys.length; i++) {
      _schedules[_dayKeys[i]] = _ScheduleEntry(
        isOpen: i < 5, // Mon-Fri open by default
        startTime: '17:00',
        endTime: '23:00',
      );
    }

    // Complete animation
    _completeAnimController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _completeAnimController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _truckNameController.dispose();
    _driverNameController.dispose();
    _phoneController.dispose();
    _locationDescController.dispose();
    _completeAnimController.dispose();
    for (final menu in _menus) {
      menu.dispose();
    }
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isGettingLocation = true);

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) SnackBarHelper.showError(context, '위치 권한이 필요합니다');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) SnackBarHelper.showError(context, '설정에서 위치 권한을 허용해주세요');
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );

      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });

      if (mounted) SnackBarHelper.showSuccess(context, '현재 위치를 가져왔습니다');
    } catch (e) {
      if (mounted) SnackBarHelper.showError(context, '위치를 가져올 수 없습니다');
    } finally {
      if (mounted) setState(() => _isGettingLocation = false);
    }
  }

  void _nextStep() {
    // Validation
    if (_currentStep == 1) {
      if (_truckNameController.text.isEmpty || _driverNameController.text.isEmpty) {
        SnackBarHelper.showWarning(context, '트럭명과 사장님 성함을 입력해주세요');
        return;
      }
      if (_selectedFoodType.isEmpty) {
        SnackBarHelper.showWarning(context, '음식 종류를 선택해주세요');
        return;
      }
    } else if (_currentStep == 3) {
      if (!_menus.any((m) => m.isValid)) {
        SnackBarHelper.showWarning(context, '최소 1개 메뉴를 등록해주세요');
        return;
      }
    } else if (_currentStep == 4) {
      if (!_schedules.values.any((s) => s.isOpen)) {
        SnackBarHelper.showWarning(context, '최소 1일 영업일을 설정해주세요');
        return;
      }
      // Last step - complete onboarding
      _completeOnboarding();
      return;
    }

    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _addMenu() {
    setState(() => _menus.add(_MenuEntry()));
  }

  void _removeMenu(int index) {
    if (_menus.length > 1) {
      setState(() {
        _menus[index].dispose();
        _menus.removeAt(index);
      });
    }
  }

  void _toggleDay(String key) {
    setState(() {
      final current = _schedules[key]!;
      _schedules[key] = _ScheduleEntry(
        isOpen: !current.isOpen,
        startTime: current.startTime,
        endTime: current.endTime,
      );
    });
  }

  Future<void> _selectTime(String key, bool isStart) async {
    final current = _schedules[key]!;
    final parts = (isStart ? current.startTime : current.endTime).split(':');
    final initialTime = TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 17,
      minute: int.tryParse(parts[1]) ?? 0,
    );

    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );

    if (picked != null) {
      final timeStr = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      setState(() {
        _schedules[key] = _ScheduleEntry(
          isOpen: current.isOpen,
          startTime: isStart ? timeStr : current.startTime,
          endTime: isStart ? current.endTime : timeStr,
        );
      });
    }
  }

  Future<void> _completeOnboarding() async {
    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authServiceProvider);
      final userId = authService.currentUserId;
      final userEmail = authService.currentUserEmail ?? '';
      final userName = authService.currentUser?.displayName ?? '';

      if (userId == null) throw Exception('로그인 정보를 찾을 수 없습니다');

      // Build menus list
      final menusList = _menus
          .where((m) => m.isValid)
          .map((m) => {
                'name': m.nameController.text.trim(),
                'price': int.tryParse(m.priceController.text) ?? 0,
                'description': m.descController.text.trim(),
              })
          .toList();

      // Build schedule map
      final scheduleMap = <String, dynamic>{};
      for (final entry in _schedules.entries) {
        scheduleMap[entry.key] = {
          'isOpen': entry.value.isOpen,
          'startTime': entry.value.startTime,
          'endTime': entry.value.endTime,
        };
      }

      // Update truck document
      await FirebaseFirestore.instance
          .collection('trucks')
          .doc(widget.truckId.toString())
          .set({
        'id': widget.truckId,
        'ownerId': userId,
        'ownerEmail': userEmail.isNotEmpty ? userEmail : userName,
        'truckNumber': _truckNameController.text.trim(),
        'driverName': _driverNameController.text.trim(),
        'contactPhone': _phoneController.text.trim(),
        'foodType': _selectedFoodType,
        'latitude': _latitude ?? 37.5665,
        'longitude': _longitude ?? 126.9780,
        'locationDescription': _locationDescController.text.trim().isEmpty
            ? '위치 설정 필요'
            : _locationDescController.text.trim(),
        'status': 'maintenance',
        'isOpen': false,
        'imageUrl': null,
        'menus': menusList,
        'announcement': null,
        'favoriteCount': 0,
        'avgRating': 0.0,
        'totalReviews': 0,
        'weeklySchedule': scheduleMap,
        'bankAccount': null,
        'claimedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'onboardingCompleted': true,
      }, SetOptions(merge: true));

      // Update user's onboarding status
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'onboardingCompleted': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Show complete animation
      setState(() {
        _currentStep = _totalSteps; // Go to complete view
        _isLoading = false;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _completeAnimController.forward();
    } catch (e) {
      if (mounted) SnackBarHelper.showError(context, '등록 실패: $e');
      setState(() => _isLoading = false);
    }
  }

  void _goToDashboard() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const OwnerDashboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isComplete = _currentStep >= _totalSteps;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: isComplete
          ? null
          : AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: _currentStep == 0
                  ? null
                  : const Text('트럭 등록', style: TextStyle(color: Colors.white)),
              leading: _currentStep > 0 && _currentStep < _totalSteps
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: _previousStep,
                    )
                  : null,
            ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator (hide on welcome & complete)
            if (_currentStep > 0 && _currentStep < _totalSteps)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: _buildProgressIndicator(),
              ),

            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildWelcomeStep(),
                  _buildBasicInfoStep(),
                  _buildLocationStep(),
                  _buildMenuStep(),
                  _buildScheduleStep(),
                  _buildCompleteStep(),
                ],
              ),
            ),

            // Bottom button (hide on complete)
            if (!isComplete) _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    // 4 progress bars for steps 1-4 (excluding welcome and complete)
    return Row(
      children: List.generate(4, (index) {
        final stepIndex = index + 1; // Steps 1-4
        final isCompleted = _currentStep > stepIndex;
        final isCurrent = _currentStep == stepIndex;

        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: index < 3 ? 8 : 0),
            height: 4,
            decoration: BoxDecoration(
              color: isCompleted || isCurrent
                  ? AppTheme.mustardYellow
                  : const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Step 0: Welcome
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildWelcomeStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.mustardYellow, AppTheme.mustardYellow.withAlpha(200)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.mustardYellow.withAlpha(77),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(Icons.local_shipping, size: 60, color: Colors.white),
          ),

          const SizedBox(height: 32),

          const Text(
            '사장님 환영합니다!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            '트럭 번호: #${widget.truckId}',
            style: TextStyle(fontSize: 16, color: AppTheme.mustardYellow),
          ),

          const SizedBox(height: 24),

          Text(
            '몇 가지 정보만 입력하시면\n바로 영업을 시작할 수 있습니다.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[400], height: 1.5),
          ),

          const SizedBox(height: 48),

          // Steps preview
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildStepPreview(1, '기본 정보', '트럭명, 음식 종류'),
                _buildStepPreview(2, '위치 설정', 'GPS로 현재 위치'),
                _buildStepPreview(3, '메뉴 등록', '판매 메뉴 추가'),
                _buildStepPreview(4, '영업 시간', '요일별 시간 설정', isLast: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepPreview(int step, String title, String subtitle, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppTheme.mustardYellow.withAlpha(50),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$step',
                style: const TextStyle(
                  color: AppTheme.mustardYellow,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                Text(subtitle, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Step 1: Basic Info + Food Type
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildBasicInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '기본 정보',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text('트럭과 사장님 정보를 입력해주세요', style: TextStyle(fontSize: 14, color: Colors.grey[500])),
          const SizedBox(height: 24),

          _buildTextField(
            controller: _truckNameController,
            label: '트럭명 / 상호명 *',
            hint: '예: 맛있는 닭꼬치',
            icon: Icons.local_shipping,
          ),
          const SizedBox(height: 16),

          _buildTextField(
            controller: _driverNameController,
            label: '사장님 성함 *',
            hint: '예: 홍길동',
            icon: Icons.person,
          ),
          const SizedBox(height: 16),

          _buildTextField(
            controller: _phoneController,
            label: '연락처 (선택)',
            hint: '010-1234-5678',
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 32),

          // Food type section
          const Text(
            '음식 종류 *',
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.2,
            ),
            itemCount: _foodTypes.length,
            itemBuilder: (context, index) {
              final food = _foodTypes[index];
              final isSelected = _selectedFoodType == food['name'];

              return GestureDetector(
                onTap: () => setState(() => _selectedFoodType = food['name']),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.mustardYellow.withAlpha(25) : const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppTheme.mustardYellow : const Color(0xFF2A2A2A),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        food['icon'] as IconData,
                        size: 24,
                        color: isSelected ? AppTheme.mustardYellow : Colors.grey[400],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        food['name'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.white : Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Step 2: Location
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildLocationStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '위치 설정',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text('현재 영업 위치를 설정해주세요', style: TextStyle(fontSize: 14, color: Colors.grey[500])),
          const SizedBox(height: 24),

          // GPS button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _isGettingLocation ? null : _getCurrentLocation,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.mustardYellow,
                side: const BorderSide(color: AppTheme.mustardYellow),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: _isGettingLocation
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(AppTheme.mustardYellow),
                      ),
                    )
                  : const Icon(Icons.my_location),
              label: Text(_isGettingLocation ? '위치 가져오는 중...' : '현재 위치 가져오기'),
            ),
          ),
          const SizedBox(height: 16),

          // Location status
          if (_latitude != null && _longitude != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withAlpha(25),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.withAlpha(50)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '위치가 설정되었습니다\n${_latitude!.toStringAsFixed(4)}, ${_longitude!.toStringAsFixed(4)}',
                      style: TextStyle(color: Colors.green[300], fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 24),

          _buildTextField(
            controller: _locationDescController,
            label: '영업 장소 설명',
            hint: '예: 강남역 2번 출구 앞',
            icon: Icons.place,
            maxLines: 2,
          ),
          const SizedBox(height: 24),

          // Info box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withAlpha(25),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withAlpha(50)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[300], size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '위치는 나중에 대시보드에서 언제든 변경할 수 있습니다.\n영업 시작 시 자동으로 업데이트됩니다.',
                    style: TextStyle(color: Colors.blue[300], fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Step 3: Menu
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildMenuStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '메뉴 등록',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text('판매할 메뉴를 등록해주세요 (최소 1개)', style: TextStyle(fontSize: 14, color: Colors.grey[500])),
          const SizedBox(height: 24),

          // Menu list
          ...List.generate(_menus.length, (index) => _buildMenuCard(index)),

          // Add menu button
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _addMenu,
              icon: const Icon(Icons.add),
              label: const Text('메뉴 추가'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.mustardYellow,
                side: BorderSide(color: AppTheme.mustardYellow.withAlpha(128)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(int index) {
    final menu = _menus[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('메뉴 ${index + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              if (_menus.length > 1)
                IconButton(
                  onPressed: () => _removeMenu(index),
                  icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Menu name
          TextField(
            controller: menu.nameController,
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration('메뉴명 *', '예: 숯불닭꼬치'),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),

          // Price
          TextField(
            controller: menu.priceController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration('가격 (원) *', '예: 5000').copyWith(prefixText: '₩ '),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),

          // Description
          TextField(
            controller: menu.descController,
            maxLines: 2,
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration('설명 (선택)', '메뉴에 대한 간단한 설명'),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Step 4: Schedule
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildScheduleStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '영업 시간',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text('요일별 영업 시간을 설정해주세요', style: TextStyle(fontSize: 14, color: Colors.grey[500])),
          const SizedBox(height: 24),

          // Days list
          ...List.generate(_days.length, (index) {
            final key = _dayKeys[index];
            final schedule = _schedules[key]!;
            return _buildDayRow(key, _days[index], schedule);
          }),

          const SizedBox(height: 24),

          // Info box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withAlpha(25),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withAlpha(50)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[300], size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '영업 시간은 대시보드에서 언제든 수정할 수 있습니다.',
                    style: TextStyle(color: Colors.blue[300], fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayRow(String key, String dayName, _ScheduleEntry schedule) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: schedule.isOpen ? AppTheme.mustardYellow.withAlpha(13) : const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: schedule.isOpen ? AppTheme.mustardYellow.withAlpha(77) : const Color(0xFF2A2A2A),
        ),
      ),
      child: Row(
        children: [
          // Day name
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

          // Toggle
          Switch(
            value: schedule.isOpen,
            onChanged: (_) => _toggleDay(key),
            activeColor: AppTheme.mustardYellow,
          ),

          const Spacer(),

          // Time selection
          if (schedule.isOpen) ...[
            GestureDetector(
              onTap: () => _selectTime(key, true),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(schedule.startTime, style: const TextStyle(color: Colors.white, fontSize: 14)),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text('~', style: TextStyle(color: Colors.grey)),
            ),
            GestureDetector(
              onTap: () => _selectTime(key, false),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(schedule.endTime, style: const TextStyle(color: Colors.white, fontSize: 14)),
              ),
            ),
          ] else
            Text('휴무', style: TextStyle(color: Colors.grey[500], fontSize: 14)),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Step 5: Complete
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildCompleteStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated check icon
          ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.mustardYellow, AppTheme.mustardYellow.withAlpha(200)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.mustardYellow.withAlpha(77),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(Icons.check, size: 70, color: Colors.white),
            ),
          ),

          const SizedBox(height: 40),

          const Text(
            '등록 완료!',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppTheme.mustardYellow,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            '${_truckNameController.text.isNotEmpty ? _truckNameController.text : '트럭'}의\n모든 준비가 완료되었습니다!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.grey[400], height: 1.5),
          ),

          const SizedBox(height: 40),

          // Next step info
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green.withAlpha(25),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.green.withAlpha(50)),
            ),
            child: Column(
              children: [
                Icon(Icons.lightbulb_outline, color: Colors.green[400], size: 32),
                const SizedBox(height: 12),
                Text(
                  '다음 단계',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green[400]),
                ),
                const SizedBox(height: 8),
                Text(
                  '대시보드에서 영업을 시작하고\n고객들에게 트럭 위치를 알려주세요!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.green[400], height: 1.5),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Go to dashboard button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _goToDashboard,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.mustardYellow,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                '대시보드로 이동',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Common Widgets
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[600]),
            prefixIcon: Icon(icon, color: Colors.grey[500]),
            filled: true,
            fillColor: const Color(0xFF1A1A1A),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.mustardYellow, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[500]),
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[700]),
      filled: true,
      fillColor: const Color(0xFF2A2A2A),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppTheme.mustardYellow),
      ),
    );
  }

  Widget _buildBottomButton() {
    String buttonText;
    if (_currentStep == 0) {
      buttonText = '시작하기';
    } else if (_currentStep == 4) {
      buttonText = '등록 완료';
    } else {
      buttonText = '다음';
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border(top: BorderSide(color: Colors.grey[800]!)),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _isLoading ? null : _nextStep,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.mustardYellow,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.black)),
                )
              : Text(buttonText, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Helper Classes
// ═══════════════════════════════════════════════════════════════════════════════
class _MenuEntry {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descController = TextEditingController();

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

class _ScheduleEntry {
  final bool isOpen;
  final String startTime;
  final String endTime;

  _ScheduleEntry({
    required this.isOpen,
    required this.startTime,
    required this.endTime,
  });
}
