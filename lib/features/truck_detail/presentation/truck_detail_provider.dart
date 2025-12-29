import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/truck_detail.dart';
import '../data/truck_detail_repository.dart';

part 'truck_detail_provider.g.dart';

@riverpod
TruckDetailRepository truckDetailRepository(Ref ref) {
  return TruckDetailRepository();
}

@riverpod
Stream<TruckDetail?> truckDetailStream(Ref ref, String truckId) {
  final repository = ref.watch(truckDetailRepositoryProvider);
  return repository.watchTruckDetail(truckId);
}

@riverpod
class TruckDetailNotifier extends _$TruckDetailNotifier {
  @override
  Stream<TruckDetail?> build(String truckId) {
    final repository = ref.watch(truckDetailRepositoryProvider);
    return repository.watchTruckDetail(truckId);
  }

  Future<void> toggleMenuItemSoldOut(String menuItemId) async {
    final repository = ref.read(truckDetailRepositoryProvider);
    await repository.toggleMenuItemSoldOut(truckId, menuItemId);
  }
}
