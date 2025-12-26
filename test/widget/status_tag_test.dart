import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:truck_tracker/core/themes/app_theme.dart';
import 'package:truck_tracker/features/truck_list/domain/truck.dart';
import 'package:truck_tracker/shared/widgets/status_tag.dart';

/// Widget tests for StatusTag
///
/// Verifies that the status tag displays correct labels and colors
/// for each truck status (onRoute, resting, maintenance).
void main() {
  group('StatusTag Widget', () {
    testWidgets('displays correct label for onRoute status',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusTag(status: TruckStatus.onRoute),
          ),
        ),
      );

      expect(find.text('운행 중'), findsOneWidget);
    });

    testWidgets('displays correct label for resting status',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusTag(status: TruckStatus.resting),
          ),
        ),
      );

      expect(find.text('대기 / 휴식'), findsOneWidget);
    });

    testWidgets('displays correct label for maintenance status',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusTag(status: TruckStatus.maintenance),
          ),
        ),
      );

      expect(find.text('점검 중'), findsOneWidget);
    });

    testWidgets('applies correct background color for onRoute',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusTag(status: TruckStatus.onRoute),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(StatusTag),
          matching: find.byType(Container),
        ),
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, AppTheme.mustardYellow15);
    });

    testWidgets('applies correct background color for resting',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusTag(status: TruckStatus.resting),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(StatusTag),
          matching: find.byType(Container),
        ),
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, AppTheme.grey15);
    });

    testWidgets('applies correct background color for maintenance',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusTag(status: TruckStatus.maintenance),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(StatusTag),
          matching: find.byType(Container),
        ),
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, AppTheme.orange15);
    });

    testWidgets('has correct text color for onRoute',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusTag(status: TruckStatus.onRoute),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('운행 중'));
      expect(textWidget.style?.color, AppTheme.mustardYellow);
    });

    testWidgets('has correct text color for resting',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusTag(status: TruckStatus.resting),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('대기 / 휴식'));
      expect(textWidget.style?.color, AppTheme.textTertiary);
    });

    testWidgets('has correct padding', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusTag(status: TruckStatus.onRoute),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(StatusTag),
          matching: find.byType(Container),
        ),
      );

      expect(
        container.padding,
        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      );
    });

    testWidgets('has rounded corners', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusTag(status: TruckStatus.onRoute),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(StatusTag),
          matching: find.byType(Container),
        ),
      );

      final decoration = container.decoration as BoxDecoration;
      final borderRadius = decoration.borderRadius as BorderRadius;

      expect(borderRadius.topLeft.x, 4.0);
      expect(borderRadius.topRight.x, 4.0);
      expect(borderRadius.bottomLeft.x, 4.0);
      expect(borderRadius.bottomRight.x, 4.0);
    });
  });
}
