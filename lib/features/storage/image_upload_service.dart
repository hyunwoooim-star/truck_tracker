import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/utils/app_logger.dart';

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

  /// Upload truck main image
  Future<String> uploadTruckImage(XFile image, int truckId) async {
    AppLogger.debug('Uploading truck #$truckId main image', tag: 'ImageUploadService');

    try {
      final bytes = await image.readAsBytes();
      final path = 'trucks/$truckId/main.jpg';

      return await _uploadBytes(bytes, path);
    } catch (e, stackTrace) {
      AppLogger.error('Error uploading truck image', error: e, stackTrace: stackTrace, tag: 'ImageUploadService');
      rethrow;
    }
  }

  /// Upload menu item image
  Future<String> uploadMenuImage(
    XFile image,
    int truckId,
    String menuId,
  ) async {
    AppLogger.debug('Uploading menu image for truck #$truckId, menu: $menuId', tag: 'ImageUploadService');

    try {
      final bytes = await image.readAsBytes();
      final path = 'trucks/$truckId/menus/$menuId.jpg';

      return await _uploadBytes(bytes, path);
    } catch (e, stackTrace) {
      AppLogger.error('Error uploading menu image', error: e, stackTrace: stackTrace, tag: 'ImageUploadService');
      rethrow;
    }
  }

  // ═══════════════════════════════════════════════════════════
  // REVIEW IMAGE UPLOAD
  // ═══════════════════════════════════════════════════════════

  /// Upload review images
  Future<List<String>> uploadReviewImages(
    List<XFile> images,
    String reviewId,
  ) async {
    AppLogger.debug('Uploading ${images.length} review images for review: $reviewId', tag: 'ImageUploadService');

    try {
      final List<String> urls = [];

      for (int i = 0; i < images.length; i++) {
        final bytes = await images[i].readAsBytes();
        final path = 'reviews/$reviewId/photo_$i.jpg';

        final url = await _uploadBytes(bytes, path);
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
  // CORE UPLOAD FUNCTION
  // ═══════════════════════════════════════════════════════════

  /// Upload bytes to Firebase Storage
  Future<String> _uploadBytes(Uint8List bytes, String path) async {
    try {
      final ref = _storage.ref().child(path);

      // Set metadata
      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {
          'uploadedAt': DateTime.now().toIso8601String(),
        },
      );

      // Upload
      final uploadTask = ref.putData(bytes, metadata);

      // Wait for completion
      final snapshot = await uploadTask;

      // Get download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();

      AppLogger.success('Upload successful: $path', tag: 'ImageUploadService');
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





