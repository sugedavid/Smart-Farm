import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_farm/shared/presentation/sf_toast_notification.dart';

void main() {
  group('SFToast Widget Tests', () {
    testWidgets('shows info toast with correct icon and color',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () =>
                      showToast('Information', context, status: Status.info),
                  child: const Text('Show Info Toast'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Info Toast'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Information'), findsOneWidget);
      expect(find.byIcon(Icons.info), findsOneWidget);

      final SnackBar snackBar = tester.widget(find.byType(SnackBar));
      expect((snackBar.backgroundColor ?? Colors.transparent),
          Colors.blue.shade50);

      final Icon icon = tester.widget(find.byIcon(Icons.info));
      expect(icon.color, Colors.blue);
    });

    testWidgets('shows success toast with correct icon and color',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () =>
                      showToast('Success!', context, status: Status.success),
                  child: const Text('Show Success Toast'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Success Toast'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Success!'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);

      final SnackBar snackBar = tester.widget(find.byType(SnackBar));
      expect((snackBar.backgroundColor ?? Colors.transparent),
          Colors.green.shade50);

      final Icon icon = tester.widget(find.byIcon(Icons.check_circle));
      expect(icon.color, Colors.green);
    });

    testWidgets('shows warning toast with correct icon and color',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () =>
                      showToast('Warning!', context, status: Status.warning),
                  child: const Text('Show Warning Toast'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Warning Toast'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Warning!'), findsOneWidget);
      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);

      final SnackBar snackBar = tester.widget(find.byType(SnackBar));
      expect((snackBar.backgroundColor ?? Colors.transparent),
          Colors.orange.shade50);

      final Icon icon = tester.widget(find.byIcon(Icons.warning_amber_rounded));
      expect(icon.color, Colors.orange);
    });

    testWidgets('shows error toast with correct icon and color',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () =>
                      showToast('Error!', context, status: Status.error),
                  child: const Text('Show Error Toast'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Error Toast'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Error!'), findsOneWidget);
      expect(find.byIcon(Icons.error), findsOneWidget);

      final SnackBar snackBar = tester.widget(find.byType(SnackBar));
      expect(
          (snackBar.backgroundColor ?? Colors.transparent), Colors.red.shade50);

      final Icon icon = tester.widget(find.byIcon(Icons.error));
      expect(icon.color, Colors.red);
    });
  });
}
