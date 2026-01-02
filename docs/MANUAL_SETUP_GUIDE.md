# Phase 1: 데이터 초기화 수동 작업 가이드

## 1. Firebase Console 접속

```
https://console.firebase.google.com/project/truck-tracker-fa0b0
```

---

## 2. Authentication 계정 정리

**경로:** Firebase Console → Authentication → Users

| 작업 | 이메일 | 비고 |
|------|--------|------|
| ✅ 유지 | `hyunwoooim@gmail.com` | 관리자 계정 |
| ❌ 삭제 | 나머지 전부 | 테스트용 정리 |

**삭제 방법:**
1. 사용자 행 오른쪽 ⋮ 클릭
2. "사용자 삭제" 선택
3. 확인

---

## 3. 테스트 계정 생성 (앱에서)

**방법:** 앱 실행 → 이메일 회원가입

| 역할 | 이메일 | 비밀번호 | 용도 |
|------|--------|----------|------|
| 사장님1 | `owner1@test.com` | `Test123!` | 트럭1 소유자 |
| 사장님2 | `owner2@test.com` | `Test123!` | 트럭2 소유자 |
| 사장님3 | `owner3@test.com` | `Test123!` | 트럭3 소유자 |
| 고객 | `customer@test.com` | `Test123!` | 일반 사용자 |

---

## 4. Firestore에서 역할 수정

**경로:** Firebase Console → Firestore Database → users 컬렉션

### 사장님 계정 수정 (3명):
```
users/{uid} 문서 클릭 → 필드 편집:

role: "owner"              (string → "owner"로 변경)
ownedTruckId: "1"          (string → 트럭 ID, 예: "1", "2", "3")
onboardingCompleted: false (boolean → false)
```

### 고객 계정:
```
users/{customer_uid}:

role: "customer"           (기본값 유지)
```

---

## 5. 트럭 데이터 확인/생성

**경로:** Firestore → trucks 컬렉션

### 트럭 문서 구조:
```javascript
// trucks/1 (문서 ID: "1")
{
  id: 1,
  ownerId: null,           // 온보딩 전이므로 null
  truckNumber: "",
  foodType: "",
  status: "maintenance",
  isOpen: false,
  onboardingCompleted: false,
  latitude: 37.5665,
  longitude: 126.9780,
  createdAt: (서버 타임스탬프)
}
```

**추가 방법:** 컬렉션 시작 또는 문서 추가 버튼 클릭 → 문서 ID: "1", "2", "3"

---

## 6. 테스트 순서

1. **앱 실행** (Chrome 또는 Windows)
2. **owner1@test.com 로그인**
3. **온보딩 화면 표시 확인** (5단계)
4. **온보딩 완료**
5. **대시보드 진입 확인**

---

## 빠른 체크리스트

```
□ Firebase Console 접속
□ Authentication에서 불필요한 계정 삭제
□ 앱에서 테스트 계정 4개 생성
□ Firestore users에서 사장님 3명 role: "owner" 변경
□ Firestore users에서 사장님 3명 ownedTruckId 설정
□ Firestore trucks에 트럭 3개 문서 확인/생성
□ 앱에서 사장님 로그인 → 온보딩 테스트
```

---

## 주의사항

- **ownedTruckId는 String 타입**으로 저장 (숫자 아님)
- **role 값은 정확히** `"owner"`, `"customer"`, `"admin"` 중 하나
- 관리자 계정(`hyunwoooim@gmail.com`)의 role은 `"admin"` 유지

---

**마지막 업데이트:** 2026-01-02
