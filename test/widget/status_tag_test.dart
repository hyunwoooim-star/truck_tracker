import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:truck_tracker/core/themes/app_theme.dart';
import 'package:truck_tracker/features/truck_list/domain/truck.dart';
import 'package:truck_tracker/generated/l10n/app_localizations.dart';
import 'package:truck_tracker/shared/widgets/status_tag.dart';

/// Widget tests for StatusTag
///
/// Verifies that the status tag displays correct labels and colors
/// for each truck status (onRoute, resting, maintenance).
void main() {
  /// Helper to wrap StatusTag with MaterialApp and localization
  Widget buildTestWidget(TruckStatus status) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('ko'),
      home: Scaffold(
        body: StatusTag(status: status),
      ),
    );
  }

  group('StatusTag Widget', () {
    testWidgets('displays correct label for onRoute status',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(TruckStatus.onRoute));
      await tester.pumpAndSettle();

      expect(find.text('운행 중'), findsOneWidget);
    });

    testWidgets('displays correct label for resting status',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(TruckStatus.resting));
      await tester.pumpAndSettle();

      expect(find.text('대기 / 휴식'), findsOneWidget);
    });

    testWidgets('displays correct label for maintenance status',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(TruckStatus.maintenance));
      await tester.pumpAndSettle();

      expect(find.text('점검 중'), findsOneWidget);
    });

    testWidgets('applies correct background color for onRoute',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(TruckStatus.onRoute));
      await tester.pumpAndSettle();

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
      await tester.pumpWidget(buildTestWidget(TruckStatus.resting));
      await tester.pumpAndSettle();

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
      await tester.pumpWidget(buildTestWidget(TruckStatus.maintenance));
      await tester.pumpAndSettle();

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
      await tester.pumpWidget(buildTestWidget(TruckStatus.onRoute));
      await tester.pumpAndSettle();

      final textWidget = tester.widget<Text>(find.text('운행 중'));
      expect(textWidget.style?.color, AppTheme.mustardYellow);
    });

    testWidgets('has correct text color for resting',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(TruckStatus.resting));
      await tester.pumpAndSettle();

      final textWidget = tester.widget<Text>(find.text('대기 / 휴식'));
      expect(textWidget.style?.color, AppTheme.textTertiary);
    });

    testWidgets('has correct padding', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(TruckStatus.onRoute));
      await tester.pumpAndSettle();

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
      await tester.pumpWidget(buildTestWidget(TruckStatus.onRoute));
      await tester.pumpAndSettle();

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
