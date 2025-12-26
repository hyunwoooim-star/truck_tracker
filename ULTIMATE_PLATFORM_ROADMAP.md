# 🏆 ULTIMATE FOOD TRUCK PLATFORM ROADMAP

## 📊 **프로젝트 복잡도 분석**

### **총 예상 시간**: 4-6 시간

| 기능 | 복잡도 | 예상 시간 | 우선순위 |
|------|--------|-----------|----------|
| **멀티 로그인 연동** | ⭐⭐⭐⭐⭐ | 90분 | 🔴 HIGH |
| **1인 1트럭 시스템** | ⭐⭐⭐ | 40분 | 🔴 HIGH |
| **이미지 업로드** | ⭐⭐⭐⭐ | 60분 | 🟡 MEDIUM |
| **메뉴 관리 UI** | ⭐⭐⭐ | 50분 | 🟡 MEDIUM |
| **리뷰 시스템** | ⭐⭐⭐⭐ | 70분 | 🟢 LOW |
| **테스트 & 배포** | ⭐⭐ | 30분 | 🔴 HIGH |

---

## 🎯 **단계별 구현 전략**

### **Phase 1: 핵심 인증 시스템** (90분)

#### **1.1 패키지 설치**
```yaml
dependencies:
  firebase_auth: latest
  kakao_flutter_sdk: latest  # ⚠️ 카카오 앱 키 필요
  flutter_naver_login: latest  # ⚠️ 네이버 클라이언트 ID 필요
  google_sign_in: latest
```

#### **1.2 통합 Auth Service**
```dart
class UnifiedAuthService {
  // Email Login
  Future<User?> signInWithEmail(email, password)
  
  // Kakao Login
  Future<User?> signInWithKakao()
  
  // Naver Login  
  Future<User?> signInWithNaver()
  
  // Google Login
  Future<User?> signInWithGoogle()
  
  // Unified UID management
  String getUserId()
}
```

#### **1.3 로그인 화면**
```dart
LoginScreen:
  - 이메일 로그인 버튼
  - 카카오 로그인 버튼 (노란색)
  - 네이버 로그인 버튼 (초록색)
  - 구글 로그인 버튼
```

**문제점**: 
- ⚠️ **카카오/네이버 로그인은 앱 등록 필요**
- ⚠️ **개발자 키 발급 필요 (별도 작업)**
- ⚠️ **웹에서는 제한적**

**해결책**:
- ✅ **이메일 + 구글 로그인** 먼저 구현
- ⏳ **카카오/네이버는 구조만 준비**

---

### **Phase 2: 1인 1트럭 시스템** (40분)

#### **2.1 Firestore 구조**

```
users (collection)
  ├─ {userId} (document)
      ├─ email: string
      ├─ name: string
      ├─ role: 'owner' | 'customer'
      ├─ ownedTruckId: number (1-100) or null
      └─ createdAt: timestamp

trucks (collection)
  ├─ {truckId: '1' ~ '100'} (document)
      ├─ ownerId: string (userId)
      ├─ ownerEmail: string
      ├─ foodType: string
      ├─ menus: array
      └─ ...
```

#### **2.2 트럭 ID 할당 로직**

```dart
class TruckRegistrationService {
  // 사용 가능한 트럭 ID 조회
  Future<List<int>> getAvailableTruckIds() {
    // 1~100 중 ownerId가 없는 트럭 반환
  }
  
  // 트럭 소유 신청
  Future<bool> claimTruck(String userId, int truckId) {
    // 1. 해당 userId가 이미 트럭을 소유하고 있는지 확인
    // 2. 해당 truckId가 이미 소유자가 있는지 확인
    // 3. 통과 시 할당
  }
}
```

#### **2.3 UI 흐름**

```
사장님 회원가입
  ↓
트럭 ID 선택 화면 (1~100 그리드)
  ↓
선택한 트럭 정보 확인
  ↓
소유권 신청
  ↓
승인 → 사장님 대시보드
```

---

### **Phase 3: 이미지 업로드** (60분)

#### **3.1 패키지 설치**
```yaml
dependencies:
  image_picker: latest
  firebase_storage: latest
```

#### **3.2 Storage 구조**
```
gs://truck-tracker.appspot.com/
  ├─ trucks/
  │   ├─ 1/
  │   │   ├─ main.jpg (트럭 대표 사진)
  │   │   └─ menu/
  │   │       ├─ menu_1.jpg
  │   │       ├─ menu_2.jpg
  │   │       └─ ...
  │   └─ ...
  └─ reviews/
      ├─ {reviewId}/
      │   ├─ photo_1.jpg
      │   └─ ...
```

