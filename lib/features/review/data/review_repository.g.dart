// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$reviewRepositoryHash() => r'7fd924fac12f53f0c8e56e7492a6158592e5ffcf';

/// See also [reviewRepository].
@ProviderFor(reviewRepository)
final reviewRepositoryProvider = AutoDisposeProvider<ReviewRepository>.internal(
  reviewRepository,
  name: r'reviewRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$reviewRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ReviewRepositoryRef = AutoDisposeProviderRef<ReviewRepository>;
String _$truckReviewsHash() => r'b85dd95b6bf1b94782de9c3d2b34f3bc6827c888';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Provider for watching reviews of a specific truck
///
/// Copied from [truckReviews].
@ProviderFor(truckReviews)
const truckReviewsProvider = TruckReviewsFamily();

/// Provider for watching reviews of a specific truck
///
/// Copied from [truckReviews].
class TruckReviewsFamily extends Family<AsyncValue<List<Review>>> {
  /// Provider for watching reviews of a specific truck
  ///
  /// Copied from [truckReviews].
  const TruckReviewsFamily();

  /// Provider for watching reviews of a specific truck
  ///
  /// Copied from [truckReviews].
  TruckReviewsProvider call(String truckId) {
    return TruckReviewsProvider(truckId);
  }

  @override
  TruckReviewsProvider getProviderOverride(
    covariant TruckReviewsProvider provider,
  ) {
    return call(provider.truckId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'truckReviewsProvider';
}

/// Provider for watching reviews of a specific truck
///
/// Copied from [truckReviews].
class TruckReviewsProvider extends AutoDisposeStreamProvider<List<Review>> {
  /// Provider for watching reviews of a specific truck
  ///
  /// Copied from [truckReviews].
  TruckReviewsProvider(String truckId)
    : this._internal(
        (ref) => truckReviews(ref as TruckReviewsRef, truckId),
        from: truckReviewsProvider,
        name: r'truckReviewsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$truckReviewsHash,
        dependencies: TruckReviewsFamily._dependencies,
        allTransitiveDependencies:
            TruckReviewsFamily._allTransitiveDependencies,
        truckId: truckId,
      );

  TruckReviewsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.truckId,
  }) : super.internal();

  final String truckId;

  @override
  Override overrideWith(
    Stream<List<Review>> Function(TruckReviewsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TruckReviewsProvider._internal(
        (ref) => create(ref as TruckReviewsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        truckId: truckId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Review>> createElement() {
    return _TruckReviewsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TruckReviewsProvider && other.truckId == truckId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, truckId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TruckReviewsRef on AutoDisposeStreamProviderRef<List<Review>> {
  /// The parameter `truckId` of this provider.
  String get truckId;
}

class _TruckReviewsProviderElement
    extends AutoDisposeStreamProviderElement<List<Review>>
    with TruckReviewsRef {
  _TruckReviewsProviderElement(super.provider);

  @override
  String get truckId => (origin as TruckReviewsProvider).truckId;
}

String _$truckAverageRatingHash() =>
    r'9b5abcc21769c08a8a4c3f56680526dd4dccd37e';

/// Provider for average rating of a truck
///
/// Copied from [truckAverageRating].
@ProviderFor(truckAverageRating)
const truckAverageRatingProvider = TruckAverageRatingFamily();

/// Provider for average rating of a truck
///
/// Copied from [truckAverageRating].
class TruckAverageRatingFamily extends Family<AsyncValue<double>> {
  /// Provider for average rating of a truck
  ///
  /// Copied from [truckAverageRating].
  const TruckAverageRatingFamily();

  /// Provider for average rating of a truck
  ///
  /// Copied from [truckAverageRating].
  TruckAverageRatingProvider call(String truckId) {
    return TruckAverageRatingProvider(truckId);
  }

  @override
  TruckAverageRatingProvider getProviderOverride(
    covariant TruckAverageRatingProvider provider,
  ) {
    return call(provider.truckId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'truckAverageRatingProvider';
}

/// Provider for average rating of a truck
///
/// Copied from [truckAverageRating].
class TruckAverageRatingProvider extends AutoDisposeFutureProvider<double> {
  /// Provider for average rating of a truck
  ///
  /// Copied from [truckAverageRating].
  TruckAverageRatingProvider(String truckId)
    : this._internal(
        (ref) => truckAverageRating(ref as TruckAverageRatingRef, truckId),
        from: truckAverageRatingProvider,
        name: r'truckAverageRatingProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$truckAverageRatingHash,
        dependencies: TruckAverageRatingFamily._dependencies,
        allTransitiveDependencies:
            TruckAverageRatingFamily._allTransitiveDependencies,
        truckId: truckId,
      );

  TruckAverageRatingProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.truckId,
  }) : super.internal();

  final String truckId;

  @override
  Override overrideWith(
    FutureOr<double> Function(TruckAverageRatingRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TruckAverageRatingProvider._internal(
        (ref) => create(ref as TruckAverageRatingRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        truckId: truckId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<double> createElement() {
    return _TruckAverageRatingProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TruckAverageRatingProvider && other.truckId == truckId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, truckId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TruckAverageRatingRef on AutoDisposeFutureProviderRef<double> {
  /// The parameter `truckId` of this provider.
  String get truckId;
}

class _TruckAverageRatingProviderElement
    extends AutoDisposeFutureProviderElement<double>
    with TruckAverageRatingRef {
  _TruckAverageRatingProviderElement(super.provider);

  @override
  String get truckId => (origin as TruckAverageRatingProvider).truckId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
