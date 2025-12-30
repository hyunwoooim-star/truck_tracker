import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../core/themes/app_theme.dart';

/// A web-compatible image widget that handles platform differences.
///
/// On mobile platforms, uses CachedNetworkImage for caching.
/// On web, uses Image.network with proper error handling and placeholder.
///
/// This solves the issue where CachedNetworkImage may not work properly
/// on web due to different caching mechanisms and CORS issues.
class WebSafeImage extends StatelessWidget {
  const WebSafeImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.placeholder,
    this.errorWidget,
    this.memCacheWidth,
    this.memCacheHeight,
    this.borderRadius,
  });

  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget? placeholder;
  final Widget? errorWidget;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final defaultPlaceholder = placeholder ?? Container(
      color: AppTheme.charcoalMedium,
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppTheme.electricBlue,
        ),
      ),
    );

    final defaultErrorWidget = errorWidget ?? Container(
      color: AppTheme.charcoalMedium,
      child: const Center(
        child: Icon(
          Icons.local_shipping,
          size: 40,
          color: AppTheme.textTertiary,
        ),
      ),
    );

    Widget imageWidget;

    if (kIsWeb) {
      // Web: Use Image.network with error handling
      // CachedNetworkImage doesn't work well on web
      imageWidget = Image.network(
        imageUrl,
        fit: fit,
        width: width,
        height: height,
        cacheWidth: memCacheWidth,
        cacheHeight: memCacheHeight,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return defaultPlaceholder;
        },
        errorBuilder: (context, error, stackTrace) {
          return defaultErrorWidget;
        },
      );
    } else {
      // Mobile: Use CachedNetworkImage for caching
      imageWidget = CachedNetworkImage(
        imageUrl: imageUrl,
        fit: fit,
        width: width,
        height: height,
        memCacheWidth: memCacheWidth,
        memCacheHeight: memCacheHeight,
        placeholder: (_, __) => defaultPlaceholder,
        errorWidget: (_, __, ___) => defaultErrorWidget,
      );
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}

/// A circular avatar variant of WebSafeImage
class WebSafeCircleAvatar extends StatelessWidget {
  const WebSafeCircleAvatar({
    super.key,
    required this.imageUrl,
    this.radius = 20,
    this.backgroundColor,
    this.child,
  });

  final String imageUrl;
  final double radius;
  final Color? backgroundColor;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor ?? AppTheme.charcoalMedium,
        backgroundImage: NetworkImage(imageUrl),
        onBackgroundImageError: (_, __) {},
        child: child,
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor ?? AppTheme.charcoalMedium,
        backgroundImage: imageProvider,
        child: child,
      ),
      placeholder: (_, __) => CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor ?? AppTheme.charcoalMedium,
        child: child ?? Icon(
          Icons.person,
          size: radius,
          color: AppTheme.textTertiary,
        ),
      ),
      errorWidget: (_, __, ___) => CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor ?? AppTheme.charcoalMedium,
        child: child ?? Icon(
          Icons.person,
          size: radius,
          color: AppTheme.textTertiary,
        ),
      ),
    );
  }
}
