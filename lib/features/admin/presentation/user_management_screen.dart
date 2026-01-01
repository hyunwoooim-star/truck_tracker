import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/themes/app_theme.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../auth/presentation/auth_provider.dart';

/// User role enum for filtering
/// Firestore에 저장된 role 값: 'customer', 'owner', 'admin'
enum UserRole {
  all('전체'),
  customer('일반 사용자'),  // Firestore: 'customer'
  owner('사장님'),          // Firestore: 'owner'
  admin('관리자');          // Firestore: 'admin'

  const UserRole(this.label);
  final String label;
}

/// User Management Screen for Admins
class UserManagementScreen extends ConsumerStatefulWidget {
  const UserManagementScreen({super.key});

  @override
  ConsumerState<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends ConsumerState<UserManagementScreen> {
  final _searchController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;

  UserRole _selectedRole = UserRole.all;
  String _searchQuery = '';
  bool? _isAdmin;
  bool _isCheckingAdmin = true;

  @override
  void initState() {
    super.initState();
    _checkAdminAccess();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _checkAdminAccess() async {
    final authService = ref.read(authServiceProvider);
    final isAdmin = await authService.isCurrentUserAdmin();
    if (mounted) {
      setState(() {
        _isAdmin = isAdmin;
        _isCheckingAdmin = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingAdmin) {
      return Scaffold(
        backgroundColor: AppTheme.charcoalDark,
        appBar: AppBar(
          title: const Text('사용자 관리'),
          backgroundColor: AppTheme.charcoalMedium,
        ),
        body: const Center(
          child: CircularProgressIndicator(color: AppTheme.mustardYellow),
        ),
      );
    }

    if (_isAdmin != true) {
      return Scaffold(
        backgroundColor: AppTheme.charcoalDark,
        appBar: AppBar(
          title: const Text('사용자 관리'),
          backgroundColor: AppTheme.charcoalMedium,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 80, color: Colors.red),
              const SizedBox(height: 24),
              const Text(
                '접근 권한이 없습니다',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('돌아가기'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.charcoalDark,
      appBar: AppBar(
        title: const Text('사용자 관리'),
        backgroundColor: AppTheme.charcoalMedium,
        foregroundColor: AppTheme.mustardYellow,
      ),
      body: Column(
        children: [
          // Search and filter section
          Container(
            padding: const EdgeInsets.all(16),
            color: AppTheme.charcoalMedium,
            child: Column(
              children: [
                // Search bar
                TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: '이메일 또는 이름으로 검색',
                    hintStyle: const TextStyle(color: AppTheme.textTertiary),
                    prefixIcon: const Icon(Icons.search, color: AppTheme.textTertiary),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: AppTheme.textTertiary),
                            onPressed: () {
                              _searchController.clear();
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: AppTheme.charcoalDark,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Role filter chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: UserRole.values.map((role) {
                      final isSelected = _selectedRole == role;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(role.label),
                          selected: isSelected,
                          onSelected: (_) {
                            setState(() {
                              _selectedRole = role;
                            });
                          },
                          backgroundColor: AppTheme.charcoalDark,
                          selectedColor: AppTheme.mustardYellow,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.black : AppTheme.textSecondary,
                          ),
                          checkmarkColor: Colors.black,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // User list
          Expanded(
            child: _buildUserList(),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList() {
    Query<Map<String, dynamic>> query = _firestore.collection('users').orderBy('createdAt', descending: true);

    // Apply role filter
    if (_selectedRole != UserRole.all) {
      query = query.where('role', isEqualTo: _selectedRole.name);
    }

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: query.limit(100).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.mustardYellow),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              '오류: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        var users = snapshot.data?.docs ?? [];

        // Apply search filter client-side
        if (_searchQuery.isNotEmpty) {
          users = users.where((doc) {
            final data = doc.data();
            final email = (data['email'] as String? ?? '').toLowerCase();
            final name = (data['displayName'] as String? ?? '').toLowerCase();
            return email.contains(_searchQuery) || name.contains(_searchQuery);
          }).toList();
        }

        if (users.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.person_off,
                  size: 64,
                  color: AppTheme.textTertiary,
                ),
                const SizedBox(height: 16),
                Text(
                  _searchQuery.isNotEmpty ? '검색 결과가 없습니다' : '사용자가 없습니다',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: users.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final doc = users[index];
            final data = doc.data();
            return _buildUserCard(doc.id, data);
          },
        );
      },
    );
  }

  Widget _buildUserCard(String userId, Map<String, dynamic> data) {
    final email = data['email'] as String? ?? '';
    final displayName = data['displayName'] as String? ?? '이름 없음';
    final role = data['role'] as String? ?? 'user';
    final ownedTruckId = data['ownedTruckId'];
    final createdAt = data['createdAt'];

    Color roleColor;
    String roleLabel;
    IconData roleIcon;

    switch (role) {
      case 'admin':
        roleColor = Colors.purple;
        roleLabel = '관리자';
        roleIcon = Icons.admin_panel_settings;
        break;
      case 'owner':
        roleColor = Colors.green;
        roleLabel = '사장님';
        roleIcon = Icons.store;
        break;
      default:
        roleColor = AppTheme.tossBlue;
        roleLabel = '일반';
        roleIcon = Icons.person;
    }

    String dateStr = '';
    if (createdAt != null) {
      try {
        final date = (createdAt as Timestamp).toDate();
        dateStr = '가입: ${date.year}.${date.month}.${date.day}';
      } catch (_) {}
    }

    return Material(
      color: AppTheme.charcoalMedium,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => _showUserDetailDialog(userId, data),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.charcoalLight),
          ),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: roleColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(roleIcon, color: roleColor),
              ),
              const SizedBox(width: 12),
              // User info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            displayName,
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: roleColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            roleLabel,
                            style: TextStyle(
                              color: roleColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: const TextStyle(
                        color: AppTheme.textTertiary,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (ownedTruckId != null || dateStr.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (ownedTruckId != null) ...[
                            Icon(
                              Icons.local_shipping,
                              size: 12,
                              color: AppTheme.textTertiary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '트럭 #$ownedTruckId',
                              style: const TextStyle(
                                color: AppTheme.textTertiary,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                          if (dateStr.isNotEmpty)
                            Text(
                              dateStr,
                              style: const TextStyle(
                                color: AppTheme.textTertiary,
                                fontSize: 11,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppTheme.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUserDetailDialog(String userId, Map<String, dynamic> data) {
    final email = data['email'] as String? ?? '';
    final displayName = data['displayName'] as String? ?? '이름 없음';
    final role = data['role'] as String? ?? 'user';
    final ownedTruckId = data['ownedTruckId'];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.charcoalMedium,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  role == 'admin'
                      ? Icons.admin_panel_settings
                      : role == 'owner'
                          ? Icons.store
                          : Icons.person,
                  color: AppTheme.mustardYellow,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        email,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Info items
            _buildInfoRow('현재 역할', _getRoleLabel(role)),
            if (ownedTruckId != null) _buildInfoRow('소유 트럭', '#$ownedTruckId'),
            _buildInfoRow('User ID', '${userId.substring(0, 8)}...'),

            const SizedBox(height: 24),

            // Actions
            const Text(
              '역할 변경',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (role != 'customer')
                  _buildRoleButton('일반으로 변경', 'customer', Colors.blue, userId, role),
                if (role != 'owner')
                  _buildRoleButton('사장님으로 변경', 'owner', Colors.green, userId, role),
                if (role != 'admin')
                  _buildRoleButton('관리자로 변경', 'admin', Colors.purple, userId, role),
              ],
            ),

            const SizedBox(height: 24),
            const Divider(color: AppTheme.charcoalLight),
            const SizedBox(height: 16),

            // Account Management Section
            const Text(
              '계정 관리',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _sendPasswordResetEmail(email),
                    icon: const Icon(Icons.lock_reset, size: 18),
                    label: const Text('비밀번호 재설정'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.tossBlue,
                      side: const BorderSide(color: AppTheme.tossBlue),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _deleteUser(userId, displayName, email),
                    icon: const Icon(Icons.delete_forever, size: 18),
                    label: const Text('계정 삭제'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  /// 비밀번호 재설정 이메일 발송
  Future<void> _sendPasswordResetEmail(String email) async {
    Navigator.pop(context); // Close bottom sheet

    if (email.isEmpty) {
      SnackBarHelper.showError(context, '이메일이 없어서 비밀번호 재설정을 할 수 없습니다');
      return;
    }

    // Confirm dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.charcoalMedium,
        title: const Text('비밀번호 재설정', style: TextStyle(color: Colors.white)),
        content: Text(
          '$email 으로 비밀번호 재설정 이메일을 발송하시겠습니까?',
          style: const TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소', style: TextStyle(color: AppTheme.textTertiary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.tossBlue),
            child: const Text('발송', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (mounted) {
        SnackBarHelper.showSuccess(context, '비밀번호 재설정 이메일을 발송했습니다');
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        String message = '비밀번호 재설정 실패';
        if (e.code == 'user-not-found') {
          message = '해당 이메일의 사용자를 찾을 수 없습니다';
        } else if (e.code == 'invalid-email') {
          message = '유효하지 않은 이메일 형식입니다';
        }
        SnackBarHelper.showError(context, message);
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, '비밀번호 재설정 실패: $e');
      }
    }
  }

  /// 사용자 계정 삭제 (Firestore 문서만 삭제, Firebase Auth는 Cloud Function 필요)
  Future<void> _deleteUser(String userId, String displayName, String email) async {
    Navigator.pop(context); // Close bottom sheet

    // Confirm dialog with strong warning
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.charcoalMedium,
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
            const SizedBox(width: 8),
            const Text('계정 삭제', style: TextStyle(color: Colors.red)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '정말로 "$displayName" 계정을 삭제하시겠습니까?',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Text(
              '이메일: $email',
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
              ),
              child: const Text(
                '⚠️ 이 작업은 취소할 수 없습니다!\n'
                '• Firestore 사용자 데이터가 삭제됩니다\n'
                '• 관련 리뷰, 즐겨찾기 등도 삭제될 수 있습니다',
                style: TextStyle(color: Colors.red, fontSize: 13),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소', style: TextStyle(color: AppTheme.textTertiary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('삭제', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      // Delete user's related data
      final batch = _firestore.batch();

      // 1. Delete favorites
      final favoritesSnapshot = await _firestore
          .collection('favorites')
          .where('userId', isEqualTo: userId)
          .get();
      for (final doc in favoritesSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // 2. Delete reviews
      final reviewsSnapshot = await _firestore
          .collection('reviews')
          .where('userId', isEqualTo: userId)
          .get();
      for (final doc in reviewsSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // 3. Delete the user document
      batch.delete(_firestore.collection('users').doc(userId));

      await batch.commit();

      if (mounted) {
        SnackBarHelper.showSuccess(context, '사용자 데이터가 삭제되었습니다');
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, '삭제 실패: $e');
      }
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppTheme.textTertiary),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleButton(String label, String newRole, Color color, String userId, String currentRole) {
    return ElevatedButton(
      onPressed: () => _changeUserRole(userId, newRole, currentRole),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      child: Text(label, style: const TextStyle(fontSize: 13)),
    );
  }

  String _getRoleLabel(String role) {
    switch (role) {
      case 'admin':
        return '관리자';
      case 'owner':
        return '사장님';
      default:
        return '일반 사용자';
    }
  }

  Future<void> _changeUserRole(String userId, String newRole, String currentRole) async {
    Navigator.pop(context); // Close bottom sheet

    // Confirm dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.charcoalMedium,
        title: const Text('역할 변경 확인', style: TextStyle(color: Colors.white)),
        content: Text(
          '${_getRoleLabel(currentRole)} → ${_getRoleLabel(newRole)}(으)로 변경하시겠습니까?',
          style: const TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소', style: TextStyle(color: AppTheme.textTertiary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.mustardYellow),
            child: const Text('변경', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _firestore.collection('users').doc(userId).update({
        'role': newRole,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        SnackBarHelper.showSuccess(context, '역할이 변경되었습니다');
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, '역할 변경 실패: $e');
      }
    }
  }
}
