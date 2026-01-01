import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/themes/app_theme.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../auth/presentation/auth_provider.dart';
import 'owner_dashboard_screen.dart';

/// 사장님 온보딩 화면
/// 새로 승인된 사장님이 트럭 정보를 입력하는 화면
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

class _OwnerOnboardingScreenState extends ConsumerState<OwnerOnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();

  int _currentStep = 0;
  bool _isLoading = false;

  // Step 1: Basic Info
  final _truckNameController = TextEditingController();
  final _driverNameController = TextEditingController();
  final _phoneController = TextEditingController();

  // Step 2: Food Type
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

  // Step 3: Location
  double? _latitude;
  double? _longitude;
  final _locationDescController = TextEditingController();
  bool _isGettingLocation = false;

  @override
  void dispose() {
    _pageController.dispose();
    _truckNameController.dispose();
    _driverNameController.dispose();
    _phoneController.dispose();
    _locationDescController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isGettingLocation = true);

    try {
      // Check permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            SnackBarHelper.showError(context, '위치 권한이 필요합니다');
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          SnackBarHelper.showError(context, '설정에서 위치 권한을 허용해주세요');
        }
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });

      if (mounted) {
        SnackBarHelper.showSuccess(context, '현재 위치를 가져왔습니다');
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, '위치를 가져올 수 없습니다');
      }
    } finally {
      if (mounted) {
        setState(() => _isGettingLocation = false);
      }
    }
  }

  void _nextStep() {
    if (_currentStep == 0) {
      if (_truckNameController.text.isEmpty ||
          _driverNameController.text.isEmpty) {
        SnackBarHelper.showWarning(context, '트럭명과 사장님 성함을 입력해주세요');
        return;
      }
    } else if (_currentStep == 1) {
      if (_selectedFoodType.isEmpty) {
        SnackBarHelper.showWarning(context, '음식 종류를 선택해주세요');
        return;
      }
    }

    if (_currentStep < 2) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
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

  Future<void> _completeOnboarding() async {
    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authServiceProvider);
      final userId = authService.currentUserId;
      final userEmail = authService.currentUserEmail ?? '';
      final userName = authService.currentUser?.displayName ?? '';

      if (userId == null) {
        throw Exception('로그인 정보를 찾을 수 없습니다');
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
        'menus': [],
        'announcement': null,
        'favoriteCount': 0,
        'avgRating': 0.0,
        'totalReviews': 0,
        'weeklySchedule': {},
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

      if (mounted) {
        SnackBarHelper.showSuccess(context, '트럭 등록이 완료되었습니다!');

        // Navigate to owner dashboard
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const OwnerDashboardScreen(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, '등록 실패: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          '트럭 등록',
          style: TextStyle(color: Colors.white),
        ),
        leading: _currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: _previousStep,
              )
            : null,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            _buildProgressIndicator(),
            const SizedBox(height: 24),

            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildBasicInfoStep(),
                  _buildFoodTypeStep(),
                  _buildLocationStep(),
                ],
              ),
            ),

            // Bottom button
            _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: List.generate(3, (index) {
          final isCompleted = index < _currentStep;
          final isCurrent = index == _currentStep;

          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
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
      ),
    );
  }

  Widget _buildBasicInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '기본 정보',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '트럭 번호: #${widget.truckId}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 32),

            // Truck name
            _buildTextField(
              controller: _truckNameController,
              label: '트럭명 / 상호명',
              hint: '예: 맛있는 닭꼬치',
              icon: Icons.local_shipping,
            ),
            const SizedBox(height: 20),

            // Driver name
            _buildTextField(
              controller: _driverNameController,
              label: '사장님 성함',
              hint: '예: 홍길동',
              icon: Icons.person,
            ),
            const SizedBox(height: 20),

            // Phone
            _buildTextField(
              controller: _phoneController,
              label: '연락처 (선택)',
              hint: '010-1234-5678',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodTypeStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '음식 종류',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '판매하는 주요 음식을 선택해주세요',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 32),

          // Food type grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
            ),
            itemCount: _foodTypes.length,
            itemBuilder: (context, index) {
              final food = _foodTypes[index];
              final isSelected = _selectedFoodType == food['name'];

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedFoodType = food['name'];
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.mustardYellow.withAlpha(25)
                        : const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.mustardYellow
                          : const Color(0xFF2A2A2A),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        food['icon'] as IconData,
                        size: 32,
                        color: isSelected
                            ? AppTheme.mustardYellow
                            : Colors.grey[400],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        food['name'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
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

  Widget _buildLocationStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '위치 설정',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '현재 영업 위치를 설정해주세요 (나중에 변경 가능)',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 32),

          // Get current location button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _isGettingLocation ? null : _getCurrentLocation,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.mustardYellow,
                side: const BorderSide(color: AppTheme.mustardYellow),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: _isGettingLocation
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation(AppTheme.mustardYellow),
                      ),
                    )
                  : const Icon(Icons.my_location),
              label: Text(
                _isGettingLocation ? '위치 가져오는 중...' : '현재 위치 가져오기',
              ),
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
                      style: TextStyle(
                        color: Colors.green[300],
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 24),

          // Location description
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
                    '위치는 영업 시작 시 자동으로 업데이트되며,\n대시보드에서 수동으로 변경할 수 있습니다.',
                    style: TextStyle(
                      color: Colors.blue[300],
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
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
              borderSide:
                  const BorderSide(color: AppTheme.mustardYellow, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton() {
    final buttonText = _currentStep < 2 ? '다음' : '등록 완료';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border(
          top: BorderSide(color: Colors.grey[800]!),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _isLoading ? null : _nextStep,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.mustardYellow,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.black),
                  ),
                )
              : Text(
                  buttonText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