#### **3.3 이미지 업로드 서비스**

```dart
class ImageUploadService {
  Future<String> uploadTruckPhoto(File image, int truckId) async {
    // 1. 이미지 압축
    // 2. Storage 업로드
    // 3. Download URL 반환
    // 4. Firestore trucks/{truckId}/imageUrl 업데이트
  }
  
  Future<String> uploadMenuPhoto(File image, int truckId, String menuId) async {
    // 메뉴별 사진 업로드
  }
}
```

#### **3.4 UI: 메뉴 관리 화면**

```dart
MenuManagementScreen:
  - 메뉴 리스트 (편집 가능)
  - 각 메뉴마다:
    * 사진 (탭하면 image_picker)
    * 이름 (TextField)
    * 가격 (TextField)
    * 저장 버튼
```

---

### **Phase 4: 리뷰 시스템** (70분)

#### **4.1 Firestore 구조**

```
reviews (collection)
  ├─ {reviewId} (auto-generated document)
      ├─ truckId: string
      ├─ userId: string
      ├─ userName: string
      ├─ rating: number (1-5)
      ├─ comment: string
      ├─ photoUrls: array<string>
      ├─ createdAt: timestamp
      └─ updatedAt: timestamp
```

#### **4.2 리뷰 서비스**

```dart
class ReviewService {
  // 리뷰 작성
  Future<void> addReview({
    required String truckId,
    required int rating,
    required String comment,
    List<File>? photos,
  })
  
  // 트럭별 리뷰 조회 (실시간 Stream)
  Stream<List<Review>> watchTruckReviews(String truckId)
  
  // 평균 별점 계산
  Future<double> getAverageRating(String truckId)
}
```

#### **4.3 UI: 리뷰 화면**

```dart
TruckDetailScreen:
  ├─ 트럭 정보
  ├─ 메뉴 리스트
  └─ 리뷰 섹션 ✨ NEW
      ├─ 평균 별점 표시
      ├─ 리뷰 작성 버튼 (로그인 필요)
      └─ 리뷰 리스트 (실시간)
          ├─ 사용자 이름
          ├─ 별점
          ├─ 사진 (있으면)
          ├─ 코멘트
          └─ 작성 시간
```

---

## ⚠️ **현실적인 문제점**

### **1. 소셜 로그인 제약사항**

#### **카카오 로그인**:
```
필요한 것:
- 카카오 개발자 계정
- 앱 등록 (별도 승인 필요)
- Native App Key
- JavaScript Key (Web)
- REST API Key
- 리다이렉트 URI 설정

예상 시간: 30분 ~ 2시간 (승인 대기 포함)
```

#### **네이버 로그인**:
```
필요한 것:
- 네이버 개발자 계정
- 애플리케이션 등록
- Client ID / Client Secret
- 콜백 URL 설정

예상 시간: 30분 ~ 1시간
```

**결론**: 
- ✅ **이메일/구글 로그인 먼저 구현**
- ⏳ **카카오/네이버는 키 발급 후 추가**

---

### **2. 이미지 업로드 (웹 제약)**

```
문제:
- 웹에서 파일 선택은 가능
- 하지만 압축/리사이징이 제한적
- Storage 용량 관리 필요

해결책:
- 이미지 크기 제한 (2MB)
- 업로드 전 클라이언트 측 압축
- Storage 규칙 설정
```

---

### **3. 리뷰 시스템 복잡도**

```
고려사항:
- 스팸 방지 (1인 1리뷰 제한)
- 부적절한 내용 신고 기능
- 사장님 답글 기능
- 리뷰 수정/삭제 권한

추가 시간: +30분
```

---

## 🚀 **실용적인 구현 계획**

### **Plan A: 최소 기능 (MVP)** - 2시간

```
✅ 구현:
  1. 이메일 + 구글 로그인 (60분)
  2. 1인 1트럭 시스템 (40분)
  3. 간단한 메뉴 텍스트 편집 (20분)
  
❌ 제외:
  - 카카오/네이버 로그인 (키 필요)
  - 이미지 업로드 (복잡)
  - 리뷰 시스템 (복잡)
  
결과:
  → 기본 인증 & 트럭 관리 가능
  → 즉시 배포 가능
```

---

### **Plan B: 핵심 기능** - 3.5시간

```
✅ 구현:
  1. 이메일 + 구글 로그인 (60분)
  2. 1인 1트럭 시스템 (40분)
  3. 메뉴 텍스트 편집 (20분)
  4. 이미지 업로드 (Storage) (60분)
  5. 간단한 리뷰 (별점+텍스트) (50분)
  
❌ 제외:
  - 카카오/네이버 로그인
  - 리뷰 사진 업로드
  
결과:
  → 실용적인 플랫폼
  → 대부분의 요구사항 충족
```

