import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/themes/app_theme.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../data/social_repository.dart';
import '../domain/post.dart';

/// Screen for creating a new post
class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({
    super.key,
    this.truckId,
    this.truckName,
  });

  final String? truckId;
  final String? truckName;

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final _contentController = TextEditingController();
  final _imagePicker = ImagePicker();
  final List<XFile> _selectedImages = [];
  bool _isSubmitting = false;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    if (_selectedImages.length >= 10) {
      SnackBarHelper.showWarning(context, '최대 10장까지 선택할 수 있습니다');
      return;
    }

    final images = await _imagePicker.pickMultiImage(
      maxWidth: 1080,
      maxHeight: 1080,
      imageQuality: 85,
    );

    if (images.isNotEmpty) {
      setState(() {
        final remaining = 10 - _selectedImages.length;
        _selectedImages.addAll(images.take(remaining));
      });
    }
  }

  Future<void> _takePhoto() async {
    if (_selectedImages.length >= 10) {
      SnackBarHelper.showWarning(context, '최대 10장까지 선택할 수 있습니다');
      return;
    }

    final image = await _imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1080,
      maxHeight: 1080,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _selectedImages.add(image);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<List<String>> _uploadImages() async {
    final urls = <String>[];
    final storage = FirebaseStorage.instance;

    for (int i = 0; i < _selectedImages.length; i++) {
      final image = _selectedImages[i];
      final ref = storage.ref().child(
            'posts/${DateTime.now().millisecondsSinceEpoch}_$i.jpg',
          );

      if (kIsWeb) {
        final bytes = await image.readAsBytes();
        await ref.putData(bytes, SettableMetadata(contentType: 'image/jpeg'));
      } else {
        await ref.putFile(File(image.path));
      }

      final url = await ref.getDownloadURL();
      urls.add(url);
    }

    return urls;
  }

  Future<void> _submitPost() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      SnackBarHelper.showWarning(context, AppLocalizations.of(context).loginRequired);
      return;
    }

    final content = _contentController.text.trim();
    if (content.isEmpty && _selectedImages.isEmpty) {
      SnackBarHelper.showWarning(context, '내용이나 사진을 추가해주세요');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Upload images
      final imageUrls = await _uploadImages();

      // Extract hashtags
      final hashtags = Post.extractHashtags(content);

      // Create post
      final post = Post(
        id: '',
        authorId: user.uid,
        authorName: user.displayName ?? user.email ?? 'User',
        authorProfileUrl: user.photoURL,
        truckId: widget.truckId,
        truckName: widget.truckName,
        content: content,
        imageUrls: imageUrls,
        hashtags: hashtags,
      );

      final repository = ref.read(socialRepositoryProvider);
      await repository.createPost(post);

      // Refresh feed
      ref.invalidate(feedPostsProvider);

      if (mounted) {
        SnackBarHelper.showSuccess(context, '게시물이 등록되었습니다');
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, '게시물 등록 실패: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('새 게시물'),
        actions: [
          TextButton(
            onPressed: _isSubmitting ? null : _submitPost,
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTheme.electricBlue,
                    ),
                  )
                : Text(
                    '공유',
                    style: TextStyle(
                      color: AppTheme.electricBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image selection
            if (_selectedImages.isNotEmpty)
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(16),
                  itemCount: _selectedImages.length + 1,
                  itemBuilder: (context, index) {
                    if (index == _selectedImages.length) {
                      // Add more button
                      return GestureDetector(
                        onTap: _pickImages,
                        child: Container(
                          width: 150,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: AppTheme.charcoalMedium,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.charcoalLight,
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate,
                                size: 32,
                                color: AppTheme.textTertiary,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '사진 추가',
                                style: TextStyle(
                                  color: AppTheme.textTertiary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    final image = _selectedImages[index];
                    return Stack(
                      children: [
                        Container(
                          width: 150,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: kIsWeb
                              ? Image.network(
                                  image.path,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  File(image.path),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Positioned(
                          top: 4,
                          right: 12,
                          child: GestureDetector(
                            onTap: () => _removeImage(index),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.6),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              )
            else
              // Empty image placeholder
              GestureDetector(
                onTap: _pickImages,
                child: Container(
                  height: 200,
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.charcoalMedium,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.charcoalLight,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate,
                        size: 48,
                        color: AppTheme.textTertiary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '사진을 추가하세요',
                        style: TextStyle(
                          color: AppTheme.textTertiary,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '최대 10장까지 선택 가능',
                        style: TextStyle(
                          color: AppTheme.textTertiary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Image picker buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickImages,
                      icon: const Icon(Icons.photo_library),
                      label: const Text('갤러리'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.textPrimary,
                        side: const BorderSide(color: AppTheme.charcoalLight),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _takePhoto,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('카메라'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.textPrimary,
                        side: const BorderSide(color: AppTheme.charcoalLight),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Truck tag (if provided)
            if (widget.truckName != null)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.electricBlue.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.local_shipping,
                      size: 16,
                      color: AppTheme.electricBlue,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.truckName!,
                      style: TextStyle(
                        color: AppTheme.electricBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

            // Content input
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _contentController,
                maxLines: 5,
                minLines: 3,
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: InputDecoration(
                  hintText: '문구를 입력하세요...\n\n#해시태그를 사용해보세요!',
                  hintStyle: TextStyle(color: AppTheme.textTertiary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.charcoalLight),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.charcoalLight),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.electricBlue),
                  ),
                  filled: true,
                  fillColor: AppTheme.charcoalMedium,
                ),
              ),
            ),

            // Hashtag suggestions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '추천 해시태그',
                    style: TextStyle(
                      color: AppTheme.textTertiary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _HashtagChip(
                        tag: '맛집',
                        onTap: () => _addHashtag('맛집'),
                      ),
                      _HashtagChip(
                        tag: '푸드트럭',
                        onTap: () => _addHashtag('푸드트럭'),
                      ),
                      _HashtagChip(
                        tag: '먹스타그램',
                        onTap: () => _addHashtag('먹스타그램'),
                      ),
                      _HashtagChip(
                        tag: '강남',
                        onTap: () => _addHashtag('강남'),
                      ),
                      _HashtagChip(
                        tag: '타코',
                        onTap: () => _addHashtag('타코'),
                      ),
                      _HashtagChip(
                        tag: '치킨',
                        onTap: () => _addHashtag('치킨'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _addHashtag(String tag) {
    final currentText = _contentController.text;
    if (!currentText.contains('#$tag')) {
      _contentController.text = currentText.isEmpty
          ? '#$tag '
          : '$currentText #$tag ';
      _contentController.selection = TextSelection.fromPosition(
        TextPosition(offset: _contentController.text.length),
      );
    }
  }
}

class _HashtagChip extends StatelessWidget {
  const _HashtagChip({
    required this.tag,
    required this.onTap,
  });

  final String tag;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.charcoalMedium,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.charcoalLight),
        ),
        child: Text(
          '#$tag',
          style: TextStyle(
            color: AppTheme.electricBlue,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
