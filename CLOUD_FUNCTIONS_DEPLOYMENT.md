# ☁️ Cloud Functions 배포 가이드

**날짜**: 2025-12-28
**상태**: 코드 구현 완료 ✅ | 배포 대기 중 ⏳

---

## 📋 구현된 Functions (5개)

### 1. ✅ notifyTruckOpening (기존)
**트리거**: `trucks/{truckId}` onUpdate
**조건**: `isOpen`이 false → true로 변경
**대상**: 트럭을 팔로우한 사용자 (topic: `truck_{truckId}`)
**알림**: "🚚 {트럭명}이 영업을 시작했습니다!"

---

### 2. 🆕 notifyOrderStatus
**트리거**: `orders/{orderId}` onUpdate
**조건**: `status` 필드 변경
**대상**: 주문한 고객 (FCM token)
**알림**: 상태별 메시지

| 상태 | 이모지 | 메시지 |
|------|--------|--------|
| pending | 📝 | 주문이 접수되었습니다 |
| confirmed | ✅ | 주문이 확인되었습니다 |
| preparing | 👨‍🍳 | 음식을 준비 중입니다 |
| ready | 🎉 | 주문이 완료되었습니다! 픽업해주세요 |
| completed | ✨ | 주문이 완료되었습니다 |
| cancelled | ❌ | 주문이 취소되었습니다 |

**데이터**:
```json
{
  "orderId": "order123",
  "truckId": "truck456",
  "status": "ready",
  "type": "order_status",
  "timestamp": "2025-12-28T14:30:00Z"
}
```

---

### 3. 🆕 notifyCouponCreated
**트리거**: `coupons/{couponId}` onCreate
**조건**: 새 쿠폰 생성
**대상**: 트럭을 팔로우한 사용자 (topic: `truck_{truckId}`)
**알림**: "🎁 {트럭명} 새 쿠폰 발행! {할인율/할인금액/무료} 쿠폰이 발행되었습니다! 코드: {code}"

**할인 타입**:
- `percentage`: "20% 할인"
- `fixed`: "5000원 할인"
- `free_item`: "무료 증정"

**데이터**:
```json
{
  "couponId": "coupon789",
  "truckId": "truck456",
  "code": "WELCOME20",
  "type": "coupon_created",
  "timestamp": "2025-12-28T14:30:00Z"
}
```

---

### 4. 🆕 notifyChatMessage
**트리거**: `chatRooms/{chatRoomId}/messages/{messageId}` onCreate
**조건**: 새 메시지 생성
**대상**: 상대방 (senderId가 아닌 참여자)
**알림**: "💬 {발신자명}\n{메시지 내용 (최대 50자)}"

**로직**:
1. chatRoom에서 customerId, truckOwnerId 조회
2. senderId와 비교하여 recipientId 결정
3. recipient의 FCM token 조회
4. 알림 전송

**데이터**:
```json
{
  "chatRoomId": "room123",
  "messageId": "msg456",
  "senderId": "user789",
  "type": "chat_message",
  "timestamp": "2025-12-28T14:30:00Z"
}
```

---

### 5. 🆕 notifyNearbyTrucks
**트리거**: `trucks/{truckId}` onUpdate
**조건**: `latitude` 또는 `longitude` 변경
**대상**: 근처 알림을 활성화한 사용자 (notificationSettings.nearbyTrucks == true)
**알림**: "🚚 근처에 {트럭명}이(가) 있어요!\n{음식 종류} 트럭이 {위치}에서 {거리}km 떨어진 곳에 있습니다"

**로직 (Haversine Formula)**:
```javascript
function haversineDistance(lat1, lon1, lat2, lon2) {
  const R = 6371; // Earth radius in km
  const dLat = (lat2 - lat1) * Math.PI / 180;
  const dLon = (lon2 - lon1) * Math.PI / 180;
  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
    Math.sin(dLon / 2) * Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c; // Distance in km
}
```

**필요 데이터**:
- `users/{userId}`: lastKnownLatitude, lastKnownLongitude, fcmToken
- `notificationSettings/{userId}`: nearbyTrucks (boolean), nearbyRadius (km)

**데이터**:
```json
{
  "truckId": "truck456",
  "distance": "1.25",
  "type": "nearby_truck",
  "timestamp": "2025-12-28T14:30:00Z"
}
```

---

## 🚀 배포 방법

### 1. Firebase CLI 설치 (한 번만)
```bash
npm install -g firebase-tools
```

### 2. Firebase 로그인
```bash
firebase login
```

### 3. Functions 배포
```bash
cd "C:\Users\임현우\Desktop\현우 작업폴더\truck_tracker\truck ver.1\truck_tracker"
firebase deploy --only functions
```

### 4. 특정 함수만 배포 (선택)
```bash
# 단일 함수 배포
firebase deploy --only functions:notifyOrderStatus

# 여러 함수 배포
firebase deploy --only functions:notifyOrderStatus,functions:notifyChatMessage
```

---

## 📊 배포 후 확인