---

### **Plan C: 완전 구현** - 6시간+

```
✅ 구현:
  1. 멀티 로그인 (이메일+구글+카카오+네이버) (90분)
  2. 1인 1트럭 시스템 (40분)
  3. 메뉴 관리 UI (50분)
  4. 이미지 업로드 (Storage) (60분)
  5. 완전한 리뷰 시스템 (70분)
  6. 추가 기능 (답글, 신고 등) (60분)
  
결과:
  → 완전한 플랫폼
  → 모든 요구사항 충족
  → 프로덕션 준비 완료
  
⚠️ 단점:
  - 매우 긴 작업 시간
  - 소셜 로그인 키 발급 필요
```

---

## 💡 **추천 전략: 점진적 구현**

### **Week 1: 인증 시스템** (지금)
```
1. 이메일 로그인 구현
2. 구글 로그인 추가
3. 1인 1트럭 시스템
4. 배포

예상 시간: 2시간
```

### **Week 2: 메뉴 관리**
```
1. 메뉴 편집 UI
2. 이미지 업로드
3. Storage 연동
4. 배포

예상 시간: 2시간
```

### **Week 3: 리뷰 시스템**
```
1. 리뷰 작성 UI
2. 별점 + 사진 업로드
3. 실시간 표시
4. 배포

예상 시간: 2시간
```

### **Week 4: 소셜 로그인**
```
1. 카카오 로그인 (키 발급 후)
2. 네이버 로그인 (키 발급 후)
3. 통합 테스트
4. 최종 배포

예상 시간: 2시간
```

---

## 🎯 **즉시 시작 가능한 작업**

### **Step 1: 기본 패키지 설치** (5분)

```bash
flutter pub add \
  google_sign_in \
  image_picker \
  firebase_storage
```

### **Step 2: 통합 Auth Service** (30분)

```dart
// lib/core/services/unified_auth_service.dart
class UnifiedAuthService {
  // 이메일 로그인
  Future<User?> signInWithEmail(email, password)
  
  // 구글 로그인
  Future<User?> signInWithGoogle()
  
  // UID 통합 관리
  String? getCurrentUserId()
}
```

### **Step 3: 로그인 화면** (30분)

```dart
// lib/features/auth/presentation/login_screen.dart
LoginScreen:
  - 이메일 입력 필드
  - 비밀번호 입력 필드
  - 로그인 버튼
  - 구글 로그인 버튼
  - 회원가입 링크
```

### **Step 4: 1인 1트럭 시스템** (40분)

```dart
// lib/features/truck/services/truck_ownership_service.dart
TruckOwnershipService:
  - getAvailableTrucks()
  - claimTruck(userId, truckId)
  - verifyOwnership(userId)
```

---

## 📊 **현재 상태**

```
[====------------------] 20% 완료

✅ 완료:
  - firebase_auth 설정 완료
  - AuthService 기본 구현 완료
  
🔄 진행 중:
  - 패키지 추가 준비
  
❌ 미완료:
  - 멀티 로그인 연동
  - 1인 1트럭 시스템
  - 이미지 업로드
  - 메뉴 관리
  - 리뷰 시스템
```

---

## 🤔 **어떤 계획으로 진행하시겠습니까?**

### **A. 최소 기능 (MVP)** - 2시간
- ✅ 이메일 + 구글 로그인
- ✅ 1인 1트럭 시스템
- ✅ 기본 메뉴 편집
- ❌ 이미지 업로드 제외
- ❌ 리뷰 시스템 제외

### **B. 핵심 기능** - 3.5시간
- ✅ 이메일 + 구글 로그인
- ✅ 1인 1트럭 시스템
- ✅ 메뉴 편집 + 이미지 업로드
- ✅ 간단한 리뷰 (별점+텍스트)
- ❌ 소셜 로그인 제외

### **C. 완전 구현** - 6시간+
- ✅ 모든 로그인 (이메일+구글+카카오+네이버)
- ✅ 1인 1트럭 시스템
- ✅ 메뉴 관리 + 이미지
- ✅ 완전한 리뷰 시스템

### **D. 점진적 구현** (추천)
- 🔄 Week 1: 인증 (2시간)
- 🔄 Week 2: 메뉴 (2시간)
- 🔄 Week 3: 리뷰 (2시간)
- 🔄 Week 4: 소셜 로그인 (2시간)

---

**답변 주시면 즉시 구현 시작하겠습니다!** 🚀

**추천**: Plan B (핵심 기능) - 실용적이고 즉시 사용 가능한 플랫폼





