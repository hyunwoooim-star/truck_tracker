import 'package:flutter_test/flutter_test.dart';
import 'package:truck_tracker/features/truck_detail/domain/menu_item.dart';

void main() {
  group('MenuItem Model', () {
    late MenuItem menuItem;

    setUp(() {
      menuItem = const MenuItem(
        id: 'menu_123',
        name: '매운 떡볶이',
        price: 7000,
        description: '매콤하고 쫄깃한 떡볶이',
        imageUrl: 'https://example.com/tteokbokki.jpg',
        isSoldOut: false,
      );
    });

    test('should create MenuItem with all fields', () {
      expect(menuItem.id, 'menu_123');
      expect(menuItem.name, '매운 떡볶이');
      expect(menuItem.price, 7000);
      expect(menuItem.description, '매콤하고 쫄깃한 떡볶이');
      expect(menuItem.imageUrl, 'https://example.com/tteokbokki.jpg');
      expect(menuItem.isSoldOut, isFalse);
    });

    test('should create MenuItem with required fields only', () {
      const minimalItem = MenuItem(
        id: 'm1',
        name: '순대',
        price: 5000,
      );

      expect(minimalItem.id, 'm1');
      expect(minimalItem.name, '순대');
      expect(minimalItem.price, 5000);
      expect(minimalItem.description, isEmpty); // default
      expect(minimalItem.imageUrl, isEmpty); // default
      expect(minimalItem.isSoldOut, isFalse); // default
    });

    group('price', () {
      test('should store positive price', () {
        expect(menuItem.price, 7000);
      });

      test('should allow various price points', () {
        const cheapItem = MenuItem(id: 'm1', name: 'Item', price: 1000);
        expect(cheapItem.price, 1000);

        const expensiveItem = MenuItem(id: 'm2', name: 'Item', price: 50000);
        expect(expensiveItem.price, 50000);
      });

      test('should allow zero price (for free items)', () {
        const freeItem = MenuItem(id: 'm1', name: 'Free Sample', price: 0);
        expect(freeItem.price, 0);
      });
    });

    group('description', () {
      test('should default to empty string', () {
        const noDescItem = MenuItem(id: 'm1', name: 'Item', price: 5000);
        expect(noDescItem.description, isEmpty);
      });

      test('should store description when provided', () {
        expect(menuItem.description, '매콤하고 쫄깃한 떡볶이');
      });
    });

    group('imageUrl', () {
      test('should default to empty string', () {
        const noImageItem = MenuItem(id: 'm1', name: 'Item', price: 5000);
        expect(noImageItem.imageUrl, isEmpty);
      });

      test('should store imageUrl when provided', () {
        expect(menuItem.imageUrl, 'https://example.com/tteokbokki.jpg');
      });
    });

    group('isSoldOut', () {
      test('should default to false', () {
        const availableItem = MenuItem(id: 'm1', name: 'Item', price: 5000);
        expect(availableItem.isSoldOut, isFalse);
      });

      test('should be true when item is sold out', () {
        const soldOutItem = MenuItem(
          id: 'm1',
          name: 'Popular Item',
          price: 5000,
          isSoldOut: true,
        );
        expect(soldOutItem.isSoldOut, isTrue);
      });

      test('should toggle with copyWith', () {
        final soldOut = menuItem.copyWith(isSoldOut: true);
        expect(soldOut.isSoldOut, isTrue);

        final available = soldOut.copyWith(isSoldOut: false);
        expect(available.isSoldOut, isFalse);
      });
    });

    group('copyWith', () {
      test('should create copy with updated name', () {
        final updated = menuItem.copyWith(name: '순한 떡볶이');

        expect(updated.name, '순한 떡볶이');
        expect(updated.id, menuItem.id); // unchanged
        expect(updated.price, menuItem.price); // unchanged
      });

      test('should create copy with updated price', () {
        final updated = menuItem.copyWith(price: 8000);

        expect(updated.price, 8000);
        expect(updated.name, menuItem.name); // unchanged
      });

      test('should create copy with updated description', () {
        final updated = menuItem.copyWith(description: '새로운 설명');

        expect(updated.description, '새로운 설명');
      });

      test('should create copy with updated imageUrl', () {
        final updated = menuItem.copyWith(imageUrl: 'https://new-url.com/img.jpg');

        expect(updated.imageUrl, 'https://new-url.com/img.jpg');
      });
    });

    group('Korean food examples', () {
      test('should handle tteokbokki menu item', () {
        const tteokbokki = MenuItem(
          id: 'menu_1',
          name: '떡볶이',
          price: 5000,
          description: '매운맛/순한맛 선택 가능',
        );

        expect(tteokbokki.name, '떡볶이');
        expect(tteokbokki.price, 5000);
      });

      test('should handle sundae menu item', () {
        const sundae = MenuItem(
          id: 'menu_2',
          name: '순대',
          price: 4000,
          description: '당면 순대',
        );

        expect(sundae.name, '순대');
        expect(sundae.price, 4000);
      });

      test('should handle fried food menu item', () {
        const friedFood = MenuItem(
          id: 'menu_3',
          name: '모듬튀김',
          price: 3000,
          description: '고구마, 김말이, 오징어',
        );

        expect(friedFood.name, '모듬튀김');
        expect(friedFood.price, 3000);
      });

      test('should handle combo menu item', () {
        const combo = MenuItem(
          id: 'menu_4',
          name: '떡볶이 + 순대 세트',
          price: 8000,
          description: '인기 조합',
        );

        expect(combo.name, '떡볶이 + 순대 세트');
        expect(combo.price, 8000);
      });
    });
  });
}
