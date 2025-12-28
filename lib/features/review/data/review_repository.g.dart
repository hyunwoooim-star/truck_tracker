// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(reviewRepository)
final reviewRepositoryProvider = ReviewRepositoryProvider._();

final class ReviewRepositoryProvider
    extends
        $FunctionalProvider<
          ReviewRepository,
          ReviewRepository,
          ReviewRepository
        >
    with $Provider<ReviewRepository> {
  ReviewRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reviewRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reviewRepositoryHash();

  @$internal
  @override
  $ProviderElement<ReviewRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ReviewRepository create(Ref ref) {
    return reviewRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReviewRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReviewRepository>(value),
    );
  }
}

String _$reviewRepositoryHash() => r'7fd924fac12f53f0c8e56e7492a6158592e5ffcf';

/// Provider for watching reviews of a specific truck

@ProviderFor(truckReviews)
final truckReviewsProvider = TruckReviewsFamily._();

/// Provider for watching reviews of a specific truck

final class TruckReviewsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Review>>,
          List<Review>,
          Stream<List<Review>>
        >
    with $FutureModifier<List<Review>>, $StreamProvider<List<Review>> {
  /// Provider for watching reviews of a specific truck
  TruckReviewsProvider._({
    required TruckReviewsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'truckReviewsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$truckReviewsHash();

  @override
  String toString() {
    return r'truckReviewsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Review>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Review>> create(Ref ref) {
    final argument = this.argument as String;
    return truckReviews(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TruckReviewsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$truckReviewsHash() => r'b85dd95b6bf1b94782de9c3d2b34f3bc6827c888';

/// Provider for watching reviews of a specific truck

final class TruckReviewsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Review>>, String> {
  TruckReviewsFamily._()
    : super(
        retry: null,
        name: r'truckReviewsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for watching reviews of a specific truck

  TruckReviewsProvider call(String truckId) =>
      TruckReviewsProvider._(argument: truckId, from: this);

  @override
  String toString() => r'truckReviewsProvider';
}

/// Provider for average rating of a truck

@ProviderFor(truckAverageRating)
final truckAverageRatingProvider = TruckAverageRatingFamily._();

/// Provider for average rating of a truck

final class TruckAverageRatingProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  /// Provider for average rating of a truck
  TruckAverageRatingProvider._({
    required TruckAverageRatingFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'truckAverageRatingProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$truckAverageRatingHash();

  @override
  String toString() {
    return r'truckAverageRatingProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<double> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double> create(Ref ref) {
    final argument = this.argument as String;
    return truckAverageRating(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TruckAverageRatingProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$truckAverageRatingHash() =>
    r'9b5abcc21769c08a8a4c3f56680526dd4dccd37e';

/// Provider for average rating of a truck

final class TruckAverageRatingFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<double>, String> {
  TruckAverageRatingFamily._()
    : super(
        retry: null,
        name: r'truckAverageRatingProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for average rating of a truck

  TruckAverageRatingProvider call(String truckId) =>
      TruckAverageRatingProvider._(argument: truckId, from: this);

  @override
  String toString() => r'truckAverageRatingProvider';
}