### Firebase Console
1. https://console.firebase.google.com/project/truck-tracker-fa0b0/functions
2. 배포된 함수 목록 확인:
   - ✅ createCustomToken
   - ✅ notifyTruckOpening
   - 🆕 notifyOrderStatus
   - 🆕 notifyCouponCreated
   - 🆕 notifyChatMessage
   - 🆕 notifyNearbyTrucks

### 로그 확인
```bash
# 전체 로그
firebase functions:log

# 특정 함수 로그
firebase functions:log --only notifyOrderStatus

# 실시간 로그 (tail)
firebase functions:log --tail
```

### 함수 테스트
1. **notifyOrderStatus**: Firestore에서 주문 상태 변경
   ```
   orders/{orderId} → status: "pending" → "confirmed"
   ```

2. **notifyCouponCreated**: Firestore에서 새 쿠폰 생성
   ```
   coupons/{couponId} → { truckId, code, discountValue, ... }
   ```

3. **notifyChatMessage**: 채팅 메시지 전송
   ```
   chatRooms/{chatRoomId}/messages/{messageId} → { text, senderId, ... }
   ```

4. **notifyNearbyTrucks**: 트럭 위치 변경
   ```
   trucks/{truckId} → latitude: 37.123, longitude: 127.456
   ```

---

## ⚠️ 주의사항

### 1. FCM Token 필수
모든 사용자는 `users/{userId}.fcmToken` 필드에 FCM 토큰이 저장되어 있어야 합니다.

**앱에서 토큰 저장 예제**:
```dart
final fcmToken = await FirebaseMessaging.instance.getToken();
await FirebaseFirestore.instance
  .collection('users')
  .doc(userId)
  .update({'fcmToken': fcmToken});
```

### 2. 위치 정보 저장 (notifyNearbyTrucks용)
사용자의 마지막 위치를 Firestore에 저장해야 합니다.

**앱에서 위치 저장 예제**:
```dart
Position position = await Geolocator.getCurrentPosition();
await FirebaseFirestore.instance
  .collection('users')
  .doc(userId)
  .update({
    'lastKnownLatitude': position.latitude,
    'lastKnownLongitude': position.longitude,
  });
```

### 3. 알림 설정 저장
사용자의 알림 선호도를 `notificationSettings` 컬렉션에 저장해야 합니다.

**Firestore 구조**:
```
notificationSettings/{userId}
  - nearbyTrucks: true
  - nearbyRadius: 2.0 (km)
  - orderUpdates: true
  - chatMessages: true
  - newCoupons: true
  ...
```

---

## 🔧 문제 해결

### 함수가 트리거되지 않는 경우
1. **Firestore 규칙 확인**: 함수가 Firestore에 접근할 수 있는지 확인
2. **로그 확인**: `firebase functions:log` 실행
3. **함수 상태 확인**: Firebase Console에서 함수가 정상적으로 배포되었는지 확인

### 알림이 전송되지 않는 경우
1. **FCM Token 확인**: 사용자의 fcmToken이 유효한지 확인
2. **Topic 구독 확인**: `truck_{truckId}` topic에 구독되어 있는지 확인
3. **Firebase Cloud Messaging 설정**: Android/iOS 앱에서 FCM 설정이 올바른지 확인

### 거리 계산 오류 (notifyNearbyTrucks)
1. **위치 데이터 확인**: users 컬렉션에 lastKnownLatitude/Longitude가 있는지 확인
2. **좌표 유효성**: 위도(-90~90), 경도(-180~180) 범위 확인
3. **nearbyRadius 확인**: 0보다 큰 값인지 확인

---

## 📈 성능 최적화

### 1. notifyNearbyTrucks 최적화
현재는 모든 사용자를 순회하므로, 사용자 수가 많으면 느려질 수 있습니다.

**개선 방안**:
- Geohash 라이브러리 사용 (firebase-geohash)
- 거리 범위 내 사용자만 쿼리
- 배치 처리 (Cloud Tasks 사용)

### 2. 함수 실행 비용 절감
- 불필요한 쿼리 제거
- 캐싱 활용 (Redis, Memorystore)
- 함수 메모리 최적화 (256MB → 128MB)

---

## 📝 다음 단계

### 단기 (배포 후)
- [ ] Firebase CLI 설치
- [ ] Functions 배포
- [ ] 로그 확인 및 테스트
- [ ] 앱에서 FCM 토큰 저장 확인

### 중기 (1주일)
- [ ] 알림 성능 모니터링
- [ ] 에러율 확인 (Cloud Monitoring)
- [ ] 사용자 피드백 수집

### 장기 (1개월)
- [ ] A/B 테스팅 (알림 메시지 최적화)
- [ ] 알림 오픈율 분석
- [ ] Geohash 기반 최적화 (notifyNearbyTrucks)

---

**작성일**: 2025-12-28
**작성자**: Claude Sonnet 4.5
**커밋**: `6ac73ad` - [Cloud Functions]: 4개 알림 함수 구현

🚀 **Cloud Functions 구현 완료! 배포만 하면 됩니다!**
