import 'package:google_maps_flutter/google_maps_flutter.dart';

/// 음식 종류별 지도 마커 색상 매핑
///
/// Google Maps 마커의 색상(Hue)을 음식 종류에 따라 일관되게 유지합니다.
/// 색상은 음식의 특성을 반영하여 선택되었습니다.
class MarkerColors {
  MarkerColors._(); // Private constructor

  /// 음식 종류별 마커 색상 매핑
  ///
  /// Hue 값 (0-360):
  /// - Red (0°): 매운/구운 음식 (닭꼬치, 불막창)
  /// - Orange (30°): 따뜻한/달콤한 음식 (호떡)
  /// - Yellow (60°): 가벼운/고소한 음식 (어묵, 붕어빵)
  /// - Violet (270°): 독특한/이국적 음식 (심야라멘)
  /// - Magenta (300°): 화려한/달콤한 음식 (크레페퀸)
  /// - Green (120°): 담백한 음식 (옛날통닭)
  static const Map<String, double> foodTypeHues = {
    '닭꼬치': BitmapDescriptor.hueRed,        // 0° - 빨강 (구운 음식)
    '불막창': BitmapDescriptor.hueRose,       // 330° - 장미색 (매운 음식)
    '호떡': BitmapDescriptor.hueOrange,       // 30° - 주황 (따뜻한 간식)
    '어묵': BitmapDescriptor.hueYellow,       // 60° - 노랑 (가벼운 간식)
    '붕어빵': BitmapDescriptor.hueYellow,     // 60° - 노랑 (고소한 간식)
    '심야라멘': BitmapDescriptor.hueViolet,   // 270° - 보라 (이국적 음식)
    '크레페퀸': BitmapDescriptor.hueMagenta,  // 300° - 마젠타 (화려한 디저트)
    '옛날통닭': BitmapDescriptor.hueGreen,    // 120° - 초록 (담백한 치킨)
  };

  /// 기본 마커 색상 (등록되지 않은 음식 종류)
  ///
  /// 청록색(Cyan)을 사용하여 구분합니다.
  static const double defaultHue = 175.0; // Cyan (청록색)

  /// 음식 종류에 따른 마커 색상(Hue) 반환
  ///
  /// 등록된 음식 종류는 해당 색상을, 등록되지 않은 경우 기본 색상을 반환합니다.
  ///
  /// Example:
  /// ```dart
  /// final hue = MarkerColors.getHue('닭꼬치'); // Returns BitmapDescriptor.hueRed
  /// final hue2 = MarkerColors.getHue('Unknown'); // Returns 175.0 (Cyan)
  /// ```
  static double getHue(String foodType) {
    return foodTypeHues[foodType] ?? defaultHue;
  }
}
