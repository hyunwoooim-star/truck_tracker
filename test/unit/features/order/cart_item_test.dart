import 'package:flutter_test/flutter_test.dart';
import 'package:truck_tracker/features/order/domain/cart_item.dart';

void main() {
  group('CartItem Model', () {
    late CartItem cartItem;

    setUp(() {
      cartItem = const CartItem(
        menuItemId: 'menu_123',
        menuItemName: '매운 떡볶이',
        price: 7000,
        quantity: 2,
        imageUrl: 'https://example.com/tteokbokki.jpg',
      );
    });

    test('should create CartItem with all fields', () {
      expect(cartItem.menuItemId, 'menu_123');
      expect(cartItem.menuItemName, '매운 떡볶이');
      expect(cartItem.price, 7000);
      expect(cartItem.quantity, 2);
      expect(cartItem.imageUrl, 'https://example.com/tteokbokki.jpg');
    });

    test('should create CartItem with required fields only', () {
      const minimalItem = CartItem(
        menuItemId: 'm1',
        menuItemName: 'Item',
        price: 5000,
        quantity: 1,
      );

      expect(minimalItem.menuItemId, 'm1');
      expect(minimalItem.menuItemName, 'Item');
      expect(minimalItem.price, 5000);
      expect(minimalItem.quantity, 1);
      expect(minimalItem.imageUrl, isEmpty); // default
    });

    group('price', () {
      test('should store positive price', () {
        expect(cartItem.price, 7000);
      });

      test('should allow various price points', () {
        const cheap = CartItem(
          menuItemId: 'm1',
          menuItemName: 'Cheap',
          price: 1000,
          quantity: 1,
        );
        expect(cheap.price, 1000);

        const expensive = CartItem(
          menuItemId: 'm2',
          menuItemName: 'Expensive',
          price: 30000,
          quantity: 1,
        );
        expect(expensive.price, 30000);
      });
    });

    group('quantity', () {
      test('should store quantity', () {
        expect(cartItem.quantity, 2);
      });

      test('should allow single item', () {
        const single = CartItem(
          menuItemId: 'm1',
          menuItemName: 'Single',
          price: 5000,
          quantity: 1,
        );
        expect(single.quantity, 1);
      });

      test('should allow multiple items', () {
        const multiple = CartItem(
          menuItemId: 'm1',
          menuItemName: 'Multiple',
          price: 5000,
          quantity: 10,
        );
        expect(multiple.quantity, 10);
      });
    });

    group('imageUrl', () {
      test('should default to empty string', () {
        const noImage = CartItem(
          menuItemId: 'm1',
          menuItemName: 'No Image',
          price: 5000,
          quantity: 1,
        );
        expect(noImage.imageUrl, isEmpty);
      });

      test('should store imageUrl when provided', () {
        expect(cartItem.imageUrl, 'https://example.com/tteokbokki.jpg');
      });
    });

    group('copyWith', () {
      test('should create copy with updated quantity', () {
        final updated = cartItem.copyWith(quantity: 5);

        expect(updated.quantity, 5);
        expect(updated.menuItemId, cartItem.menuItemId); // unchanged
        expect(updated.price, cartItem.price); // unchanged
      });

      test('should create copy with updated price', () {
        final updated = cartItem.copyWith(price: 8000);

        expect(updated.price, 8000);
        expect(updated.quantity, cartItem.quantity); // unchanged
      });
    });

    group('Korean food cart items', () {
      test('should handle tteokbokki', () {
        const tteokbokki = CartItem(
          menuItemId: 'm1',
          menuItemName: '떡볶이',
          price: 5000,
          quantity: 2,
        );
        expect(tteokbokki.menuItemName, '떡볶이');
      });

      test('should handle sundae', () {
        const sundae = CartItem(
          menuItemId: 'm2',
          menuItemName: '순대',
          price: 4000,
          quantity: 1,
        );
        expect(sundae.menuItemName, '순대');
      });

      test('should handle combo set', () {
        const combo = CartItem(
          menuItemId: 'm3',
          menuItemName: '떡볶이 + 순대 세트',
          price: 8000,
          quantity: 1,
        );
        expect(combo.menuItemName, '떡볶이 + 순대 세트');
        expect(combo.price, 8000);
      });
    });
  });
}
