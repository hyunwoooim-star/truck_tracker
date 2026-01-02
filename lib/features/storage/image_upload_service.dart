import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/utils/app_logger.dart';

/// 이미지 업로드 용도별 설정
enum ImageUploadType {
  /// 트럭 대표 이미지 (1200x800, 80%, 500KB)
  truckMain(
    maxWidth: 1200,
    maxHeight: 800,
    quality: 80,
    maxSizeKB: 500,
    label: '트럭 대표 이미지',
    hint: '권장: 가로형 사진 (4:3), 최대 5MB',
  ),

  /// 메뉴 이미지 (800x600, 80%, 200KB)
  menu(
    maxWidth: 800,
    maxHeight: 600,
    quality: 80,
    maxSizeKB: 200,
    label: '메뉴 이미지',
    hint: '권장: 정사각형 사진, 최대 2MB',
  ),

  /// 리뷰 이미지 (1000x1000, 75%, 300KB)
  review(
    maxWidth: 1000,
    maxHeight: 1000,
    quality: 75,
    maxSizeKB: 300,
    label: '리뷰 이미지',
    hint: '최대 3장, 각 2MB 이하',
  ),

  /// 프로필 이미지 (400x400, 75%, 100KB)
  profile(
    maxWidth: 400,
    maxHeight: 400,
    quality: 75,
    maxSizeKB: 100,
    label: '프로필 이미지',
    hint: '권장: 정사각형 사진',
  ),

  /// 사업자등록증 (원본 크기, 85%, 1MB)
  businessLicense(
    maxWidth: 2000,
    maxHeight: 2000,
    quality: 85,
    maxSizeKB: 1024,
    label: '사업자등록증',
    hint: '선명하게 촬영해주세요, 최대 5MB',
  );

  const ImageUploadType({
    required this.maxWidth,
    required this.maxHeight,
    required this.quality,
    required this.maxSizeKB,
    required this.label,
    required this.hint,
  });

  final int maxWidth;
  final int maxHeight;
  final int quality;
  final int maxSizeKB;
  final String label; // UI 표시용
  final String hint; // 사용자 안내 메시지
}

