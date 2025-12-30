import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:truck_tracker/shared/widgets/toss_card.dart';

void main() {
  group('TossCard', () {
    testWidgets('should render child widget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TossCard(
              child: Text('Card Content'),
            ),
          ),
        ),
      );

      expect(find.byType(TossCard), findsOneWidget);
      expect(find.text('Card Content'), findsOneWidget);
    });

    testWidgets('should handle tap callback', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TossCard(
              onTap: () => tapped = true,
              child: const Text('Tap Me'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tap Me'));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('should apply custom padding', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TossCard(
              padding: EdgeInsets.all(32),
              child: Text('Padded'),
            ),
          ),
        ),
      );

      expect(find.byType(TossCard), findsOneWidget);
    });

    testWidgets('should apply custom margin', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TossCard(
              margin: EdgeInsets.all(16),
              child: Text('Margin'),
            ),
          ),
        ),
      );

      expect(find.byType(TossCard), findsOneWidget);
    });

    testWidgets('should apply custom border radius', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TossCard(
              borderRadius: 30,
              child: Text('Rounded'),
            ),
          ),
        ),
      );

      expect(find.byType(TossCard), findsOneWidget);
    });

    testWidgets('should apply custom background color', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TossCard(
              backgroundColor: Colors.blue,
              child: Text('Blue'),
            ),
          ),
        ),
      );

      expect(find.byType(TossCard), findsOneWidget);
    });

    testWidgets('should hide shadow when showShadow is false', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TossCard(
              showShadow: false,
              child: Text('No Shadow'),
            ),
          ),
        ),
      );

      expect(find.byType(TossCard), findsOneWidget);
    });

    testWidgets('should animate on tap down and up', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TossCard(
              onTap: () {},
              child: const Text('Animate'),
            ),
          ),
        ),
      );

      // Tap down
      await tester.press(find.text('Animate'));
      await tester.pump(const Duration(milliseconds: 50));

      // Tap up
      await tester.pumpAndSettle();

      expect(find.byType(TossCard), findsOneWidget);
    });
  });

  group('TossListCard', () {
    testWidgets('should render with required fields', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TossListCard(
              leading: Icon(Icons.star),
              title: Text('Title'),
            ),
          ),
        ),
      );

      expect(find.byType(TossListCard), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.text('Title'), findsOneWidget);
    });

    testWidgets('should render subtitle when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TossListCard(
              leading: Icon(Icons.star),
              title: Text('Title'),
              subtitle: Text('Subtitle'),
            ),
          ),
        ),
      );

      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Subtitle'), findsOneWidget);
    });

    testWidgets('should render trailing when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TossListCard(
              leading: Icon(Icons.star),
              title: Text('Title'),
              trailing: Icon(Icons.arrow_forward),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    });

    testWidgets('should handle tap callback', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TossListCard(
              leading: const Icon(Icons.star),
              title: const Text('Tappable'),
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tappable'));
      await tester.pump();

      expect(tapped, isTrue);
    });
  });

  group('TossTruckCard', () {
    testWidgets('should render truck card with all fields', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TossTruckCard(
              imageUrl: 'https://example.com/image.jpg',
              name: 'Tteokbokki Truck',
              foodType: 'Korean',
              statusWidget: TossStatusTag.open(),
              distance: '500m',
              location: 'Gangnam Station',
            ),
          ),
        ),
      );

      expect(find.byType(TossTruckCard), findsOneWidget);
      expect(find.text('Tteokbokki Truck'), findsOneWidget);
      expect(find.text('Korean'), findsOneWidget);
      expect(find.text('500m'), findsOneWidget);
      expect(find.text('Gangnam Station'), findsOneWidget);
    });

    testWidgets('should render without optional fields', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TossTruckCard(
              imageUrl: '',
              name: 'Truck',
              foodType: 'Food',
              statusWidget: TossStatusTag.resting(),
            ),
          ),
        ),
      );

      expect(find.byType(TossTruckCard), findsOneWidget);
      expect(find.text('Truck'), findsOneWidget);
    });

    testWidgets('should handle tap callback', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TossTruckCard(
              imageUrl: '',
              name: 'Tappable Truck',
              foodType: 'Food',
              statusWidget: TossStatusTag.open(),
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tappable Truck'));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('should use custom image builder', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TossTruckCard(
              imageUrl: 'test_url',
              name: 'Custom Image',
              foodType: 'Food',
              statusWidget: TossStatusTag.open(),
              imageBuilder: (url) => Container(
                key: const Key('custom_image'),
                width: 56,
                height: 56,
                color: Colors.red,
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('custom_image')), findsOneWidget);
    });
  });

  group('TossStatusTag', () {
    testWidgets('should render with custom label', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TossStatusTag(label: 'Custom'),
          ),
        ),
      );

      expect(find.text('Custom'), findsOneWidget);
    });

    testWidgets('should render open status tag', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TossStatusTag.open(),
          ),
        ),
      );

      expect(find.text('영업중'), findsOneWidget);
    });

    testWidgets('should render open status tag with custom label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TossStatusTag.open(label: 'Open'),
          ),
        ),
      );

      expect(find.text('Open'), findsOneWidget);
    });

    testWidgets('should render resting status tag', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TossStatusTag.resting(),
          ),
        ),
      );

      expect(find.text('대기중'), findsOneWidget);
    });

    testWidgets('should render resting status tag with custom label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TossStatusTag.resting(label: 'Resting'),
          ),
        ),
      );

      expect(find.text('Resting'), findsOneWidget);
    });

    testWidgets('should render maintenance status tag', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TossStatusTag.maintenance(),
          ),
        ),
      );

      expect(find.text('점검중'), findsOneWidget);
    });

    testWidgets('should render maintenance status tag with custom label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TossStatusTag.maintenance(label: 'Maintenance'),
          ),
        ),
      );

      expect(find.text('Maintenance'), findsOneWidget);
    });

    testWidgets('should apply custom colors', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TossStatusTag(
              label: 'Custom Color',
              color: Colors.purple,
              backgroundColor: Colors.purpleAccent,
            ),
          ),
        ),
      );

      expect(find.text('Custom Color'), findsOneWidget);
    });
  });
}
