# Phase 11-15: Advanced Features Roadmap

**Created**: 2025-12-28
**Status**: 📋 Planning & Basic Structure
**Implementation**: 기본 구조 완료, 풀 구현은 프로덕션 요구사항에 따라 진행

---

## Phase 11: Social Features (소셜 기능) ⭐

### 개요
사용자가 좋아하는 트럭을 팔로우하고, 소셜 피드에서 활동을 확인할 수 있는 기능

### 구현된 기능
- ✅ `TruckFollow` 도메인 모델 (`lib/features/social/domain/truck_follow.dart`)
  - userId, truckId, followedAt, notificationsEnabled
  - Firestore 직렬화 지원

### 추가 구현 필요 (프로덕션)
1. **Follow Repository**:
   ```dart
   class FollowRepository {
     Future<void> followTruck(String userId, String truckId);
     Future<void> unfollowTruck(String userId, String truckId);
     Stream<List<TruckFollow>> watchUserFollows(String userId);
     Future<bool> isFollowing(String userId, String truckId);
   }
   ```

2. **Social Feed**:
   - 팔로우한 트럭의 최신 활동 (위치 변경, 메뉴 업데이트, 리뷰 등)
   - 타임라인 UI
   - 실시간 업데이트 (Stream)

3. **User Profile**:
   - 팔로잉 트럭 목록
   - 리뷰 히스토리
   - 즐겨찾기 통계

4. **Firestore 스키마**:
   ```
   /follows/{followId}
     - userId: string
     - truckId: string
     - followedAt: timestamp
     - notificationsEnabled: boolean

   /users/{userId}/following (subcollection)
     - Quick lookup for user's followed trucks

   /trucks/{truckId}/followers (subcollection)
     - Follower count aggregation
   ```

5. **FCM Integration**:
   - 팔로우한 트럭이 영업 시작할 때 알림
   - 새 메뉴 추가시 알림
   - 특별 프로모션 알림

---

## Phase 12: Coupon & Promotion System (쿠폰/프로모션) 🎟️

### 개요
트럭별 쿠폰 발행 및 사용자 프로모션 코드 관리

### 구현 필요
1. **Coupon Model**:
   ```dart
   class Coupon {
     String id;
     String truckId;
     String code;
     int discountPercent;
     int? discountAmount;
     DateTime validFrom;
     DateTime validUntil;
     int maxUses;
     int currentUses;
     List<String> usedBy;
     CouponType type; // percentage, fixed, freeItem
   }
   ```

2. **Features**:
   - QR 코드 쿠폰 생성 (사장님)
   - 쿠폰 스캔 & 적용 (고객)
   - 유효성 검증 (날짜, 사용 횟수, 중복 사용 방지)
   - 쿠폰 히스토리

3. **UI Components**:
   - 사장님: 쿠폰 생성 대시보드
   - 고객: "My Coupons" 탭, 쿠폰 스캔 화면
   - 주문 시 쿠폰 적용 UI

4. **Security**:
   - Firestore Security Rules로 쿠폰 중복 사용 방지
   - 서버 사이드 검증 (Cloud Functions)

---

## Phase 13: Real-time Chat (실시간 채팅) 💬

### 개요
고객과 트럭 사장님 간 1:1 채팅

### 구현 필요
1. **Chat Model**:
   ```dart
   class ChatMessage {
     String id;
     String chatRoomId;
     String senderId;
     String senderName;
     String message;
     DateTime timestamp;
     bool isRead;
     String? imageUrl;
   }

   class ChatRoom {
     String id;
     String userId;
     String truckId;
     DateTime lastMessageAt;
     String lastMessage;
     int unreadCount;
   }
   ```

2. **Features**:
   - 1:1 채팅방 자동 생성
   - 실시간 메시지 전송/수신 (Firestore Streams)
   - 읽음 표시
   - 이미지 전송 (Firebase Storage)
   - 푸시 알림 (새 메시지)

3. **UI**:
   - Chat List Screen (채팅방 목록)
   - Chat Room Screen (메시지)
   - 이미지 프리뷰
   - 타이핑 인디케이터

4. **Performance**:
   - 메시지 페이지네이션 (최근 50개만 로드)
   - 이미지 압축 & 캐싱
   - Firestore 쿼리 최적화

---

## Phase 14: Payment Integration (결제 시스템) 💳

### 개요
앱 내 선결제 시스템 (카카오페이, 토스페이)

