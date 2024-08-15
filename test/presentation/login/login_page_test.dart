import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_farm/presentation/login/login_page.dart';

void main() {
  testWidgets('LogInPage Widget Test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: LogInPage(),
    ));

    await tester.pumpAndSettle();

    expect(find.text('Welcome'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
  });
}
