import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_farm/views/components/sf_dropdown_button.dart';

void main() {
  group('SFDropdownButton Widget Tests', () {
    testWidgets('renders with label and required asterisk',
        (WidgetTester tester) async {
      final controller = TextEditingController();
      final list = ['Option 1', 'Option 2', 'Option 3'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SFDropdownButton(
              labelText: 'Label',
              list: list,
              controller: controller,
              onChanged: () {},
              required: true,
            ),
          ),
        ),
      );

      expect(find.text('Label'), findsOneWidget);
      expect(find.text('*'), findsOneWidget);
    });

    testWidgets('displays dropdown items and selects an option',
        (WidgetTester tester) async {
      final controller = TextEditingController();
      final list = ['Option 1', 'Option 2', 'Option 3'];
      var selectedValue = '';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SFDropdownButton(
              labelText: 'Label',
              list: list,
              controller: controller,
              onChanged: () {
                selectedValue = controller.text;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();

      for (var option in list) {
        expect(find.text(option), findsWidgets);
      }

      await tester.tap(find.text('Option 2').last);
      await tester.pumpAndSettle();

      expect(controller.text, 'Option 2');
      expect(selectedValue, 'Option 2');
    });

    testWidgets('initializes with controller text if provided',
        (WidgetTester tester) async {
      final controller = TextEditingController(text: 'Option 2');
      final list = ['Option 1', 'Option 2', 'Option 3'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SFDropdownButton(
              labelText: 'Label',
              list: list,
              controller: controller,
              onChanged: () {},
            ),
          ),
        ),
      );

      expect(find.text('Option 2'), findsOneWidget);
      expect(controller.text, 'Option 2');
    });
  });
}
