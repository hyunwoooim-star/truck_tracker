import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

/// User model for the application
@freezed
sealed class AppUser with _$AppUser {
  const factory AppUser({
    required String uid,
    required String email,
    required String displayName,
    String? photoURL,
    String? nickname, // 사용자 지정 닉네임 (2-10자, 한글/영문/숫자)
    @Default(false) bool isProfileComplete, // 닉네임 설정 완료 여부
    @Default('email') String loginMethod,
    @Default('customer') String role, // 'customer' or 'owner'
    int? ownedTruckId, // 1-100, null if not an owner
    String? fcmToken, // FCM token for push notifications
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  /// Create from Firestore document
  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return AppUser(
      uid: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? 'User',
      photoURL: data['photoURL'],
      nickname: data['nickname'],
      isProfileComplete: data['isProfileComplete'] ?? false,
      loginMethod: data['loginMethod'] ?? 'email',
      role: data['role'] ?? 'customer',
      ownedTruckId: data['ownedTruckId'],
      fcmToken: data['fcmToken'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Convert to Firestore document
  static Map<String, dynamic> toFirestore(AppUser user) {
    return {
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'photoURL': user.photoURL,
      'nickname': user.nickname,
      'isProfileComplete': user.isProfileComplete,
      'loginMethod': user.loginMethod,
      'role': user.role,
      'ownedTruckId': user.ownedTruckId,
      'fcmToken': user.fcmToken,
      'createdAt': user.createdAt != null
          ? Timestamp.fromDate(user.createdAt!)
          : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}





