// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(socialRepository)
final socialRepositoryProvider = SocialRepositoryProvider._();

final class SocialRepositoryProvider
    extends
        $FunctionalProvider<
          SocialRepository,
          SocialRepository,
          SocialRepository
        >
    with $Provider<SocialRepository> {
  SocialRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'socialRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$socialRepositoryHash();

  @$internal
  @override
  $ProviderElement<SocialRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SocialRepository create(Ref ref) {
    return socialRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SocialRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SocialRepository>(value),
    );
  }
}

String _$socialRepositoryHash() => r'7d569754b12b03553210270401408164b2eaeeb9';

@ProviderFor(feedPosts)
final feedPostsProvider = FeedPostsProvider._();

final class FeedPostsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Post>>,
          List<Post>,
          Stream<List<Post>>
        >
    with $FutureModifier<List<Post>>, $StreamProvider<List<Post>> {
  FeedPostsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'feedPostsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$feedPostsHash();

  @$internal
  @override
  $StreamProviderElement<List<Post>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Post>> create(Ref ref) {
    return feedPosts(ref);
  }
}

String _$feedPostsHash() => r'41e93199f6a655ad705425c9dac19a751b83d31b';

@ProviderFor(postsByHashtag)
final postsByHashtagProvider = PostsByHashtagFamily._();

final class PostsByHashtagProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Post>>,
          List<Post>,
          Stream<List<Post>>
        >
    with $FutureModifier<List<Post>>, $StreamProvider<List<Post>> {
  PostsByHashtagProvider._({
    required PostsByHashtagFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'postsByHashtagProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$postsByHashtagHash();

  @override
  String toString() {
    return r'postsByHashtagProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Post>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Post>> create(Ref ref) {
    final argument = this.argument as String;
    return postsByHashtag(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PostsByHashtagProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$postsByHashtagHash() => r'd027fa98ad418fe4150443e9973eda8dea0a14f8';

final class PostsByHashtagFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Post>>, String> {
  PostsByHashtagFamily._()
    : super(
        retry: null,
        name: r'postsByHashtagProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PostsByHashtagProvider call(String hashtag) =>
      PostsByHashtagProvider._(argument: hashtag, from: this);

  @override
  String toString() => r'postsByHashtagProvider';
}

@ProviderFor(postsByTruck)
final postsByTruckProvider = PostsByTruckFamily._();

final class PostsByTruckProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Post>>,
          List<Post>,
          Stream<List<Post>>
        >
    with $FutureModifier<List<Post>>, $StreamProvider<List<Post>> {
  PostsByTruckProvider._({
    required PostsByTruckFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'postsByTruckProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$postsByTruckHash();

  @override
  String toString() {
    return r'postsByTruckProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Post>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Post>> create(Ref ref) {
    final argument = this.argument as String;
    return postsByTruck(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PostsByTruckProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$postsByTruckHash() => r'1126cda7d36fbcea8899c4b12e76b4be669d4a33';

final class PostsByTruckFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Post>>, String> {
  PostsByTruckFamily._()
    : super(
        retry: null,
        name: r'postsByTruckProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PostsByTruckProvider call(String truckId) =>
      PostsByTruckProvider._(argument: truckId, from: this);

  @override
  String toString() => r'postsByTruckProvider';
}

@ProviderFor(postComments)
final postCommentsProvider = PostCommentsFamily._();

final class PostCommentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Comment>>,
          List<Comment>,
          Stream<List<Comment>>
        >
    with $FutureModifier<List<Comment>>, $StreamProvider<List<Comment>> {
  PostCommentsProvider._({
    required PostCommentsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'postCommentsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$postCommentsHash();

  @override
  String toString() {
    return r'postCommentsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Comment>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Comment>> create(Ref ref) {
    final argument = this.argument as String;
    return postComments(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PostCommentsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$postCommentsHash() => r'b9e8f1113dac8b1f0ab918d0ec315ca9bbf45651';

final class PostCommentsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Comment>>, String> {
  PostCommentsFamily._()
    : super(
        retry: null,
        name: r'postCommentsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PostCommentsProvider call(String postId) =>
      PostCommentsProvider._(argument: postId, from: this);

  @override
  String toString() => r'postCommentsProvider';
}

@ProviderFor(trendingHashtags)
final trendingHashtagsProvider = TrendingHashtagsProvider._();

final class TrendingHashtagsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  TrendingHashtagsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trendingHashtagsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trendingHashtagsHash();

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    return trendingHashtags(ref);
  }
}

String _$trendingHashtagsHash() => r'6c9f915fc224dfaad8a184db2d2a7caa243e8029';
