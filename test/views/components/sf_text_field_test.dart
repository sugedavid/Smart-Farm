import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_farm/views/components/sf_text_field.dart';

void main() {
  group('SFTextField Widget Tests', () {
    testWidgets('renders with label and hint', (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SFTextField(
              labelText: 'Email',
              hintText: 'Enter your email',
              controller: controller,
            ),
          ),
        ),
      );

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Enter your email'), findsOneWidget);
    });

    testWidgets('allows input and displays the entered text',
        (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SFTextField(
              labelText: 'Email',
              controller: controller,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'test@example.com');
      await tester.pump();

      expect(find.text('test@example.com'), findsOneWidget);
      expect(controller.text, 'test@example.com');
    });

    testWidgets('displays validation error', (WidgetTester tester) async {
      final formKey = GlobalKey<FormState>();
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: SFTextField(
                labelText: 'Email',
                textInputType: TextInputType.emailAddress,
                controller: controller,
              ),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'invalid-email');
      await tester.pump();

      formKey.currentState!.validate();
      await tester.pump();

      expect(find.text('Please enter a valid email address'), findsOneWidget);
    });
  });
}
