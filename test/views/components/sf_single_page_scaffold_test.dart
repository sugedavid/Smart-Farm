import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_farm/views/components/sf_single_page_scaffold.dart';

void main() {
  group('SFSinglePageScaffold Widget Tests', () {
    testWidgets('renders with title, child, and actions',
        (WidgetTester tester) async {
      const title = 'Test Title';
      const childText = 'Test Child';
      final actions = [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {},
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: SFSinglePageScaffold(
            title: title,
            actions: actions,
            child: const Text(childText),
          ),
        ),
      );

      expect(find.text(title), findsOneWidget);
      expect(find.text(childText), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('renders with floating action button',
        (WidgetTester tester) async {
      const title = 'Test Title';
      const childText = 'Test Child';
      final floatingActionButton = FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: SFSinglePageScaffold(
            title: title,
            floatingActionButton: floatingActionButton,
            child: const Text(childText),
          ),
        ),
      );

      expect(find.text(title), findsOneWidget);
      expect(find.text(childText), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('aligns content based on screen size (web vs mobile)',
        (WidgetTester tester) async {
      const title = 'Test Title';
      const childText = 'Test Child';

      debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(1200, 800)),
            child: SFSinglePageScaffold(
              title: title,
              child: Text(childText),
            ),
          ),
        ),
      );

      expect(find.text(title), findsOneWidget);
      expect(find.text(childText), findsOneWidget);

      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(400, 800)),
            child: SFSinglePageScaffold(
              title: title,
              child: Text(childText),
            ),
          ),
        ),
      );

      expect(find.text(title), findsOneWidget);
      expect(find.text(childText), findsOneWidget);
      expect(tester.widget<Container>(find.byType(Container)).alignment,
          isNot(Alignment.center));

      debugDefaultTargetPlatformOverride = null;
    });
  });
}
