import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:truck_tracker/shared/widgets/skeleton_loading.dart';

void main() {
  group('SkeletonBox', () {
    testWidgets('should render with default values', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SkeletonBox(),
          ),
        ),
      );

      expect(find.byType(SkeletonBox), findsOneWidget);
    });

    testWidgets('should render with custom dimensions', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SkeletonBox(
              width: 100,
              height: 50,
              borderRadius: 12,
            ),
          ),
        ),
      );

      expect(find.byType(SkeletonBox), findsOneWidget);
    });
  });

  group('SkeletonCircle', () {
    testWidgets('should render with default size', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SkeletonCircle(),
          ),
        ),
      );

      expect(find.byType(SkeletonCircle), findsOneWidget);
    });

    testWidgets('should render with custom size', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SkeletonCircle(size: 80),
          ),
        ),
      );

      expect(find.byType(SkeletonCircle), findsOneWidget);
    });
  });

  group('SkeletonLine', () {
    testWidgets('should render with default height', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SkeletonLine(),
          ),
        ),
      );

      expect(find.byType(SkeletonLine), findsOneWidget);
    });

    testWidgets('should render with custom width and height', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SkeletonLine(width: 200, height: 20),
          ),
        ),
      );

      expect(find.byType(SkeletonLine), findsOneWidget);
    });
  });

  group('SkeletonTruckCard', () {
    testWidgets('should render truck card skeleton', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SkeletonTruckCard(),
          ),
        ),
      );

      expect(find.byType(SkeletonTruckCard), findsOneWidget);
      expect(find.byType(SkeletonBox), findsWidgets);
      expect(find.byType(SkeletonLine), findsWidgets);
      expect(find.byType(SkeletonCircle), findsOneWidget);
    });
  });

  group('SkeletonTruckList', () {
    testWidgets('should render default 5 items', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SkeletonTruckList(),
          ),
        ),
      );

      expect(find.byType(SkeletonTruckList), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('should render custom item count', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SkeletonTruckList(itemCount: 3),
          ),
        ),
      );

      expect(find.byType(SkeletonTruckList), findsOneWidget);
    });
  });

  group('SkeletonMenuItem', () {
    testWidgets('should render menu item skeleton', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SkeletonMenuItem(),
          ),
        ),
      );

      expect(find.byType(SkeletonMenuItem), findsOneWidget);
      expect(find.byType(Row), findsWidgets);
    });
  });

  group('SkeletonMenuList', () {
    testWidgets('should render default 6 items', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SkeletonMenuList(),
          ),
        ),
      );

      expect(find.byType(SkeletonMenuList), findsOneWidget);
    });

    testWidgets('should render custom item count', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SkeletonMenuList(itemCount: 10),
          ),
        ),
      );

      expect(find.byType(SkeletonMenuList), findsOneWidget);
    });
  });

  group('SkeletonReviewCard', () {
    testWidgets('should render review card skeleton', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SkeletonReviewCard(),
          ),
        ),
      );

      expect(find.byType(SkeletonReviewCard), findsOneWidget);
      expect(find.byType(SkeletonCircle), findsOneWidget);
    });
  });

  group('SkeletonOrderCard', () {
    testWidgets('should render order card skeleton', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SkeletonOrderCard(),
          ),
        ),
      );

      expect(find.byType(SkeletonOrderCard), findsOneWidget);
      expect(find.byType(Divider), findsOneWidget);
    });
  });

  group('SkeletonStatsCard', () {
    testWidgets('should render stats card skeleton', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SkeletonStatsCard(),
          ),
        ),
      );

      expect(find.byType(SkeletonStatsCard), findsOneWidget);
      expect(find.byType(SkeletonCircle), findsOneWidget);
    });
  });

  group('SkeletonChatMessage', () {
    testWidgets('should render sender message aligned left', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SkeletonChatMessage(isMe: false),
          ),
        ),
      );

      expect(find.byType(SkeletonChatMessage), findsOneWidget);
      final align = tester.widget<Align>(find.byType(Align).first);
      expect(align.alignment, Alignment.centerLeft);
    });

    testWidgets('should render my message aligned right', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SkeletonChatMessage(isMe: true),
          ),
        ),
      );

      final align = tester.widget<Align>(find.byType(Align).first);
      expect(align.alignment, Alignment.centerRight);
    });
  });

  group('SkeletonChatList', () {
    testWidgets('should render chat list skeleton', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SkeletonChatList(),
          ),
        ),
      );

      expect(find.byType(SkeletonChatList), findsOneWidget);
      expect(find.byType(SkeletonChatMessage), findsNWidgets(5));
    });
  });

  group('SkeletonCouponCard', () {
    testWidgets('should render coupon card skeleton', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SkeletonCouponCard(),
          ),
        ),
      );

      expect(find.byType(SkeletonCouponCard), findsOneWidget);
    });
  });

  group('SkeletonFullScreen', () {
    testWidgets('should render child widget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SkeletonFullScreen(
              child: Text('Loading...'),
            ),
          ),
        ),
      );

      expect(find.byType(SkeletonFullScreen), findsOneWidget);
      expect(find.text('Loading...'), findsOneWidget);
    });
  });

  group('SkeletonProfileHeader', () {
    testWidgets('should render profile header skeleton', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SkeletonProfileHeader(),
          ),
        ),
      );

      expect(find.byType(SkeletonProfileHeader), findsOneWidget);
      expect(find.byType(SkeletonCircle), findsOneWidget);
    });
  });

  group('SkeletonChipGrid', () {
    testWidgets('should render default 6 chips', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SkeletonChipGrid(),
          ),
        ),
      );

      expect(find.byType(SkeletonChipGrid), findsOneWidget);
      expect(find.byType(Wrap), findsOneWidget);
    });

    testWidgets('should render custom item count', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SkeletonChipGrid(itemCount: 10),
          ),
        ),
      );

      expect(find.byType(SkeletonChipGrid), findsOneWidget);
    });
  });

  group('SkeletonTruckDetail', () {
    testWidgets('should render truck detail skeleton', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SkeletonTruckDetail(),
          ),
        ),
      );

      expect(find.byType(SkeletonTruckDetail), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });
}
