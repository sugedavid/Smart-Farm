import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_farm/views/components/sf_dialog.dart';

void main() {
  group('SFDialog Tests', () {
    testWidgets('shows dialog with correct title and content',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () => SFDialog.showSFDialog(
                    context: context,
                    title: 'Test Title',
                    content: const Text('This is a test message.'),
                    onOk: () => Navigator.of(context).pop(),
                  ),
                  child: const Text('Show Dialog'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('This is a test message.'), findsOneWidget);

      expect(find.text('OK'), findsOneWidget);
    });

    testWidgets('calls onOk when OK button is pressed',
        (WidgetTester tester) async {
      bool okPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () => SFDialog.showSFDialog(
                    context: context,
                    title: 'Test Title',
                    content: const Text('This is a test message.'),
                    onOk: () {
                      okPressed = true;
                      Navigator.of(context).pop();
                    },
                  ),
                  child: const Text('Show Dialog'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(okPressed, true);
    });

    testWidgets('calls onCancel when Cancel button is pressed',
        (WidgetTester tester) async {
      bool cancelPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () => SFDialog.showSFDialog(
                    context: context,
                    title: 'Test Title',
                    content: const Text('This is a test message.'),
                    cancelText: 'Cancel',
                    onCancel: () {
                      cancelPressed = true;
                      Navigator.of(context).pop();
                    },
                    onOk: () => Navigator.of(context).pop(),
                  ),
                  child: const Text('Show Dialog'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(cancelPressed, true);
    });
  });
}
