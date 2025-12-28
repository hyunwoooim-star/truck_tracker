// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_preferences_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(notificationPreferencesRepository)
final notificationPreferencesRepositoryProvider =
    NotificationPreferencesRepositoryProvider._();

final class NotificationPreferencesRepositoryProvider
    extends
        $FunctionalProvider<
          NotificationPreferencesRepository,
          NotificationPreferencesRepository,
          NotificationPreferencesRepository
        >
    with $Provider<NotificationPreferencesRepository> {
  NotificationPreferencesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationPreferencesRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$notificationPreferencesRepositoryHash();

  @$internal
  @override
  $ProviderElement<NotificationPreferencesRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NotificationPreferencesRepository create(Ref ref) {
    return notificationPreferencesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationPreferencesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationPreferencesRepository>(
        value,
      ),
    );
  }
}

String _$notificationPreferencesRepositoryHash() =>
    r'ec09c8318cf9c793ee7726c9348b1a8e20ccbf40';

@ProviderFor(notificationSettings)
final notificationSettingsProvider = NotificationSettingsFamily._();

final class NotificationSettingsProvider
    extends
        $FunctionalProvider<
          AsyncValue<NotificationSettings>,
          NotificationSettings,
          FutureOr<NotificationSettings>
        >
    with
        $FutureModifier<NotificationSettings>,
        $FutureProvider<NotificationSettings> {
  NotificationSettingsProvider._({
    required NotificationSettingsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'notificationSettingsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$notificationSettingsHash();

  @override
  String toString() {
    return r'notificationSettingsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<NotificationSettings> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<NotificationSettings> create(Ref ref) {
    final argument = this.argument as String;
    return notificationSettings(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is NotificationSettingsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$notificationSettingsHash() =>
    r'b3aa82c64bfa66a50856c8f0433bb83d3ca9f80b';

final class NotificationSettingsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<NotificationSettings>, String> {
  NotificationSettingsFamily._()
    : super(
        retry: null,
        name: r'notificationSettingsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  NotificationSettingsProvider call(String userId) =>
      NotificationSettingsProvider._(argument: userId, from: this);

  @override
  String toString() => r'notificationSettingsProvider';
}

@ProviderFor(notificationSettingsStream)
final notificationSettingsStreamProvider = NotificationSettingsStreamFamily._();

final class NotificationSettingsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<NotificationSettings>,
          NotificationSettings,
          Stream<NotificationSettings>
        >
    with
        $FutureModifier<NotificationSettings>,
        $StreamProvider<NotificationSettings> {
  NotificationSettingsStreamProvider._({
    required NotificationSettingsStreamFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'notificationSettingsStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$notificationSettingsStreamHash();

  @override
  String toString() {
    return r'notificationSettingsStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<NotificationSettings> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<NotificationSettings> create(Ref ref) {
    final argument = this.argument as String;
    return notificationSettingsStream(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is NotificationSettingsStreamProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$notificationSettingsStreamHash() =>
    r'e565ec7328d62877074d6d63e617999a0fe6afce';

final class NotificationSettingsStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<NotificationSettings>, String> {
  NotificationSettingsStreamFamily._()
    : super(
        retry: null,
        name: r'notificationSettingsStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  NotificationSettingsStreamProvider call(String userId) =>
      NotificationSettingsStreamProvider._(argument: userId, from: this);

  @override
  String toString() => r'notificationSettingsStreamProvider';
}
