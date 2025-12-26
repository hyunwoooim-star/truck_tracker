import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

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
        debugPrint('📸 Image picked: ${image.name} (${await image.length()} bytes)');
      }
      
      return image;
    } catch (e) {
      debugPrint('❌ Error picking image: $e');
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
        debugPrint('📸 Image captured: ${image.name} (${await image.length()} bytes)');
      }
      
      return image;
    } catch (e) {
      debugPrint('❌ Error capturing image: $e');
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
      
      debugPrint('📸 ${limitedImages.length} images picked');
      
      return limitedImages;
    } catch (e) {
      debugPrint('❌ Error picking multiple images: $e');
      return [];
    }
  }

  // ═════════════════════════════════════════════════════════════
  // TRUCK IMAGE UPLOAD
  // ═══════════════════════════════════════════════════════════

  /// Upload truck main image
  Future<String> uploadTruckImage(XFile image, int truckId) async {
    debugPrint('📤 Uploading truck #$truckId main image');
    
    try {
      final bytes = await image.readAsBytes();
      final path = 'trucks/$truckId/main.jpg';
      
      return await _uploadBytes(bytes, path);
    } catch (e) {
      debugPrint('❌ Error uploading truck image: $e');
      rethrow;
    }
  }

  /// Upload menu item image
  Future<String> uploadMenuImage(
    XFile image,
    int truckId,
    String menuId,
  ) async {
    debugPrint('📤 Uploading menu image for truck #$truckId, menu: $menuId');
    
    try {
      final bytes = await image.readAsBytes();
      final path = 'trucks/$truckId/menus/$menuId.jpg';
      
      return await _uploadBytes(bytes, path);
    } catch (e) {
      debugPrint('❌ Error uploading menu image: $e');
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
    debugPrint('📤 Uploading ${images.length} review images for review: $reviewId');
    
    try {
      final List<String> urls = [];
      
      for (int i = 0; i < images.length; i++) {
        final bytes = await images[i].readAsBytes();
        final path = 'reviews/$reviewId/photo_$i.jpg';
        
        final url = await _uploadBytes(bytes, path);
        urls.add(url);
        
        debugPrint('   ✅ Uploaded photo $i: $url');
      }
      
      debugPrint('✅ All review images uploaded: ${urls.length}');
      return urls;
    } catch (e) {
      debugPrint('❌ Error uploading review images: $e');
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
      
      debugPrint('✅ Upload successful: $path');
      debugPrint('   URL: $downloadUrl');
      
      return downloadUrl;
    } catch (e) {
      debugPrint('❌ Error uploading bytes: $e');
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
      debugPrint('✅ Image deleted: $url');
    } catch (e) {
      debugPrint('❌ Error deleting image: $e');
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
      
      debugPrint('✅ All menu images deleted for truck #$truckId');
    } catch (e) {
      debugPrint('❌ Error deleting menu images: $e');
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
      
      debugPrint('✅ All review images deleted for review: $reviewId');
    } catch (e) {
      debugPrint('❌ Error deleting review images: $e');
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