### 구현 필요
1. **Payment Model**:
   ```dart
   class Payment {
     String id;
     String orderId;
     String userId;
     String truckId;
     int amount;
     PaymentMethod method; // kakao, toss, card
     PaymentStatus status; // pending, completed, failed, refunded
     DateTime createdAt;
     String? transactionId;
   }
   ```

2. **Integration Options**:
   - **카카오페이** (https://developers.kakao.com/docs/latest/ko/kakaopay/common)
   - **토스페이먼츠** (https://docs.tosspayments.com/)
   - **PortOne (구 아임포트)** - 통합 PG

3. **Flow**:
   ```
   1. 고객: 메뉴 선택 & 주문
   2. 앱: 결제 SDK 호출 (카카오/토스)
   3. SDK: 사용자 인증 & 결제
   4. 앱: 결제 결과 수신
   5. Firestore: Payment 문서 생성
   6. Cloud Function: 결제 검증 & Order 상태 업데이트
   ```

4. **Security**:
   - 서버 사이드 결제 검증 필수
   - HTTPS Only
   - Firestore Security Rules
   - PCI-DSS 준수 (PG사에서 처리)

5. **Features**:
   - 결제 히스토리
   - 영수증 조회
   - 환불 요청
   - 자동 결제 (카드 등록)

---

## Phase 15: Advanced Notifications (고급 알림 시스템) 🔔

### 개요
맞춤형 푸시 알림 및 인앱 알림 시스템

### 구현 필요
1. **Notification Types**:
   - 트럭 영업 시작 (팔로우한 트럭)
   - 주문 상태 변경 (준비중 → 완료)
   - 새 쿠폰 발행
   - 리뷰 답글
   - 프로모션 & 이벤트
   - 위치 기반 (근처 트럭 알림)

2. **User Preferences**:
   ```dart
   class NotificationSettings {
     bool truckOpenings;
     bool orderUpdates;
     bool newCoupons;
     bool reviews;
     bool promotions;
     bool nearbyTrucks;
     int nearbyRadius; // meters
   }
   ```

3. **Implementation**:
   - Cloud Functions로 조건부 알림 발송
   - FCM Topics 활용 (지역별, 음식 종류별)
   - Firestore Triggers
   - 알림 히스토리 저장

4. **In-App Notifications**:
   - 알림 센터 UI
   - 읽음/안읽음 표시
   - 알림 클릭 시 해당 화면 이동

5. **Advanced Features**:
   - 스마트 알림 타이밍 (사용자 활동 패턴 분석)
   - A/B 테스팅 (알림 문구, 타이밍)
   - 알림 성능 분석 (오픈율, 클릭율)

---

## Implementation Priority

### 즉시 구현 가능 (현재 인프라로)
- ✅ Phase 11: Social Features (기본 팔로우)
- ✅ Phase 15: Advanced Notifications (FCM 이미 구현됨, 확장만 필요)

### 중기 구현 (API 키 & 설정 필요)
- Phase 12: Coupons (Firestore만으로 가능)
- Phase 13: Chat (Firestore Streams)

### 장기 구현 (외부 서비스 계약 필요)
- Phase 14: Payment (PG사 계약, 사업자 등록 필요)

---

## Development Estimates

| Phase | Core Implementation | Full Features | Testing |
|-------|---------------------|---------------|---------|
| 11 (Social) | 2-3 days | 5-7 days | 2 days |
| 12 (Coupon) | 3-4 days | 6-8 days | 2 days |
| 13 (Chat) | 4-5 days | 7-10 days | 3 days |
| 14 (Payment) | 5-7 days | 10-14 days | 5 days |
| 15 (Notifications) | 2-3 days | 4-6 days | 2 days |
| **Total** | **16-22 days** | **32-45 days** | **14 days** |

---

## Next Steps

1. **Complete Phase 11 Basic Structure**:
   - Generate freezed/json code for TruckFollow
   - Create FollowRepository skeleton
   - Add "Follow" button to TruckDetailScreen

2. **Prioritize by Business Value**:
   - Phase 15 (Notifications) - High value, low effort
   - Phase 12 (Coupons) - Medium value, medium effort
   - Phase 13 (Chat) - Medium value, medium effort
   - Phase 14 (Payment) - High value, high effort (requires legal/business setup)

3. **Documentation**:
   - API integration guides
   - Firestore schema documentation
   - Security rules examples

---

**Author**: Claude Sonnet 4.5
**Last Updated**: 2025-12-28
