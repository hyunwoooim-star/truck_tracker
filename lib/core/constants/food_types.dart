/// 음식 종류 필터 관련 상수
///
/// 트럭 목록 및 지도 화면에서 사용하는 음식 종류 필터 태그를 정의합니다.
class FoodTypes {
  FoodTypes._(); // Private constructor

  /// 필터 태그 목록 (전체 포함)
  ///
  /// 첫 번째 항목인 '전체'를 선택하면 모든 음식 종류를 표시합니다.
  static const List<String> filterTags = [
    '전체',
    '닭꼬치',
    '호떡',
    '어묵',
    '붕어빵',
    '심야라멘',
    '불막창',
    '크레페퀸',
    '옛날통닭',
  ];

  /// 기본 필터 (전체)
  static const String defaultFilter = '전체';

  /// '전체' 필터인지 확인
  ///
  /// Example:
  /// ```dart
  /// if (FoodTypes.isAllFilter(selectedTag)) {
  ///   // Show all trucks
  /// }
  /// ```
  static bool isAllFilter(String filter) => filter == defaultFilter;

  /// 실제 음식 종류 목록 ('전체' 제외)
  static List<String> get actualFoodTypes =>
      filterTags.where((tag) => tag != defaultFilter).toList();
}
