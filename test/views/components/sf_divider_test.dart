import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_farm/views/components/sf_divider.dart';

void main() {
  group('SFDivider Widget Tests', () {
    testWidgets('renders with default properties', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SFDivider(),
          ),
        ),
      );

      final dividerFinder = find.byType(SFDivider);
      expect(dividerFinder, findsOneWidget);

      final divider = tester.widget<Divider>(find.byType(Divider));
      expect(divider.color, Colors.black12);
      expect(divider.height, 0.5);
      expect(divider.thickness, 0.5);
      expect(divider.indent, 0.0);
      expect(divider.endIndent, 0.0);
    });

    testWidgets('renders with specified indent', (WidgetTester tester) async {
      const double testIndent = 16.0;
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SFDivider(indent: testIndent),
          ),
        ),
      );

      final divider = tester.widget<Divider>(find.byType(Divider));
      expect(divider.indent, testIndent);
    });
  });
}
