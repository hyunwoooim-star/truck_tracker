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

String _$socialRepositoryHash() => r'a8b62b6868d777b6f0f1b69d2d373630d05d8eda';

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

String _$feedPostsHash() => r'2c64a67d428ab5354453df6a5133ff40801f5598';

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

String _$postsByHashtagHash() => r'6c17e814f7ad09c649892fa359967ffb5f0dad32';

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

String _$postsByTruckHash() => r'533ec3a75d28b69b8104461b37a49afef9228d7a';

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

String _$postCommentsHash() => r'd9520cd354ff08487a8504b56b694b6e62b7082a';

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

String _$trendingHashtagsHash() => r'921d9df7123135ea4bc40cb1fb32478ff2017bbf';
