import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_farm/views/components/sf_primary_button.dart';

void main() {
  testWidgets('SFPrimaryButton Widget Tests', (WidgetTester tester) async {
    Future<void> mockAsyncFunction() async {
      await Future.delayed(const Duration(seconds: 3));
    }

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SFPrimaryButton(
          text: 'Continue',
          onPressed: () async {
            await mockAsyncFunction();
          },
        ),
      ),
    ));

    expect(find.text('Continue'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
