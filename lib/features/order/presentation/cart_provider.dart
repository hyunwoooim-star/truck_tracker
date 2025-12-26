import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/cart_item.dart';

part 'cart_provider.g.dart';

/// Cart state for menu selection
class CartState {
  final String? truckId;
  final String? truckName;
  final List<CartItem> items;

  const CartState({
    this.truckId,
    this.truckName,
    this.items = const [],
  });

  int get totalAmount =>
      items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  bool get isEmpty => items.isEmpty;

  CartState copyWith({
    String? truckId,
    String? truckName,
    List<CartItem>? items,
  }) {
    return CartState(
      truckId: truckId ?? this.truckId,
      truckName: truckName ?? this.truckName,
      items: items ?? this.items,
    );
  }
}

/// Cart provider for managing menu selections
@riverpod
class Cart extends _$Cart {
  @override
  CartState build() {
    return const CartState();
  }

  /// Add item to cart
  void addItem({
    required String truckId,
    required String truckName,
    required String menuItemId,
    required String menuItemName,
    required int price,
    String imageUrl = '',
  }) {
    // If cart is for a different truck, clear it first
    if (state.truckId != null && state.truckId != truckId) {
      state = const CartState();
    }

    final existingItemIndex =
        state.items.indexWhere((item) => item.menuItemId == menuItemId);

    List<CartItem> updatedItems;

    if (existingItemIndex >= 0) {
      // Item exists, increase quantity
      updatedItems = List.from(state.items);
      final existingItem = updatedItems[existingItemIndex];
      updatedItems[existingItemIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + 1,
      );
    } else {
      // New item, add to cart
      updatedItems = [
        ...state.items,
        CartItem(
          menuItemId: menuItemId,
          menuItemName: menuItemName,
          price: price,
          quantity: 1,
          imageUrl: imageUrl,
        ),
      ];
    }

    state = CartState(
      truckId: truckId,
      truckName: truckName,
      items: updatedItems,
    );
  }

  /// Remove item from cart
  void removeItem(String menuItemId) {
    final updatedItems =
        state.items.where((item) => item.menuItemId != menuItemId).toList();

    if (updatedItems.isEmpty) {
      state = const CartState();
    } else {
      state = state.copyWith(items: updatedItems);
    }
  }

  /// Decrease item quantity
  void decreaseQuantity(String menuItemId) {
    final existingItemIndex =
        state.items.indexWhere((item) => item.menuItemId == menuItemId);

    if (existingItemIndex < 0) return;

    final existingItem = state.items[existingItemIndex];

    if (existingItem.quantity <= 1) {
      // Remove item if quantity is 1
      removeItem(menuItemId);
    } else {
      // Decrease quantity
      final updatedItems = List<CartItem>.from(state.items);
      updatedItems[existingItemIndex] = existingItem.copyWith(
        quantity: existingItem.quantity - 1,
      );

      state = state.copyWith(items: updatedItems);
    }
  }

  /// Clear cart
  void clear() {
    state = const CartState();
  }
}