/// Service for uploading images to Firebase Storage
class ImageUploadService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  // ═══════════════════════════════════════════════════════════
  // IMAGE PICKING
  // ═══════════════════════════════════════════════════════════

  /// Pick an image from gallery
  Future<XFile?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null) {
        AppLogger.debug('Image picked: ${image.name} (${await image.length()} bytes)', tag: 'ImageUploadService');
      }

      return image;
    } catch (e, stackTrace) {
      AppLogger.error('Error picking image', error: e, stackTrace: stackTrace, tag: 'ImageUploadService');
      return null;
    }
  }

  /// Pick an image from camera
  Future<XFile?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null) {
        AppLogger.debug('Image captured: ${image.name} (${await image.length()} bytes)', tag: 'ImageUploadService');
      }

      return image;
    } catch (e, stackTrace) {
      AppLogger.error('Error capturing image', error: e, stackTrace: stackTrace, tag: 'ImageUploadService');
      return null;
    }
  }

  /// Pick multiple images from gallery
  Future<List<XFile>> pickMultipleImages({int maxImages = 5}) async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      // Limit number of images
      final limitedImages = images.take(maxImages).toList();

      AppLogger.debug('${limitedImages.length} images picked', tag: 'ImageUploadService');

      return limitedImages;
    } catch (e, stackTrace) {
      AppLogger.error('Error picking multiple images', error: e, stackTrace: stackTrace, tag: 'ImageUploadService');
      return [];
    }
  }

  // ═════════════════════════════════════════════════════════════
  // TRUCK IMAGE UPLOAD
  // ═══════════════════════════════════════════════════════════

  /// Upload truck main image (WebP, 1200x800, 80%)
  Future<String> uploadTruckImage(
    XFile image,
    int truckId, {
    void Function(double progress)? onProgress,
  }) async {
    AppLogger.debug('Uploading truck #$truckId main image', tag: 'ImageUploadService');

    try {
      final bytes = await image.readAsBytes();
      final path = 'trucks/$truckId/main.webp';

      return await _uploadBytes(
        bytes,
        path,
        type: ImageUploadType.truckMain,
        onProgress: onProgress,
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error uploading truck image', error: e, stackTrace: stackTrace, tag: 'ImageUploadService');
      rethrow;
    }
  }

  /// Upload menu item image (WebP, 800x600, 80%)
  Future<String> uploadMenuImage(
    XFile image,
    int truckId,
    String menuId, {
    void Function(double progress)? onProgress,
  }) async {
    AppLogger.debug('Uploading menu image for truck #$truckId, menu: $menuId', tag: 'ImageUploadService');

    try {
      final bytes = await image.readAsBytes();
      final path = 'trucks/$truckId/menus/$menuId.webp';

      return await _uploadBytes(
        bytes,
        path,
        type: ImageUploadType.menu,
        onProgress: onProgress,
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error uploading menu image', error: e, stackTrace: stackTrace, tag: 'ImageUploadService');
      rethrow;
    }
  }

  /// Upload business license image (WebP, high quality 85%)
  Future<String> uploadBusinessLicenseImage(
    XFile image,
    String userId, {
    void Function(double progress)? onProgress,
  }) async {
    AppLogger.debug('Uploading business license for user: $userId', tag: 'ImageUploadService');

    try {
      final bytes = await image.readAsBytes();
      final path = 'business_licenses/$userId.webp';

      return await _uploadBytes(
        bytes,
        path,
        type: ImageUploadType.businessLicense,
        onProgress: onProgress,
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error uploading business license', error: e, stackTrace: stackTrace, tag: 'ImageUploadService');
      rethrow;
    }
  }

  // ═══════════════════════════════════════════════════════════
  // REVIEW IMAGE UPLOAD
  // ═══════════════════════════════════════════════════════════

  /// Upload review images (WebP, 1000x1000, 75%)
  Future<List<String>> uploadReviewImages(
    List<XFile> images,
    String reviewId, {
    void Function(int current, int total, double progress)? onProgress,
  }) async {
    AppLogger.debug('Uploading ${images.length} review images for review: $reviewId', tag: 'ImageUploadService');

    try {
      final List<String> urls = [];

      for (int i = 0; i < images.length; i++) {
        final bytes = await images[i].readAsBytes();
        final path = 'reviews/$reviewId/photo_$i.webp';

        final url = await _uploadBytes(
          bytes,
          path,
          type: ImageUploadType.review,
          onProgress: onProgress != null
              ? (progress) => onProgress(i + 1, images.length, progress)
              : null,
        );
        urls.add(url);

        AppLogger.debug('Uploaded photo $i: $url', tag: 'ImageUploadService');
      }

      AppLogger.success('All review images uploaded: ${urls.length}', tag: 'ImageUploadService');
      return urls;
    } catch (e, stackTrace) {
      AppLogger.error('Error uploading review images', error: e, stackTrace: stackTrace, tag: 'ImageUploadService');
      rethrow;
    }
  }

  // ═══════════════════════════════════════════════════════════
  // WEBP COMPRESSION
  // ═══════════════════════════════════════════════════════════

  /// Compress image to WebP format
  Future<Uint8List> compressToWebP(
    Uint8List bytes,
    ImageUploadType type,
  ) async {
    try {
      AppLogger.debug(
        'Compressing image: ${bytes.length} bytes → ${type.name} (${type.maxWidth}x${type.maxHeight}, ${type.quality}%)',
        tag: 'ImageUploadService',
      );

      final compressedBytes = await FlutterImageCompress.compressWithList(
        bytes,
        minWidth: type.maxWidth,
        minHeight: type.maxHeight,
        quality: type.quality,
        format: CompressFormat.webp,
      );

      final originalKB = bytes.length / 1024;
      final compressedKB = compressedBytes.length / 1024;
      final reduction = ((1 - compressedKB / originalKB) * 100).toStringAsFixed(1);

      AppLogger.success(
        'Compression done: ${originalKB.toStringAsFixed(0)}KB → ${compressedKB.toStringAsFixed(0)}KB ($reduction% 감소)',
        tag: 'ImageUploadService',
      );

      return compressedBytes;
    } catch (e, stackTrace) {
      AppLogger.error('WebP compression failed, using original', error: e, stackTrace: stackTrace, tag: 'ImageUploadService');
      // 압축 실패 시 원본 반환
      return bytes;
    }
  }

  // ═══════════════════════════════════════════════════════════
  // CORE UPLOAD FUNCTION
  // ═══════════════════════════════════════════════════════════

  /// Upload bytes to Firebase Storage (with WebP compression)
  Future<String> _uploadBytes(
    Uint8List bytes,
    String path, {
    ImageUploadType type = ImageUploadType.truckMain,
    void Function(double progress)? onProgress,
  }) async {
    try {
      // WebP 압축
      final compressedBytes = await compressToWebP(bytes, type);

      // 확장자를 webp로 변경
      final webpPath = path.replaceAll(RegExp(r'\.(jpg|jpeg|png)$', caseSensitive: false), '.webp');

      final ref = _storage.ref().child(webpPath);

      // Set metadata
      final metadata = SettableMetadata(
        contentType: 'image/webp',
        customMetadata: {
          'uploadedAt': DateTime.now().toIso8601String(),
          'originalSize': bytes.length.toString(),
          'compressedSize': compressedBytes.length.toString(),
          'uploadType': type.name,
        },
      );

      // Upload with progress tracking
      final uploadTask = ref.putData(compressedBytes, metadata);

      if (onProgress != null) {
        uploadTask.snapshotEvents.listen((snapshot) {
          final progress = snapshot.bytesTransferred / snapshot.totalBytes;
          onProgress(progress);
        });
      }

      // Wait for completion
      final snapshot = await uploadTask;

      // Get download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();

      AppLogger.success('Upload successful: $webpPath', tag: 'ImageUploadService');
      AppLogger.debug('URL: $downloadUrl', tag: 'ImageUploadService');

      return downloadUrl;
    } catch (e, stackTrace) {
      AppLogger.error('Error uploading bytes', error: e, stackTrace: stackTrace, tag: 'ImageUploadService');
      rethrow;
    }
  }

  // ═══════════════════════════════════════════════════════════
  // DELETE FUNCTIONS
  // ═══════════════════════════════════════════════════════════

  /// Delete image from storage
  Future<void> deleteImage(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
      AppLogger.success('Image deleted: $url', tag: 'ImageUploadService');
    } catch (e, stackTrace) {
      AppLogger.error('Error deleting image', error: e, stackTrace: stackTrace, tag: 'ImageUploadService');
      // Don't rethrow - deletion failure shouldn't break the app
    }
  }

  /// Delete all menu images for a truck
  Future<void> deleteAllMenuImages(int truckId) async {
    try {
      final ref = _storage.ref().child('trucks/$truckId/menus');
      final listResult = await ref.listAll();

      for (final item in listResult.items) {
        await item.delete();
      }

      AppLogger.success('All menu images deleted for truck #$truckId', tag: 'ImageUploadService');
    } catch (e, stackTrace) {
      AppLogger.error('Error deleting menu images', error: e, stackTrace: stackTrace, tag: 'ImageUploadService');
    }
  }

  /// Delete all review images
  Future<void> deleteAllReviewImages(String reviewId) async {
    try {
      final ref = _storage.ref().child('reviews/$reviewId');
      final listResult = await ref.listAll();

      for (final item in listResult.items) {
        await item.delete();
      }

      AppLogger.success('All review images deleted for review: $reviewId', tag: 'ImageUploadService');
    } catch (e, stackTrace) {
      AppLogger.error('Error deleting review images', error: e, stackTrace: stackTrace, tag: 'ImageUploadService');
    }
  }

  // ═══════════════════════════════════════════════════════════
  // UTILITIES
  // ═══════════════════════════════════════════════════════════

  /// Get file size in MB
  Future<double> getFileSizeMB(XFile file) async {
    final bytes = await file.length();
    return bytes / (1024 * 1024);
  }

  /// Check if file size is within limit
  Future<bool> isFileSizeValid(XFile file, {double maxMB = 5.0}) async {
    final sizeMB = await getFileSizeMB(file);
    return sizeMB <= maxMB;
  }
}





