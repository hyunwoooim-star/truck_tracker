// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(notificationRepository)
final notificationRepositoryProvider = NotificationRepositoryProvider._();

final class NotificationRepositoryProvider
    extends
        $FunctionalProvider<
          NotificationRepository,
          NotificationRepository,
          NotificationRepository
        >
    with $Provider<NotificationRepository> {
  NotificationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationRepositoryHash();

  @$internal
  @override
  $ProviderElement<NotificationRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NotificationRepository create(Ref ref) {
    return notificationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationRepository>(value),
    );
  }
}

String _$notificationRepositoryHash() =>
    r'30f9b069679a4dd2537b0e66a71826e8349a5512';

@ProviderFor(userNotifications)
final userNotificationsProvider = UserNotificationsFamily._();

final class UserNotificationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AppNotification>>,
          List<AppNotification>,
          Stream<List<AppNotification>>
        >
    with
        $FutureModifier<List<AppNotification>>,
        $StreamProvider<List<AppNotification>> {
  UserNotificationsProvider._({
    required UserNotificationsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userNotificationsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userNotificationsHash();

  @override
  String toString() {
    return r'userNotificationsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<AppNotification>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<AppNotification>> create(Ref ref) {
    final argument = this.argument as String;
    return userNotifications(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UserNotificationsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userNotificationsHash() => r'3776d59e386919018d5147d0e6c0bb7c14662339';

final class UserNotificationsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<AppNotification>>, String> {
  UserNotificationsFamily._()
    : super(
        retry: null,
        name: r'userNotificationsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UserNotificationsProvider call(String userId) =>
      UserNotificationsProvider._(argument: userId, from: this);

  @override
  String toString() => r'userNotificationsProvider';
}

@ProviderFor(notificationUnreadCount)
final notificationUnreadCountProvider = NotificationUnreadCountFamily._();

final class NotificationUnreadCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  NotificationUnreadCountProvider._({
    required NotificationUnreadCountFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'notificationUnreadCountProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$notificationUnreadCountHash();

  @override
  String toString() {
    return r'notificationUnreadCountProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    final argument = this.argument as String;
    return notificationUnreadCount(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is NotificationUnreadCountProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$notificationUnreadCountHash() =>
    r'0387bec73ed87b1bf9557e9099946f8f9fe54e43';

final class NotificationUnreadCountFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<int>, String> {
  NotificationUnreadCountFamily._()
    : super(
        retry: null,
        name: r'notificationUnreadCountProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  NotificationUnreadCountProvider call(String userId) =>
      NotificationUnreadCountProvider._(argument: userId, from: this);

  @override
  String toString() => r'notificationUnreadCountProvider';
}
